import 'dart:async';
import 'package:MovieApp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerifyScreen extends StatefulWidget {
  String uid, fname, lname, email;
  var password;
  List favourites, watch_later;
  VerifyScreen(
      {this.uid,
      this.fname,
      this.lname,
      this.password,
      this.watch_later,
      this.favourites,
      this.email});
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  String msg = "";
  User user;
  Timer timer;
  bool flag = false;
  @override
  void initState() {
    setState(() {
      user = auth.currentUser;
      msg = 'An email has been sent to ${user.email} please verify';
    });
    user.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              flag ? Icons.verified : Icons.wifi_protected_setup_sharp,
              size: 50,
            ),
          ),
          Text(
            msg,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      setState(() {
        msg = '${user.email} email verified';
        flag = true;
      });
      var uid = user.uid;
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid.toString())
          .set({
        'fname': widget.fname,
        'lname': widget.lname,
        'password': widget.password.hashCode,
        'favourites': widget.favourites,
        'watch_later': widget.watch_later,
        'email': widget.email
      }).then(
        (value) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(uid: widget.uid.toString()),
          ),
        ),
      );
    }
  }
}
