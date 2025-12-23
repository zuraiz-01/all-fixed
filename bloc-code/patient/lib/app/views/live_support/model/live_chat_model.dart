import 'dart:convert';

LiveChatModel liveChatModelFromJson(String str) => LiveChatModel.fromJson(json.decode(str));

String liveChatModelToJson(LiveChatModel data) => json.encode(data.toJson());

class LiveChatModel {
  String? status;
  String? message;
  Data? data;

  LiveChatModel({
    this.status,
    this.message,
    this.data,
  });

  factory LiveChatModel.fromJson(Map<String, dynamic> json) => LiveChatModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  List<LiveChat>? docs;
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
        docs: json["docs"] == null ? [] : List<LiveChat>.from(json["docs"]!.map((x) => LiveChat.fromJson(x))),
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

class LiveChat {
  String? id;
  String? support;
  String? senderType;
  String? contentType;
  String? content;
  String? createdAt;
  String? updatedAt;

  LiveChat({
    this.id,
    this.support,
    this.senderType,
    this.contentType,
    this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory LiveChat.fromJson(Map<String, dynamic> json) => LiveChat(
        id: json["_id"],
        support: json["support"],
        senderType: json["senderType"],
        contentType: json["contentType"],
        content: json["content"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "support": support,
        "senderType": senderType,
        "contentType": contentType,
        "content": content,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
