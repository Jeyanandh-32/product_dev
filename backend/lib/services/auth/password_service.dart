import 'dart:isolate';

import 'package:bcrypt/bcrypt.dart';

/// Handles password hashing and verification using bcrypt.
class PasswordService {
  const PasswordService._();

  static Future<String> hash(String password) {
    return Isolate.run(() => BCrypt.hashpw(password, BCrypt.gensalt()));
  }

  static Future<bool> verify(String password, String hash) {
    return Isolate.run(() => BCrypt.checkpw(password, hash));
  }
}
