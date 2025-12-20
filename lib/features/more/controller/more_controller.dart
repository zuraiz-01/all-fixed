import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:eye_buddy/core/services/api/model/appointment_doctor_model.dart'
    as appt;
import 'package:eye_buddy/core/services/api/model/app_test_result_response_model.dart';
import 'package:eye_buddy/core/services/api/model/apply_promo_response_model.dart';
import 'package:eye_buddy/core/services/api/model/doctor_list_response_model.dart';
import 'package:eye_buddy/core/services/api/model/medication_tracker_model.dart';
import 'package:eye_buddy/core/services/api/model/patient_list_model.dart';
import 'package:eye_buddy/core/services/api/model/prescription_list_response_model.dart';
import 'package:eye_buddy/core/services/api/model/promo_list_response_model.dart';
import 'package:eye_buddy/core/services/api/model/test_result_response_model.dart'
    as tr;
import 'package:eye_buddy/core/services/api/repo/api_repo.dart';
import 'package:eye_buddy/core/services/api/service/api_constants.dart';
import 'package:eye_buddy/core/services/utils/keys/shared_pref_keys.dart';
import 'package:eye_buddy/features/global_widgets/toast.dart';
import 'package:eye_buddy/features/login/controller/profile_controller.dart';
import 'package:eye_buddy/features/reason_for_visit/controller/reason_for_visit_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrescriptionItem {
  PrescriptionItem({
    required this.title,
    required this.doctorName,
    required this.dateLabel,
    this.status = 'Pending',
  });

  final String title;
  final String doctorName;
  final String dateLabel;
  final String status;
}

class TestResultItem {
  TestResultItem({
    required this.title,
    required this.type,
    required this.dateLabel,
  });

  final String title;
  final String type;
  final String dateLabel;
}

class DoctorItem {
  DoctorItem({
    required this.name,
    required this.specialty,
    required this.hospital,
  });

  final String name;
  final String specialty;
  final String hospital;
}

class TransactionItem {
  TransactionItem({
    required this.id,
    required this.amountLabel,
    required this.status,
    required this.dateLabel,
  });

  final String id;
  final String amountLabel;
  final String status;
  final String dateLabel;
}

class PromoItem {
  PromoItem({
    required this.code,
    required this.description,
    this.discountLabel = '',
    bool isApplied = false,
  }) : isApplied = isApplied.obs;

  final String code;
  final String description;
  final String discountLabel;
  final RxBool isApplied;
}

class ChatMessage {
  ChatMessage({
    required this.message,
    required this.fromUser,
    required this.sentAt,
  });

  final String message;
  final bool fromUser;
  final DateTime sentAt;
}

class MoreController extends GetxController {
  final ApiRepo _apiRepo = ApiRepo();
  final Dio _dio = Dio();

  final selectedPrescriptionFile = Rx<XFile?>(null);
  final isUploadingPrescription = false.obs;
  final isLoadingPrescriptions = false.obs;
  final prescriptions = <PrescriptionItem>[].obs;
  final apiPrescriptions = <Prescription>[].obs;

  final selectedClinicalFile = Rx<XFile?>(null);
  final isUploadingClinicalResult = false.obs;
  final isLoadingClinicalResults = false.obs;
  final clinicalResultDocs = <tr.TestResult>[].obs;

  final isLoadingAppTestResults = false.obs;
  final appTestResultResponse = Rx<AppTestResultResponseModel?>(null);

  final isLoadingPatients = false.obs;
  final patients = <MyPatient>[].obs;
  final selectedPatient = Rx<MyPatient?>(null);

  final isLoadingTransactions = false.obs;
  final transactionAppointments = <appt.AppointmentData>[].obs;
  final transactionsHistoryResponse = Rx<appt.GetAppointmentApiResponse?>(null);

  final isLoadingPromos = false.obs;
  final promoResponse = Rx<PromoResponseModel?>(null);
  final apiPromos = <Promo>[].obs;

  final isLoadingFavoriteDoctors = false.obs;
  final favoriteDoctorsResponse = Rx<DoctorListResponseModel?>(null);
  final favoriteDoctors = <Doctor>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLocale();
    fetchPrescriptions();
    fetchClinicalResults();
    fetchAppTestResults();
    _loadPatientsFromStorage();
    fetchPatients();
    fetchPromos();
    fetchFavoriteDoctors();
  }

  Future<void> fetchAppTestResults() async {
    isLoadingAppTestResults.value = true;
    try {
      final resp = await _apiRepo.getAppTestResult();
      appTestResultResponse.value = resp;
    } catch (e, s) {
      log('MoreController: fetchAppTestResults error -> $e', stackTrace: s);
      appTestResultResponse.value = null;
    } finally {
      isLoadingAppTestResults.value = false;
    }
  }

  Future<void> fetchFavoriteDoctors() async {
    isLoadingFavoriteDoctors.value = true;
    try {
      final resp = await _apiRepo.getFavoritesDoctor();
      favoriteDoctorsResponse.value = resp;
      favoriteDoctors.assignAll(resp.doctorListResponseData?.doctorList ?? []);
    } catch (e, s) {
      log('MoreController: fetchFavoriteDoctors error -> $e', stackTrace: s);
      favoriteDoctorsResponse.value = null;
      favoriteDoctors.clear();
    } finally {
      isLoadingFavoriteDoctors.value = false;
    }
  }

  Future<bool> removeFavoriteDoctor(Doctor doctor) async {
    final id = (doctor.id ?? '').trim();
    if (id.isEmpty) return false;
    isLoadingFavoriteDoctors.value = true;
    try {
      final resp = await _apiRepo.removeDoctorFromFavoritesDoctorList(id);
      final ok = (resp.status ?? '').toLowerCase() == 'success';
      if (ok) {
        favoriteDoctors.removeWhere((d) => (d.id ?? '') == id);
      }
      return ok;
    } catch (e, s) {
      log('MoreController: removeFavoriteDoctor error -> $e', stackTrace: s);
      return false;
    } finally {
      isLoadingFavoriteDoctors.value = false;
    }
  }

  Future<void> fetchPromos() async {
    isLoadingPromos.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(getPromoKey);
      if (cachedJson != null && cachedJson.isNotEmpty) {
        try {
          final decoded = jsonDecode(cachedJson) as Map<String, dynamic>;
          final cachedResp = PromoResponseModel.fromJson(decoded);
          promoResponse.value = cachedResp;
          apiPromos.assignAll(
            cachedResp.promoResponseData?.promoList ?? <Promo>[],
          );
        } catch (_) {
          // ignore
        }
      }

      final remote = await _apiRepo.getPromos();
      promoResponse.value = remote;
      apiPromos.assignAll(remote.promoResponseData?.promoList ?? <Promo>[]);
      await prefs.setString(getPromoKey, jsonEncode(remote.toJson()));
    } catch (e, s) {
      log('MoreController: fetchPromos error -> $e', stackTrace: s);
    } finally {
      isLoadingPromos.value = false;
    }
  }

  Future<ApplyPromo?> applyPromoToAppointment({
    required String code,
    required String appointmentId,
  }) async {
    final safeCode = code.trim();
    final safeAppointmentId = appointmentId.trim();
    if (safeCode.isEmpty || safeAppointmentId.isEmpty) return null;

    isLoadingPromos.value = true;
    try {
      final resp = await _apiRepo.applyPromoCode({
        'code': safeCode,
        'appointment': safeAppointmentId,
      });

      if (resp.status == 'success') {
        if (Get.isRegistered<ReasonForVisitController>()) {
          final reasonCtrl = Get.find<ReasonForVisitController>();
          await reasonCtrl.updateAppointmentWithPromoData(
            vat: (resp.data?.vat ?? 0).toString(),
            grandTotal: (resp.data?.grandTotal ?? 0).toString(),
            totalAmount: (resp.data?.totalAmount ?? 0).toString(),
          );
        }
        return resp;
      }

      return resp;
    } catch (e, s) {
      log('MoreController: applyPromoToAppointment error -> $e', stackTrace: s);
      return null;
    } finally {
      isLoadingPromos.value = false;
    }
  }

  Future<String> _resolvePatientIdForTransactions({String? patientId}) async {
    final fromArg = (patientId ?? '').trim();
    if (fromArg.isNotEmpty) return fromArg;

    final selected = (selectedPatient.value?.id ?? '').trim();
    if (selected.isNotEmpty) return selected;

    try {
      final profileCtrl = Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());
      if (profileCtrl.profileData.value.profile == null) {
        await profileCtrl.getProfileData();
      }
      return (profileCtrl.profileData.value.profile?.sId ?? '').trim();
    } catch (_) {
      return '';
    }
  }

  Future<void> fetchTransactionsHistory({String? patientId}) async {
    final resolvedPatientId = await _resolvePatientIdForTransactions(
      patientId: patientId,
    );
    if (resolvedPatientId.isEmpty) {
      transactionAppointments.clear();
      transactionsHistoryResponse.value = null;
      return;
    }

    isLoadingTransactions.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(getTransactionListKey);
      if (cachedJson != null && cachedJson.isNotEmpty) {
        try {
          final decoded = jsonDecode(cachedJson) as Map<String, dynamic>;
          final cachedResp = appt.GetAppointmentApiResponse.fromJson(decoded);
          transactionsHistoryResponse.value = cachedResp;
          transactionAppointments.assignAll(
            cachedResp.appointmentList?.appointmentData ??
                <appt.AppointmentData>[],
          );
        } catch (_) {
          // ignore cache parse errors
        }
      }

      final resp = await _apiRepo.getAppointments('', resolvedPatientId);
      final parsed = appt.GetAppointmentApiResponse.fromJson(
        resp as Map<String, dynamic>,
      );

      transactionsHistoryResponse.value = parsed;
      transactionAppointments.assignAll(
        parsed.appointmentList?.appointmentData ?? <appt.AppointmentData>[],
      );

      await prefs.setString(getTransactionListKey, jsonEncode(parsed.toJson()));
    } catch (e) {
      log('MoreController: fetchTransactionsHistory error -> $e');
    } finally {
      isLoadingTransactions.value = false;
    }
  }

  Future<void> _loadPatientsFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString('my-patient-list');
      if (jsonStr == null) return;
      final apiResponse = GetPatientListApiResponse.fromJson(jsonStr);
      if (apiResponse.data != null) {
        patients.assignAll(apiResponse.data!);
        if (selectedPatient.value == null && patients.isNotEmpty) {
          selectedPatient.value = patients.first;
        }
      }
    } catch (_) {
      // ignore
    }
  }

  Future<void> fetchPatients() async {
    try {
      isLoadingPatients.value = true;
      final apiResponse = await _apiRepo.getMyPatientList();
      if (apiResponse.status == 'success' && apiResponse.data != null) {
        patients.assignAll(apiResponse.data!);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('my-patient-list', apiResponse.toJson());
        if (selectedPatient.value == null && patients.isNotEmpty) {
          selectedPatient.value = patients.first;
        }
      }
    } catch (_) {
      // ignore
    } finally {
      isLoadingPatients.value = false;
    }
  }

  void setSelectedPatient(MyPatient? patient) {
    selectedPatient.value = patient;
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(languagePrefsKey);
      final code = (saved == 'bn' || saved == 'en')
          ? saved!
          : (Get.locale?.languageCode == 'bn' ? 'bn' : 'en');
      selectedLocaleCode.value = code;
    } catch (_) {
      selectedLocaleCode.value = Get.locale?.languageCode == 'bn' ? 'bn' : 'en';
    }
  }

  Future<void> fetchClinicalResults() async {
    try {
      isLoadingClinicalResults.value = true;
      final resp = await _apiRepo.getClinicalTestResultData();
      if (resp.status == 'success') {
        clinicalResultDocs.assignAll(resp.data?.docs ?? <tr.TestResult>[]);
      } else {
        clinicalResultDocs.clear();
      }
    } catch (_) {
      clinicalResultDocs.clear();
    } finally {
      isLoadingClinicalResults.value = false;
    }
  }

  Future<void> pickClinicalFile() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
      maxHeight: 1000,
      maxWidth: 1000,
    );
    if (file != null) {
      selectedClinicalFile.value = file;
      debugPrint('Selected clinical file: ${file.path}');
    }
  }

  Future<bool> uploadClinicalResult(String title, {String? patientId}) async {
    if (title.trim().isEmpty) return false;
    if (selectedClinicalFile.value == null) return false;

    final resolvedPatientId = (patientId != null && patientId.trim().isNotEmpty)
        ? patientId.trim()
        : selectedPatient.value?.id;
    final profileId =
        Get.find<ProfileController>().profileData.value.profile?.sId;

    isUploadingClinicalResult.value = true;
    try {
      final file = selectedClinicalFile.value!;
      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);
      final ext = p.extension(file.path).isNotEmpty
          ? p.extension(file.path)
          : '.jpg';

      final payload = {
        if (resolvedPatientId != null && resolvedPatientId.isNotEmpty)
          'patient': resolvedPatientId
        else if (profileId != null)
          'patient': profileId,
        'title': title.trim(),
        'attachment': {'base64String': base64Image, 'fileExtension': ext},
      };

      final response = await _apiRepo.uploadPatientClinicalResult(payload);
      if (response['status'] == 'success') {
        await fetchClinicalResults();
        selectedClinicalFile.value = null;
        return true;
      }
      return false;
    } finally {
      isUploadingClinicalResult.value = false;
    }
  }

  Future<bool> deleteClinicalTestResult(String id) async {
    if (id.trim().isEmpty) return false;
    try {
      isLoadingClinicalResults.value = true;
      final resp = await _apiRepo.deleteTestResult(resultId: id.trim());
      final ok = resp.status == 'success';
      await fetchClinicalResults();
      return ok;
    } finally {
      isLoadingClinicalResults.value = false;
    }
  }

  final favouriteDoctors = <DoctorItem>[
    DoctorItem(
      name: 'Dr. Tahira Islam',
      specialty: 'Retina specialist',
      hospital: 'BEH Dhaka',
    ),
    DoctorItem(
      name: 'Dr. Faisal Rahman',
      specialty: 'Cornea specialist',
      hospital: 'BEH Chittagong',
    ),
  ].obs;

  final transactions = <TransactionItem>[
    TransactionItem(
      id: '#INV-1045',
      amountLabel: '৳ 2,800',
      status: 'Paid',
      dateLabel: '27 Dec 2024',
    ),
    TransactionItem(
      id: '#INV-1031',
      amountLabel: '৳ 1,950',
      status: 'Refunded',
      dateLabel: '12 Dec 2024',
    ),
  ].obs;

  final promos = <PromoItem>[
    PromoItem(
      code: 'BEH50',
      description: '50% off on first consultation',
      discountLabel: 'Flat 50%',
    ),
    PromoItem(
      code: 'EYE10',
      description: '10% off on eye tests',
      discountLabel: '10% OFF',
    ),
  ].obs;

  final chatMessages = <ChatMessage>[
    ChatMessage(
      message: 'Hi! How can we help you today?',
      fromUser: false,
      sentAt: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
    ChatMessage(
      message: 'I want to confirm my appointment time.',
      fromUser: true,
      sentAt: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
  ].obs;

  final selectedLocaleCode = 'en'.obs;

  void removeFavourite(DoctorItem doctor) {
    favouriteDoctors.remove(doctor);
  }

  void addPrescription(PrescriptionItem item) {
    prescriptions.insert(0, item);
  }

  Future<void> pickPrescriptionFile() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
      maxHeight: 1000,
      maxWidth: 1000,
    );
    if (file != null) {
      selectedPrescriptionFile.value = file;
      debugPrint('Selected prescription file: ${file.path}');
    }
  }

  Future<bool> uploadPrescription(String title, {String? patientId}) async {
    if (title.trim().isEmpty) {
      debugPrint('Upload blocked: title is empty');
      return false;
    }
    if (selectedPrescriptionFile.value == null) {
      debugPrint('Upload blocked: no file selected');
      return false;
    }

    final resolvedPatientId = (patientId != null && patientId.trim().isNotEmpty)
        ? patientId.trim()
        : selectedPatient.value?.id;

    final profileId =
        Get.find<ProfileController>().profileData.value.profile?.sId;

    isUploadingPrescription.value = true;
    try {
      final file = selectedPrescriptionFile.value!;
      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);
      final ext = p.extension(file.path).isNotEmpty
          ? p.extension(file.path)
          : '.jpg';

      final payload = {
        if (resolvedPatientId != null && resolvedPatientId.isNotEmpty)
          'patient': resolvedPatientId
        else if (profileId != null)
          'patient': profileId,
        'title': title.trim(),
        'attachment': {'base64String': base64Image, 'fileExtension': ext},
      };

      log('Uploading prescription payload keys: ${payload.keys}');
      final response = await _apiRepo.uploadPatientPrescription(payload);
      log('Upload prescription response: $response');

      if (response['status'] == 'success') {
        await fetchPrescriptions(remoteOnly: true);
        selectedPrescriptionFile.value = null;
        return true;
      }
      return false;
    } catch (e, s) {
      log('Upload prescription error: $e', stackTrace: s);
      return false;
    } finally {
      isUploadingPrescription.value = false;
    }
  }

  void togglePromo(PromoItem promo) {
    promo.isApplied.toggle();
    promos.refresh();
  }

  void addChatMessage(String text, {bool fromUser = true}) {
    if (text.trim().isEmpty) return;
    chatMessages.add(
      ChatMessage(
        message: text.trim(),
        fromUser: fromUser,
        sentAt: DateTime.now(),
      ),
    );
  }

  void setLocale(String code) {
    final normalized = (code == 'bn') ? 'bn' : 'en';
    selectedLocaleCode.value = normalized;
    Get.updateLocale(Locale(normalized));
    SharedPreferences.getInstance().then(
      (prefs) => prefs.setString(languagePrefsKey, normalized),
    );
  }

  String formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoString);
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (_) {
      return '';
    }
  }

  void showToastMessage({required String message}) {
    final context = Get.context;
    if (context != null) {
      showToast(message: message, context: context);
    }
  }

  Future<void> fetchPrescriptions({bool remoteOnly = false}) async {
    try {
      isLoadingPrescriptions.value = true;
      final prefs = await SharedPreferences.getInstance();

      if (!remoteOnly) {
        final cached = prefs.getString(getAllPrescriptionListKey);
        if (cached != null && cached.isNotEmpty) {
          try {
            final decoded = jsonDecode(cached) as Map<String, dynamic>;
            final cachedResp = PrescriptionListResponseModel.fromJson(decoded);
            if (cachedResp.status == 'success' &&
                cachedResp.prescriptionListData?.prescriptionList != null) {
              final list = cachedResp.prescriptionListData!.prescriptionList!;
              apiPrescriptions.assignAll(list);
              prescriptions.assignAll(
                list
                    .map(
                      (p) => PrescriptionItem(
                        title: p.title ?? 'Prescription',
                        doctorName: p.patientDetails?.name ?? 'Doctor',
                        dateLabel: formatDate(p.createdAt),
                        status: 'Uploaded',
                      ),
                    )
                    .toList(),
              );
            }
          } catch (_) {
            // ignore cache parse errors
          }
        }
      }

      final selectedId = (selectedPatient.value?.id ?? '').trim();
      final profileId = Get.isRegistered<ProfileController>()
          ? (Get.find<ProfileController>().profileData.value.profile?.sId ?? '')
          : '';

      final patientId = selectedId.isNotEmpty ? selectedId : profileId.trim();
      if (patientId.isEmpty) {
        log('fetchPrescriptions: missing patient id');
        return;
      }

      final params = {'patient': patientId};
      final resp = await _apiRepo.getPrescriptionList(params);
      log('fetchPrescriptions response status: ${resp.status}');

      await prefs.setString(
        getAllPrescriptionListKey,
        jsonEncode(resp.toJson()),
      );

      if (resp.status == 'success' &&
          resp.prescriptionListData?.prescriptionList != null) {
        final list = resp.prescriptionListData!.prescriptionList!;
        apiPrescriptions.assignAll(list);
        prescriptions.assignAll(
          list
              .map(
                (p) => PrescriptionItem(
                  title: p.title ?? 'Prescription',
                  doctorName: p.patientDetails?.name ?? 'Doctor',
                  dateLabel: formatDate(p.createdAt),
                  status: 'Uploaded',
                ),
              )
              .toList(),
        );
      }
    } catch (e, s) {
      log('fetchPrescriptions error: $e', stackTrace: s);
    } finally {
      isLoadingPrescriptions.value = false;
    }
  }

  Future<void> deletePrescription(String id) async {
    try {
      final resp = await _apiRepo.deletePrescriptionFromList(id);
      if (resp['status'] == 'success') {
        showToastMessage(message: resp['message'] ?? 'Deleted');
        await fetchPrescriptions(remoteOnly: true);
      } else {
        showToastMessage(message: resp['message'] ?? 'Failed to delete');
      }
    } catch (e, s) {
      log('deletePrescription error: $e', stackTrace: s);
      showToastMessage(message: 'Failed to delete');
    }
  }

  Future<void> sharePrescription({
    required String? file,
    required String? title,
  }) async {
    try {
      if (file == null || file.isEmpty) {
        showToastMessage(message: 'Your prescription is invalid');
        return;
      }

      final resolvedUrl = file.startsWith('http')
          ? file
          : '${ApiConstants.imageBaseUrl}$file';

      final uri = Uri.tryParse(resolvedUrl);
      if (uri == null) {
        showToastMessage(message: 'Your prescription is invalid');
        return;
      }

      final directory = await getTemporaryDirectory();

      final ext = p.extension(uri.path);
      final safeExt = ext.isNotEmpty ? ext : '.jpg';
      final fileName =
          'prescription_${DateTime.now().millisecondsSinceEpoch}$safeExt';
      final path = p.join(directory.path, fileName);

      await _dio.download(resolvedUrl, path);

      await Share.shareXFiles([XFile(path)], text: title ?? 'Prescription');
    } catch (e, s) {
      log('sharePrescription error: $e', stackTrace: s);
      showToastMessage(message: 'Failed to share prescription');
    }
  }
}
