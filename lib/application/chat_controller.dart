import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
class ChatController extends GetxController{

  void createRecords(){
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child("messages");
  }
}