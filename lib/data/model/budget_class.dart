import 'package:hive/hive.dart';

part 'budget_class.g.dart';

@HiveType(typeId: 0)
class Budgetdata extends HiveObject {
  @HiveField(0)
  int budget;
  @HiveField(1)
  int month;
  @HiveField(2)
  int year;

  Budgetdata(
    this.budget,
    this.month,
    this.year,
  );
}
