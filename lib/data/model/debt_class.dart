import 'package:hive/hive.dart';

part 'debt_class.g.dart';

@HiveType(typeId: 3)
class Debtclass extends HiveObject {
  @HiveField(0)
  String debtto;
  @HiveField(1)
  int amount;
  @HiveField(2)
  DateTime dt;

  Debtclass(this.debtto, this.amount, this.dt);
}
