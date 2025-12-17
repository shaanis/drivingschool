import 'package:drivingschool/const.dart';
import 'package:drivingschool/controller/user_controller.dart';
import 'package:drivingschool/views/user/add_user_details.dart';
import 'package:drivingschool/views/user/user_home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoogleLoginPage extends StatefulWidget {
  const GoogleLoginPage({super.key});

  @override
  State<GoogleLoginPage> createState() => _GoogleLoginPageState();
}

class _GoogleLoginPageState extends State<GoogleLoginPage> {
  bool _isLoading = false;

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? gUser = await googleSignIn.signIn();
      if (gUser == null) {
        debugPrint("Google Sign-In cancelled by user");
        return null;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      UserCredential userCred = await FirebaseAuth.instance
          .signInWithCredential(credential);

      return userCred.user;
    } catch (e, st) {
      debugPrint("Google login error: $e");
      debugPrint("Stacktrace: $st");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Google Sign-In failed: ${e.toString()}"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userCtrl = Provider.of<UserController>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [Color(0xFF0F172A), Color(0xFF1E293B)]
                : [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
        ),
        child: Column(
          children: [
            // Top decorative curve
            Container(
              height: height * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white.withOpacity(0.1), Colors.transparent],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.directions_car_filled_rounded,
                        size: 50,
                        color: defaultBlue,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Drive Master',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Learn to drive with confidence',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Login Card
            Expanded(
              child: Container(
                width: width,
                margin: EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30,
                      offset: Offset(0, -10),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Welcome Back 👋',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Sign in to access your account and continue learning',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 50),

                        // Google Login Button
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.2),
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Material(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            child: InkWell(
                              onTap: _isLoading
                                  ? null
                                  : () async {
                                      setState(() => _isLoading = true);
                                      final user = await signInWithGoogle();
                                      setState(() => _isLoading = false);

                                      if (user == null) return;

                                      final uid = user.uid;
                                      final exists = await userCtrl
                                          .checkGoogleUser(uid);

                                      if (!context.mounted) return;

                                      if (exists == true) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UserHome(uid: uid),
                                          ),
                                        );
                                      } else {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AddUserDetails(),
                                          ),
                                        );
                                      }
                                    },
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: _isLoading
                                      ? [
                                          SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.red,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            'Signing in...',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ]
                                      : [
                                          FaIcon(
                                            FontAwesomeIcons.google,
                                            color: Colors.red,
                                            size: 22,
                                          ),
                                          SizedBox(width: 16),
                                          Text(
                                            'Sign in with Google',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 30),

                        // Benefits
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFeature(
                              icon: Icons.schedule_rounded,
                              title: 'Track Progress',
                              subtitle: 'Monitor your learning journey',
                              isDark: isDark,
                            ),
                            SizedBox(height: 20),
                            _buildFeature(
                              icon: Icons.book_rounded,
                              title: 'Access Materials',
                              subtitle: 'Study guides and resources',
                              isDark: isDark,
                            ),
                            SizedBox(height: 20),
                            _buildFeature(
                              icon: Icons.calendar_today_rounded,
                              title: 'Book Classes',
                              subtitle: 'Schedule driving lessons',
                              isDark: isDark,
                            ),
                          ],
                        ),

                        SizedBox(height: 40),

                        // Footer
                        Center(
                          child: Text(
                            'Secure login with Google • Your data is protected',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey[500]
                                  : Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
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

  Widget _buildFeature({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: defaultBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: defaultBlue, size: 24),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
