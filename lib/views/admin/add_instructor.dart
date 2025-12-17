import 'dart:io';

import 'package:drivingschool/const.dart';
import 'package:drivingschool/controller/admin_controller.dart';
import 'package:drivingschool/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class AddInstructor extends StatelessWidget {
  const AddInstructor({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final adminInstrctrController = Provider.of<AdminController>(context);
    final instrctrPicController = Provider.of<UserController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              height: height * 0.25,
              width: width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(
                        EvaIcons.people_outline,
                        size: 150,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),

                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  EvaIcons.arrow_ios_back_outline,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Add New Instructor',
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Setup instructor profile and details',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Form Section — FIXED HERE
            Transform.translate(
              offset: const Offset(0, -40),
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: adminInstrctrController.instrcutorAddKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Picture
                        Center(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFFE2E8F0),
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child:
                                          instrctrPicController.proPicPath !=
                                              null
                                          ? Image.file(
                                              File(
                                                instrctrPicController
                                                    .proPicPath!,
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/instructor.jpg',
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        instrctrPicController.selectproPic(
                                          context,
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF6366F1),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                0.3,
                                              ),
                                              blurRadius: 6,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          EvaIcons.camera_outline,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Tap to upload photo',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        Text(
                          'Contact Information',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fill in the instructor details below',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF64748B),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Full Name
                        Text(
                          'Full Name',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.05),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: adminInstrctrController
                                .instrcutorNameController,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter full name'
                                : null,
                            style: GoogleFonts.poppins(fontSize: 15),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              hintText: 'Enter instructor full name',
                              hintStyle: GoogleFonts.poppins(
                                color: const Color(0xFF94A3B8),
                              ),
                              border: InputBorder.none,
                              prefixIcon: const Icon(
                                EvaIcons.person_outline,
                                color: Color(0xFF64748B),
                                size: 20,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Phone Number
                        Text(
                          'Phone Number',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.05),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: adminInstrctrController
                                .instrcutorNumberController,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Enter phone number'
                                : null,
                            keyboardType: TextInputType.phone,
                            style: GoogleFonts.poppins(fontSize: 15),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              hintText: 'Enter phone number',
                              hintStyle: GoogleFonts.poppins(
                                color: const Color(0xFF94A3B8),
                              ),
                              border: InputBorder.none,
                              prefixIcon: const Icon(
                                EvaIcons.phone_outline,
                                color: Color(0xFF64748B),
                                size: 20,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              if (adminInstrctrController
                                  .instrcutorAddKey
                                  .currentState!
                                  .validate()) {
                                adminInstrctrController
                                    .saveInstructor(
                                      adminInstrctrController
                                          .instrcutorNameController
                                          .text,
                                      int.parse(
                                        adminInstrctrController
                                            .instrcutorNumberController
                                            .text,
                                      ),
                                      instrctrPicController.proPicPath!,
                                    )
                                    .then((value) {
                                      adminInstrctrController
                                          .uploadInstructorProPic(
                                            instrctrPicController.proPic!,
                                            'Instructors Profile Pic',
                                            adminInstrctrController
                                                .instructorid,
                                          );
                                    })
                                    .whenComplete(() {
                                      Navigator.of(context).pop();
                                    });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6366F1),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  EvaIcons.cloud_upload_outline,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Add Instructor',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Center(
                          child: Text(
                            'Instructor will be added to the system',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Bottom Decoration
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    EvaIcons.people_outline,
                    size: 48,
                    color: Color(0xFFF1F5F9),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Build your dream team',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
