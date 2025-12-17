import 'package:drivingschool/const.dart';
import 'package:drivingschool/controller/admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserAttendance extends StatefulWidget {
  final String userID;
  final String userName;
  final int userNumber;
  final String trainerName;
  const UserAttendance({
    required this.userID,
    required this.userName,
    required this.userNumber,
    required this.trainerName,
    super.key,
  });

  @override
  State<UserAttendance> createState() => _UserAttendanceState();
}

class _UserAttendanceState extends State<UserAttendance> {
  bool _isLoading = true;
  String? _errorMessage;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  Future<void> _fetchAttendance() async {
    final attController = Provider.of<AdminController>(context, listen: false);

    try {
      await attController.fetchAtt(widget.userID);
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
          _errorMessage = 'Failed to load attendance: $e';
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: defaultBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: defaultBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _markAttendance() async {
    final attController = Provider.of<AdminController>(context, listen: false);

    final dateString = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final timeString = '${_selectedTime.hour}:${_selectedTime.minute}';

    try {
      await attController.markAttendance(
        dateString,
        timeString,
        widget.userID,
        widget.trainerName,
        context,
      );

      await _fetchAttendance();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Attendance marked successfully!',
            style: GoogleFonts.epilogue(),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to mark attendance: $e',
            style: GoogleFonts.epilogue(),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _showMarkAttendanceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: defaultBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.calendar_add,
                  color: defaultBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  'Mark Attendance',
                  style: GoogleFonts.epilogue(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'For ${widget.userName}',
                  style: GoogleFonts.epilogue(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                // Date Selection
                InkWell(
                  onTap: () => _selectDate(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!, width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: defaultBlue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Iconsax.calendar,
                            color: defaultBlue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date',
                                style: GoogleFonts.epilogue(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  DateFormat(
                                    'dd-MM-yyyy',
                                  ).format(_selectedDate),
                                  style: GoogleFonts.epilogue(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[900],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Iconsax.arrow_right_3,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Time Selection
                InkWell(
                  onTap: () => _selectTime(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!, width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: defaultBlue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Iconsax.clock,
                            color: defaultBlue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Time',
                                style: GoogleFonts.epilogue(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                _selectedTime.format(context),
                                style: GoogleFonts.epilogue(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[900],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Iconsax.arrow_right_3,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Trainer: ${widget.trainerName}',
                  style: GoogleFonts.epilogue(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 8,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.epilogue(fontWeight: FontWeight.w500),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _markAttendance();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: defaultBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: FittedBox(
                    child: Text(
                      'Mark Attendance',
                      style: GoogleFonts.epilogue(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              width: width,
              padding: EdgeInsets.only(
                top: isSmallScreen ? 16 : 24,
                left: isSmallScreen ? 16 : 24,
                right: isSmallScreen ? 16 : 24,
                bottom: isSmallScreen ? 20 : 30,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    defaultBlue.withOpacity(0.9),
                    defaultBlue.withOpacity(0.7),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
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
                          padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: Icon(
                          Iconsax.arrow_left_2,
                          color: Colors.white,
                          size: isSmallScreen ? 20 : 24,
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 8 : 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Attendance Records',
                              style: GoogleFonts.epilogue(
                                color: Colors.white,
                                fontSize: isSmallScreen ? 20 : 24,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.userName,
                              style: GoogleFonts.epilogue(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: isSmallScreen ? 12 : 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 8 : 12,
                          vertical: isSmallScreen ? 4 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Consumer<AdminController>(
                          builder: (context, controller, _) {
                            return Text(
                              '${controller.attList.length} records',
                              style: GoogleFonts.epilogue(
                                color: Colors.white,
                                fontSize: isSmallScreen ? 10 : 12,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 20),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 8 : 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attendance History',
                          style: GoogleFonts.epilogue(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 4 : 8),
                        Text(
                          'View and manage attendance for ${widget.userName}',
                          style: GoogleFonts.epilogue(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
                child: Consumer<AdminController>(
                  builder: (context, attController, _) {
                    // Error State
                    if (_errorMessage != null) {
                      return Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                  isSmallScreen ? 16 : 24,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Iconsax.warning_2,
                                  size: isSmallScreen ? 50 : 60,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 16 : 20),
                              Text(
                                'Error Loading Attendance',
                                style: GoogleFonts.epilogue(
                                  fontSize: isSmallScreen ? 18 : 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: isSmallScreen ? 8 : 10),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 20 : 40,
                                ),
                                child: Text(
                                  _errorMessage!,
                                  style: GoogleFonts.epilogue(
                                    color: Colors.grey[600],
                                    fontSize: isSmallScreen ? 12 : 14,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 16 : 20),
                              ElevatedButton(
                                onPressed: _fetchAttendance,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: defaultBlue,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmallScreen ? 20 : 24,
                                    vertical: isSmallScreen ? 10 : 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Try Again',
                                  style: GoogleFonts.epilogue(
                                    fontWeight: FontWeight.w600,
                                    fontSize: isSmallScreen ? 14 : 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Loading State
                    if (_isLoading) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: defaultBlue,
                              strokeWidth: 2,
                            ),
                            SizedBox(height: isSmallScreen ? 12 : 16),
                            Text(
                              'Loading attendance records...',
                              style: GoogleFonts.epilogue(
                                color: Colors.grey[600],
                                fontSize: isSmallScreen ? 14 : 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Empty State
                    if (attController.attList.isEmpty) {
                      return Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                  isSmallScreen ? 16 : 24,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Iconsax.calendar_remove,
                                  size: isSmallScreen ? 50 : 60,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 16 : 20),
                              Text(
                                'No Attendance Records',
                                style: GoogleFonts.epilogue(
                                  fontSize: isSmallScreen ? 18 : 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 8 : 10),
                              Text(
                                'Mark attendance to get started',
                                style: GoogleFonts.epilogue(
                                  color: Colors.grey[600],
                                  fontSize: isSmallScreen ? 14 : 16,
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 16 : 20),
                              ElevatedButton(
                                onPressed: _showMarkAttendanceDialog,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: defaultBlue,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmallScreen ? 20 : 24,
                                    vertical: isSmallScreen ? 10 : 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Mark First Attendance',
                                  style: GoogleFonts.epilogue(
                                    fontWeight: FontWeight.w600,
                                    fontSize: isSmallScreen ? 14 : 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Success State - Attendance List
                    return Column(
                      children: [
                        // Summary Card
                        Container(
                          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                          margin: EdgeInsets.only(
                            bottom: isSmallScreen ? 12 : 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Attendance Summary',
                                          style: GoogleFonts.epilogue(
                                            fontSize: isSmallScreen ? 14 : 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[900],
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: isSmallScreen ? 6 : 8),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: isSmallScreen
                                                    ? 8
                                                    : 12,
                                                vertical: isSmallScreen ? 4 : 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.green.withOpacity(
                                                  0.1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Iconsax.tick_circle,
                                                    color: Colors.green,
                                                    size: isSmallScreen
                                                        ? 12
                                                        : 14,
                                                  ),
                                                  SizedBox(
                                                    width: isSmallScreen
                                                        ? 4
                                                        : 6,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      '${attController.attList.length} Days',
                                                      style:
                                                          GoogleFonts.epilogue(
                                                            color: Colors.green,
                                                            fontSize:
                                                                isSmallScreen
                                                                ? 10
                                                                : 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: isSmallScreen
                                                    ? 8
                                                    : 12,
                                                vertical: isSmallScreen ? 4 : 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: defaultBlue.withOpacity(
                                                  0.1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Iconsax.teacher,
                                                    color: defaultBlue,
                                                    size: isSmallScreen
                                                        ? 12
                                                        : 14,
                                                  ),
                                                  SizedBox(
                                                    width: isSmallScreen
                                                        ? 4
                                                        : 6,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      widget.trainerName,
                                                      style:
                                                          GoogleFonts.epilogue(
                                                            color: defaultBlue,
                                                            fontSize:
                                                                isSmallScreen
                                                                ? 10
                                                                : 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
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
                                  SizedBox(width: isSmallScreen ? 8 : 12),
                                  ElevatedButton.icon(
                                    onPressed: _showMarkAttendanceDialog,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: defaultBlue,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isSmallScreen ? 12 : 16,
                                        vertical: isSmallScreen ? 10 : 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    icon: Icon(
                                      Iconsax.add,
                                      size: isSmallScreen ? 16 : 18,
                                    ),
                                    label: Text(
                                      isSmallScreen ? 'Mark' : 'Mark New',
                                      style: GoogleFonts.epilogue(
                                        fontWeight: FontWeight.w600,
                                        fontSize: isSmallScreen ? 12 : 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Attendance List
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Attendance History',
                                        style: GoogleFonts.epilogue(
                                          fontSize: isSmallScreen ? 16 : 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[900],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isSmallScreen ? 8 : 12,
                                        vertical: isSmallScreen ? 4 : 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: defaultBlue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Total: ${attController.attList.length}',
                                        style: GoogleFonts.epilogue(
                                          color: defaultBlue,
                                          fontSize: isSmallScreen ? 10 : 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: isSmallScreen ? 12 : 16),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        ListView.separated(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              attController.attList.length,
                                          separatorBuilder: (context, index) =>
                                              SizedBox(
                                                height: isSmallScreen ? 8 : 12,
                                              ),
                                          itemBuilder: (context, index) {
                                            final attendance =
                                                attController.attList[index];
                                            final date =
                                                DateTime.tryParse(
                                                  attendance.attDate,
                                                ) ??
                                                DateTime.now();
                                            final isToday = isSameDay(
                                              date,
                                              DateTime.now(),
                                            );

                                            return Container(
                                              padding: EdgeInsets.all(
                                                isSmallScreen ? 12 : 16,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isToday
                                                    ? defaultBlue.withOpacity(
                                                        0.05,
                                                      )
                                                    : Colors.grey[50],
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: isToday
                                                      ? defaultBlue.withOpacity(
                                                          0.2,
                                                        )
                                                      : Colors.grey.withOpacity(
                                                          0.1,
                                                        ),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: isSmallScreen
                                                        ? 40
                                                        : 50,
                                                    height: isSmallScreen
                                                        ? 40
                                                        : 50,
                                                    decoration: BoxDecoration(
                                                      color: defaultBlue
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        '${index + 1}',
                                                        style:
                                                            GoogleFonts.epilogue(
                                                              fontSize:
                                                                  isSmallScreen
                                                                  ? 16
                                                                  : 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  defaultBlue,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: isSmallScreen
                                                        ? 12
                                                        : 16,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                DateFormat(
                                                                  'dd-MM-yyyy',
                                                                ).format(date),
                                                                style: GoogleFonts.epilogue(
                                                                  fontSize:
                                                                      isSmallScreen
                                                                      ? 14
                                                                      : 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .grey[900],
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                            if (isToday)
                                                              Container(
                                                                padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      isSmallScreen
                                                                      ? 6
                                                                      : 8,
                                                                  vertical:
                                                                      isSmallScreen
                                                                      ? 2
                                                                      : 4,
                                                                ),
                                                                decoration: BoxDecoration(
                                                                  color: defaultBlue
                                                                      .withOpacity(
                                                                        0.1,
                                                                      ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        8,
                                                                      ),
                                                                ),
                                                                child: Text(
                                                                  'Today',
                                                                  style: GoogleFonts.epilogue(
                                                                    color:
                                                                        defaultBlue,
                                                                    fontSize:
                                                                        isSmallScreen
                                                                        ? 8
                                                                        : 10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: isSmallScreen
                                                              ? 6
                                                              : 8,
                                                        ),
                                                        Wrap(
                                                          spacing: 8,
                                                          runSpacing: 8,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.symmetric(
                                                                horizontal:
                                                                    isSmallScreen
                                                                    ? 6
                                                                    : 8,
                                                                vertical:
                                                                    isSmallScreen
                                                                    ? 3
                                                                    : 4,
                                                              ),
                                                              decoration: BoxDecoration(
                                                                color: Colors
                                                                    .green
                                                                    .withOpacity(
                                                                      0.1,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      6,
                                                                    ),
                                                              ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Icon(
                                                                    Iconsax
                                                                        .clock,
                                                                    color: Colors
                                                                        .green,
                                                                    size:
                                                                        isSmallScreen
                                                                        ? 10
                                                                        : 12,
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                        isSmallScreen
                                                                        ? 3
                                                                        : 4,
                                                                  ),
                                                                  Flexible(
                                                                    child: Text(
                                                                      attendance
                                                                          .attTime,
                                                                      style: GoogleFonts.epilogue(
                                                                        color: Colors
                                                                            .green,
                                                                        fontSize:
                                                                            isSmallScreen
                                                                            ? 10
                                                                            : 12,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.symmetric(
                                                                horizontal:
                                                                    isSmallScreen
                                                                    ? 6
                                                                    : 8,
                                                                vertical:
                                                                    isSmallScreen
                                                                    ? 3
                                                                    : 4,
                                                              ),
                                                              decoration: BoxDecoration(
                                                                color: Colors
                                                                    .orange
                                                                    .withOpacity(
                                                                      0.1,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      6,
                                                                    ),
                                                              ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Icon(
                                                                    Iconsax
                                                                        .teacher,
                                                                    color: Colors
                                                                        .orange,
                                                                    size:
                                                                        isSmallScreen
                                                                        ? 10
                                                                        : 12,
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                        isSmallScreen
                                                                        ? 3
                                                                        : 4,
                                                                  ),
                                                                  Flexible(
                                                                    child: Text(
                                                                      attendance
                                                                          .trainerName,
                                                                      style: GoogleFonts.epilogue(
                                                                        color: Colors
                                                                            .orange,
                                                                        fontSize:
                                                                            isSmallScreen
                                                                            ? 10
                                                                            : 12,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          1,
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
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      // Mark Attendance Button - Only show on small screens
      floatingActionButton: isSmallScreen
          ? FloatingActionButton.extended(
              onPressed: _showMarkAttendanceDialog,
              backgroundColor: defaultBlue,
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              icon: const Icon(Iconsax.calendar_add, size: 20),
              label: Text(
                'Mark',
                style: GoogleFonts.epilogue(fontWeight: FontWeight.w600),
              ),
            )
          : null,
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
