import 'package:flutter/material.dart';
import 'package:scrap_sandbox/functions/authen.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool loading = true;
  var user;
  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() async {
    user = await fireAuth?.currentUser() ?? null;
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    Size scr = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: scr.width,
        height: scr.height,
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : user == null
                ? Center(
                    child: Text('not logIn'),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                        child: Image.network(
                            user?.photoUrl ??
                                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                            width: scr.width / 3,
                            height: scr.width / 3,
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(scr.width),
                      ),
                      SizedBox(
                        height: scr.height / 32,
                      ),
                      Text(
                        user?.displayName ?? 'ไม่มี',
                        style: TextStyle(
                            fontSize: scr.width / 16, color: Colors.white),
                      ),
                      RaisedButton(
                          child: Text('Sign Out'),
                          onPressed: () {
                            fireAuth.signOut();
                          }),
                    ],
                  ),
      ),
    );
  }
}
