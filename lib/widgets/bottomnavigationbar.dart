//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/add.dart';
import 'package:flutter_app/Screens/home.dart';
import 'package:flutter_app/Screens/statistics.dart';
import 'package:flutter_app/Screens/HomeScreen.dart';
import 'package:flutter_app/Screens/userProfileScreen.dart';

class Bottom extends StatefulWidget {
  final String username;
  final String? userid;

  const Bottom({Key? key, required this.username, required this.userid})
      : super(key: key);

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int index_color = 0;
  // List of screens
  List Screen = [
    Home(username: '', userid: ''),
    Statistics(),
    H2(),
    UserProfile(),
  ];
  @override
  Widget build(BuildContext context) {
    Screen[0] = Home(username: widget.username, userid: widget.userid);
    return Scaffold(
      backgroundColor: Color(0xFF303030),
      //backgroundColor: const Color(0xFFBBA29F),
      body: Screen[index_color],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Add_Screen()));
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        shape: CircleBorder(),
        //backgroundColor: Color(0xFFFF8F00),
        backgroundColor: Color(0xFFEE4135),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFBBA29F),
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(top: 7.5, bottom: 7.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 0;
                  });
                },
                child: Icon(
                  Icons.home,
                  size: 30,
                  color:
                      index_color == 0 ? Color(0xFFF931A05) : Colors.grey[200],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 1;
                  });
                },
                child: Icon(
                  Icons.bar_chart_outlined,
                  size: 30,
                  color:
                      index_color == 1 ? Color(0xFFF931A05) : Colors.grey[200],
                ),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 2;
                  });
                },
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 30,
                  color:
                      index_color == 2 ? Color(0xFFF931A05) : Colors.grey[200],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 3;
                  });
                },
                child: Icon(
                  Icons.person_2_outlined,
                  size: 30,
                  color:
                      index_color == 3 ? Color(0xFFF931A05) : Colors.grey[200],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
