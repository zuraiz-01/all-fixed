class TestResultResponseModel {
  String? status;
  String? message;
  TestResultResponseData? testResultResponseData;

  TestResultResponseModel({this.status, this.message, this.testResultResponseData});

  TestResultResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    testResultResponseData = json['data'] != null ? new TestResultResponseData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.testResultResponseData != null) {
      data['data'] = this.testResultResponseData!.toJson();
    }
    return data;
  }
}

class TestResultResponseData {
  List<TestResult>? docs;
  int? totalDocs;
  int? limit;
  int? page;
  int? totalPages;
  int? pagingCounter;
  bool? hasPrevPage;
  bool? hasNextPage;
  String? prevPage;
  String? nextPage;

  TestResultResponseData(
      {this.docs, this.totalDocs, this.limit, this.page, this.totalPages, this.pagingCounter, this.hasPrevPage, this.hasNextPage, this.prevPage, this.nextPage});

  TestResultResponseData.fromJson(Map<String, dynamic> json) {
    if (json['docs'] != null) {
      docs = <TestResult>[];
      json['docs'].forEach((v) {
        docs!.add(new TestResult.fromJson(v));
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
    if (this.docs != null) {
      data['docs'] = this.docs!.map((v) => v.toJson()).toList();
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

class TestResult {
  String? sId;

  // String? patient;
  String? title;
  String? attachment;

  // String? type;
  String? status;
  String? createdAt;

  // String? updatedAt;

  TestResult({this.sId, this.title, this.attachment, this.status, this.createdAt});

  TestResult.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    // patient = json['patient'];
    if (json.containsKey('title')) {
      title = json['title'] != null ? "${json['title']}" : "No Title Found";
    } else {
      title = '';
    }
    attachment = json['attachment'];
    // type = json['type'] != null ? "${json['type']}" : "";
    status = json['status'];
    createdAt = json['createdAt'];
    // updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    // data['patient'] = this.patient;
    data['title'] = this.title;
    data['attachment'] = this.attachment;
    // data['type'] = this.type;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    // data['updatedAt'] = this.updatedAt;
    return data;
  }
}
