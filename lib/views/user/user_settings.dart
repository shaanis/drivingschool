import 'package:drivingschool/const.dart';
import 'package:drivingschool/controller/user_controller.dart';
import 'package:drivingschool/views/choose_user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserSettings extends StatelessWidget {
  const UserSettings({super.key});

  Future<void> _signOut(BuildContext context, UserController controller) async {
    try {
      // Firebase sign out
      await controller.firebaseAuth.signOut();

      // Google sign out
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      // Navigate back to ChooseUser
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const ChooseUser()),
        (route) => false,
      );
    } catch (e) {
      // Handle error if needed
      print("Error signing out: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error signing out. Try again.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final userSettingController = Provider.of<UserController>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar with Gradient
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: height * 0.3,
            floating: false,
            pinned: true,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.arrow_left_2,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton(
                  onPressed: () => _signOut(context, userSettingController),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.logout_1,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Settings',
                style: GoogleFonts.epilogue(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      defaultBlue.withOpacity(0.9),
                      defaultBlue.withOpacity(0.7),
                      defaultBlue.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Profile Card
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Profile Picture
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: defaultBlue.withOpacity(0.3),
                                  width: 3,
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    defaultBlue.withOpacity(0.1),
                                    defaultBlue.withOpacity(0.05),
                                  ],
                                ),
                              ),
                              child: ClipOval(
                                child:
                                    userSettingController
                                            .userModel
                                            .userProPic !=
                                        null
                                    ? Image.network(
                                        userSettingController
                                            .userModel
                                            .userProPic!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Iconsax.profile_circle,
                                                size: 60,
                                                color: defaultBlue,
                                              );
                                            },
                                      )
                                    : const Icon(
                                        Iconsax.profile_circle,
                                        size: 60,
                                        color: defaultBlue,
                                      ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                userSettingController
                                    .selectproPic(context)
                                    .whenComplete(
                                      () => userSettingController.uploadProPic(
                                        userSettingController.proPic!,
                                        'Users Profile Pic',
                                        userSettingController.uid,
                                      ),
                                    );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: defaultBlue,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: defaultBlue.withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Iconsax.camera,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          userSettingController.userModel.userName,
                          style: GoogleFonts.epilogue(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'User ID: ${userSettingController.userModel.userID}',
                          style: GoogleFonts.epilogue(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Personal Information Card
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 15,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: defaultBlue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Iconsax.profile_2user,
                                    color: defaultBlue,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Personal Information',
                                  style: GoogleFonts.epilogue(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[900],
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                // Edit profile functionality
                              },
                              style: IconButton.styleFrom(
                                backgroundColor: defaultBlue.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(
                                Iconsax.edit_2,
                                color: defaultBlue,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildInfoRow(
                          icon: Iconsax.user,
                          title: 'Full Name',
                          value: userSettingController.userModel.userName,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          icon: Iconsax.sms,
                          title: 'Email Address',
                          value: userSettingController.userModel.userEmail,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          icon: Iconsax.call,
                          title: 'Phone Number',
                          value: userSettingController.userModel.userNumber
                              .toString(),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          icon: Iconsax.book,
                          title: 'Course',
                          value:
                              userSettingController.userModel.selectedCourse ==
                                  null
                              ? 'No course selected'
                              : userSettingController.userModel.selectedCourse!,
                        ),
                      ],
                    ),
                  ),

                  // Account Settings
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 40),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 15,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: defaultBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Iconsax.setting_2,
                                color: defaultBlue,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Account Settings',
                              style: GoogleFonts.epilogue(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[900],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildSettingOption(
                          icon: Iconsax.shield_tick,
                          title: 'Privacy & Security',
                          onTap: () {},
                        ),
                        const SizedBox(height: 16),
                        _buildSettingOption(
                          icon: Iconsax.notification,
                          title: 'Notifications',
                          onTap: () {},
                        ),
                        const SizedBox(height: 16),
                        _buildSettingOption(
                          icon: Iconsax.language_square,
                          title: 'Language',
                          value: 'English',
                          onTap: () {},
                        ),
                        const SizedBox(height: 16),
                        _buildSettingOption(
                          icon: Iconsax.moon,
                          title: 'Dark Mode',
                          value: 'Off',
                          onTap: () {},
                        ),
                        const SizedBox(height: 20),
                        // Logout Button
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                              width: 1,
                            ),
                            color: Colors.red.withOpacity(0.05),
                          ),
                          child: InkWell(
                            onTap: () =>
                                _signOut(context, userSettingController),
                            borderRadius: BorderRadius.circular(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Iconsax.logout_1,
                                  color: Colors.red,
                                  size: 22,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Logout',
                                  style: GoogleFonts.epilogue(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.grey[700], size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.epilogue(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.epilogue(
                  color: Colors.grey[900],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingOption({
    required IconData icon,
    required String title,
    String? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[100]!, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: defaultBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: defaultBlue, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.epilogue(
                  color: Colors.grey[900],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (value != null)
              Text(
                value,
                style: GoogleFonts.epilogue(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            const SizedBox(width: 8),
            const Icon(Iconsax.arrow_right_3, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }
}
