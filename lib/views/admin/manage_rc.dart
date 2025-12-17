import 'package:drivingschool/const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageRC extends StatelessWidget {
  const ManageRC({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Dummy data
    final rcData = {
      "ownerName": "Muhammed Shanis",
      "vehicleNumber": "KL 55 B 2345",
      "vehicleType": "Motorcycle – Gear",
      "manufacturer": "Royal Enfield",
      "model": "Classic 350",
      "fuel": "Petrol",
      "registrationDate": "12-06-2021",
      "engineNumber": "ENG987654321",
      "chassisNumber": "CHS123456789",
      "registrationAuthority": "RTO Malappuram",
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "RC Book",
          style: GoogleFonts.epilogue(fontWeight: FontWeight.bold),
        ),
        backgroundColor: defaultBlue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            width: width > 450 ? 450 : width,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(3, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Kerala Emblem & Title
                Column(
                  children: [
                    Image.asset('assets/kerala_logo.png', height: 60),
                    const SizedBox(height: 5),
                    Text(
                      "Government of Kerala",
                      style: GoogleFonts.epilogue(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Smart Registration Certificate",
                      style: GoogleFonts.epilogue(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Vehicle Number Plate
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      rcData["vehicleNumber"]!,
                      style: GoogleFonts.epilogue(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // RC Fields
                buildRCField("Owner Name", rcData["ownerName"]!),
                buildRCField("Vehicle Type", rcData["vehicleType"]!),
                buildRCField("Manufacturer", rcData["manufacturer"]!),
                buildRCField("Model", rcData["model"]!),
                buildRCField("Fuel Type", rcData["fuel"]!),
                buildRCField("Registration Date", rcData["registrationDate"]!),
                buildRCField("Engine Number", rcData["engineNumber"]!),
                buildRCField("Chassis Number", rcData["chassisNumber"]!),
                buildRCField(
                  "Registration Authority",
                  rcData["registrationAuthority"]!,
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: defaultBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Close',
                      style: GoogleFonts.epilogue(
                        fontSize: 16,
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
    );
  }

  Widget buildRCField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              title,
              style: GoogleFonts.epilogue(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.epilogue(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
