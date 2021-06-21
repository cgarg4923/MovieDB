import 'package:MovieApp/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MovieApp/verify.dart';

class SignUp extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  String email, password, fname, lname, repassword;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();
  TextEditingController t5 = TextEditingController();
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
                height: 400,
                width: 370,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: t1,
                              keyboardType: TextInputType.name,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecor('First Name'),
                              onChanged: (value) {
                                fname = value;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              controller: t2,
                              keyboardType: TextInputType.name,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecor('Last Name'),
                              onChanged: (value) {
                                lname = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      TextField(
                        controller: t3,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecor('Email'),
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      TextField(
                        controller: t4,
                        style: TextStyle(color: Colors.white),
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecor('Password'),
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      TextField(
                        controller: t5,
                        style: TextStyle(color: Colors.white),
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecor('Confirm Password'),
                        onChanged: (value) {
                          repassword = value;
                        },
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                            color: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8),
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
                            onPressed: () async {
                              var uid;
                              if (password == repassword) {
                                try {
                                  UserCredential newUser = await FirebaseAuth
                                      .instance
                                      .createUserWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );

                                  if (newUser != null) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VerifyScreen(
                                          uid: uid.toString(),
                                          fname: fname,
                                          lname: lname,
                                          password: password.hashCode,
                                          favourites: [],
                                          watch_later: [],
                                          email: email,
                                        ),
                                      ),
                                    );
                                  }
                                } on FirebaseAuthException catch (e) {
                                  String msg;
                                  if (e.code == 'weak-password') {
                                    msg = 'The password provided is too weak.';
                                  } else if (e.code == 'email-already-in-use') {
                                    msg =
                                        'The account already exists for that email.';
                                  }
                                  Fluttertoast.showToast(
                                      msg: msg,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black38,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } catch (e) {
                                  print(e);
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Pasword Mismatch",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black38,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                              t1.clear();
                              t2.clear();
                              t3.clear();
                              t4.clear();
                              t5.clear();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8),
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
