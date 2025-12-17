import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivingschool/models/attendance_model.dart';
import 'package:drivingschool/models/contact_model.dart';
import 'package:drivingschool/models/course_model.dart';
import 'package:drivingschool/models/instructor_model.dart';
import 'package:drivingschool/models/invoice_model.dart';
import 'package:drivingschool/models/user_model.dart';
import 'package:drivingschool/views/admin/admin_home.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AdminController extends ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  String adminID = 'admin@driving';
  String adminPassword = '123456';
  GlobalKey<FormState> adminLoginKey = GlobalKey<FormState>();
  TextEditingController adminIDController = TextEditingController();
  TextEditingController adminPasswordController = TextEditingController();
  bool isLoading = false;

  String? _adminid;
  String get adminid => _adminid!;

  Future<void> adminLogin(String username, String password, context) async {
    try {
      isLoading = true;
      notifyListeners(); // IMPORTANT → rebuild UI to show loader

      await firebaseAuth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );

      _adminid = firebaseAuth.currentUser!.uid;

      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const AdminHome()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(e.toString())),
      );
    } finally {
      isLoading = false;
      notifyListeners(); // stop loader
    }
  }

  List<UserModel> usersDataList = [];
  UserModel? users;

  // Replace your existing fetchUsers() with this version:
  Future<void> fetchUsers() async {
    try {
      usersDataList.clear();

      CollectionReference usersCollection = firebaseFirestore.collection(
        'users',
      );
      QuerySnapshot usersSnapshot = await usersCollection.get();

      for (var doc in usersSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        String userID = data['userID'] ?? doc.id;
        String userName = data['userName'] ?? '';
        String userEmail = data['userEmail'] ?? '';
        int userNumber = (data['userNumber'] ?? 0) is int
            ? data['userNumber']
            : int.tryParse('${data['userNumber']}') ?? 0;
        String? userProPic = data['userProPic']; // may be null
        String? selectedCourse = data['selectedCourse']; // NEW: course id
        String? selectedInstructor = data['selectedInstructor']; // may be null
        List userAttendance = data['userAttendance'] ?? [];

        users = UserModel(
          userID: userID,
          userName: userName,
          userEmail: userEmail,
          userNumber: userNumber,
          userProPic: userProPic,
          selectedCourse: selectedCourse,
          selectedInstructor: selectedInstructor,
          userAttendance: userAttendance,
          createdAt: data['createdAt'] != null
              ? DateTime.tryParse(data['createdAt'])
              : null,
          updatedAt: data['updatedAt'] != null
              ? DateTime.tryParse(data['updatedAt'])
              : null,
        );

        usersDataList.add(users!);
      }

      notifyListeners();
    } catch (e) {
      print('Error in fetchUsers: $e');
    }
  }

  GlobalKey<FormState> courseAddKey = GlobalKey<FormState>();
  TextEditingController courseNameController = TextEditingController();
  TextEditingController courseHoursController = TextEditingController();
  TextEditingController coursePriceController = TextEditingController();
  CourseModel? _courseModel;
  CourseModel get courseModel => _courseModel!;

  Future<void> saveCourse(
    String courseName,
    int courseHours,
    int coursePrice,
  ) async {
    final courseDoc = firebaseFirestore.collection('courses').doc();
    _courseModel = CourseModel(
      courseID: courseDoc.id,
      courseName: courseName,
      courseHours: courseHours,
      coursePrice: coursePrice,
    );
    await courseDoc.set(_courseModel!.toMap());
    notifyListeners();
  }

  List<CourseModel> coursesList = [];
  CourseModel? courses;

  Future fetchCourses() async {
    try {
      coursesList.clear();

      CollectionReference coursesCollection = firebaseFirestore.collection(
        'courses',
      );
      QuerySnapshot coursesSnapshot = await coursesCollection.get();

      for (var doc in coursesSnapshot.docs) {
        String courseID = doc['courseID'];
        String courseName = doc['courseName'];
        int courseHours = doc['courseHours'];
        int coursePrice = doc['coursePrice'];

        courses = CourseModel(
          courseID: courseID,
          courseName: courseName,
          courseHours: courseHours,
          coursePrice: coursePrice,
        );

        coursesList.add(courses!);
      }
    } catch (e) {
      print(e);
    }
  }

  GlobalKey<FormState> instrcutorAddKey = GlobalKey<FormState>();
  TextEditingController instrcutorNameController = TextEditingController();
  TextEditingController instrcutorNumberController = TextEditingController();

  InstructorModel? _instructorModel;
  InstructorModel get instructorModel => _instructorModel!;

  String? _instructorid;
  String get instructorid => _instructorid!;

  Future<void> saveInstructor(
    String instructorName,
    int instructorNumber,
    String instructorProPic,
  ) async {
    final instructorDoc = firebaseFirestore.collection('instructors').doc();
    _instructorModel = InstructorModel(
      instructorID: instructorDoc.id,
      instructorName: instructorName,
      instructorNumber: instructorNumber,
      instructorProPic: instructorProPic,
    );

    await instructorDoc.set(_instructorModel!.toMap());

    _instructorid = instructorDoc.id;
    print('//////INSTRUCTOR ID : $_instructorid //////////////');
    notifyListeners();
  }

  List<InstructorModel> instructorsList = [];
  InstructorModel? instructors;

  Future fetchInstructors() async {
    try {
      instructorsList.clear();

      CollectionReference instructorsCollection = firebaseFirestore.collection(
        'instructors',
      );
      QuerySnapshot instructorSnapshot = await instructorsCollection.get();

      for (var doc in instructorSnapshot.docs) {
        String instructorID = doc['instructorID'];
        String instructorName = doc['instructorName'];
        int instructorNumber = doc['instructorNumber'];
        String instructorProPic = doc['instructorProPic'];

        instructors = InstructorModel(
          instructorID: instructorID,
          instructorName: instructorName,
          instructorNumber: instructorNumber,
          instructorProPic: instructorProPic,
        );

        instructorsList.add(instructors!);
      }
    } catch (e) {
      print(e);
    }
  }

  ////////////////////////////////////////////////////////////////////////

  Future<String> storeImagetoStorge(String ref, File file) async {
    SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
    UploadTask uploadTask = firebaseStorage
        .ref()
        .child(ref)
        .putFile(file, metadata);
    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();
    log(downloadURL);
    notifyListeners();
    return downloadURL;
  }

  File? proPic;
  String? proPicPath;

  Future<File> pickproPic(context) async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedImage != null) {
        proPic = File(pickedImage.path);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
    return proPic!;
  }

  Future<void> selectproPic(context) async {
    proPic = await pickproPic(context);
    proPicPath = proPic!.path;
    notifyListeners();
  }

  Future uploadInstructorProPic(File proPic, String path, String userID) async {
    try {
      await storeImagetoStorge('$path/$userID', proPic).then((value) async {
        instructorModel.instructorProPic = value;

        DocumentReference docRef = firebaseFirestore
            .collection('instructors')
            .doc(_instructorid);
        await docRef.update({'instructorProPic': value});
      });
      _instructorModel = instructorModel;
      print('Pic uploaded successfully');
      // clearCarsField();
      notifyListeners();
    } catch (e) {
      print('image upload failed :$e');
    }
  }

  List<InvoiceModel> invoiceList = [];
  InvoiceModel? invoices;

  Future<void> fetchAllInvoices() async {
    try {
      invoiceList.clear();
      CollectionReference invoiceCollection = firebaseFirestore.collection(
        'invoices',
      );

      QuerySnapshot invoiceSnapshot = await invoiceCollection.get();

      for (var doc in invoiceSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        invoices = InvoiceModel.fromMap(data);
        print(invoices);
        invoiceList.add(invoices!);
      }
    } catch (e) {
      print('Error fetching invoices: $e');
    }
  }

  GlobalKey<FormState> contactAddKey = GlobalKey<FormState>();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();

  ContactModel? _contactModel;
  ContactModel get contactModel => _contactModel!;

  String? _contactid;
  String get contactid => _contactid!;

  Future<void> saveContact(String contactName, int contactNumber) async {
    final contactDoc = firebaseFirestore.collection('contacts').doc();
    _contactModel = ContactModel(
      contactID: contactDoc.id,
      contactName: contactName,
      contactNumber: contactNumber,
    );

    await contactDoc.set(_contactModel!.toMap());

    _contactid = contactDoc.id;
    notifyListeners();
  }

  List<ContactModel> contactsList = [];
  ContactModel? contacts;

  Future fetchContacts() async {
    try {
      contactsList.clear();

      CollectionReference contactCollection = firebaseFirestore.collection(
        'contacts',
      );
      QuerySnapshot contactSnapshot = await contactCollection.get();

      for (var doc in contactSnapshot.docs) {
        String contactID = doc['contactID'];
        String contactName = doc['contactName'];
        int contactNumber = doc['contactNumber'];

        contacts = ContactModel(
          contactID: contactID,
          contactName: contactName,
          contactNumber: contactNumber,
        );

        contactsList.add(contacts!);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteContact(String contactID, context) async {
    try {
      await FirebaseFirestore.instance
          .collection('contacts')
          .doc(contactID)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact deleted successfully')),
      );
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete Contact: $e')));
    }
  }

  ///////////////////////////////////////////////////////////////////////////

  Map<String, Map<DateTime, List<dynamic>>> userAttendance = {};
  List attendance = [];
  // List<Map<String, dynamic>> userAttendance = [];
  var today = DateTime.now();

  void onDaySelected(
    DateTime selectedDay,
    DateTime focusedDay,
    String userName,
  ) async {
    attendance.clear();
    String user = userName;
    today = selectedDay;

    if (!userAttendance.containsKey(user)) {
      userAttendance[user] = {};
    }

    if (userAttendance[user]!.containsKey(today)) {
      userAttendance[user]!.remove(today);
    } else {
      userAttendance[user]![today] = [selectedDay];
    }

    print('////////$user');
    print('///////////////${userAttendance[user]}');

    // Map<String, dynamic> attendanceData = {};
    // userAttendance.forEach((key, value) {
    //   attendanceData[key] = value;
    // });

    attendance.add(userAttendance[user]);

    await firebaseFirestore.collection('users').doc(user).update({
      'userAttendance': attendance.toString(),
    });
    print('////////////////Attendance updated////////////////');
    notifyListeners();
  }

  fetchAttendance(String userName) async {
    try {
      DocumentSnapshot userDoc = await firebaseFirestore
          .collection('users')
          .doc(userName)
          .get();

      // Retrieve userAttendance data from Firestore
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('userAttendance')) {
        // Parse the userAttendance data from String to List<Map<String, dynamic>>
        List<Map<String, dynamic>> userAttendanceData = jsonDecode(
          userData['userAttendance'],
        );

        // Convert the List<Map<String, dynamic>> to the desired map structure
        Map<DateTime, List<dynamic>> attendanceData = {};

        userAttendanceData.forEach((attendanceMap) {
          attendanceMap.forEach((key, value) {
            DateTime dateTimeKey = DateTime.parse(key);
            attendanceData[dateTimeKey] = List<dynamic>.from(value);
          });
        });

        // Update the local userAttendance variable
        userAttendance[userName] = attendanceData;

        print('User attendance data fetched successfully for $userName');
        notifyListeners(); // Notify listeners about the updated data
      } else {
        print('User attendance data not found for $userName');
      }
    } catch (e) {
      print('Error fetching user attendance data: $e');
    }
    // try {
    //   DocumentSnapshot userDoc =
    //       await firebaseFirestore.collection('users').doc(userName).get();

    //   // Retrieve userAttendance data from Firestore
    //   Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
    //   if (userData != null && userData.containsKey('userAttendance')) {
    //     // Convert the userAttendance data from String to the desired map type

    //     Map<String, dynamic> attendanceData =
    //         Map<String, dynamic>.from(userData['userAttendance']);

    //     // Update the local userAttendance variable
    //     userAttendance[userName] = attendanceData.cast<DateTime, List>();

    //     print('User attendance data fetched successfully for $userName');
    //     notifyListeners(); // Notify listeners about the updated data
    //   } else {
    //     print('User attendance data not found for $userName');
    //   }
    // } catch (e) {
    //   print('Error fetching user attendance data: $e');
    // }
  }

  TextEditingController attDateController = TextEditingController();
  TextEditingController attTimeController = TextEditingController();
  late DateTime selectedDate;
  final attKey = GlobalKey<FormState>();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      attDateController.text = DateFormat('dd-MMM-yyyy').format(pickedDate);
      notifyListeners();
    }
  }

  // late TimeOfDay _selectedTime;

  Future<void> selectTime(context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      // _selectedTime = picked;
      attTimeController.text = picked.format(context);
      notifyListeners();
    }
  }

  AttendanceModel? _attendanceModel;
  AttendanceModel get attendanceModel => _attendanceModel!;

  Future markAttendance(
    String attDate,
    String attTime,
    String userid,
    String trainerName,
    context,
  ) async {
    try {
      final attRef = firebaseFirestore
          .collection('users')
          .doc(userid)
          .collection('attendance')
          .doc(attDate);
      _attendanceModel = AttendanceModel(
        attID: attDate,
        attDate: attDate,
        attTime: attTime,
        userID: userid,
        trainerName: trainerName,
      );

      await attRef.set(_attendanceModel!.toMap());
      Navigator.of(context).pop();
      attDateController.clear();
      attTimeController.clear();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  List<AttendanceModel> attList = [];
  AttendanceModel? attnds;
  Future fetchAtt(String userid) async {
    try {
      attList.clear();

      CollectionReference attndCollection = firebaseFirestore
          .collection('users')
          .doc(userid)
          .collection('attendance');
      QuerySnapshot attndSnapshot = await attndCollection.get();

      for (var doc in attndSnapshot.docs) {
        String attID = doc['attID'];
        String attDate = doc['attDate'];
        String attTime = doc['attTime'];
        String userID = doc['userID'];
        String trainerName = doc['trainerName'];

        attnds = AttendanceModel(
          attID: attID,
          attDate: attDate,
          attTime: attTime,
          userID: userID,
          trainerName: trainerName,
        );

        attList.add(attnds!);
      }
    } catch (e) {
      print(e);
    }
  }
}
