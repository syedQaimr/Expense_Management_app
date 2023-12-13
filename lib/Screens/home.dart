import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/authPage.dart';
import 'package:flutter_app/data/model/image_class.dart';
import 'package:flutter_app/data/utility.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter_app/data/model/add_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/Screens/userProfileScreen.dart';

class Home extends StatefulWidget {
  final String username;
  final String? userid;

  const Home({Key? key, required this.username, required this.userid})
      : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var history;
  // hive class to add transactions
  final box = Hive.box<Add_data>('data');
  // img hive class
  final imgbx = Hive.box<Imageclass>('Image');
  // variable that stores reference to shared preference
  SharedPreferences? _prefs;
  // variable to store avatar img
  String _AvatarImg = "";
  final List<String> day = [
    'Monday',
    "Tuesday",
    "Wednesday",
    "Thursday",
    'friday',
    'saturday',
    'sunday'
  ];

  // Firebase documentIds
  List<String> docIDs = [];

  // variable to check wether data is fetched to avoid printing same data again
  bool dataFetched = false;

  // get firebase documentIds
  Future getDocId() async {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('Transactions')
        .doc(currentUserID) // Use the current user's ID
        .collection('userTransactions')
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            },
          ),
        );
  }

// After fetching documtentIds now use that info to fetch data in each doucment
  Future fetchTransactionDetails() async {
    await getDocId();

    // Get the current user's ID
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    for (var docId in docIDs) {
      var document = await FirebaseFirestore.instance
          .collection('Transactions')
          .doc(currentUserID) // Use the current user's ID
          .collection('userTransactions')
          .doc(docId)
          .get();
      var transactionData = document.data() as Map<String, dynamic>;

      // Extract the required details
      var category = transactionData['category'];
      var type = transactionData['type'];
      var amount = transactionData['amount'].toString();
      var explanation = transactionData['explanation'];
      var dateTimestamp = transactionData['date'] as Timestamp;
      var date = dateTimestamp.toDate();
      // Create an Add_data object and add it to the Hive box
      var transaction = Add_data(type, amount, date, explanation, category);
      box.add(transaction);
    }
  }

  // Function to delete transaction from Firebase
  Future deleteTransactionFromFirebase(Add_data transaction) async {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    // Query the document based on unique fields
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Transactions')
        .doc(currentUserID)
        .collection('userTransactions')
        .where('category', isEqualTo: transaction.name)
        .where('type', isEqualTo: transaction.IN)
        //.where('date', isEqualTo: transaction.datetime)
        .where('amount', isEqualTo: int.parse(transaction.amount))
        .where('explanation', isEqualTo: transaction.explain)
        .get();

    // Check if the document exists
    if (querySnapshot.docs.isNotEmpty) {
      // Delete the document
      await querySnapshot.docs.first.reference.delete();
    }
  }

  // log out user
  void UserLogout() {
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
      (route) => false,
    );
  }



  // get user info from firebase
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    box.clear();
    super.initState();
    fetchTransactionDetails().then((_) {
      print(box.isEmpty); // Trigger a rebuild after fetching data
    });
    SharedPreferences.getInstance().then((value) {
      setState(() {
        _prefs = value;
        _AvatarImg = _prefs!.getString("last_image") ?? "";

        //_RMhistory = _prefs!.getStringList("rm_history") ?? [];
        //_save = _prefs!.getDouble("last_input_save")?.toDouble() ?? 0;
        //_money = _prefs!.getDouble("last_input_money")?.toDouble() ?? 0;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      //backgroundColor: Color(0xFF100405),
      //backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, value, child) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(height: 340, child: _head()),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Transactions History',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 19,
                                  color: Colors.grey[300]),
                            ),
                            Text(
                              'See all',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (box.isEmpty) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            history = box.getAt(index)!;
                            return getList(history, index);
                          }
                        },
                        childCount: box.length,
                      ),
                    )
                  ],
                );
              })),
    );
  }

  Widget getList(Add_data history, int index) {
    return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) async {
          // Delete from Firebase when dismissed
          await deleteTransactionFromFirebase(history);
          // Then, delete locally
          history.delete();
        },
        child: get(index, history));
  }

  ListTile get(int index, Add_data history) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset(
          'images/${history.name}.png',
          height: 40,
        ),
      ),
      title: Text(
        history.name,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.grey[300],
        ),
      ),
      subtitle: Text(
        history.datetime != null
            ? '${day[history.datetime.weekday - 1]}  ${history.datetime.year}-${history.datetime.day}-${history.datetime.month}'
            : 'Date not available',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
      trailing: Text(
        history.amount,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 19,
          color: history.IN == 'Income' ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  Widget _head() {
    var media = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              //height: 240,
              height: 330,

              decoration: BoxDecoration(
                color: Color(0xFFA4111F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 35,
                    //left: 340,
                    left: 320,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        color: Color.fromRGBO(250, 250, 250, 0.1),
                        child: IconButton(
                          onPressed: UserLogout,
                          icon: Icon(Icons.search),
                          iconSize: 30,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35, left: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //imgbx.isNotEmpty
                        _AvatarImg != ""
                            ? InkWell(
                                onTap: (){
                                  
                                },
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(_AvatarImg),
                                ),
                              )
                            : const CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                        Text(
                          user.email!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 140,
          left: 25,
          child: Container(
            height: 170,
            width: 320,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(47, 125, 121, 0.3),
                  offset: Offset(0, 6),
                  blurRadius: 12,
                  spreadRadius: 6,
                )
              ],
              //color: Colors.orange.shade900,
              color: Color(0xFFC95963),
              //color: Color(0xFFFF584C),

              //color: Color(0xff283593),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Text(
                        'Balance',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 23,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '\$ ${total()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.arrow_downward,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'Income',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                          Text(
                            '\$ ${income()}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 1.5,
                        height: 50,
                        color: Colors.black,
                      ),
                      CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.redAccent,
                        child: Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'Expenses',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                          Text(
                            '\$ ${expenses()}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
