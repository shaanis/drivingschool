import 'package:drivingschool/controller/admin_controller.dart';
import 'package:drivingschool/controller/payment_gateway.dart';
import 'package:drivingschool/controller/slot_controller.dart';
import 'package:drivingschool/controller/test_controller.dart';
import 'package:drivingschool/controller/user_controller.dart';
import 'package:drivingschool/firebase_options.dart';
import 'package:drivingschool/utils/notification_service.dart';
import 'package:drivingschool/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserController>(
          create: (context) => UserController(),
        ),
        ChangeNotifierProvider<PaymentGateway>(
          create: (context) => PaymentGateway(),
        ),
        ChangeNotifierProvider<AdminController>(
          create: (context) => AdminController(),
        ),
        ChangeNotifierProvider<TestController>(
          create: (context) => TestController(),
        ),
        ChangeNotifierProvider<SlotController>(
          create: (context) => SlotController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Driving School',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
