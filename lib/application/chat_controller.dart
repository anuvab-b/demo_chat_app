import 'package:demo_chat_app/domain/message_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:demo_chat_app/utils.dart';
import 'dart:math';

class ChatController extends GetxController {
  List<MessageModel> messagesList = List.empty(growable: true);
  String selectedUser = "User 1";
  bool selected = false;
  late TextEditingController messageController;
  late final ScrollController scrollController;
  final String _recordKey = "-Nvqvt8eQr-rbBzkWP4E";

  @override
  void onInit() {
    setInitialMessages();
    messageController = TextEditingController();
    scrollController = ScrollController();
    super.onInit();
  }

  void setInitialMessages() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

    fetchMessages();
  }

  void populate() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    generateMessageList();
    await databaseReference
        .child(_recordKey)
        .update({"messages": messagesList.map((e) => e.toJson()).toList()});
  }

  generateMessageList() {
    for (int i = 0; i < 100; i++) {
      Random random = Random();
      int randomUser = random.nextInt(2);
      messagesList.add(MessageModel(
          timeStamp: Utils.formatDate(DateTime.now(),
              outputFormat: "dd/MM/yyyy HH:mm"),
          sender: "User ${randomUser + 1}",
          message: "Hello World $i"));
    }
  }

  fetchMessages() {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

    databaseReference.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot.child(_recordKey);
      if (dataSnapshot.value != null) {
        List messages = (dataSnapshot.value as Map)["messages"] ?? [];
        messagesList = messages
            .map((e) => MessageModel(
                message: e["message"] ?? "",
                sender: e["sender"] ?? "",
                timeStamp: e["timeStamp"] ?? ""))
            .toList();
        if (kDebugMode) {
          print("Fetch ${dataSnapshot.children.length}");
        }
      }
      scrollToBottom();
      update();
    });
  }

  void onUserSwitched() {
    selected = !selected;
    int index = selected ? 1:2;
    selectedUser = "User $index";
    scrollToBottom();
    update();
  }

  void addMessage() {
    messagesList.add(MessageModel(
        timeStamp:
            Utils.formatDate(DateTime.now(), outputFormat: "dd/MM/yyyy HH:mm"),
        sender: selectedUser,
        message: messageController.text));
    messageController.clear();
    updateMessages();
  }

  Future<void> updateMessages() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    await databaseReference
        .child(_recordKey)
        .update({"messages": messagesList.map((e) => e.toJson()).toList()});
    fetchMessages();
    scrollToBottom();
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    update();
  }
}
