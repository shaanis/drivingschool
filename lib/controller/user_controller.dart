import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:drivingschool/models/invoice_model.dart';
import 'package:drivingschool/models/user_model.dart';
import 'package:drivingschool/utils/authentication_dialogue_widget.dart';
import 'package:drivingschool/views/admin/AdminSlotPage.dart';
import 'package:drivingschool/views/admin/manage_contact.dart';
import 'package:drivingschool/views/admin/manage_course.dart';
import 'package:drivingschool/views/admin/manage_instructor.dart';
import 'package:drivingschool/views/admin/manage_invoice.dart';
import 'package:drivingschool/views/admin/manage_rc.dart';
import 'package:drivingschool/views/admin/rc/rc_list_page.dart';
import 'package:drivingschool/views/admin/test_management.dart';
import 'package:drivingschool/views/admin/users_list.dart';
import 'package:drivingschool/views/user/contact_us.dart';
import 'package:drivingschool/views/user/courses.dart';
import 'package:drivingschool/views/user/history.dart';
import 'package:drivingschool/views/user/invoice.dart';
import 'package:drivingschool/views/user/select_instructor.dart'
    show ChooseInstructor;
import 'package:drivingschool/views/user/user_profile.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:google_sign_in/google_sign_in.dart'; // <-- added

class UserController extends ChangeNotifier {
  //////////////////////////////////////////////////////////////////////////////
  List<Map<String, dynamic>> adminServiceList = [
    {
      'service name': 'Users',
      'icon': Iconsax.profile_2user,
      'onTap': const UsersList(),
    },
    {
      'service name': 'Manage Course',
      'icon': Iconsax.book,
      'onTap': const ManageCourse(),
    },
    {
      'service name': 'Manage Invoice',
      'icon': Iconsax.receipt,
      'onTap': const ManageInvoice(),
    },
    {
      'service name': 'Manage Instructor',
      'icon': Iconsax.teacher,
      'onTap': const ManageInstructor(),
    },
    {
      'service name': 'Manage RC Renewal',
      'icon': Iconsax.car,
      'onTap': RCListPage(),
    },
    {
      'service name': 'FAQ & Feedback',
      'icon': Iconsax.message_question,
      'onTap': const ManageContact(),
    },
    {
      'service name': 'Test Management',
      'icon': Iconsax.message_question,
      'onTap': const AdminTestResultsPage(),
    },
    {
      'service name': 'Slots Management',
      'icon': Iconsax.message_question,
      'onTap': const AdminSlotPage(),
    },
  ];
  List<Map<String, dynamic>> userServiceList = [
    {
      'service name': 'Profile',
      'icon': Icons.person,
      'onTap': const UserProfile(),
    },
    {
      'service name': 'Course',
      'icon': Icons.settings,
      'onTap': const Courses(),
    },
    {
      'service name': 'Invoice',
      'icon': Icons.receipt_long,
      'onTap': const Invoice(),
    },
    {
      'service name': 'Instructor',
      'icon': Icons.school,
      'onTap': const ChooseInstructor(),
    },
    {
      'service name': 'History',
      'icon': Icons.history,
      'onTap': const History(),
    },
    {
      'service name': 'Contact',
      'icon': Icons.headset_mic,
      'onTap': const ContactUs(),
    },
  ];

  //////////////////////////////////////////////////////////////////////////////

  GlobalKey<FormState> numberKey = GlobalKey<FormState>();
  GlobalKey<FormState> userDetailsKey = GlobalKey<FormState>();
  TextEditingController numberController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();

  //---------------For country Pick-------------------

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: 'India',
    displayName: 'India',
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  showCountries(context) {
    showCountryPicker(
      context: context,
      countryListTheme: const CountryListThemeData(bottomSheetHeight: 600),
      onSelect: (value) {
        selectedCountry = value;
        notifyListeners();
      },
    );
  }

  void setPhonenumber(String value, context) {
    numberController.text = value;
    if (value.length == 10) {
      sendOTP(context);
      FocusScope.of(context).unfocus();
    }
    notifyListeners();
  }

  String? otpError;
  String verificationCode = '';
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  String? otpCode;

  String? _uid;
  String get uid => _uid!;

  Future<void> sendOTP(context) async {
    showDialog(
      context: context,
      builder: (context) {
        return const AuthenticationDialogueWidget(
          message: 'Authenticating, Please wait...',
        );
      },
    );
    String userPhoneNumber = numberController.text.trim();
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+${selectedCountry.phoneCode}$userPhoneNumber",
        verificationCompleted: (phoneAuthCredential) {
          // Optionally auto-sign-in here, if desired
        },
        verificationFailed: (FirebaseAuthException error) {
          otpError = error.toString();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                error.toString(),
                style: GoogleFonts.epilogue(color: Colors.white),
              ),
            ),
          );
          Navigator.pop(context);
          log("Verification failed $error");
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          verificationCode = verificationId;
          log(verificationCode);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'OTP Sent to +${selectedCountry.phoneCode}$userPhoneNumber',
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // optional
        },
      );
      log(
        "OTP request initiated for +${selectedCountry.phoneCode}$userPhoneNumber",
      );
    } catch (e) {
      Navigator.of(context).pop();
      log("sendOTP error: $e");
    }

    notifyListeners();
  }

  verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
    required Function onSuccess,
  }) async {
    showDialog(
      context: context,
      builder: (context) {
        return const AuthenticationDialogueWidget(message: 'Verifying OTP...');
      },
    );
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      User? user = (await firebaseAuth.signInWithCredential(credential)).user;
      if (user != null) {
        _uid = user.uid;
        onSuccess();
      }
      log("OTP correct");
    } catch (e) {
      Navigator.pop(context);
      log('$e');
    }
    notifyListeners();
  }

  /////////////////// GOOGLE SIGN-IN //////////////////////
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // user cancelled login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      _uid = userCredential.user?.uid;
      notifyListeners();
      return userCredential.user;
    } catch (e) {
      log("Google Sign-In Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Google Sign-In Failed: $e")));
      return null;
    }
  }

  /// Check if Google user exists in Firestore
  Future<bool> checkGoogleUser(String uid) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    if (snapshot.exists) {
      _uid = uid;
      print(snapshot.data());
      return true;
    }
    return false;
  }

  /////////////////DATABASE OPERATIONS/////////////////////////////////////////
  Future<bool> checkExistingUser() async {
    if (_uid == null) return false;
    DocumentSnapshot snapshot = await firebaseFirestore
        .collection('users')
        .doc(_uid)
        .get();

    if (snapshot.exists) {
      log('USER EXISTS');
      print(snapshot.data());
      return true;
    } else {
      log('NEW USER');
      return false;
    }
  }

  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  Future<void> saveUser(
    String userID,
    String userName,
    String userEmail,
    int userNumber,
  ) async {
    _userModel = UserModel(
      userID: userID,
      userName: userName,
      userEmail: userEmail,
      userNumber: userNumber,
    );

    await firebaseFirestore
        .collection('users')
        .doc(userID)
        .set(_userModel!.toMap());

    notifyListeners();
  }

  Future<void> fetchUserData(String uid) async {
    try {
      DocumentSnapshot snapshot = await firebaseFirestore
          .collection('users')
          .doc(uid)
          .get();

      // Check if document exists
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;

        _userModel = UserModel(
          userID: data['userID'] ?? '',
          userName: data['userName'] ?? 'User',
          userEmail: data['userEmail'] ?? '',
          userNumber: data['userNumber'] ?? 0,
          userProPic: data['userProPic'], // can be null
          selectedCourse: data['selectedCourse'], // can be null
          selectedInstructor: data['selectedInstructor'], // can be null
          createdAt: parseDate(data['createdAt']),
        );
      } else {
        _userModel = null;
      }

      notifyListeners(); // important for Provider to update UI
    } catch (e) {
      print('Error fetching user data: $e');
      _userModel = null;
      notifyListeners();
    }
  }

  ////////////////////////////////////////////////////////////////////////////

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

  Future uploadProPic(File proPic, String path, String userID) async {
    try {
      await storeImagetoStorge('$path/$userID', proPic).then((value) async {
        userModel.userProPic = value;

        DocumentReference docRef = firebaseFirestore
            .collection('users')
            .doc(_uid);
        docRef.update({'userProPic': value});
      });
      _userModel = userModel;
      print('Pic uploaded successfully');
      notifyListeners();
    } catch (e) {
      print('image upload failed :$e');
    }
  }

  InvoiceModel? _invoiceModel;
  InvoiceModel get invoiceModel => _invoiceModel!;

  Future<void> saveInvoice(
    String invoiceUserName,
    String invoiceCourseName,
    String invoiceDate,
    double invoicePrice,
  ) async {
    final date = DateTime.parse(invoiceDate);
    DateTime dueDate = date.add(const Duration(days: 30));
    String formttedDueDate = DateFormat("dd-MMM-yyy").format(dueDate);
    final docs = firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('invoices')
        .doc();
    _invoiceModel = InvoiceModel(
      invoiceId: docs.id,
      userId: firebaseAuth.currentUser!.uid, // Set userID
      invoiceUserName: invoiceUserName,
      invoiceCourseName: invoiceCourseName,
      invoiceDate: invoiceDate,
      invoicePrice: invoicePrice,
      dueDate: formttedDueDate,
    );

    await docs.set(_invoiceModel!.toMap());
    await firebaseFirestore
        .collection('invoices')
        .doc(docs.id)
        .set(_invoiceModel!.toMap());
  }

  List<InvoiceModel> invoiceList = [];
  InvoiceModel? invoices;

  Future<void> fetchInvoices(String userId) async {
    try {
      invoiceList.clear();

      QuerySnapshot snapshot = await firebaseFirestore
          .collection('invoices')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        invoices = InvoiceModel.fromMap(data);
        invoiceList.add(invoices!);
      }

      print("Fetched ${invoiceList.length} invoices for user $userId");
      notifyListeners();
    } catch (e) {
      print("Error fetching user invoices: $e");
    }
  }

  /// Update selected course and store updatedAt timestamp
  Future<void> updateCourse(String courseName) async {
    try {
      _userModel?.selectedCourse = courseName;
      _userModel?.createdAt = DateTime.now(); // track update time

      DocumentReference docRef = firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid);

      await docRef.update({
        'selectedCourse': courseName,
        'createdAt': _userModel?.createdAt!.toIso8601String(),
      });

      notifyListeners();
      print('Course Updated: $courseName at ${_userModel?.createdAt}');
    } catch (e) {
      print('Error updating course: $e');
    }
  }

  Future updateInstructor(String instructorName) async {
    try {
      // Update local model
      userModel.selectedInstructor = instructorName;

      // Update in Firestore
      await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .update({'selectedInstructor': instructorName});

      _userModel = userModel;

      notifyListeners();
      print('/////////Instructor Updated/////////////');
    } catch (e) {
      print("ERROR Updating Instructor: $e");
    }
  }

  /// Parse date from dynamic value (string or Timestamp)
  DateTime? parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        print('Error parsing date string: $e');
        return null;
      }
    }
    return null;
  }
}
