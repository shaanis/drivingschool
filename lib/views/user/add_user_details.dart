import 'dart:io';
import 'package:drivingschool/views/user/user_home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import '../../const.dart';
import '../../controller/user_controller.dart';

class AddUserDetails extends StatefulWidget {
  const AddUserDetails({super.key});

  @override
  State<AddUserDetails> createState() => _AddUserDetailsState();
}

class _AddUserDetailsState extends State<AddUserDetails> {
  bool isLoading = false; // ✅ loader state

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final userDetailsController = Provider.of<UserController>(context);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // ---------------- Top Gradient ------------------
              Container(
                height: height * 0.35,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2F56F4), Color(0xFF507BFF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // ---------------- Back Button ------------------
              SafeArea(
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    EvaIcons.arrow_ios_back_outline,
                    color: Colors.white,
                  ),
                ),
              ),

              // ---------------- Form Content ------------------
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.12),

                      /// ---------------- Heading ------------------
                      Text(
                        "Create Profile",
                        style: GoogleFonts.epilogue(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Set up your account information",
                        style: GoogleFonts.epilogue(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// ---------------- Profile Picture ------------------
                      InkWell(
                        onTap: () {
                          userDetailsController.selectproPic(context);
                        },
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.15),
                                offset: const Offset(0, 4),
                              ),
                            ],
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: userDetailsController.proPicPath != null
                                  ? FileImage(
                                      File(userDetailsController.proPicPath!),
                                    )
                                  : const AssetImage('assets/profile.jpg')
                                        as ImageProvider,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Form(
                        key: userDetailsController.userDetailsKey,
                        child: Column(
                          children: [
                            /// ---------------- Full Name ------------------
                            TextFormField(
                              validator: (value) =>
                                  value!.isEmpty ? "* Required field" : null,
                              controller:
                                  userDetailsController.usernameController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  EvaIcons.person_outline,
                                  color: Colors.black54,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF7F8FA),
                                hintText: "Full Name",
                                hintStyle: GoogleFonts.epilogue(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            /// ---------------- Phone Number ------------------
                            TextFormField(
                              validator: (value) =>
                                  value!.isEmpty ? "* Required field" : null,
                              controller:
                                  userDetailsController.numberController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  EvaIcons.phone_outline,
                                  color: Colors.black54,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF7F8FA),
                                hintText: "Phone Number",
                                hintStyle: GoogleFonts.epilogue(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            /// ---------------- Save Button ------------------
                            SizedBox(
                              width: width,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  backgroundColor: defaultBlue,
                                ),
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                        if (userDetailsController
                                            .userDetailsKey
                                            .currentState!
                                            .validate()) {
                                          setState(() => isLoading = true);

                                          final uid = userDetailsController
                                              .firebaseAuth
                                              .currentUser!
                                              .uid;

                                          final email =
                                              userDetailsController
                                                  .firebaseAuth
                                                  .currentUser!
                                                  .email ??
                                              "";

                                          await userDetailsController.saveUser(
                                            uid,
                                            userDetailsController
                                                .usernameController
                                                .text
                                                .trim(),
                                            email,
                                            int.parse(
                                              userDetailsController
                                                  .numberController
                                                  .text
                                                  .trim(),
                                            ),
                                          );

                                          if (userDetailsController.proPic !=
                                              null) {
                                            await userDetailsController
                                                .uploadProPic(
                                                  userDetailsController.proPic!,
                                                  'Users Profile Pic',
                                                  uid,
                                                );
                                          }

                                          if (!mounted) return;

                                          Navigator.of(
                                            context,
                                          ).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserHome(uid: uid),
                                            ),
                                            (route) => false,
                                          );

                                          setState(() => isLoading = false);
                                        }
                                      },
                                child: Text(
                                  'Continue',
                                  style: GoogleFonts.epilogue(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ---------------- Loader Overlay ------------------
        if (isLoading)
          Container(
            height: height,
            width: width,
            color: Colors.black.withOpacity(0.4),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          ),
      ],
    );
  }
}
