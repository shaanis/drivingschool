import 'package:drivingschool/const.dart';
import 'package:drivingschool/controller/admin_controller.dart';
import 'package:drivingschool/controller/payment_gateway.dart';
import 'package:drivingschool/controller/user_controller.dart';
import 'package:drivingschool/views/user/choose_payment.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class Courses extends StatelessWidget {
  const Courses({super.key});

  Widget _buildFeatureText(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Iconsax.tick_circle,
          color: Colors.white.withOpacity(0.8),
          size: 14,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.epilogue(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header Banner
          Container(
            width: width,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              left: 20,
              right: 20,
              bottom: 30,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  defaultBlue.withOpacity(0.9),
                  defaultBlue.withOpacity(0.7),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                      ),
                      icon: const Icon(
                        Iconsax.arrow_left_2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Packages',
                      style: GoogleFonts.epilogue(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Choose Your Driving Course',
                  style: GoogleFonts.epilogue(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select the perfect package to start your driving journey',
                  style: GoogleFonts.epilogue(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // MAIN CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Consumer2<AdminController, UserController>(
                builder: (context, adminController, userController, _) {
                  return FutureBuilder(
                    future: adminController.fetchCourses(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: defaultBlue),
                        );
                      }

                      if (adminController.coursesList.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Iconsax.box_remove,
                              size: 80,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "No Courses Available",
                              style: GoogleFonts.epilogue(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      }

                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.85,
                            ),
                        itemCount: adminController.coursesList.length,
                        itemBuilder: (context, index) {
                          final course = adminController.coursesList[index];
                          final price =
                              double.tryParse(course.coursePrice.toString()) ??
                              0;

                          // Colors Rotation
                          final List<List<Color>> gradients = [
                            [const Color(0xFF1B53FF), const Color(0xFF3D6DFF)],
                            [const Color(0xFFF4E558), const Color(0xFFFFD166)],
                            [const Color(0xFF34C759), const Color(0xFF30D158)],
                          ];

                          final gradientColors =
                              gradients[index % gradients.length];

                          return InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () async {
                              final paymentSuccess = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChangeNotifierProvider(
                                    create: (_) => PaymentGateway(),
                                    child: ChoosePayment(
                                      price: price,
                                      courseId: course.courseID, // Pass ID
                                      courseName: course.courseName, // optional
                                      userName:
                                          userController.userModel.userName,
                                      userPhone: userController
                                          .userModel
                                          .userNumber
                                          .toString(),
                                      userEmail:
                                          userController.userModel.userEmail,
                                    ),
                                  ),
                                ),
                              );

                              if (paymentSuccess == true && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "${course.courseName} selected successfully!",
                                      style: GoogleFonts.epilogue(),
                                    ),
                                    backgroundColor: defaultBlue,
                                  ),
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: gradientColors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 36,
                                      width: 36,
                                      decoration: BoxDecoration(
                                        color: Colors.white24,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${index + 1}",
                                          style: GoogleFonts.fraunces(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      course.courseName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.epilogue(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildFeatureText("Professional Training"),
                                    const SizedBox(height: 4),
                                    _buildFeatureText("Flexible Schedule"),
                                    const Spacer(),
                                    Text(
                                      "Starting from",
                                      style: GoogleFonts.epilogue(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "₹",
                                          style: GoogleFonts.fraunces(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          price.toStringAsFixed(0),
                                          style: GoogleFonts.fraunces(
                                            color: Colors.white,
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          "Select Package",
                                          style: GoogleFonts.epilogue(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(
                                          Iconsax.arrow_right_3,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
