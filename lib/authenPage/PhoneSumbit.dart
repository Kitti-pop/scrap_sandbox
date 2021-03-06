import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap_sandbox/functions/authen.dart';
import 'package:scrap_sandbox/provider/authen_prov.dart';

class PhoneSumbit extends StatefulWidget {
  final bool login;
  PhoneSumbit({this.login = false});
  @override
  _PhoneSumbitState createState() => _PhoneSumbitState();
}

class _PhoneSumbitState extends State<PhoneSumbit> {
  var _key = GlobalKey<FormState>();
  var auth = AuthFunc();
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
                  TextFormField(
                      decoration: InputDecoration(hintText: 'Phone'),
                      onSaved: (val) {
                        authenInfo.phone = val;
                      }),
                  RaisedButton(
                      child: Text('submit'),
                      onPressed: () async {
                        auth.load.add(true);
                        _key.currentState.save();
                        widget.login ? await login() : await register();
                      }),
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
    await auth.hasAccount('phone', authenInfo.phone)
        ? auth.phoneVerified(authenInfo.phone, context, login: true)
        : auth.warn('ไม่พบบัญชีดังกล่าว', context);
  }

  register() async {
    final authenInfo = Provider.of<AuthenProv>(context, listen: false);
    await auth.hasAccount('phone', authenInfo.phone)
        ? auth.warn('เบอร์ซ้ำ', context)
        : auth.phoneVerified(authenInfo.phone, context);
  }
}
