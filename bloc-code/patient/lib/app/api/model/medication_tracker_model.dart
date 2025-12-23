// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MedicationTrackerApiResponse {
  String status;
  String message;
  MedicationTrackerApiResponse({
    required this.status,
    required this.message,
    this.data,
  });
  MedicationTrackerApiResponseData? data;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
    };
  }

  factory MedicationTrackerApiResponse.fromMap(Map<String, dynamic> map) {
    List<Medication> listOfReturnMedications = [];
    List listOfMedications = map['data'];

    List listOfQniqueName = listOfMedications
        .map(
          (e) => e['title'],
        )
        .toList()
        .toSet()
        .toList();

    for (int i = 0; i < listOfQniqueName.length; i++) {
      String forName = listOfQniqueName[i];
      List qniuedNamedMedicationList = listOfMedications.where((element) => element["title"] == forName).toList().toSet().toList();
      List daylist = qniuedNamedMedicationList.map((e) => e["day"].toString()).toList().toSet().toList();
      List timeList = qniuedNamedMedicationList.map((e) => e["time"]).toList().toSet().toList();
      listOfReturnMedications.add(
        Medication(
          id: "",
          patient: qniuedNamedMedicationList.first["patient"],
          title: qniuedNamedMedicationList.first["title"],
          description: qniuedNamedMedicationList.first["description"],
          sat: daylist.contains("sat"),
          sun: daylist.contains("sun"),
          mon: daylist.contains("mon"),
          tue: daylist.contains("tue"),
          wed: daylist.contains("wed"),
          thu: daylist.contains("thu"),
          fri: daylist.contains("fri"),
          status: qniuedNamedMedicationList.first["status"],
          createdAt: qniuedNamedMedicationList.first["createdAt"],
          updatedAt: qniuedNamedMedicationList.first["updatedAt"],
          time: timeList.map((e) => e.toString()).toList(),
        ),
      );
    }
    return MedicationTrackerApiResponse(
      status: map['status'] as String,
      message: map['message'] as String,
      data: MedicationTrackerApiResponseData(
        docs: listOfReturnMedications,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MedicationTrackerApiResponse.fromJson(String source) => MedicationTrackerApiResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class MedicationTrackerApiResponseData {
  List<Medication>? docs;
  int? totalDocs;
  int? limit;
  int? page;
  int? totalPages;
  int? pagingCounter;
  bool? hasPrevPage;
  bool? hasNextPage;
  String? prevPage;
  String? nextPage;
  MedicationTrackerApiResponseData({
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docs': docs?.map((x) => x.toMap()).toList(),
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

  factory MedicationTrackerApiResponseData.fromMap(Map<String, dynamic> map) {
    return MedicationTrackerApiResponseData(
      docs: [],
      totalDocs: map['totalDocs'] != null ? map['totalDocs'] as int : null,
      limit: map['limit'] != null ? map['limit'] as int : null,
      page: map['page'] != null ? map['page'] as int : null,
      totalPages: map['totalPages'] != null ? map['totalPages'] as int : null,
      pagingCounter: map['pagingCounter'] != null ? map['pagingCounter'] as int : null,
      hasPrevPage: map['hasPrevPage'] != null ? map['hasPrevPage'] as bool : null,
      hasNextPage: map['hasNextPage'] != null ? map['hasNextPage'] as bool : null,
      prevPage: map['prevPage'] != null ? map['prevPage'].toString() : null,
      nextPage: map['nextPage'] != null ? map['nextPage'].toString() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MedicationTrackerApiResponseData.fromJson(String source) => MedicationTrackerApiResponseData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MedicationTrackerApiResponseData(docs: $docs, totalDocs: $totalDocs, limit: $limit, page: $page, totalPages: $totalPages, pagingCounter: $pagingCounter, hasPrevPage: $hasPrevPage, hasNextPage: $hasNextPage, prevPage: $prevPage, nextPage: $nextPage)';
  }
}

class Medication {
  String? id;
  String? patient;
  String? title;
  String? description;
  List<String> time;
  bool? sat;
  bool? sun;
  bool? mon;
  bool? tue;
  bool? wed;
  bool? thu;
  bool? fri;
  String? status;
  String? createdAt;
  String? updatedAt;
  Medication({
    this.id,
    this.patient,
    this.title,
    this.description,
    required this.time,
    this.sat,
    this.sun,
    this.mon,
    this.tue,
    this.wed,
    this.thu,
    this.fri,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'patient': patient,
      'title': title,
      'description': description,
      'time': time,
      'sat': sat,
      'sun': sun,
      'mon': mon,
      'tue': tue,
      'wed': wed,
      'thu': thu,
      'fri': fri,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['_id'] != null ? map['_id'] as String : null,
      patient: map['patient'] != null ? map['patient'] as String : null,
      title: map['title'],
      description: map['description'] != null ? map['description'] as String : null,
      sat: map['sat'] != null ? map['sat'] as bool : null,
      sun: map['sun'] != null ? map['sun'] as bool : null,
      mon: map['mon'] != null ? map['mon'] as bool : null,
      tue: map['tue'] != null ? map['tue'] as bool : null,
      wed: map['wed'] != null ? map['wed'] as bool : null,
      thu: map['thu'] != null ? map['thu'] as bool : null,
      fri: map['fri'] != null ? map['fri'] as bool : null,
      status: map['status'] != null ? map['status'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      time: List<String>.from((map['time'])),
    );
  }

  String toJson() => json.encode(toMap());

  factory Medication.fromJson(String source) => Medication.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Medication(id: $id, patient: $patient, title: $title, description: $description, time: $time, sat: $sat, sun: $sun, mon: $mon, tue: $tue, wed: $wed, thu: $thu, fri: $fri, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

class UpdateMedicationApiResponse {
  String status;
  String message;
  UpdateMedicationApiResponse({
    required this.status,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
    };
  }

  factory UpdateMedicationApiResponse.fromMap(Map<String, dynamic> map) {
    return UpdateMedicationApiResponse(
      status: map['status'] as String,
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateMedicationApiResponse.fromJson(String source) => UpdateMedicationApiResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UpdateMedicationApiResponse(status: $status, message: $message)';
}
