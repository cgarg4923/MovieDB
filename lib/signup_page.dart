import 'package:MovieApp/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  String email, password, fname, lname, repassword;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();
  TextEditingController t5 = TextEditingController();

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
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                hintText: 'First Name',
                                labelText: 'First Name',
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5)),
                                labelStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white.withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(5)),
                              ),
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
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                hintText: 'Last Name',
                                labelText: 'Last Name',
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5)),
                                labelStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white.withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(5)),
                              ),
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
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          hintText: 'Email',
                          labelText: 'Email',
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
                          labelStyle:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(5)),
                        ),
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
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          hintText: 'Password',
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
                          labelText: 'Password',
                          labelStyle:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(5)),
                        ),
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
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          hintText: 'Confirm Password',
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
                          labelText: 'Confirm Password',
                          labelStyle:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(5)),
                        ),
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
                                  final newUser =
                                      await auth.createUserWithEmailAndPassword(
                                          email: email, password: password);
                                  if (newUser != null) {
                                    uid = await newUser.user.uid;
                                    await firestore
                                        .collection('Users')
                                        .doc(uid.toString())
                                        .set({
                                      'fname': fname,
                                      'lname': lname,
                                      'password': password.hashCode,
                                      'favourites': [],
                                      'watch_later': [],
                                      'email': email
                                    }).then((value) async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString(
                                          'email', email.toString());
                                    });

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MyHomePage(uid: uid.toString()),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  Fluttertoast.showToast(
                                      msg: e.toString(),
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black38,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
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
