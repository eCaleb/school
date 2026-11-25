# Bowen Student Portal

A prototype of a university student portal, built in Flutter during the final year of my Computer Science degree. It runs entirely on the device with demo data, so there's no backend.

## Features

- **Sign up and log in** with a matric number and password. The forms validate input: matric numbers must be 11 letters or digits, and passwords need at least 8 characters with both letters and numbers. The password field has a show/hide toggle.
- **Course registration:** enrol in and drop courses, with prerequisite checks, and see your own schedule.
- **Payments:** outstanding and paid fees, with a demo payment step. No card details are collected and no money is taken.
- **E-learning:** filter by department, level and course to see notes, video lectures, assignments and assessments.
- **Results:** choose an academic session. The link out to the university's results site is a placeholder.
- **Hostel:** filter hostels by gender and level, then apply for a room.
- A profile drawer with a logout confirmation.

## Tests

- `test/password_hasher_test.dart` checks the password hashing against published PBKDF2-HMAC-SHA256 test vectors, and checks that salts are random and comparisons work.
- `integration_test/app_test.dart` runs end to end on a device: it registers a new account, logs in with it and checks that the home page opens, then checks that a wrong password is rejected. The values in the test are dummy data.

## Tech

Flutter, Dart, `flutter_secure_storage`, `crypto`, `url_launcher`, Navigator routing and `setState`.

## Security

The first version of this prototype had several security problems. They're fixed as follows:

| Problem | Fix |
| --- | --- |
| Passwords were saved in plain text in `SharedPreferences` | Only a salted PBKDF2-HMAC-SHA256 hash is stored (16-byte random salt, 100,000 iterations), in `flutter_secure_storage`, which uses the Android Keystore and the iOS Keychain. Accounts from the old version are hashed and moved on first launch, and the plain-text copies are deleted. |
| Anyone could register an existing matric number again with their own password and then log in as that student | Registration refuses a matric number that already has an account |
| Logging out pushed the login screen on top, so the back button returned to the logged-in pages | Logout clears the navigation stack |
| The payment form asked for a card number, expiry date and CVV | The card fields are gone. Payment is a clearly labelled demo step. |

The hashing runs on a background isolate so the UI doesn't freeze. Comparisons are constant-time.

What a real portal would still need: accounts belong on a server, not on the phone. The app would send credentials over HTTPS, keep only a short-lived session token in secure storage, and hand payments to a provider's own checkout. Because hashing runs in pure Dart, 100,000 iterations is a trade-off for speed on older phones. A server would use a higher count, or Argon2id.

## Running it

```bash
flutter pub get
flutter run

# unit tests
flutter test

# integration tests (needs a device or emulator)
flutter test integration_test
```

On macOS and Linux desktop, `flutter_secure_storage` needs extra setup (a Keychain entitlement on macOS, `libsecret` on Linux). Android and iOS work as they are.
