import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../routes/v1/payments/subscription-phonepe-webhook.dart'
    as webhook_route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;

  setUp(() {
    context = _MockRequestContext();
    request = _MockRequest();
    when(() => context.request).thenReturn(request);
  });

  group('POST /v1/payments/subscription-phonepe-webhook', () {
    test('rejects invalid payload structure with 400', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => request.body()).thenAnswer((_) async => jsonEncode(<String, dynamic>{}));

      final response = await webhook_route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test('rejects payload without merchantOrderId or state with 400', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => request.body()).thenAnswer(
        (_) async => jsonEncode(<String, dynamic>{
          'event': 'checkout.order.completed',
          'payload': <String, dynamic>{},
        }),
      );

      final response = await webhook_route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });
  });
}
