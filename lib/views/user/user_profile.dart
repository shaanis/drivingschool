import 'package:drivingschool/const.dart';
import 'package:drivingschool/controller/admin_controller.dart';
import 'package:drivingschool/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// ✅ SAFE DATE FORMATTER (NO ERRORS)
String formatDate(dynamic raw) {
  if (raw == null) return 'N/A';

  if (raw is Timestamp) {
    final dt = raw.toDate();
    return "${dt.day}-${dt.month}-${dt.year}";
  }

  if (raw is DateTime) {
    return "${raw.day}-${raw.month}-${raw.year}";
  }

  if (raw is String) {
    try {
      final dt = DateTime.parse(raw);
      return "${dt.day}-${dt.month}-${dt.year}";
    } catch (_) {
      return raw;
    }
  }

  return 'N/A';
}

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late Future<void> loadDataFuture;

  @override
  void initState() {
    super.initState();
    final userCtrl = Provider.of<UserController>(context, listen: false);
    final adminCtrl = Provider.of<AdminController>(context, listen: false);
    final uid = userCtrl.firebaseAuth.currentUser!.uid;

    loadDataFuture = adminCtrl
        .fetchAtt(uid)
        .then((_) => userCtrl.fetchInvoices(uid));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const Color primaryBlue = Color(0xFF3D6DFF);

    final userProfile = Provider.of<UserController>(context);
    final admin = Provider.of<AdminController>(context);

    return Scaffold(
      body: FutureBuilder(
        future: loadDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final invoiceList = userProfile.invoiceList;
          final attList = admin.attList;
          final selectedCourse = userProfile.userModel.selectedCourse;

          final enrollmentDate = formatDate(userProfile.userModel.createdAt);

          final totalDays = 30;
          final attendedDays = attList.length;
          final remainingDays = totalDays - attendedDays;
          final progress = attendedDays / totalDays;

          final dueDate = invoiceList.isNotEmpty
              ? formatDate(invoiceList.first.dueDate)
              : 'N/A';

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: width * 0.75,
                pinned: true,
                backgroundColor: primaryBlue,
                leading: IconButton(
                  icon: const Icon(
                    EvaIcons.arrow_ios_back_outline,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: width * 0.13,
                        backgroundImage:
                            userProfile.userModel.userProPic != null
                            ? NetworkImage(userProfile.userModel.userProPic!)
                            : const AssetImage('assets/profile.jpg')
                                  as ImageProvider,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userProfile.userModel.userName,
                        style: GoogleFonts.epilogue(
                          color: Colors.white,
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              /// BODY
              SliverPadding(
                padding: EdgeInsets.all(width * 0.05),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    selectedCourse != null
                        ? _CourseCard(
                            course: selectedCourse,
                            instructor:
                                userProfile.userModel.selectedInstructor ??
                                'N/A',
                            date: enrollmentDate,
                          )
                        : _NoCourseCard(),

                    SizedBox(height: width * 0.08),

                    /// ATTENDANCE PROGRESS
                    _AttendanceProgressCard(
                      attended: attendedDays,
                      total: totalDays,
                      remaining: remainingDays,
                      progress: progress,
                    ),

                    SizedBox(height: width * 0.08),

                    /// INFO CARDS
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: width < 600 ? 2 : 3,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1,
                      children: [
                        _InfoCard(
                          title: 'Payment Due',
                          value: dueDate,
                          icon: EvaIcons.credit_card_outline,
                          color: primaryBlue,
                        ),
                        _InfoCard(
                          title: 'Invoices',
                          value: '${invoiceList.length}',
                          icon: EvaIcons.file_text_outline,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    SizedBox(height: width * 0.15),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// COURSE CARD
class _CourseCard extends StatelessWidget {
  final String course;
  final String instructor;
  final String date;

  const _CourseCard({
    required this.course,
    required this.instructor,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Card(
      elevation: 8,
      color: defaultBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(width * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Course',
              style: GoogleFonts.epilogue(color: Colors.white70),
            ),
            const SizedBox(height: 5),
            Text(
              course,
              style: GoogleFonts.epilogue(
                color: Colors.white,
                fontSize: width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.white30),
            _detailRow(EvaIcons.person_outline, 'Instructor', instructor),
            const SizedBox(height: 10),
            _detailRow(EvaIcons.calendar_outline, 'Enrollment Date', date),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.epilogue(color: Colors.white70),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.epilogue(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// ATTENDANCE PROGRESS
class _AttendanceProgressCard extends StatelessWidget {
  final int attended;
  final int remaining;
  final int total;
  final double progress;

  const _AttendanceProgressCard({
    required this.attended,
    required this.remaining,
    required this.total,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance Progress',
              style: GoogleFonts.epilogue(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            LinearProgressIndicator(
              value: progress.clamp(0, 1),
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$attended / $total classes completed'),
                Text(
                  '$remaining classes left',
                  style: GoogleFonts.epilogue(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// INFO CARD
class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 10),
            Text(title, style: GoogleFonts.epilogue(color: Colors.grey[700])),
            const SizedBox(height: 5),
            Text(
              value,
              style: GoogleFonts.epilogue(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// NO COURSE CARD
class _NoCourseCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: const Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Icon(
              EvaIcons.alert_triangle_outline,
              color: Colors.orange,
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              'No Course Selected',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
