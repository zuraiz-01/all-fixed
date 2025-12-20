class PrescriptionListResponseModel {
  PrescriptionListResponseModel({
    this.status,
    this.message,
    this.prescriptionListData,
  });

  String? status;
  String? message;
  PrescriptionListData? prescriptionListData;

  factory PrescriptionListResponseModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionListResponseModel(
      status: json['status'],
      message: json['message'],
      prescriptionListData: json['data'] != null
          ? PrescriptionListData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        if (prescriptionListData != null)
          'data': prescriptionListData!.toJson(),
      };
}

class PrescriptionListData {
  PrescriptionListData({
    this.prescriptionList,
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

  List<Prescription>? prescriptionList;
  int? totalDocs;
  int? limit;
  int? page;
  int? totalPages;
  int? pagingCounter;
  bool? hasPrevPage;
  bool? hasNextPage;
  String? prevPage;
  String? nextPage;

  factory PrescriptionListData.fromJson(Map<String, dynamic> json) {
    return PrescriptionListData(
      prescriptionList: (json['docs'] as List<dynamic>?)
          ?.map((e) => Prescription.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalDocs: json['totalDocs'] as int?,
      limit: json['limit'] as int?,
      page: json['page'] as int?,
      totalPages: json['totalPages'] as int?,
      pagingCounter: json['pagingCounter'] as int?,
      hasPrevPage: json['hasPrevPage'] as bool?,
      hasNextPage: json['hasNextPage'] as bool?,
      prevPage:
          json['prevPage'] != null ? "${json['prevPage']}" : null,
      nextPage:
          json['nextPage'] != null ? "${json['nextPage']}" : null,
    );
  }

  Map<String, dynamic> toJson() => {
        if (prescriptionList != null)
          'docs': prescriptionList!.map((e) => e.toJson()).toList(),
        'totalDocs': totalDocs,
        'limit': limit,
        'page': page,
        'totalPages': totalPages,
        'pagingCounter': pagingCounter,
        'hasPrevPage': hasPrevPage,
        'hasNextPage': hasNextPage,
        'prevPage': prevPage,
        'nextPage': nextPage,
      };
}

class Prescription {
  Prescription({
    this.sId,
    this.title,
    this.patientDetails,
    this.file,
    this.createdAt,
  });

  String? sId;
  String? title;
  PatientDetails? patientDetails;
  String? file;
  String? createdAt;

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      sId: json['_id'] as String?,
      title: json['title'] != null ? "${json['title']}" : "No data",
      patientDetails: json['patient'] != null
          ? PatientDetails.fromJson(json['patient'] as Map<String, dynamic>)
          : null,
      file: json['file'] ?? "",
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'title': title,
        if (patientDetails != null) 'patient': patientDetails!.toJson(),
        'file': file,
        'createdAt': createdAt,
      };
}

class PatientDetails {
  PatientDetails({this.sId, this.phone, this.name, this.photo});

  String? sId;
  String? phone;
  String? name;
  String? photo;

  factory PatientDetails.fromJson(Map<String, dynamic> json) {
    return PatientDetails(
      sId: json['_id'] as String?,
      phone: json['phone'] as String?,
      name: json['name'] as String?,
      photo: json['photo'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'phone': phone,
        'name': name,
        'photo': photo,
      };
}

