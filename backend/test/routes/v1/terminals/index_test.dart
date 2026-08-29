import 'dart:convert';
import 'dart:io';

import 'package:backend/enums/user_role.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/subscription_repository.dart';
import 'package:backend/repositories/terminal_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../routes/v1/terminals/index.dart' as route;
import '../../../helpers/schema_factories.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockTerminalRepository extends Mock implements TerminalRepository {}

class _MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockTerminalRepository terminalRepo;
  late _MockSubscriptionRepository subRepo;

  const validStoreId = '11111111-1111-1111-1111-111111111111';
  const merchantToken = TokenPayload(sub: 'm-1', role: UserRole.merchant);

  setUp(() {
    context = _MockRequestContext();
    request = _MockRequest();
    terminalRepo = _MockTerminalRepository();
    subRepo = _MockSubscriptionRepository();

    when(() => context.request).thenReturn(request);
    when(() => request.uri)
        .thenReturn(Uri.parse('http://localhost/v1/terminals'));
    when(() => context.read<TokenPayload>()).thenReturn(merchantToken);
    when(() => context.read<TerminalRepository>()).thenReturn(terminalRepo);
    when(() => context.read<SubscriptionRepository>()).thenReturn(subRepo);
    when(() => subRepo.getStoreSubscription(any()))
        .thenAnswer((_) async => null);
  });

  group('/v1/terminals', () {
    group('GET (terminal role)', () {
      const terminalToken = TokenPayload(
        sub: 'm-1',
        role: UserRole.terminal,
        terminalCode: 'TERM12345678',
      );

      test('responds with terminal info when terminal is active', () async {
        when(() => context.read<TokenPayload>()).thenReturn(terminalToken);
        when(() => request.method).thenReturn(.get);
        when(() => request.uri).thenReturn(
          Uri.parse('http://localhost/v1/terminals'),
        );

        final terminalRow = createTerminalRow(
          code: 'TERM12345678',
          name: 'Billing Terminal',
          storeId: validStoreId,
        );

        when(() => terminalRepo.getByCode('TERM12345678'))
            .thenAnswer((_) async => terminalRow);
        when(() => terminalRepo.getStoreById(validStoreId))
            .thenAnswer((_) async => null);
        when(() => terminalRepo.getMerchantById('m-1'))
            .thenAnswer((_) async => null);

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.ok));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['status'], equals('success'));
        final data = body['data'] as Map<String, dynamic>;
        final terminal = data['terminal'] as Map<String, dynamic>;
        expect(terminal['code'], equals('TERM12345678'));
      });

      test('responds with 400 when terminal does not exist', () async {
        when(() => context.read<TokenPayload>()).thenReturn(terminalToken);
        when(() => request.method).thenReturn(.get);
        when(() => request.uri).thenReturn(
          Uri.parse('http://localhost/v1/terminals'),
        );

        when(() => terminalRepo.getByCode('TERM12345678'))
            .thenAnswer((_) async => null);

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.badRequest));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['status'], equals('error'));
        expect(body['message'], equals('Terminal not exists'));
      });

      test('responds with 403 when terminal is deactivated', () async {
        when(() => context.read<TokenPayload>()).thenReturn(terminalToken);
        when(() => request.method).thenReturn(.get);
        when(() => request.uri).thenReturn(
          Uri.parse('http://localhost/v1/terminals'),
        );

        final terminalRow = createTerminalRow(
          code: 'TERM12345678',
          name: 'Billing Terminal',
          storeId: validStoreId,
          isActive: false,
        );

        when(() => terminalRepo.getByCode('TERM12345678'))
            .thenAnswer((_) async => terminalRow);

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.forbidden));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['status'], equals('error'));
        expect(body['message'], equals('This Terminal is deactivated.'));
      });
    });

    group('GET (merchant role)', () {
      test('responds with terminals list and pagination', () async {
        when(() => request.method).thenReturn(.get);
        when(() => request.uri).thenReturn(
          Uri.parse('http://localhost/v1/terminals?storeId=$validStoreId'),
        );

        final terminalRows = [
          createTerminalRow(
            code: 'TERM12345678',
            name: 'Terminal 1',
            storeId: validStoreId,
          ),
        ];

        when(
          () => terminalRepo.count(
            merchantId: 'm-1',
            storeId: validStoreId,
          ),
        ).thenAnswer((_) async => 1);

        when(
          () => terminalRepo.getAll(
            merchantId: 'm-1',
            storeId: validStoreId,
            limit: 50,
            offset: 0,
          ),
        ).thenAnswer((_) async => terminalRows);

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.ok));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['status'], equals('success'));
        final data = body['data'] as Map<String, dynamic>;
        expect(data['currentPage'], equals(1));
        expect(data['totalItems'], equals(1));
        final terminals = data['terminals'] as List<dynamic>;
        expect(terminals.length, equals(1));
        final firstTerminal = terminals.first as Map<String, dynamic>;
        expect(firstTerminal['code'], equals('TERM12345678'));
      });

      test('responds with 400 when storeId is invalid UUID', () async {
        when(() => request.method).thenReturn(.get);
        when(() => request.uri).thenReturn(
          Uri.parse('http://localhost/v1/terminals?storeId=not-a-valid-uuid'),
        );

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.badRequest));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['status'], equals('error'));
        expect(body['message'], equals('Invalid store id.'));
      });

      test('responds with 400 when page parameter is invalid', () async {
        when(() => request.method).thenReturn(.get);
        when(() => request.uri).thenReturn(
          Uri.parse(
            'http://localhost/v1/terminals?storeId=$validStoreId&page=0',
          ),
        );

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.badRequest));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['status'], equals('error'));
        final message = body['message'] as String;
        expect(message, contains('page must be a positive integer'));
      });

      test('responds with 400 when size parameter is invalid', () async {
        when(() => request.method).thenReturn(.get);
        when(() => request.uri).thenReturn(
          Uri.parse(
            'http://localhost/v1/terminals?storeId=$validStoreId&size=0',
          ),
        );

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.badRequest));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['status'], equals('error'));
        final message = body['message'] as String;
        expect(message, contains('size must be a positive integer'));
      });
    });

    group('POST', () {
      test('creates terminal successfully', () async {
        when(() => request.method).thenReturn(.post);
        when(() => request.uri).thenReturn(
          Uri.parse('http://localhost/v1/terminals?storeId=$validStoreId'),
        );
        when(() => request.json()).thenAnswer(
          (_) async => {
            'name': 'Counter 1 POS',
            'password': 'Password1',
          },
        );

        final createdTerminal = createTerminalRow(
          code: 'ABCDEF123456',
          name: 'Counter 1 POS',
          storeId: validStoreId,
        );

        when(
          () => terminalRepo.create(
            code: any(named: 'code'),
            merchantId: 'm-1',
            storeId: validStoreId,
            name: 'Counter 1 POS',
            passwordHash: any(named: 'passwordHash'),
          ),
        ).thenAnswer((_) async => createdTerminal);

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.created));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['status'], equals('success'));
        final data = body['data'] as Map<String, dynamic>;
        final terminal = data['terminal'] as Map<String, dynamic>;
        expect(terminal['name'], equals('Counter 1 POS'));
        expect(terminal['code'], equals('ABCDEF123456'));
      });

      test('responds with 400 when storeId is missing', () async {
        when(() => request.method).thenReturn(.post);
        when(() => request.uri).thenReturn(
          Uri.parse('http://localhost/v1/terminals'),
        );

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.badRequest));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['status'], equals('error'));
        expect(body['message'], equals('Store ID is required.'));
      });

      test('responds with 400 when storeId is invalid UUID', () async {
        when(() => request.method).thenReturn(.post);
        when(() => request.uri).thenReturn(
          Uri.parse('http://localhost/v1/terminals?storeId=bad-uuid'),
        );

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.badRequest));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['status'], equals('error'));
        expect(body['message'], equals('Invalid store id.'));
      });

      test('responds with 400 when body validation fails', () async {
        when(() => request.method).thenReturn(.post);
        when(() => request.uri).thenReturn(
          Uri.parse('http://localhost/v1/terminals?storeId=$validStoreId'),
        );
        when(() => request.json()).thenAnswer((_) async => <String, dynamic>{});

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.badRequest));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['status'], equals('error'));
        expect(body['message'], equals('Terminal Name is required.'));
      });
    });

    test('DELETE responds with 405 Method Not Allowed', () async {
      when(() => request.method).thenReturn(.delete);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });
}
