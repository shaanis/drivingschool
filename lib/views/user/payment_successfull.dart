import 'package:drivingschool/const.dart';
import 'package:drivingschool/views/user/user_home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentSuccessful extends StatelessWidget {
  const PaymentSuccessful({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: width,
                height: height / 2,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(100, 50),
                    bottomRight: Radius.elliptical(100, 50),
                  ),
                  color: defaultBlue,
                ),
              ),
              SizedBox(width: width, height: height / 2),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Image.asset('assets/Ellipse 16.png'),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Image.asset('assets/Ellipse 17.png'),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: width,
                height: 280,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/c-tick logo.png'),
                        const SizedBox(height: 20),
                        Text(
                          'YOUR PAYMENT\nCOMPLETED',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.epilogue(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: width,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                defaultBlue,
                              ),
                              shape:
                                  MaterialStateProperty.all<
                                    RoundedRectangleBorder
                                  >(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                            ),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UserHome(uid: "user123"),
                                ),
                                (route) => false,
                              );
                            },
                            child: Text(
                              'CLOSE',
                              style: GoogleFonts.epilogue(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
