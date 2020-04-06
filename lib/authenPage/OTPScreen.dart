import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap_sandbox/functions/authen.dart';
import 'package:scrap_sandbox/provider/authen_prov.dart';

class OTPScreen extends StatefulWidget {
  final bool login;
  OTPScreen({this.login = false});
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  var auth = AuthFunc();
  var _key = GlobalKey<FormState>();
  bool loading = false;
  StreamSubscription loadStatus;
  @override
  void initState() {
    loadStatus = auth.load.listen((value) => setState(() => loading = value));
    super.initState();
  }

  @override
  void dispose() {
    loadStatus.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authenInfo = Provider.of<AuthenProv>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Submit your OTP'),
                  TextFormField(
                      decoration: InputDecoration(hintText: 'OTP'),
                      onSaved: (val) {
                        authenInfo.otp = val;
                      }),
                  RaisedButton(
                      child: Text('verified'),
                      onPressed: () async {
                        auth.load.add(true);
                        _key.currentState.save();
                        widget.login ? await login() : await register();
                      })
                ],
              ),
            ),
          ),
          loading
              ? Center(
                  child: Container(
                      width: 81,
                      height: 81,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius: BorderRadius.circular(6)),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(accentColor: Colors.white),
                        child: CircularProgressIndicator(),
                      )),
                )
              : SizedBox()
        ],
      ),
    );
  }

  login() async {
    final authenInfo = Provider.of<AuthenProv>(context, listen: false);
    await auth.signInWithPhone(context,
        verificationId: authenInfo.verificationID, smsCode: authenInfo.otp);
  }

  register() async {
    final authenInfo = Provider.of<AuthenProv>(context, listen: false);
    String uid = await auth.signUpWithPhone(context,
        verificationId: authenInfo.verificationID,
        smsCode: authenInfo.otp,
        phone: authenInfo.phone,
        password: authenInfo.password,
        pName: authenInfo.pName,
        region: authenInfo.region);
    if (uid != null) print(uid);
  }
}
