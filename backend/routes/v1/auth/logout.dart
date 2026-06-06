import 'dart:io';

import 'package:backend/services/auth_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    .get => _onGet(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context) async {
  final cookies = AuthService.removeTokens();
  return succes(
    headers: {
      HttpHeaders.setCookieHeader: cookies,
    },
  );
}
