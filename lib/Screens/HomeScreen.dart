import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/AddBudgets.dart';
import 'package:flutter_app/data/model/budget_class.dart';
import 'package:hive/hive.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class H2 extends StatefulWidget {
  const H2({super.key});

  @override
  State<H2> createState() => _H2State();
}

class _H2State extends State<H2> {
  late Budgetdata history;
  // reference hive box
  final _budgetbox = Hive.box<Budgetdata>('Budgets');

  // Firebase documentIds
  List<String> docIDs = [];

  // get firebase documentIds
  Future getDocId() async {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('Budgets')
        .doc(currentUserID) // Use the current user's ID
        .collection('userBudgets')
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
  Future fetchbudgetdetails() async {
    await getDocId();

    // Get the current user's ID
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    for (var docId in docIDs) {
      var document = await FirebaseFirestore.instance
          .collection('Budgets')
          .doc(currentUserID) // Use the current user's ID
          .collection('userBudgets')
          .doc(docId)
          .get();
      var data = document.data() as Map<String, dynamic>;

      // Extract the required details
      var budget = data['budget'] as int;
      var month = data['month'] as int;
      var year = data['year'] as int;
      // Create an budget object and add it to the Hive box
      var budgetobj = Budgetdata(budget, month, year);
      _budgetbox.add(budgetobj);
    }
  }

// Function to delete a budget from Firebase
  Future<void> deleteBudgetFromFirebase(Budgetdata hist) async {
    try {
      // Get the current user's ID
      final currentUserID = FirebaseAuth.instance.currentUser!.uid;
      // Query the document based on unique fields
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Budgets')
          .doc(currentUserID)
          .collection('userBudgets')
          .where('budget', isEqualTo: hist.budget)
          .where('month', isEqualTo: hist.month)
          .where('year', isEqualTo: hist.year)
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

  Future<void> deleteBudgetAndRefresh(Budgetdata history, dynamic index) async {
    try {
      bool? userConfirmed = await showDeleteConfirmationDialog(context);
      if (userConfirmed!) {
        // call delete function
        await deleteBudgetFromFirebase(history);
        //remove the budget locally from the Hive box
        _budgetbox.delete(index);
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
          backgroundColor: Colors.deepOrange[700],
          title: Text(
            "Delete Budget",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          content: Text(
            "Are you sure you want to delete this budget?",
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
    _budgetbox.clear();
    super.initState();
    fetchbudgetdetails().then((_) {
      print(_budgetbox.length); // Trigger a rebuild after fetching data
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
              backgroundColor: Colors.red,
              title: Center(
                child: Text(
                  "Budgets",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              floating: true,
              pinned: true,
              snap: false,
              expandedHeight: 180,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  //'images/budget.jpg',
                  'images/money.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (_budgetbox.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    history = _budgetbox.getAt(index)!;
                    return buildBudgetItem(history);
                  }
                },
                childCount: _budgetbox.length,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        elevation: 20,
        //backgroundColor: const Color.fromARGB(255, 246, 200, 63),
        backgroundColor: const Color(0xFFFF5722),
        onPressed: () {
          // move to add budget screen
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddBudget()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildBudgetItem(Budgetdata history) {
    return FutureBuilder<String>(
        future: calculateRemainingBudget(history),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: AvatarGlow(
                child: Icon(Icons.calculate, color: Colors.white, size: 40),
                endRadius: 100,
                glowColor: Color(0xFFCC0E00),
                duration: Duration(milliseconds: 2000),
                repeatPauseDuration: Duration(milliseconds: 100),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            String remainingBudget =
                snapshot.data ?? 'N/A'; // Use 'N/A' if data is null.
            return Container(
              height: 150, // Adjust the height as needed
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Color.fromARGB(122, 221, 151, 133),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "${getMonthName(history.month)}, ${history.year}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              "Rs${history.budget}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[300],
                              ),
                            ),
                            Text(
                              remainingBudget,
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<double>(
                        future: calculateBudgetProgress(history),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: AvatarGlow(
                                child: Icon(Icons.wifi_2_bar_sharp,
                                    color: Colors.white, size: 40),
                                endRadius: 100,
                                glowColor: Colors.deepOrange,
                                duration: Duration(milliseconds: 2000),
                                repeatPauseDuration:
                                    Duration(milliseconds: 100),
                              ),
                            ); // Display a loading indicator.
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            double progress = snapshot.data ??
                                0.0; // Use 0.0 if data is null.
                            return LinearProgressIndicator(
                              borderRadius: BorderRadius.circular(20),
                              minHeight: 10,
                              value: progress,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.redAccent),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.bar_chart,
                          color: Colors.grey[300],
                        ),
                      ),
                      Text(
                        "Budget Analysis",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey[300],
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            deleteBudgetAndRefresh(history, history.key),
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
        });
  }

// get month name from month number
  String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return 'Unknown';
    }
  }

// calculate remaining budget
  Future<String> calculateRemainingBudget(Budgetdata history) async {
    // Get the current user's ID
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    // Get the month and year from the budget hive
    final budgetMonth = history.month;
    final budgetYear = history.year;

    // Fetch transactions for the months that are in hive from Firebase
    final transactionsSnapshot = await FirebaseFirestore.instance
        .collection('Transactions')
        .doc(currentUserID)
        .collection('userTransactions')
        .where('date',
            isGreaterThanOrEqualTo: DateTime(budgetYear, budgetMonth, 1))
        .where('date', isLessThan: DateTime(budgetYear, budgetMonth + 1, 1))
        .get();

    // Calculate total expenses for the months in hive
    int totalExpenses = 0;
    for (var transactionDoc in transactionsSnapshot.docs) {
      var transactionData = transactionDoc.data() as Map<String, dynamic>;
      if (transactionData['type'] == 'Expense') {
        totalExpenses += transactionData['amount'] as int;
      }
    }

    // Calculate remaining budget
    int remainingBudget = history.budget - totalExpenses;

    // Return the result
    if (remainingBudget == 0) {
      return 'Budget complete Rs${remainingBudget.toString()}';
    } else if (remainingBudget < 0) {
      return 'Overspent by Rs${remainingBudget.toString()}';
    } else {
      return 'Left Rs${remainingBudget.toString()}';
    }
  }

// getting the value of progress bar
  Future<double> calculateBudgetProgress(Budgetdata history) async {
    // Get the current user's ID
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    // Get the month and year from the budget hive
    final budgetMonth = history.month;
    final budgetYear = history.year;

    // Fetch transactions for the month from Firebase
    final transactionsSnapshot = await FirebaseFirestore.instance
        .collection('Transactions')
        .doc(currentUserID)
        .collection('userTransactions')
        .where('date',
            isGreaterThanOrEqualTo: DateTime(budgetYear, budgetMonth, 1))
        .where('date', isLessThan: DateTime(budgetYear, budgetMonth + 1, 1))
        .get();

    // Calculate the total expenses for the month
    int totalExpenses = 0;
    for (var transactionDoc in transactionsSnapshot.docs) {
      var transactionData = transactionDoc.data() as Map<String, dynamic>;
      if (transactionData['type'] == 'Expense') {
        totalExpenses += transactionData['amount'] as int;
      }
    }

    // Calculate the progress as a ratio between totalExpenses and original budget
    double progress =
        history.budget == 0 ? 0.0 : totalExpenses / history.budget;

    // Ensure the progress is between 0.0 and 1.0
    return progress.clamp(0.0, 1.0);
  }
}
