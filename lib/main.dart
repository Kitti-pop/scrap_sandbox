import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:scrap_sandbox/authenPage/PhoneSumbit.dart';
import 'package:scrap_sandbox/authenPage/signUp.dart';
import 'package:scrap_sandbox/functions/authen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String pName, password;
  var auth = AuthFunc();
  var _key = GlobalKey<FormState>();
  DocumentSnapshot user;
  var doc;
  var ref2 = Firestore.instance
      .collection('Scraps')
      .document('TH')
      .collection('indicators')
      .orderBy('popularity.P');
  var geo = ReverseGeoCoding(
    apiKey:
        'pk.eyJ1Ijoic2NyYXAtZGV2IiwiYSI6ImNrN3psdGZnYzA1cmkzZG80YjgyenYzZXYifQ.mGLyQ9BgHoiaBVpJOkEw1g',
  );

  @override
  void initState() {
    super.initState();
  }

  getUid() async {
    var uid = await FirebaseAuth.instance.currentUser();
    print(uid != null ? 'login' : 'not login');
    print(uid?.uid ?? 'nope');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
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
                  child: Text('Sign In'),
                  onPressed: () async {
                    _key.currentState.save();
                    await hasAccount()
                        ? signIn()
                        : auth.warn('ไม่พบบัญชืดังกล่าว', context);
                  }),
              RaisedButton(
                  child: Text('Sign In with phone'),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PhoneSumbit(login: true)));
                  }),
              RaisedButton(
                  child: Text('Sign Up'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  }),
              RaisedButton(
                  child: Text('Sign Out'),
                  onPressed: () {
                    auth.signOut();
                  }),
              RaisedButton(
                child: Text('check isLogin?'),
                onPressed: getUid,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  signIn() {
    password == user['password']
        ? auth.signInWithPenName(
            phone: user['phone'], password: user['password'])
        : auth.warn('ตรวจสอบรหัสผ่าน', context);
  }

  Future<bool> hasAccount() async {
    var doc = await Firestore.instance
        .collection('Account')
        .where('pName', isEqualTo: pName)
        .limit(1)
        .getDocuments();
    if (doc.documents.length > 0) user = doc.documents[0];
    return doc.documents.length > 0;
  }

  String readTimestamp(Timestamp timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = timestamp.toDate();
    var diff = now.difference(date);
    var time = '';

    if (diff.inDays < 1) {
      if (diff.inMinutes <= 30) {
        time = 'เมื่อไม่นานมานี้';
      } else if (diff.inMinutes < 60) {
        time = 'เมื่อ ' + diff.inMinutes.toString() + 'นาที ที่แล้ว';
      } else {
        time = 'เมื่อ ' + diff.inHours.toString() + 'ชั่วโมง ที่แล้ว';
      }
    } else if (diff.inDays < 7) {
      diff.inDays == 1
          ? time = 'เมื่อวานนี้'
          : time = diff.inDays.toString() + ' วันที่แล้ว';
    } else {
      diff.inDays == 7 ? time = 'สัปดาที่แล้ว' : time = format.format(date);
    }
    return time;
  }
}
