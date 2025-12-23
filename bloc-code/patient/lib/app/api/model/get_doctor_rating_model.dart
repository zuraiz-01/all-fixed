// To parse this JSON data, do
//
//     final getDoctorRatingModel = getDoctorRatingModelFromJson(jsonString);

import 'dart:convert';

GetDoctorRatingModel getDoctorRatingModelFromJson(String str) => GetDoctorRatingModel().fromJson(json.decode(str));

String getDoctorRatingModelToJson(GetDoctorRatingModel data) => json.encode(data.toJson());

class GetDoctorRatingModel {
  String? status;
  String? message;
  Data? data;
  List<Statistic>? statistics;
  double? averageRating;
  int? totalRatings;

  GetDoctorRatingModel({
    this.status,
    this.message,
    this.data,
    this.statistics,
    this.averageRating,
  });

  fromJson(Map<String, dynamic> json) {
    GetDoctorRatingModel getDoctorRatingModel = GetDoctorRatingModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
      statistics: json["statistics"] == null ? [] : List<Statistic>.from(json["statistics"]!.map((x) => Statistic.fromJson(x))),
    );
    getDoctorRatingModel.averageRating = 0.0;
    getDoctorRatingModel.totalRatings = 0;
    if (getDoctorRatingModel.statistics != null) {
      for (Statistic stat in getDoctorRatingModel.statistics!) {
        getDoctorRatingModel.averageRating = getDoctorRatingModel.averageRating! + ((stat.average ?? 0) * (stat.count ?? 0));
        getDoctorRatingModel.totalRatings = getDoctorRatingModel.totalRatings! + stat.count!;
      }
      getDoctorRatingModel.averageRating = getDoctorRatingModel.averageRating! / getDoctorRatingModel.statistics!.length;
    }
    return getDoctorRatingModel;
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
        "statistics": statistics == null ? [] : List<dynamic>.from(statistics!.map((x) => x.toJson())),
      };
}

class Data {
  List<Doc>? docs;
  int? totalDocs;
  int? limit;
  int? page;
  int? totalPages;
  int? pagingCounter;
  bool? hasPrevPage;
  bool? hasNextPage;
  bool? prevPage;
  bool? nextPage;

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
        docs: json["docs"] == null ? [] : List<Doc>.from(json["docs"]!.map((x) => Doc.fromJson(x))),
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
        "docs": docs == null ? [] : List<dynamic>.from(docs!.map((x) => x.toJson())),
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

class Doc {
  String? id;
  Patient? patient;
  String? doctor;
  double? rating;
  String? review;
  DateTime? createdAt;

  Doc({
    this.id,
    this.patient,
    this.doctor,
    this.rating,
    this.review,
    this.createdAt,
  });

  factory Doc.fromJson(Map<String, dynamic> json) => Doc(
        id: json["_id"],
        patient: json["patient"] == null ? null : Patient.fromJson(json["patient"]),
        doctor: json["doctor"],
        rating: json["rating"]?.toDouble(),
        review: json["review"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "patient": patient?.toJson(),
        "doctor": doctor,
        "rating": rating,
        "review": review,
        "createdAt": createdAt?.toIso8601String(),
      };
}

class Patient {
  String? id;
  String? name;
  String? photo;

  Patient({
    this.id,
    this.name,
    this.photo,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        id: json["_id"],
        name: json["name"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "photo": photo,
      };
}

class Statistic {
  int? id;
  int? count;
  double? average;

  Statistic({
    this.id,
    this.count,
    this.average,
  });

  factory Statistic.fromJson(Map<String, dynamic> json) => Statistic(
        id: json["_id"],
        count: json["count"],
        average: json["average"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "count": count,
        "average": average,
      };
}
