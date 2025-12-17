import 'package:drivingschool/const.dart';
import 'package:drivingschool/controller/admin_controller.dart';
import 'package:drivingschool/controller/test_controller.dart';
import 'package:drivingschool/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// No longer need StudentModel as we have UserModel
// Using UserModel directly for type safety

class AddTest extends StatefulWidget {
  final Color primary;
  final void Function() onCancel;

  const AddTest({super.key, required this.primary, required this.onCancel});

  @override
  State<AddTest> createState() => _AddTestState();
}

class _AddTestState extends State<AddTest> {
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();
  final _testNameController = TextEditingController();
  final _rtoController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  // Student selection state
  UserModel? _selectedStudent;
  bool _isLoadingStudents = true;
  String? _studentSearchQuery;

  List<UserModel> _allStudents = [];
  List<UserModel> _filteredStudents = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchStudents();
    });
  }

  Future<void> _fetchStudents() async {
    final adminController = Provider.of<AdminController>(
      context,
      listen: false,
    );

    try {
      await adminController.fetchUsers();
      if (mounted) {
        setState(() {
          // Assuming adminController.usersDataList contains List<UserModel>
          _allStudents = adminController.usersDataList
              .whereType<UserModel>() // Ensure we only get UserModel
              .toList();
          _filteredStudents = List.from(_allStudents);
          _isLoadingStudents = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingStudents = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load students: $e')));
      }
    }
  }

  void _filterStudents(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredStudents = List.from(_allStudents);
      });
      return;
    }

    final upperQuery = query.toUpperCase();
    final lowerQuery = query.toLowerCase();

    setState(() {
      _filteredStudents = _allStudents.where((student) {
        final id = student.userID.toUpperCase();
        final name = student.userName.toLowerCase();
        final phone = student.userNumber.toString().toLowerCase();
        final email = student.userEmail.toLowerCase();

        return id.contains(upperQuery) ||
            name.contains(lowerQuery) ||
            phone.contains(lowerQuery) ||
            email.contains(lowerQuery);
      }).toList();
    });
  }

  void _selectStudent(UserModel student) {
    setState(() {
      _selectedStudent = student;
    });
    // Update the display field
    _studentIdController.text = student.userID;
  }

  void _showStudentSearchDialog() {
    final searchController = TextEditingController(text: _studentSearchQuery);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxHeight: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      "Select Student",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setDialogState(() {
                      _studentSearchQuery = value.trim();
                    });
                    _filterStudents(value.trim());
                  },
                  decoration: InputDecoration(
                    hintText: "Search by ID, name, phone or email...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _isLoadingStudents
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredStudents.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No students found",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                "Try searching by ID, name, phone or email",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _filteredStudents.length,
                          itemBuilder: (context, index) {
                            final student = _filteredStudents[index];
                            final isSelected =
                                student.userID == _selectedStudent?.userID;
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: widget.primary.withOpacity(
                                  0.1,
                                ),
                                child: Text(
                                  student.userName.isNotEmpty
                                      ? student.userName[0].toUpperCase()
                                      : student.userID[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                student.userName,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ID: ${student.userID}"),
                                  Text("${student.userNumber}"),
                                ],
                              ),
                              trailing: isSelected
                                  ? Icon(
                                      Icons.check_circle,
                                      color: widget.primary,
                                    )
                                  : null,
                              onTap: () {
                                _selectStudent(student);
                                Navigator.pop(context);
                              },
                              selectedTileColor: widget.primary.withOpacity(
                                0.1,
                              ),
                              selected: isSelected,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.primary,
              onPrimary: Colors.white,
              onSurface: Colors.grey[800]!,
            ),
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

  // Function to add test using TestController
  Future<void> _addTest() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedStudent == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select a student"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        // Get the TestController
        final testController = Provider.of<TestController>(
          context,
          listen: false,
        );

        // Call the addTest method from TestController
        await testController.addTest(
          studentId: _selectedStudent!.userID,
          studentName: _selectedStudent!.userName,
          testName: _testNameController.text.trim(),
          rto: _rtoController.text.trim(),
          date: _selectedDate,
          context: context,
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Test added successfully!',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Close the add test screen
        widget.onCancel();
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to add test: $e',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _testNameController.dispose();
    _rtoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.grey),
          onPressed: widget.onCancel,
        ),
        title: Text(
          "Add New Test",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.grey[800],
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header illustration
                Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: widget.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Icon(EvaIcons.clipboard, size: 64, color: widget.primary),
                      const SizedBox(height: 12),
                      Text(
                        "Create Test Record",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: widget.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Student Selection
                _buildStudentField(),

                const SizedBox(height: 16),

                // Test Name
                _buildTextField(
                  controller: _testNameController,
                  label: "Test Name",
                  icon: EvaIcons.book_open_outline,
                  validator: (value) =>
                      value?.isEmpty == true ? "Enter test name" : null,
                ),

                const SizedBox(height: 16),

                // RTO
                _buildTextField(
                  controller: _rtoController,
                  label: "RTO Location",
                  icon: EvaIcons.pin_outline,
                  validator: (value) =>
                      value?.isEmpty == true ? "Enter RTO location" : null,
                ),

                const SizedBox(height: 16),

                // Test Date
                _buildDateField(),

                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onCancel,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _addTest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: Consumer<TestController>(
                          builder: (context, testController, child) {
                            return testController.isLoading
                                ? SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    "Add Test",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _studentIdController,
          readOnly: true,
          decoration: InputDecoration(
            prefixIcon: Icon(EvaIcons.hash, color: widget.primary, size: 20),
            labelText: "Student ID",
            labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
            suffixIcon: IconButton(
              icon: Icon(
                _selectedStudent != null ? Icons.person : Icons.search,
                color: widget.primary,
              ),
              onPressed: _showStudentSearchDialog,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: widget.primary, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(20),
          ),
          validator: (value) =>
              _selectedStudent == null ? "Please select a student" : null,
        ),
        if (_selectedStudent != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: widget.primary.withOpacity(0.2),
                  child: Text(
                    _selectedStudent!.userName.isNotEmpty
                        ? _selectedStudent!.userName[0].toUpperCase()
                        : _selectedStudent!.userID[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedStudent!.userName,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        _selectedStudent!.userNumber.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: widget.primary, size: 20),
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: widget.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        prefixIcon: Icon(
          EvaIcons.calendar_outline,
          color: widget.primary,
          size: 20,
        ),
        labelText: "Test Date",
        labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: widget.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(20),
        suffixIcon: IconButton(
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          onPressed: () => _selectDate(context),
        ),
      ),
      onTap: () => _selectDate(context),
      controller: TextEditingController(
        text: DateFormat('dd MMM yyyy').format(_selectedDate),
      ),
    );
  }
}
