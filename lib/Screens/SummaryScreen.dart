import 'package:flutter/material.dart';
import 'package:flutter_app/data/utility.dart';
import 'package:flutter_app/widgets/pie_chart.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text(
          'Summary',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PiechartComponent(),
            SizedBox(height: 10),
            Container(
              height: 100,
              width: 300,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xffCFCFFC).withOpacity(0.1),
                ),
                color: const Color(0xff4E4E61).withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.money,
                    color: Colors.grey[400],
                  ),
                  SizedBox(width: 7),
                  Center(
                    child: Text(
                      "Total expense:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Rs ${expenses().abs()}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: Colors.red[400],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
