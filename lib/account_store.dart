import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'password_hasher.dart';

/// A local demo account. Only a salted hash of the password is kept.
class User {
  final String matricNumber; // always lower case
  final String email;
  final String salt; // base64
  final String passwordHash; // base64
  final int iterations;

  const User({
    required this.matricNumber,
    required this.email,
    required this.salt,
    required this.passwordHash,
    required this.iterations,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        matricNumber: json['matricNumber'] as String,
        email: json['email'] as String,
        salt: json['salt'] as String,
        passwordHash: json['passwordHash'] as String,
        iterations: json['iterations'] as int,
      );

  Map<String, dynamic> toJson() => {
        'matricNumber': matricNumber,
        'email': email,
        'salt': salt,
        'passwordHash': passwordHash,
        'iterations': iterations,
      };
}

/// Keeps accounts in platform secure storage (Android Keystore-backed
/// storage, iOS Keychain) instead of plain SharedPreferences.
class AccountStore {
  static const _storageKey = 'registered_users_v2';
  static const _legacyPrefsKey = 'registered_users';

  final FlutterSecureStorage _storage;

  AccountStore([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  Future<List<User>> load() async {
    await _migrateLegacyAccounts();
    return _readUsers();
  }

  Future<void> save(List<User> users) {
    return _storage.write(
      key: _storageKey,
      value: jsonEncode(users.map((user) => user.toJson()).toList()),
    );
  }

  Future<User> createUser({
    required String matricNumber,
    required String email,
    required String password,
  }) async {
    final salt = PasswordHasher.newSalt();
    final hash = await hashInBackground(
      password,
      salt,
      PasswordHasher.defaultIterations,
    );
    return User(
      matricNumber: matricNumber.toLowerCase(),
      email: email,
      salt: base64Encode(salt),
      passwordHash: base64Encode(hash),
      iterations: PasswordHasher.defaultIterations,
    );
  }

  static Future<bool> verifyPassword(User user, String password) async {
    final hash = await hashInBackground(
      password,
      base64Decode(user.salt),
      user.iterations,
    );
    return PasswordHasher.constantTimeEquals(
      hash,
      base64Decode(user.passwordHash),
    );
  }

  Future<List<User>> _readUsers() async {
    final raw = await _storage.read(key: _storageKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((entry) => User.fromJson(entry as Map<String, dynamic>))
        .toList();
  }

  /// Earlier versions of the app saved accounts in SharedPreferences with
  /// plain-text passwords. Hash those, move them to secure storage, and
  /// delete the old entries.
  Future<void> _migrateLegacyAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final legacy = prefs.getStringList(_legacyPrefsKey);
    if (legacy == null) {
      return;
    }
    final users = await _readUsers();
    for (final entry in legacy) {
      final parts = entry.split(',');
      if (parts.length != 3) {
        continue;
      }
      final matricNumber = parts[0].toLowerCase();
      if (users.any((user) => user.matricNumber == matricNumber)) {
        continue;
      }
      users.add(await createUser(
        matricNumber: matricNumber,
        email: parts[2],
        password: parts[1],
      ));
    }
    await save(users);
    await prefs.remove(_legacyPrefsKey);
  }
}
