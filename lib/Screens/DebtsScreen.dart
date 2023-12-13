import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/addDebts.dart';
import 'package:flutter_app/data/model/debt_class.dart';
import 'package:hive/hive.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class DebtScreen extends StatefulWidget {
  const DebtScreen({super.key});

  @override
  State<DebtScreen> createState() => _DebtScreenState();
}

class _DebtScreenState extends State<DebtScreen> {
  late Debtclass history;
  // reference hive box
  final dbtbx = Hive.box<Debtclass>('debts');

  // Firebase documentIds
  List<String> docIDs = [];

  // get firebase documentIds
  Future getDocId() async {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('Debts')
        .doc(currentUserID) // Use the current user's ID
        .collection('userDebts')
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

  void clearbox() {
    dbtbx.clear();
  }

  // After fetching documtentIds now use that info to fetch data in each doucment
  Future fetchdebtdetails() async {
    await getDocId();

    // Get the current user's ID
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    for (var docId in docIDs) {
      var document = await FirebaseFirestore.instance
          .collection('Debts')
          .doc(currentUserID) // Use the current user's ID
          .collection('userDebts')
          .doc(docId)
          .get();
      var data = document.data() as Map<String, dynamic>;

      // Extract the required details
      var debt = data['Debt'] as String;
      var amount = data['amount'] as int;
      var timestamp = data['date'] as Timestamp; // Use Timestamp type
      var dat = timestamp.toDate(); // Convert Timestamp to DateTime
      // Create an debt object and add it to the Hive box
      var dbtbj = Debtclass(debt, amount, dat);
      dbtbx.add(dbtbj);
    }
  }

  // Function to delete a debt from Firebase
  Future<void> deletedebtFromFirebase(Debtclass hist) async {
    try {
      // Get the current user's ID
      final currentUserID = FirebaseAuth.instance.currentUser!.uid;
      // Query the document based on unique fields
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Debts')
          .doc(currentUserID)
          .collection('userDebts')
          .where('Debt', isEqualTo: hist.debtto)
          .where('amount', isEqualTo: hist.amount)
          .where('date', isEqualTo: hist.dt)
          .get();

      // Check if the document exists
      if (querySnapshot.docs.isNotEmpty) {
        // Delete the document
        await querySnapshot.docs.first.reference.delete();
      }
    } catch (e) {
      print('Error deleting budget: $e');
    }
  }

  Future<void> deletedebtAndRefresh(Debtclass history, dynamic index) async {
    try {
      bool? userConfirmed = await showDeleteConfirmationDialog(context);
      if (userConfirmed!) {
        // call delete function
        await deletedebtFromFirebase(history);
        //remove the budget locally from the Hive box
        dbtbx.delete(index);
        // refresh the UI
        setState(() {});
      }
    } catch (e) {
      // errors that occur during the deletion process
      print('Error deleting budget: $e');
      // an error message to the user here
    }
  }

  // Function to show the delete confirmation dialog
  Future<bool?> showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red[400],
          title: Text(
            "Delete Debt record",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          content: Text(
            "Are you sure you want to delete this debt record?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[300],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                "OK",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> cmpltdebtAndRefresh(Debtclass history, dynamic index) async {
    try {
      bool? userConfirmed = await showCompletedConfirmationDialog(context);
      if (userConfirmed!) {
        // call delete function
        await deletedebtFromFirebase(history);
        //remove the budget locally from the Hive box
        dbtbx.delete(index);
        // refresh the UI
        setState(() {});
      }
    } catch (e) {
      // errors that occur during the deletion process
      print('Error deleting budget: $e');
      // an error message to the user here
    }
  }

  // Function to show the delete confirmation dialog
  Future<bool?> showCompletedConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green[400],
          title: Text(
            "Debt Paid",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          content: Text(
            "Are you sure you want to proceed?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[300],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                "OK",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    dbtbx.clear();
    super.initState();
    fetchdebtdetails().then((_) {
      print(dbtbx.length); // Trigger a rebuild after fetching data
    });
  }

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
                "Debts",
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
                  if (dbtbx.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    history = dbtbx.getAt(index)!;
                    return builddebtItem(history);
                  }
                },
                childCount: dbtbx.length,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        elevation: 20,
        backgroundColor: Color(0xFFEE4135),
        onPressed: () {
          // move to add debt screen
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddDebts()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget builddebtItem(Debtclass history) {
    return Container(
      height: 150, // Adjust the height as needed
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xffCFCFFC).withOpacity(0.1),
        ),
        color: const Color(0xff4E4E61).withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      history.debtto,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[300],
                      ),
                    ),
                    Text(
                      "Return date",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      "Rs ${history.amount}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[300],
                      ),
                    ),
                    Text(
                      '${history.dt.day}/${history.dt.month}/${history.dt.year}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () => cmpltdebtAndRefresh(history, history.key),
                  icon: Icon(
                    Icons.done_all_outlined,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              Text(
                "Debt Record",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[300],
                ),
              ),
              IconButton(
                onPressed: () => deletedebtAndRefresh(history, history.key),
                icon: Icon(
                  Icons.delete,
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
