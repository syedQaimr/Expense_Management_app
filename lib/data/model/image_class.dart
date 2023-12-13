import 'package:hive/hive.dart';

part 'image_class.g.dart';

@HiveType(typeId: 2)
class Imageclass extends HiveObject {
  @HiveField(0)
  String image;

  Imageclass(this.image);
}
