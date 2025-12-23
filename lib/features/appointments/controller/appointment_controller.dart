import 'dart:convert';
import 'dart:developer';

import 'package:eye_buddy/core/services/api/model/appointment_doctor_model.dart'
    as core_models;
import 'package:eye_buddy/core/services/api/model/patient_list_model.dart';
import 'package:eye_buddy/core/services/api/model/doctor_list_response_model.dart';
import 'package:eye_buddy/core/services/api/repo/api_repo.dart';
import 'package:eye_buddy/features/login/controller/profile_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentController extends GetxController {
  final ApiRepo _apiRepo = ApiRepo();

  RxBool isLoading = false.obs;

  // Mirrors BLoC AppointmentCubit appointment button loading behavior
  final isAppointmentButtonLoading = false.obs;
  final appointmentIdLoading = ''.obs;
  Rx<core_models.GetAppointmentApiResponse?> pastAppointments =
      Rx<core_models.GetAppointmentApiResponse?>(null);
  Rx<core_models.GetAppointmentApiResponse?> upcomingAppointments =
      Rx<core_models.GetAppointmentApiResponse?>(null);
  Rx<core_models.GetAppointmentApiResponse?> followupAppointments =
      Rx<core_models.GetAppointmentApiResponse?>(null);

  final isLoadingPatients = false.obs;
  final patients = <MyPatient>[].obs;
  final selectedPatient = Rx<MyPatient?>(null);

  static const String _selectedPatientIdStorageKey =
      'appointments-selected-patient-id';

  String patientId = ""; // set from profile

  @override
  void onInit() {
    super.onInit();
    _resolvePatientId();
    getPatientsFromStorage();
    getPatients();
  }

  Future<void> _syncSelectedPatientFromPatients() async {
    if (patients.isEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedId = prefs.getString(_selectedPatientIdStorageKey) ?? '';

      MyPatient? resolved;
      if (savedId.isNotEmpty) {
        resolved = _firstWhereOrNull(patients, (p) => p.id == savedId);
      }

      resolved ??= _firstWhereOrNull(patients, (p) => p.id == patientId);
      resolved ??= patients.first;

      if (resolved.id == null || resolved.id!.isEmpty) return;

      final current = selectedPatient.value;
      if (current?.id == resolved.id) return;

      selectedPatient.value = resolved;
      patientId = resolved.id!;
      await prefs.setString(_selectedPatientIdStorageKey, patientId);

      // Fetch appointments only after we have resolved the correct selected patient.
      await getAppointments();
    } catch (e) {
      log(
        'AppointmentController: _syncSelectedPatientFromPatients error -> $e',
      );
    }
  }

  MyPatient? _firstWhereOrNull(
    List<MyPatient> list,
    bool Function(MyPatient) test,
  ) {
    for (final item in list) {
      if (test(item)) return item;
    }
    return null;
  }

  /// Ensure we have a valid patient id before fetching appointments
  Future<void> _resolvePatientId() async {
    try {
      // Ensure profile controller is available
      final profileCtrl = Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());

      // If profile not loaded yet, attempt a fetch
      if (profileCtrl.profileData.value.profile == null) {
        await profileCtrl.getProfileData();
      }

      patientId = profileCtrl.profileData.value.profile?.sId ?? "";
      if (patientId.isEmpty) {
        log("AppointmentController: patientId missing, skipping fetch");
        return;
      }
    } catch (e) {
      log("AppointmentController: failed to resolve patientId -> $e");
    }
  }

  Future<void> getPatientsFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString('my-patient-list');
      if (jsonStr == null) return;
      final apiResponse = GetPatientListApiResponse.fromJson(jsonStr);
      if (apiResponse.data != null) {
        patients.assignAll(apiResponse.data!);
        await _syncSelectedPatientFromPatients();
      }
    } catch (e) {
      log('AppointmentController: getPatientsFromStorage error -> $e');
    }
  }

  Future<void> getPatients() async {
    try {
      isLoadingPatients.value = true;
      final apiResponse = await _apiRepo.getMyPatientList();
      if (apiResponse.status == 'success' && apiResponse.data != null) {
        patients.assignAll(apiResponse.data!);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('my-patient-list', apiResponse.toJson());
        await _syncSelectedPatientFromPatients();
      }
    } catch (e) {
      log('AppointmentController: getPatients error -> $e');
    } finally {
      isLoadingPatients.value = false;
    }
  }

  Future<void> selectPatient(MyPatient patient) async {
    selectedPatient.value = patient;
    if ((patient.id ?? '').isNotEmpty) {
      patientId = patient.id!;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_selectedPatientIdStorageKey, patientId);
      } catch (e) {
        log('AppointmentController: failed to persist selected patient -> $e');
      }
      await getAppointments(loadFromStorage: false);
    }
  }

  Future<void> refreshScreen() async {
    getAppointments(loadFromStorage: false);
  }

  Future<bool> submitRatingForAppointment({
    required String appointmentId,
    required double rating,
    required String review,
  }) async {
    if (appointmentId.isEmpty) return false;
    if (isAppointmentButtonLoading.value) return false;

    isAppointmentButtonLoading.value = true;
    appointmentIdLoading.value = appointmentId;
    try {
      final resp = await _apiRepo.submitRating({
        'appointment': appointmentId,
        'rating': rating,
        'review': review,
      });

      if (resp.status == 'success') {
        await getAppointments(loadFromStorage: false);
        return true;
      }
      return false;
    } catch (e) {
      log('AppointmentController: submitRatingForAppointment error -> $e');
      return false;
    } finally {
      isAppointmentButtonLoading.value = false;
      appointmentIdLoading.value = '';
    }
  }

  Future<Doctor?> getDoctorById({
    required String appointmentId,
    required String docId,
  }) async {
    if (docId.trim().isEmpty) return null;

    // Note: the caller (AppointmentTileWidget) already manages
    // isAppointmentButtonLoading/appointmentIdLoading to match BLoC behavior.
    try {
      final doc = await _apiRepo.getDoctorById(docId.trim());
      return doc;
    } catch (e) {
      log('AppointmentController: getDoctorById error -> $e');
      return null;
    } finally {
      // keep flags untouched here; caller will reset them
    }
  }

  Future<void> getAppointments({bool loadFromStorage = true}) async {
    if (patientId.isEmpty) {
      log("getAppointments aborted: patientId is empty");
      return;
    }
    try {
      isLoading.value = true;

      if (loadFromStorage) {
        await getAppointmentFromStorage();
      }

      final pastResponseData = await _apiRepo.getAppointments(
        "past",
        patientId,
      );
      final upcomingResponseData = await _apiRepo.getAppointments(
        "upcoming",
        patientId,
      );
      final followupResponseData = await _apiRepo.getAppointments(
        "followup",
        patientId,
      );

      pastAppointments.value = core_models.GetAppointmentApiResponse.fromJson(
        pastResponseData as Map<String, dynamic>,
      );
      upcomingAppointments.value =
          core_models.GetAppointmentApiResponse.fromJson(
            upcomingResponseData as Map<String, dynamic>,
          );
      followupAppointments.value =
          core_models.GetAppointmentApiResponse.fromJson(
            followupResponseData as Map<String, dynamic>,
          );

      await saveAppointmentToStorage();

      // After fetching upcoming appointments, extract the latest
      // non-empty patientAgoraToken and persist it so that the
      // AgoraCallController can use it when starting a call.
      try {
        final upcoming = upcomingAppointments.value;
        final docs = upcoming?.appointmentList?.appointmentData;
        if (docs != null && docs.isNotEmpty) {
          // Prefer the most recent upcoming appointment that has a token
          for (final appt in docs.reversed) {
            final token = appt.patientAgoraToken?.toString() ?? '';
            if (token.isNotEmpty) {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('patient_agora_token', token);
              log(
                'AppointmentController: Saved patient_agora_token from upcoming appointments.',
              );
              break;
            }
          }
        }
      } catch (e) {
        log(
          'AppointmentController: failed to extract/save patientAgoraToken -> $e',
        );
      }
    } catch (e) {
      log("Get appointments error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveAppointmentToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (pastAppointments.value != null) {
        prefs.setString(
          "$patientId-getPastAppointmentApiResponse",
          jsonEncode(pastAppointments.value!.toJson()),
        );
      }
      if (upcomingAppointments.value != null) {
        prefs.setString(
          "$patientId-getUpcomingAppointmentApiResponse",
          jsonEncode(upcomingAppointments.value!.toJson()),
        );
      }
      if (followupAppointments.value != null) {
        prefs.setString(
          "$patientId-getFollowupAppointmentApiResponse",
          jsonEncode(followupAppointments.value!.toJson()),
        );
      }

      final pastIds =
          (pastAppointments.value?.appointmentList?.appointmentData ??
                  const <core_models.AppointmentData>[])
              .map((e) => e.id)
              .whereType<String>()
              .where((id) => id.isNotEmpty)
              .toList();
      final upcomingIds =
          (upcomingAppointments.value?.appointmentList?.appointmentData ??
                  const <core_models.AppointmentData>[])
              .map((e) => e.id)
              .whereType<String>()
              .where((id) => id.isNotEmpty)
              .toList();
      final followupIds =
          (followupAppointments.value?.appointmentList?.appointmentData ??
                  const <core_models.AppointmentData>[])
              .map((e) => e.id)
              .whereType<String>()
              .where((id) => id.isNotEmpty)
              .toList();

      final prescribedIds = <String>{
        ...((pastAppointments.value?.appointmentList?.appointmentData ??
                const <core_models.AppointmentData>[])
            .where((e) => e.isPrescribed == true)
            .map((e) => e.id)
            .whereType<String>()
            .where((id) => id.isNotEmpty)),
        ...((upcomingAppointments.value?.appointmentList?.appointmentData ??
                const <core_models.AppointmentData>[])
            .where((e) => e.isPrescribed == true)
            .map((e) => e.id)
            .whereType<String>()
            .where((id) => id.isNotEmpty)),
        ...((followupAppointments.value?.appointmentList?.appointmentData ??
                const <core_models.AppointmentData>[])
            .where((e) => e.isPrescribed == true)
            .map((e) => e.id)
            .whereType<String>()
            .where((id) => id.isNotEmpty)),
      }.toList();

      await prefs.setStringList('past_appointment_ids', pastIds);
      await prefs.setStringList(
        'active_appointment_ids',
        <String>{...upcomingIds, ...followupIds}.toList(),
      );
      await prefs.setStringList('prescribed_appointment_ids', prescribedIds);
    } catch (e) {
      log("Save appointments to storage error: $e");
    }
  }

  Future<void> getAppointmentFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pastJson = prefs.getString(
        "$patientId-getPastAppointmentApiResponse",
      );
      final upcomingJson = prefs.getString(
        "$patientId-getUpcomingAppointmentApiResponse",
      );
      final followupJson = prefs.getString(
        "$patientId-getFollowupAppointmentApiResponse",
      );

      if (pastJson != null) {
        pastAppointments.value = core_models.GetAppointmentApiResponse.fromJson(
          jsonDecode(pastJson),
        );
      }
      if (upcomingJson != null) {
        upcomingAppointments.value = core_models
            .GetAppointmentApiResponse.fromJson(jsonDecode(upcomingJson));
      }
      if (followupJson != null) {
        followupAppointments.value = core_models
            .GetAppointmentApiResponse.fromJson(jsonDecode(followupJson));
      }

      final pastIds =
          (pastAppointments.value?.appointmentList?.appointmentData ??
                  const <core_models.AppointmentData>[])
              .map((e) => e.id)
              .whereType<String>()
              .where((id) => id.isNotEmpty)
              .toList();
      final upcomingIds =
          (upcomingAppointments.value?.appointmentList?.appointmentData ??
                  const <core_models.AppointmentData>[])
              .map((e) => e.id)
              .whereType<String>()
              .where((id) => id.isNotEmpty)
              .toList();
      final followupIds =
          (followupAppointments.value?.appointmentList?.appointmentData ??
                  const <core_models.AppointmentData>[])
              .map((e) => e.id)
              .whereType<String>()
              .where((id) => id.isNotEmpty)
              .toList();

      final prescribedIds = <String>{
        ...((pastAppointments.value?.appointmentList?.appointmentData ??
                const <core_models.AppointmentData>[])
            .where((e) => e.isPrescribed == true)
            .map((e) => e.id)
            .whereType<String>()
            .where((id) => id.isNotEmpty)),
        ...((upcomingAppointments.value?.appointmentList?.appointmentData ??
                const <core_models.AppointmentData>[])
            .where((e) => e.isPrescribed == true)
            .map((e) => e.id)
            .whereType<String>()
            .where((id) => id.isNotEmpty)),
        ...((followupAppointments.value?.appointmentList?.appointmentData ??
                const <core_models.AppointmentData>[])
            .where((e) => e.isPrescribed == true)
            .map((e) => e.id)
            .whereType<String>()
            .where((id) => id.isNotEmpty)),
      }.toList();

      await prefs.setStringList('past_appointment_ids', pastIds);
      await prefs.setStringList(
        'active_appointment_ids',
        <String>{...upcomingIds, ...followupIds}.toList(),
      );
      await prefs.setStringList('prescribed_appointment_ids', prescribedIds);
    } catch (e) {
      log("Get appointments from storage error: $e");
    }
  }
}
