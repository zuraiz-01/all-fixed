import 'dart:async';
import 'dart:io';

import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/widgets/support_bottom_nav_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../bloc/agora_call_cubit/agora_call_cubit.dart';
import '../../utils/dimentions.dart';
import '../global_widgets/common_app_bar.dart';
import '../global_widgets/custom_button.dart';
import '../global_widgets/inter_text.dart';

class PrescriptionScreen extends StatefulWidget {
  PrescriptionScreen({
    super.key,
    required this.pdfUrl,
  });

  String pdfUrl;

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {

  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "Prescription",
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      body: BlocBuilder<AgoraCallCubit, AgoraCallState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: Container(
                  height: getHeight(
                    context: context,
                  ),
                  width: getWidth(
                    context: context,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: SvgPicture.asset(
                                AppAssets.prescriptionIcon,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InterText(
                                    title: "Here is your prescription",
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  InterText(
                                    title:
                                        "Don’t worry! Your prescription will store in you profile for life time. You can access this anytime under All prescriptions",
                                    textColor: Colors.grey.withOpacity(.99),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Material(
                          elevation: 5,
                          color: Colors.white,
                          child: Container(
                            height: 200,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child:
                            PDFView(
                              filePath: "${widget.pdfUrl}",
                              enableSwipe: true,
                              swipeHorizontal: true,
                              autoSpacing: false,
                              pageFling: true,
                              pageSnap: true,
                              // defaultPage: currentPage!,
                              fitPolicy: FitPolicy.BOTH,
                              preventLinkNavigation:
                              false, // if set to true the link is handled in flutter
                              onRender: (_pages) {

                              },
                              onError: (error) {

                              },
                              onPageError: (page, error) {

                              },
                              onViewCreated: (PDFViewController pdfViewController) {
                                _controller.complete(pdfViewController);
                              },
                              onLinkHandler: (String? uri) {
                                print('goto uri: $uri');
                              },
                              onPageChanged: (int? page, int? total) {
                                print('page change: $page/$total');

                              },
                            )
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     SizedBox(
                            //       height: 12,
                            //     ),
                            //     Row(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Flexible(
                            //           flex: 1,
                            //           child: SizedBox(
                            //             width: getWidth(context: context),
                            //             child: Column(
                            //               crossAxisAlignment: CrossAxisAlignment.start,
                            //               children: [
                            //                 InterText(
                            //                   title: "Chief Complaints",
                            //                   fontWeight: FontWeight.bold,
                            //                 ),
                            //                 SizedBox(
                            //                   height: 4,
                            //                 ),
                            //                 InterText(
                            //                   title: payload["note"] != null ? (payload["note"] as List).first : "",
                            //                 ),
                            //                 SizedBox(
                            //                   height: 12,
                            //                 ),
                            //                 InterText(
                            //                   title: "Diagnosis",
                            //                   fontWeight: FontWeight.bold,
                            //                 ),
                            //                 SizedBox(
                            //                   height: 4,
                            //                 ),
                            //                 InterText(
                            //                   title: (payload["diagnosis"] as List).first,
                            //                 ),
                            //                 SizedBox(
                            //                   height: 12,
                            //                 ),
                            //                 InterText(
                            //                   title: "Investigations",
                            //                   fontWeight: FontWeight.bold,
                            //                 ),
                            //                 SizedBox(
                            //                   height: 4,
                            //                 ),
                            //                 InterText(
                            //                   title: (payload["investigations"] as List).first,
                            //                 ),
                            //                 SizedBox(
                            //                   height: 12,
                            //                 ),
                            //                 InterText(
                            //                   title: "Surgery",
                            //                   fontWeight: FontWeight.bold,
                            //                 ),
                            //                 SizedBox(
                            //                   height: 4,
                            //                 ),
                            //                 InterText(
                            //                   title: (payload["surgery"] as List).first,
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //         ),
                            //         SizedBox(
                            //           width: 16,
                            //         ),
                            //         Flexible(
                            //           flex: 1,
                            //           child: SizedBox(
                            //             width: getWidth(context: context),
                            //             child: Column(
                            //               crossAxisAlignment: CrossAxisAlignment.start,
                            //               mainAxisAlignment: MainAxisAlignment.start,
                            //               children: [
                            //                 InterText(
                            //                   title: "Medicine",
                            //                   fontWeight: FontWeight.bold,
                            //                 ),
                            //                 SizedBox(
                            //                   height: 4,
                            //                 ),
                            //                 MediaQuery.removePadding(
                            //                   context: context,
                            //                   removeBottom: true,
                            //                   removeTop: true,
                            //                   child: ListView.builder(
                            //                     itemCount: (payload["medicines"] as List).length,
                            //                     shrinkWrap: true,
                            //                     physics: NeverScrollableScrollPhysics(),
                            //                     itemBuilder: (context, index) {
                            //                       return Column(
                            //                         crossAxisAlignment: CrossAxisAlignment.start,
                            //                         children: [
                            //                           InterText(
                            //                             title: (index + 1).toString() + ". " + (payload["medicines"] as List)[index]["name"],
                            //                           ),
                            //                           InterText(
                            //                             title: "Notes: " + (payload["medicines"] as List)[index]["note"],
                            //                           ),
                            //                           SizedBox(
                            //                             height: 12,
                            //                           ),
                            //                         ],
                            //                       );
                            //                     },
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //         )
                            //       ],
                            //     ),
                            //     SizedBox(
                            //       height: 16,
                            //     ),
                            //     InterText(
                            //       title: "Follow Up Date",
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //     SizedBox(
                            //       height: 4,
                            //     ),
                            //     InterText(title: payload["followUpDate"]),
                            //     SizedBox(
                            //       height: 12,
                            //     ),
                            //     InterText(
                            //       title: "Reffered to",
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //     SizedBox(
                            //       height: 4,
                            //     ),
                            //     InterText(
                            //       title: payload["referredTo"],
                            //     ),
                            //     SizedBox(
                            //       height: 24,
                            //     ),
                            //   ],
                            // ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: CustomButton(
                                title: "Download",
                                callBackFunction: () {
                                  createFileOfPdfUrl(widget.pdfUrl);
                                },
                                backGroundColor: Color(0xff888E9D),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Flexible(
                              flex: 1,
                              child: CustomButton(
                                title: "Back to Home",
                                callBackFunction: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SupportBottomNavBar()
            ],
          );
        },
      ),
    );
  }

  Future<File> createFileOfPdfUrl(String pdfUrl) async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";
      final url = "$pdfUrl";
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
      await OpenFile.open(file.path);

    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }
}
