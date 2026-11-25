import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:school/password_hasher.dart';

String toHex(List<int> bytes) =>
    bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

void main() {
  group('PBKDF2-HMAC-SHA256 matches published test vectors', () {
    final salt = utf8.encode('salt');

    test('1 iteration', () {
      expect(
        toHex(PasswordHasher.pbkdf2('password', salt, 1)),
        '120fb6cffcf8b32c43e7225256c4f837a86548c92ccc35480805987cb70be17b',
      );
    });

    test('2 iterations', () {
      expect(
        toHex(PasswordHasher.pbkdf2('password', salt, 2)),
        'ae4d0c95af6b46d32d0adff928f06dd02a303f8ef3c251dfd6e2d85a95474c43',
      );
    });

    test('4096 iterations', () {
      expect(
        toHex(PasswordHasher.pbkdf2('password', salt, 4096)),
        'c5e478d59288c841aa530db6845c4c8d962893a001ce4e11a4963873aa98134a',
      );
    });
  });

  test('the same password with different salts gives different hashes', () {
    final first = PasswordHasher.pbkdf2('computer123', PasswordHasher.newSalt(), 1000);
    final second = PasswordHasher.pbkdf2('computer123', PasswordHasher.newSalt(), 1000);
    expect(PasswordHasher.constantTimeEquals(first, second), isFalse);
  });

  test('salts are 16 random bytes', () {
    final salt = PasswordHasher.newSalt();
    expect(salt.length, PasswordHasher.saltLength);
    expect(toHex(salt), isNot(toHex(PasswordHasher.newSalt())));
  });

  test('constantTimeEquals', () {
    expect(PasswordHasher.constantTimeEquals([1, 2, 3], [1, 2, 3]), isTrue);
    expect(PasswordHasher.constantTimeEquals([1, 2, 3], [1, 2, 4]), isFalse);
    expect(PasswordHasher.constantTimeEquals([1, 2, 3], [1, 2]), isFalse);
  });

  test('rejects zero iterations', () {
    expect(
      () => PasswordHasher.pbkdf2('password', utf8.encode('salt'), 0),
      throwsArgumentError,
    );
  });
}
