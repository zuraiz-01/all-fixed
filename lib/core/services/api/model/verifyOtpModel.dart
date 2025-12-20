import 'dart:convert';

import '../../utils/keys/token_keys.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class VerifyOtpModel {
  String traceId;
  String code;
  VerifyOtpModel({required this.traceId, required this.code});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'traceId': traceId,
      'code': code,
      "deviceToken": pushNotificationTokenKey,
    };
    print("VerifyOtpModel.toMap: deviceToken = $pushNotificationTokenKey");
    return map;
  }

  factory VerifyOtpModel.fromMap(Map<String, dynamic> map) {
    return VerifyOtpModel(
      traceId: map['traceId'] as String,
      code: map['code'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory VerifyOtpModel.fromJson(String source) =>
      VerifyOtpModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'VerifyOtpModel(traceId: $traceId, code: $code)';
}

class VerifyOtpApiResponseData {
  String? token;
  bool? isNewUser;
  VerifyOtpApiResponseData({this.token, this.isNewUser});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'token': token};
  }

  factory VerifyOtpApiResponseData.fromMap(Map<String, dynamic> map) {
    return VerifyOtpApiResponseData(
      token: map['token'] != null ? map['token'] as String : null,
      isNewUser: map['patient']["name"] == null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VerifyOtpApiResponseData.fromJson(String source) =>
      VerifyOtpApiResponseData.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() => 'VerifyOtpApiResponseData(token: $token)';
}

class VerifyOtpApiResponse {
  String? status;
  VerifyOtpApiResponseData? data;
  String? message;
  VerifyOtpApiResponse({this.status, this.message, this.data});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'status': status, 'message': message};
  }

  factory VerifyOtpApiResponse.fromMap(Map<String, dynamic> map) {
    return VerifyOtpApiResponse(
      status: map['status'] != null ? map['status'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      data: map['data'] != null && map['data'] is Map<String, dynamic>
          ? VerifyOtpApiResponseData.fromMap(
              map['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VerifyOtpApiResponse.fromJson(String source) =>
      VerifyOtpApiResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
