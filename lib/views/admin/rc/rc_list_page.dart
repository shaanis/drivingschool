import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'view_rc_page.dart';

class RCListPage extends StatelessWidget {
  RCListPage({super.key});

  // Dummy multiple RCs
  final List<Map<String, dynamic>> rcList = [
    {
      "vehicleNumber": "KL 55 B 2345",
      "ownerName": "Muhammed Shanis",
      "regDate": "03-Sep-2022",
      "validTill": "02-Sep-2037",
      "vehicleClass": "LMV",
      "fuelType": "PETROL",
    },
    {
      "vehicleNumber": "KL 13 Z 9911",
      "ownerName": "Adil M",
      "regDate": "10-Jan-2020",
      "validTill": "09-Jan-2035",
      "vehicleClass": "LMV",
      "fuelType": "DIESEL",
    },
    {
      "vehicleNumber": "KL 07 BD 2200",
      "ownerName": "Rafeeq",
      "regDate": "15-Aug-2021",
      "validTill": "14-Aug-2036",
      "vehicleClass": "SUV",
      "fuelType": "PETROL",
    },
    {
      "vehicleNumber": "KL 01 AA 9999",
      "ownerName": "Priya S",
      "regDate": "22-Mar-2023",
      "validTill": "21-Mar-2038",
      "vehicleClass": "SEDAN",
      "fuelType": "ELECTRIC",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My RC Books",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Vehicle Documents",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${rcList.length} Registered Vehicles",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search by vehicle number or owner...",
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),

          // Add RC Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_circle_outline, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Add New RC",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // RC Cards List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: rcList.length,
              itemBuilder: (context, index) {
                final rc = rcList[index];

                final vehicleNumber = rc["vehicleNumber"] ?? "N/A";
                final ownerName = rc["ownerName"] ?? "N/A";
                final regDate = rc["regDate"] ?? "N/A";
                final validTill = rc["validTill"] ?? "N/A";
                final vehicleClass = rc["vehicleClass"] ?? "N/A";
                final fuelType = rc["fuelType"] ?? "N/A";

                // Safe date validation
                final isActive = _isValid(validTill);

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ViewRCPage(rcData: rc),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Status + Vehicle Type Badge
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? const Color(0xFFE8F5E9)
                                        : const Color(0xFFFFEBEE),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isActive
                                            ? Icons.check_circle
                                            : Icons.warning,
                                        size: 14,
                                        color: isActive
                                            ? const Color(0xFF4CAF50)
                                            : const Color(0xFFF44336),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        isActive ? "Active" : "Expired",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: isActive
                                              ? const Color(0xFF4CAF50)
                                              : const Color(0xFFF44336),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Vehicle type
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getVehicleTypeColor(vehicleClass),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    vehicleClass,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Vehicle Number
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF1A237E,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.directions_car,
                                    color: Color(0xFF1A237E),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vehicleNumber,
                                        style: GoogleFonts.poppins(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF1A237E),
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Vehicle Registration Number",
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Owner + Fuel
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "OWNER",
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        ownerName,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "FUEL TYPE",
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            _getFuelIcon(fuelType),
                                            size: 16,
                                            color: _getFuelColor(fuelType),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            fuelType,
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Dates
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "REGISTERED",
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          regDate,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 1,
                                    color: Colors.grey[300],
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "VALID UNTIL",
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          validTill,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isActive
                                                ? const Color(0xFF4CAF50)
                                                : const Color(0xFFF44336),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ViewRCPage(rcData: rc),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF1A237E),
                                ),
                                icon: const Icon(
                                  Icons.remove_red_eye_outlined,
                                  size: 18,
                                ),
                                label: Text(
                                  "View Full Details",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
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
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Safely checks if the RC expiry is valid
  bool _isValid(String? date) {
    if (date == null || date.isEmpty) return false;

    try {
      final months = {
        "Jan": "01",
        "Feb": "02",
        "Mar": "03",
        "Apr": "04",
        "May": "05",
        "Jun": "06",
        "Jul": "07",
        "Aug": "08",
        "Sep": "09",
        "Oct": "10",
        "Nov": "11",
        "Dec": "12",
      };

      final parts = date.split('-'); // ["03", "Sep", "2037"]

      if (parts.length != 3) return false;

      final formatted =
          "${parts[2]}-${months[parts[1]]}-${parts[0].padLeft(2, '0')}";

      final parsedDate = DateTime.parse(formatted);

      return DateTime.now().isBefore(parsedDate);
    } catch (e) {
      return false;
    }
  }

  Color _getVehicleTypeColor(String? type) {
    final t = type?.toUpperCase() ?? "OTHER";
    switch (t) {
      case "LMV":
        return const Color(0xFF2196F3);
      case "SUV":
        return const Color(0xFF4CAF50);
      case "SEDAN":
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF607D8B);
    }
  }

  IconData _getFuelIcon(String? fuelType) {
    final f = fuelType?.toUpperCase() ?? "";
    switch (f) {
      case "PETROL":
      case "DIESEL":
        return Icons.local_gas_station;
      case "ELECTRIC":
        return Icons.electric_car;
      default:
        return Icons.local_gas_station;
    }
  }

  Color _getFuelColor(String? fuelType) {
    final f = fuelType?.toUpperCase() ?? "";
    switch (f) {
      case "PETROL":
        return const Color(0xFFFF9800);
      case "DIESEL":
        return const Color(0xFF795548);
      case "ELECTRIC":
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF607D8B);
    }
  }
}
