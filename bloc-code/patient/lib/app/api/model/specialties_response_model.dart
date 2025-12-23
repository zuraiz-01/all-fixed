import 'package:eye_buddy/app/api/model/doctor_list_response_model.dart';

class SpecialtiesResponseModel {
  String? status;
  String? message;
  List<Specialty>? specialtyList;

  SpecialtiesResponseModel({this.status, this.message, this.specialtyList});

  SpecialtiesResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      specialtyList = <Specialty>[];
      json['data'].forEach((v) {
        specialtyList!.add(new Specialty.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.specialtyList != null) {
      data['data'] = this.specialtyList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}