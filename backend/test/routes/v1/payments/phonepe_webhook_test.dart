import 'dart:convert';
import 'dart:io';

import 'package:backend/config/env.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../routes/v1/payments/phonepe-webhook.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;

  setUp(() {
    Env.init();
    context = _MockRequestContext();
    request = _MockRequest();

    when(() => context.request).thenReturn(request);
  });

  group('POST /v1/payments/phonepe-webhook payload validation', () {
    test('responds with 400 when event is missing from webhook payload', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.body()).thenAnswer(
        (_) async => jsonEncode({
          'payload': {
            'merchantOrderId': 'ORD-12345678',
            'state': 'COMPLETED',
          },
        }),
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['message'], equals('Invalid webhook payload structure'));
    });

    test('responds with 400 when payload object is missing from webhook body', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.body()).thenAnswer(
        (_) async => jsonEncode({
          'event': 'checkout.order.completed',
        }),
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['message'], equals('Invalid webhook payload structure'));
    });

    test('responds with 400 when merchantOrderId is missing inside payload', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.body()).thenAnswer(
        (_) async => jsonEncode({
          'event': 'checkout.order.completed',
          'payload': {
            'state': 'COMPLETED',
          },
        }),
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['message'], equals('Missing required webhook payload fields'));
    });

    test('responds with 400 when state is missing inside payload', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.body()).thenAnswer(
        (_) async => jsonEncode({
          'event': 'checkout.order.completed',
          'payload': {
            'merchantOrderId': 'ORD-12345678',
          },
        }),
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['message'], equals('Missing required webhook payload fields'));
    });

    test('responds with 500 when webhook raw body is invalid JSON', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.body()).thenAnswer((_) async => '{unclosed_json:');

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.internalServerError));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('error'));
    });
  });

  group('unsupported methods', () {
    test('responds with 405 for GET', () async {
      when(() => request.method).thenReturn(.get);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('responds with 405 for DELETE', () async {
      when(() => request.method).thenReturn(.delete);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('responds with 405 for PUT', () async {
      when(() => request.method).thenReturn(.put);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });
}
