import 'dart:convert';
import 'dart:developer';

import 'package:eye_buddy/app/api/model/app_test_result_response_model.dart';
import 'package:eye_buddy/app/api/model/apply_promo_response_model.dart';
import 'package:eye_buddy/app/api/model/appointment_doctor_model.dart';
import 'package:eye_buddy/app/api/model/banner_response_model.dart';
import 'package:eye_buddy/app/api/model/doctor_list_response_model.dart';
import 'package:eye_buddy/app/api/model/get_doctor_rating_model.dart';
import 'package:eye_buddy/app/api/model/init_payment_response_model.dart';
import 'package:eye_buddy/app/api/model/loginModels.dart';
import 'package:eye_buddy/app/api/model/medication_tracker_model.dart';
import 'package:eye_buddy/app/api/model/patient_list_model.dart';
import 'package:eye_buddy/app/api/model/prescription_list_response_model.dart';
import 'package:eye_buddy/app/api/model/profile_reponse_model.dart';
import 'package:eye_buddy/app/api/model/promo_list_response_model.dart';
import 'package:eye_buddy/app/api/model/specialties_response_model.dart';
import 'package:eye_buddy/app/api/model/test_result_response_model.dart';
import 'package:eye_buddy/app/api/model/verifyOtpModel.dart';
import 'package:eye_buddy/app/api/service/api_constants.dart';
import 'package:eye_buddy/app/api/service/api_service.dart';
import 'package:eye_buddy/app/models/common_api_response_model.dart';
import 'package:eye_buddy/app/services/local_notification_services.dart';
import 'package:eye_buddy/app/views/live_support/model/live_chat_model.dart';
import 'package:eye_buddy/app/views/live_support/model/live_support_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/test_result/test_result_cubit.dart';
import '../../views/live_support/model/send_message_response_model.dart';
import '../model/notification_response_model.dart';

class ApiRepo {
  final ApiService _apiService = ApiService();

  Future<LoginApiResponseModel> loginUser({
    required String phone,
    required String dialCode,
  }) async {
    try {
      final loginModel = LoginModel(
        dialCode: dialCode,
        phone: phone,
      );

      Map<String, dynamic> response = await _apiService.getPostResponse(
        '${ApiConstants.baseUrl}/api/patient/auth/request',
        // DIO.FormData.fromMap(
        //   loginModel.toMap(),
        // ),
        loginModel.toMap(),
      ) as Map<String, dynamic>;
      print("Login Error: $response");

      final loginApiResponseModel = LoginApiResponseModel.fromMap(response);

      return loginApiResponseModel;
    } catch (err) {
      return LoginApiResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<UpdateMedicationApiResponse> updateMedication({
    required Medication medication,
  }) async {
    try {
      List<Map<String, dynamic>> data =
          _convertJsonForMedicationTracker(medication.toMap());
      UpdateMedicationApiResponse? apiResponse;
      for (var element in data) {
        apiResponse = UpdateMedicationApiResponse.fromMap(
          await _apiService.getPatchResponse(
            '${ApiConstants.baseUrl}/api/patient/medicineTracker',
            element,
          ) as Map<String, dynamic>,
        );
      }
      return apiResponse!;
    } catch (err) {
      return UpdateMedicationApiResponse(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  List<Map<String, dynamic>> _convertJsonForMedicationTracker(
      Map<String, dynamic> jsonData) {
    List<Map<String, dynamic>> outputList = [];

    // Iterate through days and create a new entry if the day is true
    for (var day in ['sat', 'sun', 'mon', 'tue', 'wed', 'thu', 'fri']) {
      if (jsonData[day]) {
        for (var time in jsonData['time']) {
          outputList.add({
            "title": jsonData['title'],
            "day": day,
            "description": jsonData["description"],
            "time": time,
          });
        }
      }
    }

    return outputList;
  }

  Future<UpdateMedicationApiResponse> addMedication({
    required Medication medication,
  }) async {
    try {
      List<Map<String, dynamic>> data =
          _convertJsonForMedicationTracker(medication.toMap());
      UpdateMedicationApiResponse? apiResponse;
      for (var element in data) {
        apiResponse = UpdateMedicationApiResponse.fromMap(
          await _apiService.getPostResponse(
            '${ApiConstants.baseUrl}/api/patient/medicineTracker',
            element,
          ) as Map<String, dynamic>,
        );
      }
      return apiResponse!;
    } catch (err) {
      return UpdateMedicationApiResponse(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<UpdateMedicationApiResponse> deleteMedication({
    required String id,
  }) async {
    try {
      final apiRespnse = UpdateMedicationApiResponse.fromMap(
        await _apiService.getDeleteResponse(
          '${ApiConstants.baseUrl}/api/patient/medicineTracker/${id}',
        ) as Map<String, dynamic>,
      );
      return apiRespnse;
    } catch (err) {
      return UpdateMedicationApiResponse(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<void> scheduleAppointmentNotification({
    required String id,
    required String title,
    required String body,
    required String day,
    required String time,
  }) async {
    int dayOfWeek = getDayOfWeek(day);
    DateTime now = DateTime.now();
    DateTime scheduledNotificationDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(time.split(':')[0]),
      int.parse(time.split(':')[1]),
    );

    while (scheduledNotificationDateTime.weekday != dayOfWeek) {
      scheduledNotificationDateTime =
          scheduledNotificationDateTime.add(Duration(days: 1));
      log("Duration extended for day $day, time: $time");
    }

    await NotificationService().scheduleNotification(
      id: id.hashCode,
      title: title,
      body: body,
      scheduledNotificationDateTime: scheduledNotificationDateTime,
    );
  }

  int getDayOfWeek(String day) {
    switch (day.toLowerCase()) {
      case 'mon':
        return DateTime.monday;
      case 'tue':
        return DateTime.tuesday;
      case 'wed':
        return DateTime.wednesday;
      case 'thu':
        return DateTime.thursday;
      case 'fri':
        return DateTime.friday;
      case 'sat':
        return DateTime.saturday;
      case 'sun':
        return DateTime.sunday;
      default:
        throw Exception('Invalid day of the week');
    }
  }

  Future<MedicationTrackerApiResponse> getMedications() async {
    var prefs = await SharedPreferences.getInstance();
    var response = await _apiService.getGetResponse(
            '${ApiConstants.baseUrl}/api/patient/medicineTracker')
        as Map<String, dynamic>;
    List listOfMedications = response['data'];

    String? jsonData = prefs.getString("getMedicationListJson");

    List jsonMedication = jsonDecode(jsonData ?? "[]");
    var jsonMedicationIds =
        jsonMedication.map((e) => e["_id"]).toSet().toList();

    List newMedications = [];

    for (var element in listOfMedications) {
      log("Medication ID: " + element["_id"]);
      if (!jsonMedicationIds.contains(element["_id"])) {
        jsonMedication.add(element);

        newMedications.add(element);
      }
    }

    log("Json Medications: " + jsonMedication.toString());

    for (var element in newMedications) {
      log("Medication Scheduled for: " +
          element['day'] +
          " " +
          element['time'] +
          " Title: ${element['title']}");
      scheduleAppointmentNotification(
        id: element['_id'],
        title: element['title'],
        body: 'It is time to take your medication.',
        day: element['day'],
        time: element['time'],
      );
    }

    // // Schedule notifications for each appointment
    // for (var appointment in jsonMedication) {
    //   await scheduleAppointmentNotification(
    //     id: appointment['_id'],
    //     title: appointment['title'],
    //     body: 'Your appointment is scheduled for ${appointment['time']} on ${appointment['day']}.',
    //     day: appointment['day'],
    //     time: appointment['time'],
    //   );
    // }

    // try {
    final apiResponse = MedicationTrackerApiResponse.fromMap(
      response,
    );

    prefs.setString(
      "getMedicationListJson",
      jsonEncode(jsonMedication),
    );
    return apiResponse;
    // } catch (err) {
    //   return MedicationTrackerApiResponse(
    //     status: 'error',
    //     message: 'An error occurred',
    //   );
    // }
  }

  Future<GetPatientListApiResponse> getMyPatientList() async {
    try {
      final apiResponse = GetPatientListApiResponse.fromMap(
        await _apiService.getGetResponse(
                '${ApiConstants.baseUrl}/api/patient/myPatients')
            as Map<String, dynamic>,
      );
      return apiResponse;
    } catch (err) {
      return GetPatientListApiResponse(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<GetPatientListApiResponse> saveMyPatient({
    required Map<String, dynamic> params,
  }) async {
    try {
      final apiResponse = GetPatientListApiResponse.fromMap(
        await _apiService.getPostResponse(
          '${ApiConstants.baseUrl}/api/patient/myPatients',
          params,
        ) as Map<String, dynamic>,
      );
      return apiResponse;
    } catch (err) {
      return GetPatientListApiResponse(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<SaveAppointmentApiResponse> saveAppointments(
      Map<String, dynamic> params) async {
    // try {
    final apiRes = SaveAppointmentApiResponse.fromMap(
      await _apiService.getPostResponse(
        '${ApiConstants.baseUrl}/api/patient/appointment/init',
        params,
      ) as Map<String, dynamic>,
    );
    return apiRes;
    // } catch (err) {
    //   return SaveAppointmentApiResponse(
    //     status: 'error',
    //     message: 'An error occurred',
    //   );
    // }
  }

  Future<InitPaymentApiResponseModel> inititatePayment(
      Map<String, dynamic> params) async {
    try {
      final apiRes = InitPaymentApiResponseModel.fromJson(
        await _apiService.getPostResponse(
          '${ApiConstants.baseUrl}/api/patient/appointment/initiatePayment',
          params,
        ) as Map<String, dynamic>,
      );
      return apiRes;
    } catch (err) {
      return InitPaymentApiResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<VerifyOtpApiResponse> verifyOtp({
    required String traceId,
    required String otpCode,
    required bool isForChangePhoneNumber,
  }) async {
    try {
      final verifyOtpModel = VerifyOtpModel(
        traceId: traceId,
        code: otpCode,
      );

      log("Verify OTP Model:${verifyOtpModel.toMap()}");

      final verifyOtpApiResponse = VerifyOtpApiResponse.fromMap(
        await _apiService.getPostResponse(
          isForChangePhoneNumber
              ? '${ApiConstants.baseUrl}/api/patient/changePhone/verify'
              : '${ApiConstants.baseUrl}/api/patient/auth/verifyAuth',
          verifyOtpModel.toMap(),
        ) as Map<String, dynamic>,
      );
      return verifyOtpApiResponse;
    } catch (err) {
      return VerifyOtpApiResponse(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<void> resendOtp({
    required String traceId,
  }) async {
    try {
      await _apiService
          .getPostResponse('${ApiConstants.baseUrl}/api/common/resendOtp', {
        "traceId": traceId,
      });
    } catch (err) {
      return;
    }
    return;
  }

  Future<LoginApiResponseModel> changePhoneNumber({
    required Map<String, dynamic> params,
  }) async {
    try {
      final apiRes = LoginApiResponseModel.fromMap(
        await _apiService.getPostResponse(
          '${ApiConstants.baseUrl}/api/patient/changePhone/request',
          params,
        ) as Map<String, dynamic>,
      );
      return apiRes;
    } catch (err) {
      return LoginApiResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<PromoResponseModel> getPromos() async {
    try {
      final promoApiResponse = PromoResponseModel.fromJson(
        await _apiService.getGetResponse(ApiConstants.patientPromos)
            as Map<String, dynamic>,
      );
      return promoApiResponse;
    } catch (err) {
      return PromoResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<BannerResponseModel> getHomeBanners() async {
    try {
      final promoApiResponse = BannerResponseModel.fromJson(
        await _apiService.getGetResponse(ApiConstants.homeBanners)
            as Map<String, dynamic>,
      );
      return promoApiResponse;
    } catch (err) {
      return BannerResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<ApplyPromo> applyPromoCode(Map<String, String> parameters) async {
    try {
      ApplyPromo applyPromo = ApplyPromo.fromJson(
        await _apiService.getPostResponse(
            ApiConstants.applyPromoCode, parameters) as Map<String, dynamic>,
      );
      return applyPromo;
    } catch (err) {
      return ApplyPromo(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<DoctorListResponseModel> getFavoritesDoctor() async {
    try {
      final promoApiResponse = DoctorListResponseModel.fromJson(
        await _apiService.getGetResponse(ApiConstants.patientDoctorFavorites)
            as Map<String, dynamic>,
      );
      return promoApiResponse;
    } catch (err) {
      return DoctorListResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<GetAppointmentApiResponse> getAppointments(
    String type,
    String? patientId,
  ) async {
    // try {
    final apiRes = GetAppointmentApiResponse.fromJson(
      await _apiService.getGetResponse(
              '${ApiConstants.baseUrl}/api/patient/appointment/list?type=${type}&patient=${patientId ?? ""}&limit=500')
          as Map<String, dynamic>,
    );
    return apiRes;
    // } catch (err) {
    //   return GetAppointmentApiResponse(
    //     status: 'error',
    //     message: 'An error occurred',
    //   );
    // }
  }

  Future<CommonResponseModel> removeDoctorFromFavoritesDoctorList(
      String doctorId) async {
    try {
      final commonApiResponseModel = CommonResponseModel.fromJson(
        await _apiService.getDeleteResponse(
                ApiConstants.patientDoctorRemoveToFavorite + doctorId)
            as Map<String, dynamic>,
      );
      return commonApiResponseModel;
    } catch (err) {
      return CommonResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<CommonResponseModel> addDoctorToFavoritesDoctorList(
      String doctorId) async {
    try {
      final commonApiResponseModel = CommonResponseModel.fromJson(
        await _apiService.getPostResponse(
                ApiConstants.patientDoctorAddToFavorite + doctorId, {})
            as Map<String, dynamic>,
      );
      return commonApiResponseModel;
    } catch (err) {
      return CommonResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<DoctorListResponseModel> getPatientDoctor(
      Map<String, String> parameters) async {
    // try {
    print("Parameters: $parameters");
    final promoApiResponse = DoctorListResponseModel.fromJson(
      await _apiService.getGetQueryParametersResponse(
          ApiConstants.patientDoctor, parameters) as Map<String, dynamic>,
    );
    return promoApiResponse;
    // } catch (err) {
    //   return DoctorListResponseModel(
    //     status: 'error',
    //     message: 'An error occurred',
    //   );
    // }
  }

  Future<SpecialtiesResponseModel> getSpecialtiesList() async {
    try {
      final promoApiResponse = SpecialtiesResponseModel.fromJson(
        await _apiService.getGetResponse(ApiConstants.specialtiesList)
            as Map<String, dynamic>,
      );
      return promoApiResponse;
    } catch (err) {
      return SpecialtiesResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<PrescriptionListResponseModel> getPrescriptionList(
      Map<String, String> parameters) async {
    try {
      final apiResponse = PrescriptionListResponseModel.fromJson(
        await _apiService.getGetQueryParametersResponse(
                ApiConstants.patientPrescription, parameters)
            as Map<String, dynamic>,
      );
      return apiResponse;
    } catch (err) {
      return PrescriptionListResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<CommonResponseModel> deletePrescriptionFromList(
      String prescriptionId) async {
    try {
      final apiResponse = CommonResponseModel.fromJson(
        await _apiService.getDeleteResponse(
                ApiConstants.deletePatientPrescription + prescriptionId)
            as Map<String, dynamic>,
      );
      return apiResponse;
    } catch (err) {
      return CommonResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<CommonResponseModel> uploadPatientPrescription(var parameters) async {
    try {
      final commonApiResponseModel = CommonResponseModel.fromJson(
        await _apiService.getPostResponse(
                ApiConstants.patientPrescriptionUpload, parameters)
            as Map<String, dynamic>,
      );
      return commonApiResponseModel;
    } catch (err) {
      return CommonResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<CommonResponseModel> uploadPatientClinicalResult(
      var parameters) async {
    try {
      final commonApiResponseModel = CommonResponseModel.fromJson(
        await _apiService.getPostResponse(
                ApiConstants.patientClinicalResultUpload, parameters)
            as Map<String, dynamic>,
      );
      return commonApiResponseModel;
    } catch (err) {
      return CommonResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<CommonResponseModel> updateClinicalPrescription(var parameters) async {
    try {
      final commonApiResponseModel = CommonResponseModel.fromJson(
        await _apiService.getPatchResponse(
                ApiConstants.updateClinicalPrescription, parameters)
            as Map<String, dynamic>,
      );
      return commonApiResponseModel;
    } catch (err) {
      return CommonResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<CommonResponseModel> updatePatientPrescriptionUpdate(
      var parameters) async {
    try {
      final commonApiResponseModel = CommonResponseModel.fromJson(
        await _apiService.getPatchResponse(
                ApiConstants.updatePatientPrescriptionUpdate, parameters)
            as Map<String, dynamic>,
      );
      return commonApiResponseModel;
    } catch (err) {
      return CommonResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<ProfileResponseModel> getProfileData() async {
    try {
      final apiResponse = ProfileResponseModel.fromJson(
        await _apiService.getGetResponse(ApiConstants.profileMe)
            as Map<String, dynamic>,
      );
      return apiResponse;
    } catch (err) {
      return ProfileResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<ProfileResponseModel> updateProfileData(
      Map<String, dynamic> parameters) async {
    try {
      final apiResponse = ProfileResponseModel.fromJson(
        await _apiService.getPatchResponse(
            ApiConstants.profileUpdate, parameters) as Map<String, dynamic>,
      );
      return apiResponse;
    } catch (err) {
      return ProfileResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<ProfileResponseModel> uploadProfileImageInBase64(
      String imageAsBase64) async {
    try {
      final apiResponse = ProfileResponseModel.fromJson(
        await _apiService.getPostResponse(
          '${ApiConstants.baseUrl}/api/patient/profile/uploadProfilePhoto',
          {
            "base64String": imageAsBase64,
            "fileExtension": "jpg",
          },
        ) as Map<String, dynamic>,
      );
      return apiResponse;
    } catch (err) {
      return ProfileResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<TestResultResponseModel> getClinicalTestResultData() async {
    try {
      final apiResponse = TestResultResponseModel.fromJson(
        await _apiService.getGetResponse(ApiConstants.clinicalTestResult)
            as Map<String, dynamic>,
      );
      return apiResponse;
    } catch (err) {
      return TestResultResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<AppTestResultResponseModel> getAppTestResultData() async {
    // try {
    final apiResponse = AppTestResultResponseModel.fromJson(
      await _apiService.getGetResponse(ApiConstants.appTestResult)
          as Map<String, dynamic>,
    );
    return apiResponse;
    // } catch (err) {
    //   return AppTestResultResponseModel(
    //     status: 'error',
    //     message: 'An error occurred',
    //   );
    // }
  }

  Future<CommonResponseModel> deleteTestResult({
    required String resultId,
  }) async {
    try {
      final apiRespnse = CommonResponseModel.fromJson(
        await _apiService.getDeleteResponse(
          '${ApiConstants.deleteTestResult}/${resultId}',
        ) as Map<String, dynamic>,
      );
      return apiRespnse;
    } catch (err) {
      return CommonResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<SendMessageResponseModel> messageSend(
      {required Map<String, dynamic> parameters}) async {
    try {
      final commonResponseModel = SendMessageResponseModel.fromJson(
        await _apiService.getPostResponse(
            '${ApiConstants.baseUrl}/api/patient/support/submit',
            // DIO.FormData.fromMap(
            //   loginModel.toMap(),
            // ),
            parameters) as Map<String, dynamic>,
      );
      return commonResponseModel;
    } catch (err) {
      return SendMessageResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<LiveSupportList> fetchLiveSupportList(
      {required Map<String, dynamic> parameters}) async {
    try {
      final liveSupportList = LiveSupportList.fromJson(
        await _apiService.getGetQueryParametersResponse(
                '${ApiConstants.baseUrl}/api/patient/support/list', parameters)
            as Map<String, dynamic>,
      );
      return liveSupportList;
    } catch (err) {
      return LiveSupportList(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<LiveChatModel> messagesListBySupportId(
      {required String supportId}) async {
    try {
      final liveChatModel = LiveChatModel.fromJson(
        await _apiService.getGetResponse(
                '${ApiConstants.baseUrl}/api/patient/support/messages/$supportId')
            as Map<String, dynamic>,
      );
      return liveChatModel;
    } catch (err) {
      return LiveChatModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<void> markAppointmentCallAsDropped(
    String id,
  ) async {
    try {
      await _apiService.getPatchResponse(
        ApiConstants.markAppointmentCallAsDropped + "/${id}",
        {},
      );
      return;
    } catch (err) {
      return;
    }
  }

  Future<GetDoctorRatingModel> getDoctorRating(
    String id,
  ) async {
    try {
      final promoApiResponse = GetDoctorRatingModel().fromJson(
        await _apiService.getGetResponse(
          ApiConstants.getDoctorRating + id,
        ) as Map<String, dynamic>,
      );
      return promoApiResponse;
    } catch (err) {
      return GetDoctorRatingModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<Doctor?> getDoctorByPhoneNumber(
    String phoneNumber,
  ) async {
    try {
      Map<String, dynamic> data = await _apiService.getGetResponse(
        ApiConstants.getDoctorByPhoneNumber + phoneNumber,
      );
      if (data["status"] == "success") {
        return Doctor.fromJson(
          data["data"],
        );
      }
      return null;
    } catch (err) {
      return null;
    }
  }

  Future<Doctor?> getDoctorById(
    String id,
  ) async {
    try {
      Map<String, dynamic> data = await _apiService.getGetResponse(
        ApiConstants.getDoctorById + id,
      );
      if (data["status"] == "success") {
        return Doctor.fromJson(
          data["data"],
        );
      }
      return null;
    } catch (err) {
      return null;
    }
  }

  Future<void> updateVisualAcuityTestResults(
    BuildContext context,
    String patientId,
    String leftEyeScore,
    String rightEyeScore,
  ) async {
    AppTestResultResponseModel? appTestResult =
        context.read<TestResultCubit>().state.appTestResult;

    try {
      await _apiService.getPostResponse(
        ApiConstants.updateVisualAcuityTestResults,
        {
          "patient": patientId,
          "data": {
            "visualAcuity": {
              "left": {
                "os": leftEyeScore,
                "od": leftEyeScore,
              },
              "right": {
                "os": rightEyeScore,
                "od": rightEyeScore,
              }
            },
            "colorVision": {
              "left":
                  "${appTestResult!.appTestData!.colorVision != null ? "${appTestResult.appTestData!.colorVision!.left}" : "--"}",
              "right":
                  "${appTestResult.appTestData!.colorVision != null ? "${appTestResult.appTestData!.colorVision!.right}" : "--"}"
            },
            "nearVision": {
              "left": {
                "os":
                    "${appTestResult.appTestData!.nearVision != null ? "${appTestResult.appTestData!.nearVision!.left!.os}" : "--"}"
              },
              "right": {
                "od":
                    "${appTestResult.appTestData!.nearVision != null ? "${appTestResult.appTestData!.nearVision!.right!.od}" : "--"}"
              }
            },
            "amdVision": {
              "left":
                  "${appTestResult.appTestData!.amdVision != null ? "${appTestResult.appTestData!.amdVision!.left}" : "--"}",
              "right":
                  "${appTestResult.appTestData!.amdVision != null ? "${appTestResult.appTestData!.amdVision!.right}" : "--"}"
            },
          }
        },
      );
      return null;
    } catch (err) {
      return null;
    }
  }

  Future<void> updateAppEyeTestResults(String patientId,
      {required Map<String, dynamic> parameters}) async {
    try {
      await _apiService.getPostResponse(
          ApiConstants.updateVisualAcuityTestResults, parameters);
      return null;
    } catch (err) {
      return null;
    }
  }

  Future<NotificationResponseModel> getNotificationList(
      Map<String, String> parameters) async {
    try {
      final apiResponse = NotificationResponseModel.fromJson(
        await _apiService.getGetResponse(ApiConstants.notificationList)
            as Map<String, dynamic>,
      );
      return apiResponse;
    } catch (err) {
      return NotificationResponseModel(
        status: 'error',
        message: 'An error occurred',
      );
    }
  }

  Future<void> submitRating({required Map<String, dynamic> parameters}) async {
    try {
      await _apiService.getPostResponse(ApiConstants.submitRating, parameters);
      return null;
    } catch (err) {
      return null;
    }
  }
}
