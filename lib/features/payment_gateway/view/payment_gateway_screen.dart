import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/services/api/service/api_constants.dart';
import '../../../core/services/api/model/doctor_list_response_model.dart';
import '../../../core/services/api/model/patient_list_model.dart';
import '../../../features/global_widgets/toast.dart';
import '../../../l10n/app_localizations.dart';
import '../../appointments/controller/appointment_controller.dart';
import '../../reason_for_visit/controller/reason_for_visit_controller.dart';

class PaymentGatewayScreen extends StatefulWidget {
  const PaymentGatewayScreen({super.key});

  @override
  State<PaymentGatewayScreen> createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
  late final WebViewController _controller;
  late final String _initialUrl;
  bool _isLoading = true;
  bool _handledTerminalResult = false;
  bool _isProcessingTerminalResult = false;
  String _appointmentId = '';
  final Stopwatch _loadStopwatch = Stopwatch();

  Future<void> _handlePaymentUrlIfTerminal(
    String url, {
    required Map<String, dynamic>? args,
  }) async {
    if (_handledTerminalResult) return;

    final lowerUrl = url.toLowerCase();
    final uri = Uri.tryParse(url);
    final qp = uri?.queryParameters ?? const <String, String>{};

    // IMPORTANT:
    // SSLCommerz shows OTP/3DS inside their own domain and can include misleading
    // query params (e.g. status=valid) during intermediate steps.
    // We only treat navigation as terminal when the webview returns back to our
    // own backend/merchant domain.
    final merchantHost = Uri.parse(ApiConstants.baseUrl).host.toLowerCase();
    final currentHost = (uri?.host ?? '').toLowerCase();
    final isMerchantReturn =
        currentHost.isNotEmpty &&
        (currentHost == merchantHost || currentHost.endsWith(merchantHost));
    if (!isMerchantReturn) {
      return;
    }

    final tranType = (qp['tran_type'] ?? '').toLowerCase();
    final paymentStatus = (qp['payment_status'] ?? '').toLowerCase();
    final status = (qp['status'] ?? '').toLowerCase();
    final payStatus = (qp['pay_status'] ?? '').toLowerCase();

    final hasTransactionRef =
        (qp['tran_id'] ?? '').trim().isNotEmpty ||
        (qp['val_id'] ?? '').trim().isNotEmpty ||
        (qp['bank_tran_id'] ?? '').trim().isNotEmpty;

    final isSuccessCandidate =
        lowerUrl.contains('payment-success') ||
        lowerUrl.contains('payment_success') ||
        (hasTransactionRef &&
            (lowerUrl.contains('tran_type=success') ||
                tranType == 'success' ||
                paymentStatus == 'success' ||
                status == 'success' ||
                status == 'paid' ||
                status == 'valid' ||
                payStatus == 'valid' ||
                payStatus == 'success'));

    final isFailedCandidate =
        lowerUrl.contains('payment-failed') ||
        lowerUrl.contains('payment_failed') ||
        (hasTransactionRef &&
            (status == 'failed' || paymentStatus == 'failed'));

    final isCancelCandidate =
        lowerUrl.contains('payment-cancel') ||
        lowerUrl.contains('payment_cancel') ||
        (hasTransactionRef &&
            (status == 'cancel' || paymentStatus == 'cancel'));

    if (!isSuccessCandidate && !isFailedCandidate && !isCancelCandidate) {
      return;
    }

    if (_isProcessingTerminalResult) return;
    _isProcessingTerminalResult = true;

    if (isFailedCandidate || isCancelCandidate) {
      _handledTerminalResult = true;
      _isProcessingTerminalResult = false;
      Get.back();
      return;
    }

    final MyPatient? patientData = args?['patientData'] as MyPatient?;
    final Doctor? selectedDoctor = args?['selectedDoctor'] as Doctor?;

    if (patientData == null || selectedDoctor == null) {
      _handledTerminalResult = true;
      _isProcessingTerminalResult = false;
      Get.back();
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    // Try to verify paid status, but do not block navigation if verification
    // is delayed on backend.
    try {
      final reasonController = Get.find<ReasonForVisitController>();
      await _verifyAppointmentPaidWithRetries(reasonController, _appointmentId);
      reasonController.clearState();
    } catch (_) {
      // ignore
    }

    _handledTerminalResult = true;

    final ctx = Get.context;
    if (ctx != null) {
      final l10n = AppLocalizations.of(ctx)!;
      showToast(message: l10n.payment_successful, context: ctx);
    }

    Get.offNamed(
      '/waiting-for-doctor',
      arguments: {
        'patientData': patientData,
        'selectedDoctor': selectedDoctor,
        'queueStatus': null,
      },
    );

    _isProcessingTerminalResult = false;
  }

  @override
  void initState() {
    super.initState();

    _loadStopwatch
      ..reset()
      ..start();

    final args = Get.arguments as Map<String, dynamic>?;
    _initialUrl = args?['url'] as String;
    _appointmentId = (args?['appointmentId'] ?? '').toString();

    log(
      'PaymentGateway: init with url=$_initialUrl (t=${_loadStopwatch.elapsedMilliseconds}ms)',
    );

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 0 ||
                progress == 10 ||
                progress == 25 ||
                progress == 50 ||
                progress == 75 ||
                progress == 100) {
              log(
                'Payment page progress: $progress% (t=${_loadStopwatch.elapsedMilliseconds}ms)',
              );
            }
          },
          onPageStarted: (String url) {
            log(
              'Payment page started: $url (t=${_loadStopwatch.elapsedMilliseconds}ms)',
            );
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) async {
            log(
              'Payment page finished: $url (t=${_loadStopwatch.elapsedMilliseconds}ms)',
            );

            // Page finished loading, hide loader
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }

            await _handlePaymentUrlIfTerminal(url, args: args);
          },
          onWebResourceError: (WebResourceError error) {
            log('Web resource error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            // Match BLoC behaviour: allow all navigation inside the payment webview
            // so that SSLCommerz can open its internal payment pages/modals.
            _handlePaymentUrlIfTerminal(request.url, args: args);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(_initialUrl));
  }

  @override
  void dispose() {
    _loadStopwatch.stop();
    super.dispose();
  }

  Future<bool> _isAppointmentPaid(String appointmentId) async {
    if (appointmentId.isEmpty) {
      return false;
    }

    try {
      final appointmentController = Get.isRegistered<AppointmentController>()
          ? Get.find<AppointmentController>()
          : Get.put(AppointmentController());

      // We assume refreshAppointments() already pulled fresh data, but ensure
      // we have something.
      final upcoming =
          appointmentController.upcomingAppointments.value?.appointmentList;
      final past =
          appointmentController.pastAppointments.value?.appointmentList;
      final followup =
          appointmentController.followupAppointments.value?.appointmentList;

      final all = <dynamic>[
        ...(upcoming?.appointmentData ?? const []),
        ...(followup?.appointmentData ?? const []),
        ...(past?.appointmentData ?? const []),
      ];

      dynamic match;
      for (final a in all) {
        if ((a.id?.toString() ?? '') == appointmentId) {
          match = a;
          break;
        }
      }

      if (match == null) {
        return false;
      }

      final paymentId = (match.paymentId?.toString() ?? '').trim();
      final paymentMethod = (match.paymentMethod?.toString() ?? '').trim();
      final patientAgoraToken = (match.patientAgoraToken?.toString() ?? '')
          .trim();
      final doctorAgoraToken = (match.doctorAgoraToken?.toString() ?? '')
          .trim();
      final channelId = (match.channelId?.toString() ?? '').trim();
      final status = (match.status?.toString() ?? '').toLowerCase().trim();

      // Heuristics: any real payment should have paymentId/paymentMethod OR a paid status.
      if (paymentId.isNotEmpty || paymentMethod.isNotEmpty) return true;
      if (patientAgoraToken.isNotEmpty || doctorAgoraToken.isNotEmpty)
        return true;
      if (channelId.isNotEmpty) return true;
      if (match.queueStatus != null) return true;
      if (status == 'paid' || status == 'confirmed' || status == 'upcoming') {
        // Some backends use upcoming only after payment.
        return true;
      }

      return false;
    } catch (e) {
      log('Payment verification error: $e');
      return false;
    }
  }

  Future<bool> _verifyAppointmentPaidWithRetries(
    ReasonForVisitController reasonController,
    String appointmentId,
  ) async {
    const attempts = 4;
    for (var i = 0; i < attempts; i++) {
      await reasonController.refreshAppointments();
      final ok = await _isAppointmentPaid(appointmentId);
      if (ok) return true;
      await Future.delayed(const Duration(milliseconds: 900));
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final args = Get.arguments as Map<String, dynamic>?;
    final MyPatient? patientData = args?['patientData'] as MyPatient?;
    final Doctor? selectedDoctor = args?['selectedDoctor'] as Doctor?;

    // patientData and selectedDoctor are currently unused but kept
    // for future navigation (e.g., waiting room screen) after payment.

    return Scaffold(
      appBar: AppBar(title: Text(l10n.payment_gateway)),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 10),
                  _PaymentLoadingLabel(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PaymentLoadingLabel extends StatelessWidget {
  const _PaymentLoadingLabel();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Text(
      l10n.loading,
      style: const TextStyle(fontSize: 16, color: Colors.black54),
    );
  }
}
