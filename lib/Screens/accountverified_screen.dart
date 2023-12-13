import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class AccountVerifiedScr extends StatefulWidget {
  const AccountVerifiedScr({super.key});

  @override
  State<AccountVerifiedScr> createState() => _AccountVerifiedScrState();
}

class _AccountVerifiedScrState extends State<AccountVerifiedScr> {
  // get user info from firebase
  final user = FirebaseAuth.instance.currentUser!;
  // user verified
  final String userverified =
      'Awesome news! Your email verification process is complete, and you are all set to explore our platform. This additional layer of security ensures a seamless and safe experience for you.';
  final String notverified =
      'We were not able to verify your email. Usually this mean that the email account that you are using does not exist.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: LiquidPullToRefresh(
        onRefresh: () async {
          setState(() {});
        },
        color: Color(0xFFF931A05),
        height: 300,
        backgroundColor: Colors.red[300],
        animSpeedFactor: 2,
        showChildOpacityTransition: true,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.black54,
              title: Text(
                "Account verification",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[300],
                ),
              ),
              centerTitle: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return buildItem();
                },
                childCount: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem() {
    return Container(
      height: 300,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xffCFCFFC).withOpacity(0.1),
        ),
        color: const Color(0xff4E4E61).withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.email!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[300],
                    ),
                  ),
                  Text(
                    user.emailVerified ? 'User Verified' : 'User Not Verified',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: user.emailVerified ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  "Account verified",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[300],
                  ),
                ),
                Text(
                  '${user.emailVerified.toString()}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[300],
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    user.emailVerified ? Icons.done_outline : Icons.clear,
                    color: user.emailVerified ? Colors.green : Colors.red,
                  ),
                ),
              ),
              Text(
                "Account Info",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[300],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.account_balance,
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
