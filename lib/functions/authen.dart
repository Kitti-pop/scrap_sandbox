import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrap_sandbox/authenPage/OTPScreen.dart';

class AuthFunc {
  var fs = Firestore.instance;
  var fa = FirebaseAuth.instance;

  Future<bool> hasAccount(String key, dynamic value) async {
    var doc = await fs
        .collection('Account')
        .where(key, isEqualTo: value)
        .limit(1)
        .getDocuments();
    return doc.documents.length > 0;
  }

  warn(String warning, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(warning),
                  RaisedButton(
                      child: Text('ok'),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          );
        });
  }

  Future<void> phoneVerified(String phone, BuildContext context,
      {bool login = false}) async {
    String verifiedid;
    final PhoneCodeAutoRetrievalTimeout autoRetrieval = (String id) {
      print(id);
    };
    final PhoneCodeSent smsCode = (String id, [int resendCode]) {
      verifiedid = id;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  OTPScreen(phone: phone, verifiedID: id, login: login)));
    };
    final PhoneVerificationCompleted success = (AuthCredential credent) async {
      verifiedid != null ? print('use OTP') : print('succese');
    };
    PhoneVerificationFailed failed = (AuthException error) {
      print('error');
    };
    await fa
        .verifyPhoneNumber(
            phoneNumber: '+66' + phone,
            timeout: Duration(seconds: 120),
            verificationCompleted: success,
            verificationFailed: failed,
            codeSent: smsCode,
            codeAutoRetrievalTimeout: autoRetrieval)
        .catchError((e) {
      print('e');
    });
  }

  Future<String> signUpWithPhone(BuildContext context,
      {@required String verificationId,
      @required String smsCode,
      @required String phone,
      @required String region,
      @required String password,
      @required String pName}) async {
    String uid;
    var phoneCredent = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);
    var emailCredent = EmailAuthProvider.getCredential(
        email: phone + '@gmail.com', password: password);
    await fa.signInWithCredential(phoneCredent).then((authResult) async {
      uid = authResult.user?.uid ?? null;
      authResult.user.linkWithCredential(emailCredent);
      await fs.collection('Account').document(uid).setData({
        'email': phone + '@gmail.com',
        'password': password,
        'pName': pName,
        'region': region,
        'phone': phone
      });
      print('link fin');
    }).catchError((e) {
      switch (e.code) {
        case 'ERROR_NETWORK_REQUEST_FAILED':
          warn('ตรวจสอบการเชื่อมต่อ', context);
          break;
        case 'ERROR_INVALID_VERIFICATION_CODE':
          warn('เช็คใหม่', context);
          break;
        default:
          warn('OTPอาจหมดอายุ', context);
          break;
      }
    });
    return uid;
  }

  signInWithPhone(BuildContext context,
      {@required String verificationId, @required String smsCode}) {
    var credent = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);
    fa.signInWithCredential(credent).then((value) {}).catchError((e) {
      switch (e.code) {
        case 'ERROR_NETWORK_REQUEST_FAILED':
          warn('ตรวจสอบการเชื่อมต่อ', context);
          break;
        case 'ERROR_INVALID_VERIFICATION_CODE':
          warn('เช็คใหม่', context);
          break;
        default:
          warn('OTPอาจหมดอายุ', context);
          break;
      }
    });
  }

  signInWithPenName({@required String phone, @required String password}) {
    fa.signInWithEmailAndPassword(
        email: phone + '@gmail.com', password: password);
  }

  signOut() async {
    await fa.signOut();
  }
}
