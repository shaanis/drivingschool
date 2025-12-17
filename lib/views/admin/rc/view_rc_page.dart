import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewRCPage extends StatelessWidget {
  final Map<String, dynamic> rcData;

  const ViewRCPage({super.key, required this.rcData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "RC Details",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildRCCard(context),
                const SizedBox(height: 25),
                _buildDetailsPanel(context, constraints),
                const SizedBox(height: 25),
                _buildDisclaimerCard(),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------------- RC ATM STYLE CARD ----------------------
  Widget _buildRCCard(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 500, minHeight: 250),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1a237e), Color(0xFF283593), Color(0xFF3949ab)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.3),
            blurRadius: 25,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,

        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    "KL",
                    style: GoogleFonts.poppins(
                      color: Colors.blue[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              Text(
                "E-RC CARD",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Chip Row
          Row(
            children: [
              Container(
                width: 50,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFffcc00), Color(0xFFff9900)],
                  ),
                ),
                child: const Icon(
                  Icons.credit_card,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 15),
              const Icon(Icons.wifi, color: Colors.white, size: 28),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Valid",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Vehicle Number
          Text(
            rcData["vehicleNumber"] ?? "KL-01-AB-1234",
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 3.0,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            "VEHICLE NUMBER",
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.white70,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          // Bottom Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _rcSmallInfo("REG DATE", rcData["regDate"] ?? "01/01/2023"),
              _rcSmallInfo("VALID TILL", rcData["validTill"] ?? "31/12/2030"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rcSmallInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 9, color: Colors.white70),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // ---------------------- DETAILS PANEL ----------------------
  Widget _buildDetailsPanel(BuildContext context, BoxConstraints constraints) {
    final isWide = constraints.maxWidth > 400;

    final details = [
      _DetailItem(
        "OWNER NAME",
        rcData["ownerName"] ?? "John Doe",
        Icons.person_outline,
        Colors.blue,
      ),
      _DetailItem(
        "VEHICLE CLASS",
        rcData["vehicleClass"] ?? "LMV",
        Icons.directions_car_outlined,
        Colors.green,
      ),
      _DetailItem(
        "FUEL TYPE",
        rcData["fuelType"] ?? "PETROL",
        Icons.local_gas_station_outlined,
        Colors.orange,
      ),
      _DetailItem(
        "ENGINE NO",
        rcData["engineNo"] ?? "XYZ123456",
        Icons.engineering_outlined,
        Colors.purple,
      ),
      _DetailItem(
        "CHASSIS NO",
        rcData["chassisNo"] ?? "CHS789012",
        Icons.settings_outlined,
        Colors.red,
      ),
      _DetailItem(
        "REGISTERING AUTHORITY",
        rcData["regAuthority"] ?? "Kerala RTO",
        Icons.account_balance_outlined,
        Colors.teal,
      ),
    ];

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "VEHICLE DETAILS",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey[800],
            ),
          ),

          const SizedBox(height: 20),

          // Two or one column layout
          Column(
            children: [
              for (int i = 0; i < details.length; i += isWide ? 2 : 1)
                Row(
                  children: [
                    Expanded(child: _buildDetailCard(details[i])),
                    if (isWide && i + 1 < details.length)
                      const SizedBox(width: 15),
                    if (isWide && i + 1 < details.length)
                      Expanded(child: _buildDetailCard(details[i + 1])),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 25),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[50],
                    foregroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.share_outlined),
                  label: Text(
                    "Share",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[50],
                    foregroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.download_outlined),
                  label: Text(
                    "Download",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(_DetailItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: item.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(item.icon, color: item.color, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  item.value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------- DISCLAIMER ----------------------
  Widget _buildDisclaimerCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.blueGrey, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "This is a digital representation of your RC. Always carry original documents while driving.",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.blueGrey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// MODEL CLASS FOR DETAIL ITEMS
// ==================================================================
class _DetailItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  _DetailItem(this.title, this.value, this.icon, this.color);
}
