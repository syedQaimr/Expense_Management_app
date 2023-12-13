import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_app/Screens/LogInPage.dart';
import 'package:flutter_app/Screens/loginOrRegister.dart';
import 'package:flutter_app/Screens/security_pin.dart';
import 'package:flutter_app/widgets/bottomnavigationbar.dart';
//import 'package:lottie/lottie.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            final currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser != null) {
              return FutureBuilder<bool>(
                future: hasPin(currentUser.uid),
                builder: (context, pinSnapshot) {
                  if (pinSnapshot.connectionState == ConnectionState.waiting) {
                    // Return a loading indicator if the PIN check is still in progress
                    return Center(
                      child: SizedBox(
                        width: 170,
                        height: 10,
                        child: LinearProgressIndicator(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  } else {
                    if (pinSnapshot.data == true) {
                      return SecurityPinScreen();
                    } else {
                      return Bottom(username: '', userid: '');
                    }
                  }
                },
              );
            } else {
              return LoginOrRegister();
            }
            //return Bottom(username: '', userid: '');
          }
          // user is not logged in
          else {
            return LoginOrRegister();
          }
        },
      ),
    );
  }

  // check if user has created a pin for the app
  List<String> docIDs = [];

// Check if the user has a PIN
  Future<bool> hasPin(String? userID) async {
    if (userID == null) {
      // Handle the case when userID is null
      return false;
    }
    QuerySnapshot pinSnapshot = await FirebaseFirestore.instance
        .collection('PIN')
        .doc(userID) // Use the current user's ID
        .collection('userPIN')
        .get();

    if (pinSnapshot.docs.isNotEmpty) {
      // User has a PIN
      pinSnapshot.docs.forEach(
        (document) {
          docIDs.add(document.reference.id);
        },
      );
      return true;
    } else {
      // User does not have a PIN
      return false;
    }
  }
}
