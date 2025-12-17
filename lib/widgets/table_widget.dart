import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TableWidget extends StatelessWidget {
  final String title;
  final String value;
  const TableWidget({
    required this.title,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style:
              GoogleFonts.epilogue(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: GoogleFonts.epilogue(
            fontSize: 15,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
    // Table(
    //   children: [
    //     TableRow(
    //       children: [
    //         TableCell(
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: [
    // Text(
    //   title,
    //   style: GoogleFonts.epilogue(
    //       fontSize: 15, fontWeight: FontWeight.w500),
    // ),
    //             ],
    //           ),
    //         ),
    //         TableCell(
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.end,
    //             children: [
    // Text(
    //   value,
    //   style: GoogleFonts.epilogue(
    //     fontSize: 15,
    //   ),
    //   overflow: TextOverflow.ellipsis,
    //   maxLines: 1,
    // ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }
}
