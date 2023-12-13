import 'package:hive/hive.dart';

part 'add_date.g.dart';

@HiveType(typeId: 1)
class Add_data extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String explain;
  @HiveField(2)
  String amount;
  @HiveField(3)
  String IN;
  @HiveField(4)
  DateTime datetime;
  Add_data(this.IN, this.amount, this.datetime, this.explain, this.name);

  // Deserialize from a Map<String, dynamic>
  // factory Add_data.fromJson(Map<String, dynamic> json) {
  // return Add_data(
  //  json['type'] as String,
  //  json['amount']
  //      .toString(), // Assuming amount is a number, so convert to String
  //   DateTime.parse(json['date'] as String),
  //  json['explanation'] as String,
  //   json['category'] as String, // Adjust the key based on your data
  // );
  // }

  // Serialize to a Map<String, dynamic>
//  Map<String, dynamic> toJson() {
//    return {
//      'IN': IN,
//      'amount': amount,
//      'datetime': datetime.toIso8601String(),
//      'explain': explain,
//      'name': name,
//    };
  // }
}
