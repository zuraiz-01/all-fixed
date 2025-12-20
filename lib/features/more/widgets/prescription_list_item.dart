import 'package:eye_buddy/core/services/api/model/prescription_list_response_model.dart';
import 'package:eye_buddy/core/services/api/service/api_constants.dart';
import 'package:eye_buddy/core/services/utils/config/app_colors.dart';
import 'package:eye_buddy/core/services/utils/size_config.dart';
import 'package:eye_buddy/features/global_widgets/common_network_image_widget.dart';
import 'package:eye_buddy/features/global_widgets/common_size_box.dart';
import 'package:eye_buddy/features/global_widgets/inter_text.dart';
import 'package:eye_buddy/features/more/controller/more_controller.dart';
import 'package:eye_buddy/features/more/widgets/prescription_option_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PrescriptionListItem extends StatelessWidget {
  final Prescription prescription;

  PrescriptionListItem({required this.prescription, super.key});

  String _resolveS3Url(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return '';
    if (v.startsWith('http://') || v.startsWith('https://')) return v;
    return '${ApiConstants.imageBaseUrl}$v';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MoreController>();
    final patientPhotoUrl = _resolveS3Url(prescription.patientDetails?.photo);
    final fileUrl = _resolveS3Url(prescription.file);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.colorEDEDED,
      ),
      padding: EdgeInsets.all(getProportionateScreenWidth(10)),
      child: GestureDetector(
        onTap: () async {
          if (fileUrl.isEmpty) return;
          final uri = Uri.tryParse(fileUrl);
          if (uri == null) return;
          await launchUrl(uri, mode: LaunchMode.externalApplication);
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
                    height: getProportionateScreenWidth(
                      getProportionateScreenWidth(85),
                    ),
                    child: Container(
                      foregroundDecoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.colorBBBBBB, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [0.0, 0.5],
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CommonNetworkImageWidget(
                          imageLink: patientPhotoUrl,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () async {
                        await controller.sharePrescription(
                          file: prescription.file,
                          title: prescription.title,
                        );
                      },
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: AppColors.colorE6F2EE,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(
                            Icons.ios_share,
                            size: 14,
                            color: AppColors.primaryColor,
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
                        Get.bottomSheet(
                          PrescriptionOptionBottomSheet(
                            prescription: prescription,
                          ),
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: AppColors.colorE6F2EE,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(
                            Icons.more_vert,
                            size: 14,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CommonSizeBox(height: getProportionateScreenHeight(7)),
            InterText(
              title:
                  '${controller.formatDate(prescription.createdAt.toString())}',
              fontSize: 12,
              textColor: AppColors.black,
            ),
            CommonSizeBox(height: getProportionateScreenWidth(5)),
            InterText(
              title: prescription.title ?? '',
              fontSize: 14,
              textColor: AppColors.black,
            ),
          ],
        ),
      ),
    );
  }
}
