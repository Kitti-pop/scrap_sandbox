import 'package:flutter/material.dart';
import 'package:scrap_sandbox/functions/authen.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  final String verifiedID;
  final bool login;
  OTPScreen(
      {@required this.phone, @required this.verifiedID, this.login = false});
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  var auth = AuthFunc();
  var _key = GlobalKey<FormState>();
  String otp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Submit your OTP'),
              TextFormField(
                  decoration: InputDecoration(hintText: 'OTP'),
                  onSaved: (val) {
                    otp = val;
                  }),
              RaisedButton(
                  child: Text('verified'),
                  onPressed: () async {
                    _key.currentState.save();
                    widget.login ? await login() : await register();
                  })
            ],
          ),
        ),
      ),
    );
  }

  login() async {
    await auth.signInWithPhone(context,
        verificationId: widget.verifiedID, smsCode: otp);
  }

  register() async {
    String uid = await auth.signUpWithPhone(context,
        verificationId: widget.verifiedID,
        smsCode: otp,
        phone: widget.phone,
        password: '123456',
        pName: 'ou',
        region: 'th');
    if (uid != null) print(uid);
  }
}
