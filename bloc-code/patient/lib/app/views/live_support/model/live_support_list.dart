// To parse this JSON data, do
//
//     final liveSupportList = liveSupportListFromJson(jsonString);

import 'dart:convert';

LiveSupportList liveSupportListFromJson(String str) => LiveSupportList.fromJson(json.decode(str));

String liveSupportListToJson(LiveSupportList data) => json.encode(data.toJson());

class LiveSupportList {
  String? status;
  String? message;
  Data? data;

  LiveSupportList({
    this.status,
    this.message,
    this.data,
  });

  factory LiveSupportList.fromJson(Map<String, dynamic> json) => LiveSupportList(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  List<LiveSupport>? docs;
  int? totalDocs;
  int? limit;
  int? page;
  int? totalPages;
  int? pagingCounter;
  bool? hasPrevPage;
  bool? hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  Data({
    this.docs,
    this.totalDocs,
    this.limit,
    this.page,
    this.totalPages,
    this.pagingCounter,
    this.hasPrevPage,
    this.hasNextPage,
    this.prevPage,
    this.nextPage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        docs: List<LiveSupport>.from(json["docs"].map((x) => LiveSupport.fromJson(x))),
        totalDocs: json["totalDocs"],
        limit: json["limit"],
        page: json["page"],
        totalPages: json["totalPages"],
        pagingCounter: json["pagingCounter"],
        hasPrevPage: json["hasPrevPage"],
        hasNextPage: json["hasNextPage"],
        prevPage: json["prevPage"],
        nextPage: json["nextPage"],
      );

  Map<String, dynamic> toJson() => {
        "docs": List<dynamic>.from(docs!.map((x) => x.toJson())),
        "totalDocs": totalDocs,
        "limit": limit,
        "page": page,
        "totalPages": totalPages,
        "pagingCounter": pagingCounter,
        "hasPrevPage": hasPrevPage,
        "hasNextPage": hasNextPage,
        "prevPage": prevPage,
        "nextPage": nextPage,
      };
}

class LiveSupport {
  String? id;
  String? user;
  String? subject;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? admin;

  LiveSupport({
    this.id,
    this.user,
    this.subject,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.admin,
  });

  factory LiveSupport.fromJson(Map<String, dynamic> json) => LiveSupport(
        id: json["_id"],
        user: json["user"],
        subject: json["subject"],
        status: json["status"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        admin: json["admin"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "subject": subject,
        "status": status,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "admin": admin,
      };
}
