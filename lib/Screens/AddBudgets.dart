import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/data/model/budget_class.dart';
import 'package:hive/hive.dart';

class AddBudget extends StatefulWidget {
  const AddBudget({super.key});

  @override
  State<AddBudget> createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {
  // textediting controller
  final budgetController = TextEditingController();
  // set date to now
  DateTime date = new DateTime.now();
  late Budgetdata history;
  // reference hive box
  final _budgetbox = Hive.box<Budgetdata>('Budgets');

  // write data to hive
  void writedatatohive(Budgetdata obj) {
    _budgetbox.add(obj);
  }

  // Function to add budget data to Firebase
  Future<void> addBudgetToFirebase() async {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('Budgets')
        .doc(currentUserID)
        .collection('userBudgets')
        .add({
      'month': date.month,
      'year': date.year,
      'budget': int.parse(budgetController.text),
    });
    Budgetdata object =
        Budgetdata(int.parse(budgetController.text), date.month, date.year);
    // write to hive box
    writedatatohive(object);
    // a success message
    showSuccessMessage('Budget Added');
  }

  void showSuccessMessage(String Message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.green,
          title: Center(
            child: Text(
              Message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.deepOrange[900],
      backgroundColor: const Color(0xFF7F0900),

      // app bar
      appBar: AppBar(
        backgroundColor: const Color(0xFF7F0900),
        title: Text(
          "Add Budget",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[300],
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 25),

                // logo for add
                Icon(
                  Icons.add_circle_outline_outlined,
                  size: 50,
                  color: Colors.grey[300],
                ),

                const SizedBox(height: 25),
                // month picker
                date_time(),

                const SizedBox(height: 10),
                // budget textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: budgetController,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade300,
                      filled: true,
                      hintText: 'Total Budget',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Save button
                GestureDetector(
                  onTap: () {
                    // function call to add data to firebase
                    addBudgetToFirebase();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Card(
                    elevation: 10,
                    color: Colors.deepOrange[400],
                    //color: const Color(0xFFC95963),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Icon(
                              Icons.tips_and_updates,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          Text(
                            "Tip:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Track your expenses regularly to understand where your money is going. This helps you make informed decisions and stay within your budget.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // month picker widget
  Widget date_time() {
    return Container(
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: Color(0xffC5C5C5))),
      width: 315,
      child: TextButton(
        onPressed: () async {
          DateTime? newDate = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2020),
              lastDate: DateTime(2100));
          if (newDate == Null) return;
          setState(() {
            date = newDate!;
          });
        },
        child: Text(
          'Month : ${date.year} / ${date.month}',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
