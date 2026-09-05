import 'dart:convert';
import 'dart:io';

import 'package:backend/config/env.dart';
import 'package:backend/repositories/terminal_repository.dart';
import 'package:backend/services/auth_service.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../routes/v1/auth/terminal/login.dart' as route;
import '../../../../helpers/schema_factories.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockTerminalRepository extends Mock implements TerminalRepository {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockTerminalRepository repo;

  setUp(() {
    Env.init();
    context = _MockRequestContext();
    request = _MockRequest();
    repo = _MockTerminalRepository();

    when(() => context.request).thenReturn(request);
    when(() => context.read<TerminalRepository>()).thenReturn(repo);
  });

  group('POST /v1/auth/terminal/login', () {
    test('returns 200 and terminal token on valid credentials', () async {
      when(() => request.method).thenReturn(.post);
      final hash = await PasswordService.hash('Password123');

      final terminalRow = createTerminalRow(
        code: 'TERM12345678',
        passwordHash: hash,
      );

      when(() => request.json()).thenAnswer(
        (_) async => {'code': 'TERM12345678', 'password': 'Password123'},
      );
      when(() => repo.getByCode('TERM12345678'))
          .thenAnswer((_) async => terminalRow);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      final data = body['data'] as Map<String, dynamic>;
      final terminal = data['terminal'] as Map<String, dynamic>;
      expect(terminal['code'], equals('TERM12345678'));
      expect(response.headers[HttpHeaders.setCookieHeader], isNotNull);
      expect(
        response.headers[HttpHeaders.setCookieHeader],
        contains('access_token='),
      );
    });
  });
}
