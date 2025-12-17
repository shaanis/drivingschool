import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivingschool/controller/admin_controller.dart';
import 'package:drivingschool/controller/user_controller.dart';
import 'package:drivingschool/views/admin/admin_home.dart';
import 'package:drivingschool/views/choose_user.dart';
import 'package:drivingschool/views/user/user_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    gotoNext(context);
    return Scaffold(body: Center(child: Image.asset('assets/splash_logo.png')));
  }

  void gotoNext(context) async {
    await Future.delayed(const Duration(seconds: 3));
    final splashProvider = Provider.of<UserController>(context, listen: false);
    final adminController = Provider.of<AdminController>(
      context,
      listen: false,
    );

    if (splashProvider.firebaseAuth.currentUser != null) {
      if (splashProvider.firebaseAuth.currentUser!.uid ==
          'OZnfVWmZloOvdi9BvIonQohXIa83') {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AdminHome()),
          (route) => false,
        );
      } else {
        DocumentSnapshot snapshot = await splashProvider.firebaseFirestore
            .collection('users')
            .doc(splashProvider.firebaseAuth.currentUser!.uid)
            .get();
        if (snapshot.exists) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                  UserHome(uid: FirebaseAuth.instance.currentUser!.uid),
            ),
            (route) => false,
          );
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const ChooseUser()),
            (route) => false,
          );
        }
      }
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const ChooseUser()),
        (route) => false,
      );
    }
  }
}
