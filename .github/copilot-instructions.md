# Copilot instructions for Driving School Flutter app

Summary
- This is a Flutter mobile (and desktop/web-capable) app that uses Firebase + Provider-based state management. Aim for small, focused changes and prefer modifications to `ChangeNotifier` controllers in `lib/controller/` rather than sprinkling app logic in UI widgets.

Quick start (developer commands)
- Install deps: `flutter pub get`
- Run app: `flutter run -d <device>` (Android, iOS, Windows, Web)
- Analyze & format: `flutter analyze`, `dart format .`
- Run tests: `flutter test` (note: there is only a basic widget test)
- Reconfigure Firebase (if you need to): use the FlutterFire CLI (`dart pub global activate flutterfire_cli` then `flutterfire configure`) — generated options live in `lib/firebase_options.dart`.

Architecture & conventions
- State management: Provider + ChangeNotifier. Controllers live in `lib/controller/` (e.g., `UserController`, `AdminController`, `SlotController`). They are created in `main.dart` inside `MultiProvider`.
  - Pattern to follow: keep Firestore and business logic inside controllers; views in `lib/views/` consume controllers via `Provider.of<T>(context)` or `Consumer`.
- Data models: `lib/models/` contains model classes (e.g., `UserModel`, `SlotModel`, `InvoiceModel`). Use `.toMap()`/constructors for Firestore mapping.
- Views: UI lives under `lib/views/` split into `user/`, `admin/`, and shared pages.
- Utilities: common services (notifications, auth dialogues, helpers) live in `lib/utils/` (e.g., `NotificationService.init()` is invoked from `main.dart`).

Firebase & data flows
- Firebase initialization: `main.dart` calls `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` (see `lib/firebase_options.dart`).
- Firestore collections frequently used (search for `collection('...')`): `users`, `tests`, `slots`, `invoices`, `courses`, `instructors`, `contacts`, `attendance`.
- Auth patterns: phone OTP (see `UserController.sendOTP()` / `verifyOTP()`), and Google Sign-In (`UserController.signInWithGoogle()`).
- Storage: file uploads use `FirebaseStorage` via `UserController.storeImagetoStorge(ref, File)`.

Integrations & platform-specific notes
- Razorpay: `lib/controller/payment_gateway.dart` uses a test key (`rzp_test_...`) inside `PaymentGateway.openCheckout()`; update keys and Android/iOS native config before production.
- Notifications: `awesome_notifications` with `NotificationService.init()` in `lib/utils/notification_service.dart`. The app schedules reminders (see method `scheduleTestReminder`).
- Google Sign-In: `google_sign_in` is used; ensure platform OAuth clients are configured (check `android/app/google-services.json` and iOS equivalents).
- Image picker and file handling: `image_picker` and `open_file` are used; follow respective platform setup steps in their package docs.

Testing & debugging tips specific to this repo
- Logs: controllers use `log()` / `print()` for quick debugging. Search for `log(` to find common logging points.
- Minimal tests: add unit tests for controllers (mock Firestore) and widget tests for key screens (e.g., login flow, slot booking).
- Linting: project uses `flutter_lints` (see `analysis_options.yaml`). Keep changes conforming to the lints when possible.

PR & contribution guidance for agents
- Keep focused diffs: change one controller or feature per PR.
- Include short screenshots for UI changes and a short description of Firestore effects (which collections/documents are changed).
- Avoid committing sensitive credentials. `lib/firebase_options.dart` is present in repo; if you must reconfigure Firebase during development, coordinate with the repo owner before changing or committing new project credentials.

Where to look for examples
- Provider usage & setup: `lib/main.dart` (MultiProvider) and view files like `lib/views/user/user_profile.dart` for `Provider.of<UserController>(context)` examples.
- Phone OTP and Google Sign-in flow: `lib/controller/user_controller.dart` (methods: `sendOTP`, `verifyOTP`, `signInWithGoogle`).
- Scheduling notifications: `lib/utils/notification_service.dart` (`scheduleTestReminder`).
- Razorpay integration: `lib/controller/payment_gateway.dart` (event handlers & `openCheckout`).

If anything here is unclear or missing, tell me which part you'd like expanded (examples, recommended tests, CI steps), and I will iterate. Thank you.