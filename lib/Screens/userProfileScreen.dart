import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/DebtsScreen.dart';
import 'package:flutter_app/Screens/SummaryScreen.dart';
import 'package:flutter_app/Screens/accountverified_screen.dart';
import 'package:flutter_app/Screens/calculate_screen.dart';
import 'package:flutter_app/Screens/guidelines_screen.dart';
import 'package:flutter_app/Screens/pincode_screen.dart';
import 'package:flutter_app/components/icon_item_row.dart';
import 'package:hive/hive.dart';
import 'package:flutter_app/data/model/image_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late Imageclass imagehistory;
  // reference hive box
  final imagebox = Hive.box<Imageclass>('Image');
  // variable that stores reference to shared preference
  SharedPreferences? _prefs;
  String _img = "";
  bool isActive = false;
  // get user info from firebase
  final user = FirebaseAuth.instance.currentUser!;

  // write data to hive
  void writedatatohive(Imageclass obj) {
    imagebox.add(obj);
  }

  final List<String> imageList = [
    "images/gamer.png",
    "images/man2.png",
    "images/woman2.png",
    "images/hacker.png",
    "images/man.png",
    "images/woman.png",
    "images/user.png",
  ];

  String selectedImage = '';

  // Function to add image to firebase first time then it will only update
  Future<void> addOrUpdateImageInFirebase() async {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    final CollectionReference userProfileCollection = FirebaseFirestore.instance
        .collection('images')
        .doc(currentUserID)
        .collection('userProfile');

    // Query the existing document
    final QuerySnapshot querySnapshot = await userProfileCollection.get();

    // Check if the document exists
    if (querySnapshot.docs.isNotEmpty) {
      // If the document exists, update it
      final String documentID = querySnapshot.docs.first.id;
      await userProfileCollection.doc(documentID).set({
        'image': selectedImage,
      }, SetOptions(merge: true));
    } else {
      // If the document doesn't exist, create a new one
      await userProfileCollection.add({
        'image': selectedImage,
      });
    }

    // Update Hive box
    if (imagebox.isNotEmpty) {
      // Update the existing image record in the Hive box
      final int imageBoxKey = imagebox.keys.first;
      imagebox.put(imageBoxKey, Imageclass(selectedImage));
    } else {
      // Add a new image record to the Hive box
      imagebox.add(Imageclass(selectedImage));
    }
  }

  @override
  void initState() {
    super.initState();
    imagehistory = imagebox.isNotEmpty ? imagebox.getAt(0)! : Imageclass('');
    SharedPreferences.getInstance().then((value) {
      setState(() {
        _prefs = value;
        _img = _prefs!.getString("last_image") ?? "";
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Color(0xFF91030E),
        elevation: 12,
        title: Text(
          'User Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              //imagebox.isNotEmpty
              _img != ""
                  ? CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(_img),
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
              const SizedBox(height: 5),
              Text(
                user.email!,
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  showDialog(
                    barrierColor: Colors.grey[400]?.withOpacity(0.25),
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: Colors.grey[300],
                        elevation: 20,
                        shadowColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          height: 200, // Adjust height as needed
                          padding: EdgeInsets.all(12),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  3, // Adjust the number of columns as needed
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                            ),
                            itemCount: imageList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    selectedImage = imageList[index];
                                    Navigator.pop(context); // Close the popup
                                  });
                                  await addOrUpdateImageInFirebase();
                                  // Update imagehistory after the operation
                                  setState(() {
                                    // hive
                                    imagehistory = imagebox.isNotEmpty
                                        ? imagebox.getAt(0)!
                                        : Imageclass('');
                                    // shared preference
                                    _img = selectedImage;
                                    _prefs!.setString(
                                      "last_image",
                                      _img.toString(),
                                    );
                                  });
                                },
                                child: Image.asset(
                                  imageList[index],
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Edit profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 8),
                      child: Text(
                        "Security & Storage",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xffCFCFFC).withOpacity(0.1),
                        ),
                        color: const Color(0xff4E4E61).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          IconItemRow(
                            title: "Security",
                            icon: "images/cyber-security.png",
                            value: "Pincode",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PinScreen()));
                            },
                          ),
                          IconItemSwitchRow(
                            title: "Cloud Storage",
                            icon: "images/server.png",
                            value: isActive,
                            didChange: (newVal) {
                              setState(() {
                                isActive = newVal;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 8),
                      child: Text(
                        "App data",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xffCFCFFC).withOpacity(0.1),
                        ),
                        color: const Color(0xff4E4E61).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          IconItemRow(
                            title: "Loans",
                            icon: "images/bank-loan.png",
                            value: "Debts",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DebtScreen()));
                            },
                          ),
                          IconItemRow(
                            title: "Summary",
                            icon: "images/chart.png",
                            value: "Expense",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SummaryScreen()));
                            },
                          ),
                          IconItemRow(
                            title: "Default currency",
                            icon: "images/mone.png",
                            value: "PKR (Rs)",
                            onTap: () {},
                          ),
                          IconItemRow(
                            title: "Clean data",
                            icon: "images/data-cleaning.png",
                            value: "Delete with single click",
                            onTap: () async {
                              await deleteDataAndRefresh();
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 8),
                      child: Text(
                        "General settings",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xffCFCFFC).withOpacity(0.1),
                        ),
                        color: const Color(0xff4E4E61).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          IconItemRow(
                            title: "Privacy",
                            icon: "images/data-protection.png",
                            value: "Remove pin",
                            onTap: () async {
                              await deletepinAndRefresh();
                            },
                          ),
                          IconItemRow(
                            title: "Account verified",
                            icon: "images/project-status.png",
                            value: "${user.emailVerified.toString()}",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AccountVerifiedScr()));
                            },
                          ),
                          IconItemRow(
                            title: "User guidelines",
                            icon: "images/manual-book.png",
                            value: "Guidelines",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => GuidelineSceen()));
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 8),
                      child: Text(
                        "Additional Features",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xffCFCFFC).withOpacity(0.1),
                        ),
                        color: const Color(0xff4E4E61).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          IconItemRow(
                            title: "Calculate",
                            icon: "images/calculator.png",
                            value: "Remaining money",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CalculateScreen()));
                            },
                          ),
                          IconItemRow(
                            title: "Generate File",
                            icon: "images/calculator.png",
                            value: "PDF",
                            onTap: () {
                              //Navigator.of(context).push(MaterialPageRoute(
                              //  builder: (context) => PdfPage()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Add more widgets to display user information
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deletePinFromFirebase() async {
    try {
      final currentUserID = FirebaseAuth.instance.currentUser!.uid;

      final CollectionReference userProfileCollection = FirebaseFirestore
          .instance
          .collection('PIN')
          .doc(currentUserID)
          .collection('userPIN');

      // Query the existing document
      final QuerySnapshot querySnapshot = await userProfileCollection.get();

      // Check if the document exists
      if (querySnapshot.docs.isNotEmpty) {
        // If the document exists, delete it
        final String documentID = querySnapshot.docs.first.id;
        await userProfileCollection.doc(documentID).delete();
        print('Pin deleted successfully.');
        messageToUser(Colors.green, 'Pin removed successfully.');
      } else {
        print('Pin not found for the user.');
        messageToUser(Colors.red, 'Pin not found for the user.');
      }
    } catch (e) {
      print('Error deleting pin: $e');
      messageToUser(Colors.red, 'Error deleting pin: $e');
    }
  }

  Future<void> deletepinAndRefresh() async {
    try {
      bool? userConfirmed = await showDeleteConfirmationDialog(context);
      if (userConfirmed!) {
        // call delete function
        await deletePinFromFirebase();
        // refresh the UI
        setState(() {});
      }
    } catch (e) {
      // errors that occur during the deletion process
      print('Error deleting pin: $e');
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
            "Remove Pin",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          content: Text(
            "Are you sure you want to remove pin?",
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

  // Function to show the delete confirmation dialog
  Future<bool?> deleteUserdataConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.deepOrange[700],
          title: Text(
            "Clean data",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          content: Text(
            "Are you sure you want to clean data? This will remove all your budgets and transactions.",
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

  // error message popup
  void messageToUser(Color clr, String Message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: clr,
          title: Center(
            child: Text(
              Message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteDataAndRefresh() async {
    try {
      bool? userConfirmed = await deleteUserdataConfirmationDialog(context);
      if (userConfirmed!) {
        // call delete function
        await deleteUserDataFromFirebase();
        // refresh the UI
        setState(() {});
      }
    } catch (e) {
      // errors that occur during the deletion process
      print('Error deleting pin: $e');
      // an error message to the user here
    }
  }

  // Function to delete budgets and transactions of a user from Firebase
  Future<void> deleteUserDataFromFirebase() async {
    try {
      // Get the current user's ID
      final currentUserID = FirebaseAuth.instance.currentUser!.uid;

      // Delete transactions
      await FirebaseFirestore.instance
          .collection('Transactions')
          .doc(currentUserID)
          .collection('userTransactions')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });

      // Delete budgets
      await FirebaseFirestore.instance
          .collection('Budgets')
          .doc(currentUserID)
          .collection('userBudgets')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });

      // Show success message
      messageToUser(Colors.green, "Your data has been successfuly deleted");
    } catch (error) {
      // Handle any errors that may occur during the deletion process
      print('Error deleting user data: $error');
      messageToUser(Colors.red, "Error deleting your data: $error");
    }
  }

  // Function to clean all data
  void cleanAllData(BuildContext context) {
    // You can implement the logic to clean data here
    // For example, clearing local storage, deleting from Firebase, etc.

    // After cleaning, you might want to navigate to the home screen
    Navigator.of(context).pop(); // Close the drawer
    // Navigate to the home screen or any other screen
    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
