import 'dart:developer';
import 'dart:io';

import 'package:eye_buddy/app/api/model/prescription_list_response_model.dart';
import 'package:eye_buddy/app/api/service/api_constants.dart';
import 'package:eye_buddy/app/bloc/upload_prescription_or_clinical_image/prescription_viewer.dart';
import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/functions.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/all_prescriptions_screen/view/pdf_viewer.dart';
import 'package:eye_buddy/app/views/global_widgets/common_network_image_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../bloc/prescription_list/prescription_list_cubit.dart';
import 'prescription_option_bottom_sheet.dart';

class PrescriptionListItem extends StatelessWidget {
  Prescription prescription;

  PrescriptionListItem({
    required this.prescription,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.colorEDEDED,
      ),
      padding: EdgeInsets.all(getProportionateScreenWidth(10)),
      child: GestureDetector(
        onTap: () {
          // String pdfUrl = 'https://beh-app.s3.eu-north-1.amazonaws.com/prescription/7263122f-90ed-496b-a7fa-77155541d021.pdf';
          // String pdfFileName = 'example.pdf'; // Replace with your desired PDF file name.
          // downloadFile(pdfUrl, pdfFileName);
          // log("https://beh-app.s3.eu-north-1.amazonaws.com/" +
          //     prescription.file!);
          // if (prescription.file != null && prescription.file!.isNotEmpty) {
          //   log("if https://beh-app.s3.eu-north-1.amazonaws.com/" +
          //       prescription.file!);
          //   context.read<PrescriptionListCubit>().downloadFile(
          //       context: context,
          //       url:
          //           '${"https://beh-app.s3.eu-north-1.amazonaws.com/" + prescription.file!}',
          //       filename: 'test');

          //   // launchUrl(mode: LaunchMode.externalApplication, Uri.parse("https://beh-app.s3.eu-north-1.amazonaws.com/" + prescription.file!));
          // } else {
          //   showToast(
          //       message: "Your prescription is invalid", context: context);
          // }
          print("Doc Link: ${prescription.file!}");
          if (prescription.file != null && prescription.file!.contains('pdf')) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFViewer(url: prescription.file!),
                ));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrescriptionViewer(
                      title: prescription.title!, url: prescription.file!),
                ));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.maxFinite,
              child: Stack(
                fit: StackFit.loose,
                children: [
                  SizedBox(
                    // width: getProportionateScreenWidth(100),
                    height: getProportionateScreenWidth(
                        getProportionateScreenWidth(85)),
                    child: Container(
                      foregroundDecoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.colorBBBBBB,
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [0.0, 0.5],
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CommonNetworkImageWidget(
                          imageLink:
                              '${ApiConstants.imageBaseUrl}${prescription.patientDetails!.photo}',
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () async {
                        // if (prescription.file != null && prescription.file!.isNotEmpty) {
                        //
                        //   launchUrl(mode: LaunchMode.externalApplication, Uri.parse(prescription.file!));
                        // } else {
                        //   showToast(message: "Your prescription is invalid", context: context);
                        // }
                        if (prescription.file != null &&
                            prescription.file!.isNotEmpty) {
                          log("if https://beh-app.s3.eu-north-1.amazonaws.com/" +
                              prescription.file!);
                          File file = await context
                              .read<PrescriptionListCubit>()
                              .downloadFile(
                                  context: context,
                                  url:
                                      '${"https://beh-app.s3.eu-north-1.amazonaws.com/" + prescription.file!}',
                                  filename: 'test');
                          Share.shareXFiles([XFile(file.path)],
                              text: prescription.title);
                          // launchUrl(mode: LaunchMode.externalApplication, Uri.parse("https://beh-app.s3.eu-north-1.amazonaws.com/" + prescription.file!));
                        } else {
                          showToast(
                              message: "Your prescription is invalid",
                              context: context);
                        }
                      },
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            color: AppColors.colorE6F2EE,
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            AppAssets.share,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            //isDismissible: false,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0)),
                            ),
                            builder: (BuildContext bc) {
                              return Container(
                                // height: getProportionateScreenHeight(150),
                                child: PrescriptionOptionBottomSheet(
                                  prescription: prescription,
                                ),
                              );
                            });
                      },
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            color: AppColors.colorE6F2EE,
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            AppAssets.option,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CommonSizeBox(
              height: getProportionateScreenHeight(7),
            ),
            InterText(
              title: '${formatDate(prescription.createdAt.toString())}',
              fontSize: 12,
              textColor: AppColors.black,
            ),
            CommonSizeBox(
              height: getProportionateScreenWidth(5),
            ),
            InterText(
              title: '${prescription.title}',
              fontSize: 14,
              textColor: AppColors.black,
            ),
          ],
        ),
      ),
    );
  }
}
