import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/signup.dart';
import 'package:flutter_app/data/AuthJwt.dart';
import 'package:flutter_app/data/user.dart';
import 'package:flutter_app/widgets/bottomnavigationbar.dart';
import 'package:http/http.dart' as http;

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  late final bool response;
  //_________Sign IN Request
  Future save() async {
    var res = await http.post(Uri.parse("http://localhost:8080/signin"),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(
            <String, String>{'email': user.email, 'password': user.password}));

    print("Response body: ${res.body}");

    // Parse the JSON response
    var jsonResponse = json.decode(res.body);

    if (jsonResponse['success'] == true) {
      // Sign-in was successful
      // Store the JWT token in AuthService
      String jwtToken = jsonResponse['token'];
      AuthService().setJwtToken(jwtToken);
      print(jwtToken);
      String? userid = AuthService().getUserEmailFromToken();
      print(userid);
      String? email = await AuthService().getUserEmail(userid);
      print(email);
      String username = AuthService().extractUsernameFromEmail(email);
      print(username);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Bottom(username: username, userid: userid)),
      );
    } else {
      // Sign-in failed, handle the error
      print("Sign-in failed: ${jsonResponse['message']}");
      showAlert(context, 'Sign-in Failed', jsonResponse['message']);
    }
  }

  User user = User('', '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 23, 26, 184),
                Color.fromARGB(255, 21, 22, 55),
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'ExpenseEase\nWelcome to ExpenseEase',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign In',
                        style: TextStyle(
                            fontSize: 30,
                            color: Color(0xFF2962FF),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          controller: TextEditingController(text: user.email),
                          onChanged: (value) {
                            user.email = value;
                          },
                          validator: (String? value) {
                            if (value?.isEmpty ?? true) {
                              return 'Enter something';
                            } else if (RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value ?? '')) {
                              return null;
                            } else {
                              return 'Enter valid email';
                            }
                          },
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.email,
                                color: Color(0xFF2962FF),
                              ),
                              hintText: 'Enter Email',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide:
                                      BorderSide(color: Color(0xFF2962FF))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide:
                                      BorderSide(color: Color(0xFF2962FF))),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.red))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          controller:
                              TextEditingController(text: user.password),
                          onChanged: (value) {
                            user.password = value;
                          },
                          validator: (String? value) {
                            if (value?.isEmpty ?? true) {
                              return 'Enter something';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.key,
                                color: Color(0xFF2962FF),
                              ),
                              hintText: 'Enter Password',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide:
                                      BorderSide(color: Color(0xFF2962FF))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide:
                                      BorderSide(color: Color(0xFF2962FF))),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.red))),
                        ),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            save();
                            print("ok");
                          } else {
                            print("not ok");
                          }
                        },
                        child: Container(
                          height: 55,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(colors: [
                              Color.fromARGB(255, 23, 26, 184),
                              Color.fromARGB(255, 21, 22, 55)
                            ]),
                          ),
                          child: const Center(
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(95, 20, 0, 0),
                          child: Row(
                            children: [
                              Text(
                                "Not have Account ? ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => Signup()));
                                },
                                child: Text(
                                  "Signup",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ))
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

// Function to show an alert
void showAlert(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor:
            Colors.black.withOpacity(1), // Semi-transparent black background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Color(0xFF2962FF), // Dark blue text color
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: Color(0xFF2962FF), // Dark blue text color
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              backgroundColor:
                  Color(0xFF2962FF), // Dark color for the "OK" button
            ),
            child: Text(
              'OK',
              style: TextStyle(
                color: Colors.white, // White text color for the "OK" button
              ),
            ),
          ),
        ],
      );
    },
  );
}
