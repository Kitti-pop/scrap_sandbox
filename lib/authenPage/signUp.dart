import 'package:flutter/material.dart';
import 'package:scrap_sandbox/authenPage/PhoneSumbit.dart';
import 'package:scrap_sandbox/functions/authen.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _key = GlobalKey<FormState>();
  var auth = AuthFunc();
  String pName, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(hintText: 'Pen Name'),
                onSaved: (val) {
                  pName = val;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Password'),
                onSaved: (val) {
                  password = val;
                },
              ),
              RaisedButton(
                  child: Text('Sign Up'),
                  onPressed: () async {
                    _key.currentState.save();
                    if (!await checkAlreadyuse()) signUp();
                  })
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> checkAlreadyuse() async {
    bool usedName = await auth.hasAccount('penName', pName);
    if (usedName) auth.warn('ชื่อซ้ำ', context);
    return usedName;
  }

  signUp() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PhoneSumbit()));
  }
}
