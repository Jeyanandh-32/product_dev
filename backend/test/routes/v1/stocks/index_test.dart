import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../routes/v1/stocks/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  late _MockRequestContext context;

  setUp(() {
    context = _MockRequestContext();
  });

  group('/v1/stocks', () {
    test('responds with placeholder response', () async {
      final response = route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      final body = await response.body();
      expect(body, equals('This is a new route!'));
    });
  });
}
