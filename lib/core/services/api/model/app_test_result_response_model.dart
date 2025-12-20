import 'dart:convert';

AppTestResultResponseModel appTestResultResponseModelFromJson(String str) =>
    AppTestResultResponseModel.fromJson(json.decode(str));

String appTestResultResponseModelToJson(AppTestResultResponseModel data) =>
    json.encode(data.toJson());

class AppTestResultResponseModel {
  String? status;
  String? message;
  AppTestData? appTestData;

  AppTestResultResponseModel({this.status, this.message, this.appTestData});

  factory AppTestResultResponseModel.fromJson(Map<String, dynamic> json) =>
      AppTestResultResponseModel(
        status: json['status']?.toString(),
        message: json['message']?.toString(),
        appTestData: json['data'] is Map<String, dynamic>
            ? AppTestData.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': appTestData?.toJson(),
  };
}

class AppTestData {
  NearVision? visualAcuity;
  NearVision? nearVision;
  Vision? colorVision;
  Vision? amdVision;

  AppTestData({
    this.visualAcuity,
    this.nearVision,
    this.colorVision,
    this.amdVision,
  });

  factory AppTestData.fromJson(Map<String, dynamic> json) => AppTestData(
    visualAcuity:
        json.containsKey('visualAcuity') &&
            json['visualAcuity'] is Map<String, dynamic>
        ? NearVision.fromJson(json['visualAcuity'] as Map<String, dynamic>)
        : null,
    nearVision:
        json.containsKey('nearVision') &&
            json['nearVision'] is Map<String, dynamic>
        ? NearVision.fromJson(json['nearVision'] as Map<String, dynamic>)
        : null,
    colorVision:
        json.containsKey('colorVision') &&
            json['colorVision'] is Map<String, dynamic>
        ? Vision.fromJson(json['colorVision'] as Map<String, dynamic>)
        : null,
    amdVision:
        json.containsKey('amdVision') &&
            json['amdVision'] is Map<String, dynamic>
        ? Vision.fromJson(json['amdVision'] as Map<String, dynamic>)
        : null,
  );

  Map<String, dynamic> toJson() => {
    'visualAcuity': visualAcuity?.toJson(),
    'nearVision': nearVision?.toJson(),
    'colorVision': colorVision?.toJson(),
    'amdVision': amdVision?.toJson(),
  };
}

class Vision {
  String? left;
  String? right;

  Vision({this.left, this.right});

  factory Vision.fromJson(Map<String, dynamic> json) =>
      Vision(left: json['left']?.toString(), right: json['right']?.toString());

  Map<String, dynamic> toJson() => {'left': left, 'right': right};
}

class NearVision {
  EyeSide? left;
  EyeSide? right;

  NearVision({this.left, this.right});

  factory NearVision.fromJson(Map<String, dynamic> json) => NearVision(
    left: json['left'] is Map<String, dynamic>
        ? EyeSide.fromJson(json['left'] as Map<String, dynamic>)
        : null,
    right: json['right'] is Map<String, dynamic>
        ? EyeSide.fromJson(json['right'] as Map<String, dynamic>)
        : null,
  );

  Map<String, dynamic> toJson() => {
    'left': left?.toJson(),
    'right': right?.toJson(),
  };
}

class EyeSide {
  String? os;
  String? od;

  EyeSide({this.os, this.od});

  factory EyeSide.fromJson(Map<String, dynamic> json) =>
      EyeSide(os: json['os']?.toString(), od: json['od']?.toString());

  Map<String, dynamic> toJson() => {'os': os, 'od': od};
}
