import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap_sandbox/authenPage/PhoneSumbit.dart';
import 'package:scrap_sandbox/functions/authen.dart';
import 'package:scrap_sandbox/provider/authen_prov.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _key = GlobalKey<FormState>();
  var auth = AuthFunc();
  @override
  Widget build(BuildContext context) {
    final authenInfo = Provider.of<AuthenProv>(context);
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
                  authenInfo.pName = val;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Password'),
                onSaved: (val) {
                  authenInfo.password = val;
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
    final authenInfo = Provider.of<AuthenProv>(context, listen: false);
    bool usedName = await auth.hasAccount('pName', authenInfo.pName);
    if (usedName) auth.warn('ชื่อซ้ำ', context);
    return usedName;
  }

  signUp() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PhoneSumbit()));
  }
}
