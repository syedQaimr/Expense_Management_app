import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/utility.dart';

class PiechartComponent extends StatefulWidget {
  const PiechartComponent({super.key});

  @override
  State<PiechartComponent> createState() => _PiechartComponentState();
}

class _PiechartComponentState extends State<PiechartComponent> {
  double totalFoodExpenses = totalForSpecificTransaction('food').toDouble();
  double educationExpenses =
      totalForSpecificTransaction('Education').toDouble();
  double transferExpenses = totalForSpecificTransaction('Transfer').toDouble();
  double transportExpenses =
      totalForSpecificTransaction('Transportation').toDouble();
  double healthExpenses = totalForSpecificTransaction('Health').toDouble();

  @override
  void initState() {
    super.initState();
    // Example: Calculate total amount for "food" expenses
    print('Total Food Expenses: $totalFoodExpenses');
  }

  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // title of pie chart in center
        Text(
          "Expense",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[300],
          ),
        ),

        // pie chart
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: SingleChildScrollView(
            child: Container(
              height: 500,
              width: 700,
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
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: PieChart(
                        swapAnimationDuration:
                            const Duration(milliseconds: 750),
                        swapAnimationCurve: Curves.easeInOutQuint,
                        PieChartData(
                          sections: [
                            //item1
                            PieChartSectionData(
                              value: educationExpenses,
                              color: Colors.blue,
                            ),

                            //item 2
                            PieChartSectionData(
                              value: totalFoodExpenses,
                              color: Colors.deepPurple,
                            ),

                            //item 3
                            PieChartSectionData(
                              value: transferExpenses,
                              color: Colors.green,
                            ),

                            //item 4
                            PieChartSectionData(
                              value: transportExpenses,
                              color: Colors.amber,
                            ),

                            //item 5
                            PieChartSectionData(
                              value: healthExpenses,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Text below the pie chart
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // Example text with color representation
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildColorIcon(Colors.deepPurple),
                            SizedBox(width: 8),
                            Text(
                              'Food: Rs ${totalFoodExpenses}',
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildColorIcon(Colors.green),
                            SizedBox(width: 8),
                            Text(
                              'Transfer: Rs ${transferExpenses}',
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildColorIcon(Colors.amber),
                            SizedBox(width: 8),
                            Text(
                              'Transport: Rs ${transportExpenses}',
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildColorIcon(Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Education: Rs ${educationExpenses}',
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildColorIcon(Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Health: Rs ${healthExpenses}',
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
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
          ),
        ),
      ],
    );
  }
}

// Function to build a circular color icon
Widget _buildColorIcon(Color color) {
  return Container(
    width: 20,
    height: 20,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    ),
  );
}
