import 'package:drivingschool/const.dart';
import 'package:drivingschool/controller/admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class AddCourse extends StatelessWidget {
  const AddCourse({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final adminCtrl = Provider.of<AdminController>(context);

    return Scaffold(
      backgroundColor: const Color(0xfff4f6fa),
      body: SafeArea(
        child: Column(
          children: [
            /// -------------------- HEADER --------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(EvaIcons.arrow_ios_back_outline),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Add Course",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// ---------------- CENTERED FORM ----------------
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: width,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          spreadRadius: 3,
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Form(
                      key: adminCtrl.courseAddKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Enter Course Details",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),

                          /// ------------- COURSE NAME --------------
                          Text(
                            "Course Name",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _inputField(
                            controller: adminCtrl.courseNameController,
                            hint: "Enter course name",
                          ),

                          const SizedBox(height: 15),

                          /// ------------- TOTAL HOURS ---------------
                          Text(
                            "Total Hours",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _inputField(
                            controller: adminCtrl.courseHoursController,
                            hint: "Enter total hours",
                            type: TextInputType.number,
                          ),

                          const SizedBox(height: 15),

                          /// ------------- PRICE -------------------
                          Text(
                            "Course Price",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _inputField(
                            controller: adminCtrl.coursePriceController,
                            hint: "Enter price",
                            type: TextInputType.number,
                          ),

                          const SizedBox(height: 25),

                          /// ---------------- BUTTON ----------------
                          SizedBox(
                            width: width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 4,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: defaultBlue,
                              ),
                              onPressed: () {
                                if (adminCtrl.courseAddKey.currentState!
                                    .validate()) {
                                  adminCtrl
                                      .saveCourse(
                                        adminCtrl.courseNameController.text,
                                        int.parse(
                                          adminCtrl.courseHoursController.text,
                                        ),
                                        int.parse(
                                          adminCtrl.coursePriceController.text,
                                        ),
                                      )
                                      .then((value) => Navigator.pop(context));
                                }
                              },
                              child: Text(
                                "Upload",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- REUSABLE INPUT FIELD ----------------
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType type = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: (v) => v == null || v.isEmpty ? "*required field" : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xfff0f2f5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 14,
        ),
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
      ),
    );
  }
}
