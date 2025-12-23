class PrescriptionListResponseModel {
  String? status;
  String? message;
  PrescriptionListData? prescriptionListData;

  PrescriptionListResponseModel({this.status, this.message, this.prescriptionListData});

  PrescriptionListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    prescriptionListData = json['data'] != null ? new PrescriptionListData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.prescriptionListData != null) {
      data['data'] = this.prescriptionListData!.toJson();
    }
    return data;
  }
}

class PrescriptionListData {
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

  PrescriptionListData(
      {this.prescriptionList,
      this.totalDocs,
      this.limit,
      this.page,
      this.totalPages,
      this.pagingCounter,
      this.hasPrevPage,
      this.hasNextPage,
      this.prevPage,
      this.nextPage});

  PrescriptionListData.fromJson(Map<String, dynamic> json) {
    if (json['docs'] != null) {
      prescriptionList = <Prescription>[];
      json['docs'].forEach((v) {
        prescriptionList!.add(new Prescription.fromJson(v));
      });
    }
    totalDocs = json['totalDocs'];
    limit = json['limit'];
    page = json['page'];
    totalPages = json['totalPages'];
    pagingCounter = json['pagingCounter'];
    hasPrevPage = json['hasPrevPage'];
    hasNextPage = json['hasNextPage'];
    prevPage = json['prevPage'] != null ? "${json['prevPage']}" : "";
    nextPage = json['nextPage'] != null ? "${json['nextPage']}" : "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.prescriptionList != null) {
      data['docs'] = this.prescriptionList!.map((v) => v.toJson()).toList();
    }
    data['totalDocs'] = this.totalDocs;
    data['limit'] = this.limit;
    data['page'] = this.page;
    data['totalPages'] = this.totalPages;
    data['pagingCounter'] = this.pagingCounter;
    data['hasPrevPage'] = this.hasPrevPage;
    data['hasNextPage'] = this.hasNextPage;
    data['prevPage'] = this.prevPage;
    data['nextPage'] = this.nextPage;
    return data;
  }
}

class Prescription {
  String? sId;
  String? title;
  PatientDetails? patientDetails;
  String? file;
  String? createdAt;

  Prescription({this.sId, this.title, this.patientDetails, this.file, this.createdAt});

  Prescription.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'] != null ? "${json['title']}" : "No data";
    patientDetails = json['patient'] != null ? new PatientDetails.fromJson(json['patient']) : null;
    file = json['file'] ?? "";
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    if (this.patientDetails != null) {
      data['patient'] = this.patientDetails!.toJson();
    }
    data['file'] = this.file;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class PatientDetails {
  String? sId;
  String? phone;
  String? name;
  String? photo;

  PatientDetails({this.sId, this.phone, this.name, this.photo});

  PatientDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    phone = json['phone'];
    name = json['name'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['photo'] = this.photo;
    return data;
  }
}
