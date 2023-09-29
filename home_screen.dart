import 'package:flutter/material.dart';
import 'package:mad_project/data/userInfo.dart';
import 'package:mad_project/utils/constants.dart';
import 'package:mad_project/widget/income_expense_card.dart';
import 'package:mad_project/widget/transaction_item_title.dart';

class HomeScreenTab extends StatelessWidget {
  const HomeScreenTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(defaultSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: defaultSpacing * 4,
            ),
            ListTile(
              title: Text("Hey! ${userdata.name}"),
              leading: ClipRRect(
                  borderRadius:
                      const BorderRadius.all(Radius.circular(defaultRadius)),
                  child: Image.asset("assets/images/5856.jpg")),
              trailing: Image.asset("assets/icons/bell.png"),
            ),
            const SizedBox(
              height: defaultSpacing,
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    "Rs${userdata.totalBalance}",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: fontSizeHeading, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: defaultSpacing / 2,
                  ),
                  Text(
                    "Total balance",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: fontLight),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: defaultSpacing * 2,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: IncomeExpenseCard(
                        expenseData: ExpenseData(
                            "Income",
                            "Rs${userdata.inflow}",
                            Icons.arrow_upward_rounded))),
                const SizedBox(
                  width: defaultSpacing,
                ),
                Expanded(
                    child: IncomeExpenseCard(
                        expenseData: ExpenseData(
                            "Expense",
                            "-Rs${userdata.outflow}",
                            Icons.arrow_downward_rounded)))
              ],
            ),
            const SizedBox(
              height: defaultSpacing * 2,
            ),
            Text(
              "Recent Transactions",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: defaultSpacing,
            ),
            const Text(
              "Today",
              style: TextStyle(color: fontLight),
            ),
            ...userdata.transactions.map(
                (transaction) => TransactionItemTile(transaction: transaction)),
            const SizedBox(
              height: defaultSpacing,
            ),
            const Text(
              "Yesterday",
              style: TextStyle(color: fontLight),
            ),
            ...transaction2.map(
                (transaction) => TransactionItemTile(transaction: transaction)),
          ],
        ),
      ),
    );
  }
}
