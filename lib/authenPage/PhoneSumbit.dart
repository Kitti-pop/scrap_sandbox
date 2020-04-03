import 'package:flutter/material.dart';
import 'package:scrap_sandbox/functions/authen.dart';

class PhoneSumbit extends StatefulWidget {
  final bool login;
  PhoneSumbit({this.login = false});
  @override
  _PhoneSumbitState createState() => _PhoneSumbitState();
}

class _PhoneSumbitState extends State<PhoneSumbit> {
  String phone;
  var _key = GlobalKey<FormState>();
  var auth = AuthFunc();
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
                  decoration: InputDecoration(hintText: 'Phone'),
                  onSaved: (val) {
                    phone = val;
                  }),
              RaisedButton(
                  child: Text('submit'),
                  onPressed: () async {
                    _key.currentState.save();
                    widget.login ? await login() : await register();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  login() async {
    await auth.hasAccount('phone', phone)
        ? auth.phoneVerified(phone, context, login: true)
        : auth.warn('ไม่พบบัญชีดังกล่าว', context);
  }

  register() async {
    await auth.hasAccount('phone', phone)
        ? auth.warn('เบอร์ซ้ำ', context)
        : auth.phoneVerified(phone, context);
  }
}
