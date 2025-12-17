import 'package:drivingschool/const.dart';
import 'package:drivingschool/controller/admin_controller.dart';
import 'package:drivingschool/views/admin/user_attedance.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final userController = Provider.of<AdminController>(context, listen: false);

    try {
      await userController.fetchUsers();
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load users: $e';
        });
      }
    }
  }

  bool _checkHasCourse(dynamic selectedCourse) {
    if (selectedCourse == null) return false;
    if (selectedCourse is String) return selectedCourse.trim().isNotEmpty;
    if (selectedCourse is List) return selectedCourse.isNotEmpty;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildHeader(width),

          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.trim().toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search by name or phone number",
                  hintStyle: GoogleFonts.epilogue(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  prefixIcon: const Icon(Iconsax.search_normal, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                ),
              ),
            ),
          ),

          Expanded(child: _buildUsersList(height)),
        ],
      ),
    );
  }

  Widget _buildHeader(double width) {
    return Container(
      width: width,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        bottom: 30,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [defaultBlue.withOpacity(0.9), defaultBlue.withOpacity(0.7)],
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
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(
                  Iconsax.arrow_left_2,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'All Users',
                style: GoogleFonts.epilogue(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Consumer<AdminController>(
                builder: (context, controller, _) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${controller.usersDataList.length} Users',
                      style: GoogleFonts.epilogue(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Driving School Students',
                  style: GoogleFonts.epilogue(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'View and manage all registered students',
                  style: GoogleFonts.epilogue(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(double height) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Consumer<AdminController>(
        builder: (context, userController, _) {
          if (_errorMessage != null) return _buildErrorState();
          if (_isLoading) return _buildLoadingState();

          final filteredUsers = userController.usersDataList.where((user) {
            final name = user.userName.toLowerCase();
            final number = user.userNumber.toString();
            return name.contains(searchQuery) || number.contains(searchQuery);
          }).toList();

          if (filteredUsers.isEmpty) {
            return const Center(child: Text("No Users Found"));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              int crossAxis = 2;
              if (constraints.maxWidth < 500) crossAxis = 2;
              if (constraints.maxWidth < 380) crossAxis = 1;

              return GridView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxis,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: constraints.maxWidth < 380 ? 0.80 : 0.75,
                ),
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  final hasCourse = _checkHasCourse(user.selectedCourse);
                  return _buildUserCard(user, height, hasCourse);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildUserCard(user, double height, bool hasCourse) {
    return InkWell(
      onTap: () {
        if (!hasCourse) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Course not assigned"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UserAttendance(
              userID: user.userID,
              userName: user.userName,
              userNumber: user.userNumber,
              trainerName: user.selectedInstructor ?? "No Instructor",
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
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
          children: [
            Container(
              height: height * 0.12,
              decoration: BoxDecoration(
                color: defaultBlue.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Center(child: _buildProfileImage(user)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          user.userName,
                          style: GoogleFonts.epilogue(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.userEmail,
                          style: GoogleFonts.epilogue(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        _buildCourseBadge(hasCourse),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _circleBtn(Iconsax.call, Colors.green, () {}),
                        const SizedBox(width: 8),
                        _circleBtn(Iconsax.eye, defaultBlue, () {
                          if (!hasCourse) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Course not assigned"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UserAttendance(
                                userID: user.userID,
                                userName: user.userName,
                                userNumber: user.userNumber,
                                trainerName:
                                    user.selectedInstructor ?? "No Instructor",
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(user) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: ClipOval(
        child: user.userProPic != null
            ? Image.network(
                user.userProPic!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallbackProfile(),
              )
            : _fallbackProfile(),
      ),
    );
  }

  Widget _fallbackProfile() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [defaultBlue.withOpacity(0.3), defaultBlue.withOpacity(0.1)],
        ),
      ),
      child: const Icon(Iconsax.profile_circle, color: defaultBlue, size: 32),
    );
  }

  Widget _buildCourseBadge(bool hasCourse) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: hasCourse
            ? defaultBlue.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        hasCourse ? "Has Course" : "No Course",
        style: GoogleFonts.epilogue(
          fontSize: 10,
          color: hasCourse ? defaultBlue : Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _circleBtn(IconData icon, Color color, VoidCallback action) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: action,
        icon: Icon(icon, size: 16, color: color),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator(color: defaultBlue));
  }
}
