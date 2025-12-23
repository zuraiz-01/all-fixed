// import 'package:flutter/material.dart';
// import 'package:pdf_thumbnail/pdf_thumbnail.dart';

// class PdfThumbnailWidget extends StatelessWidget {
//   final String pdfUrl;

//   const PdfThumbnailWidget({super.key, required this.pdfUrl});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: PdfThumbnail.fromFile(pdfUrl, height: 100), // Generate thumbnail
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         }
//         if (snapshot.hasError || snapshot.data == null) {
//           return Icon(Icons.picture_as_pdf, size: 50, color: Colors.red);
//         }
//         return Image.memory(snapshot.data!);
//       },
//     );
//   }
// }
