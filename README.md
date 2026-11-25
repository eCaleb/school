# Bowen Student Portal

A prototype of a university student portal, built in Flutter during the final year of my Computer Science degree. It runs entirely on the device with demo data, so there's no backend.

## Features

- **Sign up and log in** with a matric number and password. The forms validate input: matric numbers must be 11 letters or digits, and passwords need at least 8 characters with both letters and numbers. The password field has a show/hide toggle.
- **Course registration:** enrol in and drop courses, with prerequisite checks, and see your own schedule.
- **Payments:** outstanding and paid fees, with a demo card form. No real payments are processed.
- **E-learning:** filter by department, level and course to see notes, video lectures, assignments and assessments.
- **Results:** choose an academic session. The link out to the university's results site is a placeholder.
- **Hostel:** filter hostels by gender and level, then apply for a room.
- A profile drawer with a logout confirmation.

## Tests

`integration_test/app_test.dart` drives the login screen end to end: it enters a matric number and password, taps Login and checks that the home page opens. The values in the test are dummy data.

## Tech

Flutter, Dart, `shared_preferences`, `url_launcher`, Navigator routing and `setState`.

## Security notes

This was a UI prototype. A few things would need to change before it handled real student data:

- Accounts are saved locally in `SharedPreferences`, with passwords in plain text. A real portal would authenticate against a server, never store passwords on the device, and keep any session token in platform-backed secure storage (Android Keystore or iOS Keychain).
- The card form is for display only. A real version would hand card entry to a payment provider's SDK, so card details never pass through the app.

## Running it

```bash
flutter pub get
flutter run

# integration test (needs a device or emulator)
flutter test integration_test
```
