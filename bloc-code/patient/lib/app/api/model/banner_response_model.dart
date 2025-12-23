// To parse this JSON data, do
//
//     final bannerResponseModel = bannerResponseModelFromJson(jsonString);

import 'dart:convert';

BannerResponseModel bannerResponseModelFromJson(String str) => BannerResponseModel.fromJson(json.decode(str));

String bannerResponseModelToJson(BannerResponseModel data) => json.encode(data.toJson());

class BannerResponseModel {
  String? status;
  String? message;
  List<Banner>? bannerList;

  BannerResponseModel({
    this.status,
    this.message,
    this.bannerList,
  });

  factory BannerResponseModel.fromJson(Map<String, dynamic> json) => BannerResponseModel(
        status: json["status"],
        message: json["message"],
        bannerList: List<Banner>.from(json["data"].map((x) => Banner.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(bannerList!.map((x) => x.toJson())),
      };
}

class Banner {
  String? id;
  String? title;
  String? description;
  String? file;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? v;

  Banner({
    this.id,
    this.title,
    this.description,
    this.file,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        file: json["file"],
        status: json["status"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "file": file,
        "status": status,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
      };
}
