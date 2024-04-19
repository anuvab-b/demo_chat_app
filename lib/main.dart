import 'package:demo_chat_app/application/chat_controller.dart';
import 'package:demo_chat_app/domain/message_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ChatController chatController = Get.put<ChatController>(ChatController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ChatController>(builder: (controller) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: controller.scrollController,
                  itemBuilder: (ctx, index) {
                    MessageModel message = controller.messagesList[index];
                    return Row(
                        mainAxisAlignment:
                            message.sender != controller.selectedUser
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.end,
                        children: [
                          Container(
                              margin: const EdgeInsets.all(10.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                // Set border radius
                                color: message.sender != controller.selectedUser
                                    ? Colors.blueAccent
                                    : Colors
                                        .blueGrey, // Set background color (optional)
                              ),
                              child: Text(
                                message.message,
                                style: const TextStyle(color: Colors.white),
                              ))
                        ]);
                  },
                  itemCount: controller.messagesList.length),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration:
                        const InputDecoration(hintText: "Type a message"),
                    controller: controller.messageController,
                  ),
                ),
                IconButton(onPressed: controller.addMessage, icon: const Icon(Icons.send)),
                IconButton(onPressed: controller.populate, icon: const Icon(Icons.add)),
                IconButton(onPressed: controller.onUserSwitched, icon: const Icon(Icons.swap_calls))
              ],
            ),
          ],
        );
      }),
    );
  }
}
