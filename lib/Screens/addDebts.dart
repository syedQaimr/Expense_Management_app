import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/model/debt_class.dart';
import 'package:hive/hive.dart';

class AddDebts extends StatefulWidget {
  const AddDebts({super.key});

  @override
  State<AddDebts> createState() => _AddDebtsState();
}

class _AddDebtsState extends State<AddDebts> {
  final debtController = TextEditingController();
  final debtamountController = TextEditingController();
  // set date to now
  DateTime date = new DateTime.now();
  late Debtclass history;
  // reference hive box
  final debtbox = Hive.box<Debtclass>('debts');

  // write data to hive
  void writedatatohive(Debtclass obj) {
    debtbox.add(obj);
  }

  // Function to add debt data to Firebase
  Future<void> addDebtToFirebase() async {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('Debts')
        .doc(currentUserID)
        .collection('userDebts')
        .add({
      'Debt': debtController.text,
      'amount': int.parse(debtamountController.text),
      'date': date,
    });
    Debtclass object = Debtclass(
        debtController.text, int.parse(debtamountController.text), date);
    // write to hive box
    writedatatohive(object);
    // a success message
    showSuccessMessage('Debt Added');
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
      backgroundColor: const Color(0xFF7F0900),
      // app bar
      appBar: AppBar(
        backgroundColor: const Color(0xFF7F0900),
        title: Text(
          "Add Debts here",
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
                Image.asset(
                  'images/debt.gif',
                  height: 50,
                ),

                const SizedBox(height: 25),
                // month picker
                date_time(),

                const SizedBox(height: 10),
                // debt textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: debtController,
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade300,
                      filled: true,
                      hintText: 'debt to:',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // debt amount textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: debtamountController,
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
                      hintText: 'Amount:',
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
                    addDebtToFirebase();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.amber[700],
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Icon(
                              Icons.timelapse,
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
                            "It is advisable to document any outstanding debts in order to effectively monitor and facilitate the repayment process.",
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
      width: 300,
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
          'Date : ${date.year} / ${date.day} / ${date.month}',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
