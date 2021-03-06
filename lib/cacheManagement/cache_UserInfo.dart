import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';

class CacheUserInfo {
  File jsonFile;
  Directory dir;
  String fileName = "userInfo";
  bool fileExists = false;
  Map<String, String > fileContent;

  String uid = getUid();

   getUid() async {
    var uid = await FirebaseAuth.instance.currentUser();
    return uid.uid;
  }

  hasFile() async {
  Directory _directory = await getApplicationDocumentsDirectory();
  jsonFile = File(_directory.path + "/" + fileName);
  fileExists = jsonFile.existsSync();
  return fileExists;
  }

  getUserInfo(){
    fileContent = jsonDecode(jsonFile.readAsStringSync());
    return fileContent;
  }


  newFileUserInfo(){
    Map<String,String> _content;

    Firestore.instance
    .collection("User")
    .document("th")
    .collection("users")
    .document(uid)
    .get()
    .then((value){
      _content = {
        "uid": uid,
        "pName": value['pName'],
        "img": value['img'],
        "birthday": value['birthday'],
        "gender": value['gender']
      };
    });
    
    jsonFile.createSync();
    jsonFile.writeAsStringSync(jsonEncode(_content));
    getUserInfo();
  }

  //first call func---------------------------
  userInfo(){
    bool _hasFile = hasFile();
    if(_hasFile == false)
      newFileUserInfo();
    else
      getUserInfo();
  }
  //------------------------------------------

}