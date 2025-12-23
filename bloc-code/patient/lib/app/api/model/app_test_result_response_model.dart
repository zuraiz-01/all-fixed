// To parse this JSON data, do
//
//     final appTestResultResponseModel = appTestResultResponseModelFromJson(jsonString);

import 'dart:convert';

AppTestResultResponseModel appTestResultResponseModelFromJson(String str) =>
    AppTestResultResponseModel.fromJson(json.decode(str));

String appTestResultResponseModelToJson(AppTestResultResponseModel data) => json.encode(data.toJson());

class AppTestResultResponseModel {
  String? status;
  String? message;
  AppTestData? appTestData;

  AppTestResultResponseModel({
    this.status,
    this.message,
    this.appTestData,
  });

  factory AppTestResultResponseModel.fromJson(Map<String, dynamic> json) => AppTestResultResponseModel(
        status: json["status"],
        message: json["message"],
        appTestData: AppTestData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": appTestData!.toJson(),
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
        visualAcuity: json.containsKey("visualAcuity") ? NearVision.fromJson(json["visualAcuity"]) : null,
        nearVision: json.containsKey("nearVision") ? NearVision.fromJson(json["nearVision"]) : null,
        colorVision: json.containsKey("colorVision") ? Vision.fromJson(json["colorVision"]) : null,
        amdVision: json.containsKey("amdVision") ? Vision.fromJson(json["amdVision"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "visualAcuity": visualAcuity!.toJson(),
        "nearVision": nearVision!.toJson(),
        "colorVision": colorVision!.toJson(),
        "amdVision": amdVision!.toJson(),
      };
}

class Vision {
  String? left;
  String? right;

  Vision({
    this.left,
    this.right,
  });

  factory Vision.fromJson(Map<String, dynamic> json) => Vision(
        left: json["left"],
        right: json["right"],
      );

  Map<String, dynamic> toJson() => {
        "left": left,
        "right": right,
      };
}

class NearVision {
  Left? left;
  Left? right;

  NearVision({
    this.left,
    this.right,
  });

  factory NearVision.fromJson(Map<String, dynamic> json) => NearVision(
        left: Left.fromJson(json["left"]),
        right: Left.fromJson(json["right"]),
      );

  Map<String, dynamic> toJson() => {
        "left": left!.toJson(),
        "right": right!.toJson(),
      };
}

class Left {
  String? os;
  String? od;

  Left({
    this.os,
    this.od,
  });

  factory Left.fromJson(Map<String, dynamic> json) => Left(
        os: json["os"],
        od: json["od"],
      );

  Map<String, dynamic> toJson() => {
        "os": os,
        "od": od,
      };
}
