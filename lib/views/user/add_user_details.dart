import 'dart:io';

import 'package:drivingschool/const.dart';
import 'package:drivingschool/views/user/user_home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../../controller/user_controller.dart';

class AddUserDetails extends StatelessWidget {
  const AddUserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final userDetailsController = Provider.of<UserController>(context);

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: width,
            height: height / 6,
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(EvaIcons.arrow_ios_back_outline),
                ),
                const SizedBox(width: 20),
                Text(
                  'Account Setup',
                  style: GoogleFonts.epilogue(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          ////////////////////////////////////////////////////////
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset('assets/Ellipse 2.png'),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Image.asset('assets/Ellipse 36.png')],
          ),

          //////////////////////////////////////////////////////
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: userDetailsController.userDetailsKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Set your account information',
                    style: GoogleFonts.epilogue(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      userDetailsController.selectproPic(context);
                    },
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: userDetailsController.proPicPath != null
                              ? FileImage(
                                  File(userDetailsController.proPicPath!),
                                )
                              : const AssetImage('assets/profile.jpg')
                                    as ImageProvider,
                        ),
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*required field';
                      } else {
                        return null;
                      }
                    },
                    controller: userDetailsController.usernameController,
                    decoration: InputDecoration(
                      isDense: true,
                      hintStyle: GoogleFonts.epilogue(),
                      hintText: 'Enter Fullname',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*required field';
                      } else {
                        return null;
                      }
                    },
                    controller: userDetailsController.userEmailController,
                    decoration: InputDecoration(
                      isDense: true,
                      hintStyle: GoogleFonts.epilogue(),
                      hintText: 'Enter Email',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*required field';
                      } else {
                        return null;
                      }
                    },
                    controller: userDetailsController.numberController,
                    decoration: InputDecoration(
                      isDense: true,
                      hintStyle: GoogleFonts.epilogue(),
                      hintText: 'Enter Phonenumber',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: width,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                        backgroundColor: const MaterialStatePropertyAll(
                          defaultBlue,
                        ),
                      ),
                      onPressed: () {
                        if (userDetailsController.userDetailsKey.currentState!
                            .validate()) {
                          final uid = userDetailsController
                              .firebaseAuth
                              .currentUser!
                              .uid;

                          userDetailsController
                              .saveUser(
                                uid,
                                userDetailsController.usernameController.text,
                                userDetailsController.userEmailController.text
                                    .trim(),
                                int.parse(
                                  userDetailsController.numberController.text
                                      .trim(),
                                ),
                              )
                              .then(
                                (value) => userDetailsController
                                    .uploadProPic(
                                      userDetailsController.proPic!,
                                      'Users Profile Pic',
                                      uid,
                                    )
                                    .whenComplete(
                                      () => Navigator.of(context)
                                          .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserHome(uid: uid),
                                            ),
                                            (route) => false,
                                          ),
                                    ),
                              );
                        }
                      },
                      child: Text(
                        'Save Information',
                        style: GoogleFonts.epilogue(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
