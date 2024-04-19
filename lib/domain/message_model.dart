import 'dart:convert';

MessageModel messageModelFromJson(String str) => MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  String timeStamp;
  String sender;
  String message;

  MessageModel({
    required this.timeStamp,
    required this.sender,
    required this.message,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    timeStamp: json["timeStamp"],
    sender: json["sender"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "timeStamp": timeStamp,
    "sender": sender,
    "message": message,
  };
}