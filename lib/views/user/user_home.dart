import 'package:drivingschool/const.dart';
import 'package:drivingschool/controller/user_controller.dart';
import 'package:drivingschool/views/user/slot_booking_page.dart';
import 'package:drivingschool/views/user/test_result_page.dart';
import 'package:drivingschool/views/user/user_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class UserHome extends StatefulWidget {
  final String uid;
  const UserHome({required this.uid, super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  late Future<void> _fetchUserFuture;

  @override
  void initState() {
    super.initState();
    final userHomeController = Provider.of<UserController>(
      context,
      listen: false,
    );
    _fetchUserFuture = userHomeController.fetchUserData(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userHomeController = Provider.of<UserController>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: FutureBuilder(
          future: _fetchUserFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: defaultBlue,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Loading your dashboard...',
                      style: GoogleFonts.epilogue(color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            final user = userHomeController.userModel;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  expandedHeight: size.height * 0.24,
                  floating: false,
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            defaultBlue.withOpacity(0.9),
                            defaultBlue.withOpacity(0.7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome back,',
                                      style: GoogleFonts.epilogue(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      user.userName ?? 'Student',
                                      style: GoogleFonts.epilogue(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const UserSettings(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Iconsax.setting_4,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),

                            if (user.selectedCourse != null)
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Iconsax.driving,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Current Course",
                                            style: GoogleFonts.epilogue(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            user.selectedCourse!,
                                            style: GoogleFonts.epilogue(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Main Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats Section
                        if (user.selectedCourse != null) _buildStatsSection(),

                        const SizedBox(height: 30),

                        // Services Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Services',
                              style: GoogleFonts.epilogue(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[900],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: defaultBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${userHomeController.userServiceList?.length ?? 0} available',
                                style: GoogleFonts.epilogue(
                                  fontSize: 12,
                                  color: defaultBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Access all driving services",
                          style: GoogleFonts.epilogue(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 25),

                        // Responsive Services Grid
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.maxWidth;
                            final itemWidth = width / 3;
                            final itemHeight = itemWidth * 1.15;

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  userHomeController.userServiceList?.length ??
                                  0,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 20,
                                    childAspectRatio: itemWidth / itemHeight,
                                  ),
                              itemBuilder: (_, index) {
                                final service =
                                    userHomeController.userServiceList![index];

                                return _buildServiceItem(service);
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 40),

                        // Quick Actions
                        _buildQuickActions(user),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ----------------------- Widgets ---------------------------

  Widget _buildStatsSection() {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildStatCard(
            icon: Iconsax.calendar,
            title: 'Progress',
            value: '75%',
            gradient: [Colors.blueAccent, Colors.blue],
          ),
          const SizedBox(width: 15),
          _buildStatCard(
            icon: Iconsax.clock,
            title: 'Hours',
            value: '24/30',
            gradient: [Colors.orangeAccent, Colors.orange],
          ),
          const SizedBox(width: 15),
          _buildStatCard(
            icon: Iconsax.star_1,
            title: 'Grade',
            value: 'A+',
            gradient: [Colors.greenAccent, Colors.green],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required List<Color> gradient,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const Spacer(),
          Text(
            title,
            style: GoogleFonts.epilogue(color: Colors.white70, fontSize: 12),
          ),
          Text(
            value,
            style: GoogleFonts.epilogue(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(service) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: service["onTap"] == null
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => service["onTap"]),
              );
            },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ICON
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    defaultBlue.withOpacity(0.9),
                    defaultBlue.withOpacity(0.7),
                  ],
                ),
              ),
              child: service["icon"] != ""
                  ? Icon(service['icon'], size: 30, color: Colors.white)
                  : const Icon(Iconsax.category, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              service["service name"],
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.epilogue(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(user) {
    final List<Map<String, dynamic>> actions = [
      {
        "icon": Iconsax.calendar_2,
        "label": "Schedule",
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TestResultsPage()),
          );
        },
      },
      {
        "icon": Iconsax.book,
        "label": "Lessons",
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SlotBookingPage(
                studentId: user.userID,
                studentName: user.userName!,
                studentNumber: user.userNumber.toString(),
              ),
            ),
          );
        },
      },
      {"icon": Iconsax.wallet_3, "label": "Payments"},
      {"icon": Iconsax.message, "label": "Support"},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            defaultBlue.withOpacity(0.05),
            defaultBlue.withOpacity(0.02),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.flash, color: defaultBlue),
              const SizedBox(width: 10),
              Text(
                "Quick Actions",
                style: GoogleFonts.epilogue(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Responsive Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: actions.map((act) {
              return Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: act["onTap"],
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: defaultBlue.withOpacity(0.12),
                      ),
                      child: Icon(act["icon"], color: defaultBlue),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    act["label"],
                    style: GoogleFonts.epilogue(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
