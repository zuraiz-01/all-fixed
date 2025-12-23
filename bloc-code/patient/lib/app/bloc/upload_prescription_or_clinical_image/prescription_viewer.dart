import 'package:eye_buddy/app/api/service/api_constants.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/views/global_widgets/common_network_image_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PrescriptionViewer extends StatelessWidget {
  final String title;
  final String url;
  const PrescriptionViewer({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        title: InterText(
          title: l10n.view_prescription,
        ),
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.black,
            size: 20,
          ),
        ),
      ),
      body: InteractiveViewer(
        child: CommonNetworkImageWidget(
          imageLink: '${ApiConstants.imageBaseUrl}$url',
        ),
      ),
    );
  }
}
