import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

/// Password hashing for the app's local demo accounts.
///
/// Uses PBKDF2-HMAC-SHA256 with a random 16-byte salt per account, so a stored
/// hash can't be turned back into the password and two people with the same
/// password get different hashes.
class PasswordHasher {
  static const int defaultIterations = 100000;
  static const int saltLength = 16;

  static Uint8List newSalt() {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(saltLength, (_) => random.nextInt(256)),
    );
  }

  /// PBKDF2-HMAC-SHA256 (RFC 8018) with a 32-byte output, which is a single
  /// SHA-256 block.
  static Uint8List pbkdf2(String password, List<int> salt, int iterations) {
    if (iterations < 1) {
      throw ArgumentError.value(iterations, 'iterations', 'must be at least 1');
    }
    final hmac = Hmac(sha256, utf8.encode(password));
    var block = hmac.convert(<int>[...salt, 0, 0, 0, 1]).bytes;
    final result = Uint8List.fromList(block);
    for (var i = 1; i < iterations; i++) {
      block = hmac.convert(block).bytes;
      for (var j = 0; j < result.length; j++) {
        result[j] ^= block[j];
      }
    }
    return result;
  }

  /// Compares two byte lists without stopping at the first difference, so the
  /// time taken doesn't reveal how much of a hash matched.
  static bool constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) {
      return false;
    }
    var difference = 0;
    for (var i = 0; i < a.length; i++) {
      difference |= a[i] ^ b[i];
    }
    return difference == 0;
  }
}

class _HashRequest {
  final String password;
  final List<int> salt;
  final int iterations;

  const _HashRequest(this.password, this.salt, this.iterations);
}

Uint8List _runPbkdf2(_HashRequest request) =>
    PasswordHasher.pbkdf2(request.password, request.salt, request.iterations);

/// Runs the hash on a background isolate so the UI doesn't freeze.
Future<Uint8List> hashInBackground(
  String password,
  List<int> salt,
  int iterations,
) {
  return compute(_runPbkdf2, _HashRequest(password, salt, iterations));
}
