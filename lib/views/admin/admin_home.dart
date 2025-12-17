import 'package:drivingschool/const.dart';
import 'package:drivingschool/controller/user_controller.dart';
import 'package:drivingschool/views/choose_user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final adminHomeController = Provider.of<UserController>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildHeader(context, adminHomeController, width),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  _buildStatsSection(),
                  const SizedBox(height: 30),
                  _buildServiceHeader(adminHomeController),
                  const SizedBox(height: 10),
                  _buildServiceGrid(context, adminHomeController),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------
  // HEADER
  // --------------------------------------------------------------
  Widget _buildHeader(
    BuildContext context,
    UserController controller,
    double width,
  ) {
    return Container(
      width: width,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 25,
        left: 22,
        right: 22,
        bottom: 35,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            defaultBlue.withOpacity(0.95),
            defaultBlue.withOpacity(0.75),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Admin Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: GoogleFonts.epilogue(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'Admin',
                    style: GoogleFonts.epilogue(
                      color: Colors.white,
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Logout Button
              GestureDetector(
                onTap: () {
                  controller.firebaseAuth.signOut().then(
                    (value) => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (ctx) => const ChooseUser()),
                      (route) => false,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.28)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Iconsax.logout, color: Colors.red, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        "Logout",
                        style: GoogleFonts.epilogue(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // Header description
          Text(
            "Admin Dashboard",
            style: GoogleFonts.epilogue(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Manage all driving school operations from one place",
            style: GoogleFonts.epilogue(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------
  // STATS SECTION
  // --------------------------------------------------------------
  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Iconsax.profile_2user,
            "24",
            "Students",
            Colors.blueAccent,
          ),
          _buildStatItem(
            Iconsax.teacher,
            "5",
            "Instructors",
            Colors.greenAccent,
          ),
          _buildStatItem(Iconsax.car, "8", "Courses", Colors.orangeAccent),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.epilogue(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
        Text(
          label,
          style: GoogleFonts.epilogue(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  // --------------------------------------------------------------
  // SERVICE HEADER
  // --------------------------------------------------------------
  Widget _buildServiceHeader(UserController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Management Services",
          style: GoogleFonts.epilogue(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: defaultBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "${controller.adminServiceList.length} services",
            style: GoogleFonts.epilogue(
              fontSize: 12,
              color: defaultBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------------------
  // SERVICE GRID
  // --------------------------------------------------------------
  Widget _buildServiceGrid(BuildContext context, UserController controller) {
    return Expanded(
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.88,
        ),
        itemCount: controller.adminServiceList.length,
        itemBuilder: (context, index) {
          final service = controller.adminServiceList[index];
          final icon = service['icon'];
          final title = service['service name'];
          final page = service['onTap'];

          return GestureDetector(
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (ctx) => page));
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon container
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          defaultBlue.withOpacity(0.9),
                          defaultBlue.withOpacity(0.7),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.epilogue(
                        fontSize: 13,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
