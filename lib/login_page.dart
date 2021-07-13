import 'dart:math';

import 'package:MovieApp/main.dart';
import 'package:MovieApp/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatelessWidget {
  String email, password;
  TextEditingController t2 = new TextEditingController();
  TextEditingController t1 = new TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  InputDecor(String txt) {
    return InputDecoration(
      prefixIcon: Icon(
        Icons.lock,
        color: Colors.white.withOpacity(0.5),
      ),
      hintText: txt,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
      labelText: txt,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(5),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/bg3.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black.withOpacity(0.75),
                ),
                height: 300,
                width: 300,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        size: 40,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: t1,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecor('Email'),
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: t2,
                        style: TextStyle(color: Colors.white),
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecor('Password'),
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                            color: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onPressed: () async {
                              var uid;
                              try {
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );
                                if (userCredential != null) {
                                  uid = await userCredential.user.uid;
                                  print(uid);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          MyHomePage(uid: uid.toString()),
                                    ),
                                  );
                                }
                              } on FirebaseAuthException catch (e) {
                                String msg;
                                if (e.code == 'user-not-found') {
                                  msg = 'No user found for that email.';
                                } else if (e.code == 'wrong-password') {
                                  msg =
                                      'Wrong password provided for that user.';
                                }
                                Fluttertoast.showToast(
                                    msg: msg, //e.toString(),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black38,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                print('hello');
                                print(e);
                              }

                              t1.clear();
                              t2.clear();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 8),
                              child: Text(
                                'LOGIN',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          RaisedButton(
                            color: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onPressed: () {
                              //Navigator.pushNamed(context, '/signup');
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => SignUp()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 8),
                              child: Text(
                                'SIGNUP',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
