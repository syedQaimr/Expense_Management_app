enum TransactionType { outflow, inflow }

enum ItemCategoryType { fashion, grocery, payments }

class userInfo {
  final String name;
  final String totalBalance;
  final String inflow;
  final String outflow;
  final List<Transaction> transactions;
  const userInfo(
      {required this.name,
      required this.totalBalance,
      required this.inflow,
      required this.outflow,
      required this.transactions});
}

class Transaction {
  final ItemCategoryType categoryType;
  final TransactionType transactionType;
  final String itemCategoryName;
  final String itemName;
  final String amount;
  final String date;

  const Transaction(this.categoryType, this.transactionType,
      this.itemCategoryName, this.itemName, this.amount, this.date);
}

const List<Transaction> transaction1 = [
  Transaction(ItemCategoryType.fashion, TransactionType.outflow, "Shoes",
      "Puma Sneaker", "Rs 20,000.00", "Oct, 23"),
  Transaction(ItemCategoryType.fashion, TransactionType.outflow, "Bag", "Gucci",
      "Rs 30,000.00", "Sep, 13")
];
const List<Transaction> transaction2 = [
  Transaction(ItemCategoryType.payments, TransactionType.inflow, "Payments",
      "Transfer from Qaim", "Rs 100,000.00", "Oct, 2"),
  Transaction(ItemCategoryType.grocery, TransactionType.outflow, "Food", "KFC",
      "Rs 1500", "Oct, 10"),
  Transaction(ItemCategoryType.payments, TransactionType.outflow, "Rent",
      "Transfer from Qaim", "Rs 100,000.00", "Oct, 2"),
  Transaction(ItemCategoryType.fashion, TransactionType.outflow, "Clothing",
      "Blazer", "Rs 1500", "Oct, 10"),
];

const userdata = userInfo(
    name: "Shehroz",
    totalBalance: "200,000.00",
    inflow: "180,000.00",
    outflow: "70,000",
    transactions: transaction1);
