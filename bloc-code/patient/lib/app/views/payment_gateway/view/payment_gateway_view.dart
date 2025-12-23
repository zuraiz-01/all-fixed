import 'dart:developer';
import 'package:eye_buddy/app/api/model/appointment_doctor_model.dart';
import 'package:eye_buddy/app/api/model/patient_list_model.dart';
import 'package:eye_buddy/app/bloc/appointment_cubit/appointment_cubit.dart';
import 'package:eye_buddy/app/bloc/reason_for_visit_cubit/reason_for_visit_cubit.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/views/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:eye_buddy/app/views/waiting_for_doctor/view/waiting_for_doctor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../api/model/doctor_list_response_model.dart' as docListDoc;

class PaymentGatewayView extends StatefulWidget {
  PaymentGatewayView({
    super.key,
    required this.url,
    required this.patientData,
    required this.selectedDoctor,
  });

  final String url;
  final MyPatient patientData;
  final docListDoc.Doctor selectedDoctor;

  @override
  State<PaymentGatewayView> createState() => _PaymentGatewayViewState();
}

class _PaymentGatewayViewState extends State<PaymentGatewayView> {
  late WebViewController controller;

  /// A loading state variable to control the visibility of the progress indicator.
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading progress.
            log("Page loading progress: $progress%");
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true; // Show the loading indicator.
            });
            log("Page started loading: $url");
          },
          onPageFinished: (String url) async {
            setState(() {
              isLoading =
                  false; // Hide the loading indicator when the page finishes loading.
            });
            log("Page finished loading: $url");

            if (url.contains("payment-success")) {
              showToast(message: "Payment Success", context: context);
              var state = await context.read<ReasonForVisitCubit>().state;
              await context.read<AppointmentCubit>().getAppointments();
              NavigatorServices().toReplacement(
                context: context,
                widget: WaitingForDoctorScreen(
                  patientData: widget.patientData,
                  selectedDoctor: widget.selectedDoctor,
                  appointmentData: null,
                  queueStatus: QueueStatus(
                      totalQueueCount: state
                              .appointmentMarkAsPaidApiResponseModel
                              ?.queueStatus
                              ?.totalQueueCount ??
                          0,
                      waitingTimeInMin: state
                              .appointmentMarkAsPaidApiResponseModel
                              ?.queueStatus
                              ?.waitingTimeInMin ??
                          0),
                ),
              );
            } else if (url.contains("payment-failed")) {
              showToast(
                message: "Payment Failure",
                context: context,
              );
              NavigatorServices().pop(context: context);
            } else if (url.contains("payment-cancel")) {
              showToast(
                message: "Payment Cancel",
                context: context,
              );
              NavigatorServices().pop(context: context);
            }
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isLoading = false; // Hide the loading indicator on error.
            });
            log("Web resource error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(widget.url)) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "Payment Gateway",
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      body: Stack(
        children: [
          /// The WebView widget
          WebViewWidget(controller: controller),

          /// The Circular Progress Indicator
          if (isLoading)
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 10),
                  Text(
                    "Loading...",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
