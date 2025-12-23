class SendMessageResponseModel {
  String? status;
  String? message;
  String? supportId;

  SendMessageResponseModel({this.status, this.message});

  SendMessageResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    supportId = json['supportId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['supportId'] = this.supportId;
    return data;
  }
}
