import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DrawerList extends StatefulWidget {
  String fname, lname;
  DrawerList({this.fname, this.lname});
  @override
  _DrawerListState createState() => _DrawerListState();
}

class _DrawerListState extends State<DrawerList> {
  @override
  var textStyle = TextStyle(
    fontFamily: 'Quicksand',
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  Widget Divide(BuildContext context) {
    return Divider(
      color: Colors.white54,
      height: MediaQuery.of(context).size.height * 0.05,
      indent: MediaQuery.of(context).size.width * 0.2,
      endIndent: MediaQuery.of(context).size.width * 0.2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('images/users.png'),
          backgroundColor: Colors.transparent,
        ),
        Divide(context),
        Text(
          widget.fname + " " + widget.lname,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
        Divide(context),
        Text(
          'About the App',
          textAlign: TextAlign.center,
          style: textStyle,
        ),
        Divide(context),
        Text(
          'Report A Bug',
          textAlign: TextAlign.center,
          style: textStyle,
        ),
        Divide(context),
        Text(
          'Contact Us',
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ],
    );
  }
}
