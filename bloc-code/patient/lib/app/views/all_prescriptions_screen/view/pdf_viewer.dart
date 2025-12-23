import 'package:eye_buddy/app/api/service/api_constants.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PDFViewer extends StatefulWidget {
  final String url;
  PDFViewer({required this.url});
  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(
          "https://docs.google.com/gview?embedded=true&url=${ApiConstants.imageBaseUrl}${widget.url}"));
  }

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
      body: WebViewWidget(controller: controller),
    );
  }
}
