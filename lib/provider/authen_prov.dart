
import 'package:flutter/widgets.dart';

class AuthenProv extends ChangeNotifier{
  String _verificationID = "";
  String _smsCode = "";
  String _phone = "";
  String _password = "";
  String _pName = "";
  String _region = "";

  String get verificationID => _verificationID;
  String get smsCode => _smsCode;
  String get phone => _phone;
  String get password => _password;
  String get pName => _pName;
  String get region => _region;

  set verificationID(String val){
    _verificationID = val;
    notifyListeners();
  }

  set smsCode(String val){
    _smsCode = val;
    notifyListeners();
  }

  set phone(String val){
    _phone = val;
    notifyListeners();
  }

  set password(String val){
    _password = val;
    notifyListeners();
  }

  set pName(String val){
    _pName = val;
    notifyListeners();
  }

  set region(String val){
    _region = val;
    notifyListeners();
  }

}