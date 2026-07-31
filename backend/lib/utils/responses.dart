import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Response success({
  int? statusCode,
  Map<String, Object?>? data,
  Map<String, Object>? headers,
}) {
  return Response.json(
    headers: headers ?? {},
    statusCode: statusCode ?? HttpStatus.ok,
    body: {'status': 'success', if (data != null) 'data': data},
  );
}

Response error({required String message, int? statusCode}) {
  return Response.json(
    statusCode: statusCode ?? HttpStatus.internalServerError,
    body: {
      'status': 'error',
      'message': message,
    },
  );
}

Response methodNotAllowed() => error(
  message: 'Method not allowed.',
  statusCode: HttpStatus.methodNotAllowed,
);

Response invalidBody() =>
    error(statusCode: HttpStatus.badRequest, message: 'Invalid Body');

Response badRequest({required String message}) =>
    error(statusCode: HttpStatus.badRequest, message: message);

Response unauthorized({required String message}) =>
    error(statusCode: HttpStatus.unauthorized, message: message);

Response forbidden({required String message}) =>
    error(statusCode: HttpStatus.forbidden, message: message);
