import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Response succes({
  int? statuscode,
  Map<String, Object?>? data,
  Map<String, Object>? headers,
}) {
  return Response.json(
    headers: headers ?? {},
    statusCode: statuscode ?? HttpStatus.ok,
    body: {'status': 'success', if (data != null) 'data': data},
  );
}

Response error({required String message, int? statuscode}) {
  return Response.json(
    statusCode: statuscode ?? HttpStatus.internalServerError,
    body: {
      'status': 'error',
      'message': message,
    },
  );
}

Response methodNotAllowed() => error(
  message: 'Method not allowed.',
  statuscode: HttpStatus.methodNotAllowed,
);

Response inValidBody() =>
    error(statuscode: HttpStatus.badRequest, message: 'Invalid Body');

Response badRequest({required String message}) =>
    error(statuscode: HttpStatus.badRequest, message: message);

Response unauthorized({required String message}) =>
    error(statuscode: HttpStatus.unauthorized, message: message);

Response forbidden({required String message}) =>
    error(statuscode: HttpStatus.forbidden, message: message);
