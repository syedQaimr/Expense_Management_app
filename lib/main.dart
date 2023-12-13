import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/authPage.dart';
import 'package:flutter_app/data/model/add_date.dart';
import 'package:flutter_app/data/model/debt_class.dart';
import 'package:flutter_app/data/model/image_class.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/data/model/budget_class.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //initialize hive
  await Hive.initFlutter();
  // register adapters
  Hive.registerAdapter(AdddataAdapter());
  Hive.registerAdapter(BudgetdataAdapter());
  Hive.registerAdapter(ImageclassAdapter());
  Hive.registerAdapter(DebtclassAdapter());

  // open the box for transactions database
  await Hive.openBox<Add_data>('data');
  // open the box for Budgets database
  await Hive.openBox<Budgetdata>('Budgets');
  // open the box for images database
  await Hive.openBox<Imageclass>('Image');
  // open the box for debts database
  await Hive.openBox<Debtclass>('debts');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
