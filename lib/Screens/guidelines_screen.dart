import 'package:flutter/material.dart';

class GuidelineSceen extends StatelessWidget {
  const GuidelineSceen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text(
          "User Guidlines",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[300],
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xffCFCFFC).withOpacity(0.1),
            ),
            color: const Color(0xff4E4E61).withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to ExpensePro Tracker!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[300],
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Thanks for choosing our expense tracker app. We're here to make your financial journey a breeze. Let's get started with some handy guidelines:",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[300],
                ),
              ),
              SizedBox(height: 16),
              _buildSection("Key Features:", [
                "Track Transactions: Add your spending like a pro! Tap the '+' button, enter details, and voilà – your expenses are in check.",
                "Budget Management: Set monthly budgets. We'll keep you on the money-saving track.",
                "Graphs and Insights: Dive into colorful graphs to understand your spending habits. It's not just data; it's your financial story.",
              ]),
              _buildSection("How to Add Transactions:", [
                "Tap the '+' button.",
                "Choose a category (e.g., food, health).",
                "Enter the amount and any extra info.",
                "Hit 'Save' – boom, transaction added!",
                "This will now help in calculating total expense, total income, and total balance",
              ]),
              _buildSection("Budget Management:", [
                "Head to 'Budgets' from the navigation bar.",
                "Set your budget limits for each month.",
                "Keep an eye on the your budget screen as it will tell you how much you have spend how much money is left to spend",
              ]),
              _buildSection("Graphs and Insights:", [
                "Check out the 'Statistics and expense summary' screens for visual breakdowns of your spending. The more you know, the more you can save!",
              ]),
              _buildSection("Customization Options:", [
                "Make the app yours!",
                "Personalize avatar images in 'user profile'.",
              ]),
              _buildSection("Security", [
                "Your app data is secure",
                "For an extra layer of security you can also add a pin for your app in user profile screen",
                "If you dont want the pin anymore we give you the option to remove it",
              ]),
              SizedBox(height: 16),
              Text(
                "Stay in the Loop:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[300],
                ),
              ),
              Text(
                "Exciting updates are on the horizon. Keep an eye out for new features and improvements!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[300],
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Good luck in your expense tracking journey!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[300],
                ),
              ),
              Text(
                "Team ExpensePro Tracker",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[300],
          ),
        ),
        SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: content
              .map(
                (item) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
