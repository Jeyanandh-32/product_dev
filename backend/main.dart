import 'dart:io';

import 'package:backend/config/database.dart';
import 'package:backend/config/env.dart';
import 'package:dart_frog/dart_frog.dart';

Future<void> init(InternetAddress ip, int port) async {
  Env.init();
  await Database.init();
  await Database.runMigrations();
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  return serve(handler, InternetAddress.anyIPv4, port);
}
