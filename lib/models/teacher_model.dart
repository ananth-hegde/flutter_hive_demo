import 'package:hive/hive.dart';
part 'teacher_model.g.dart';
@HiveType(typeId: 0)
class Teacher extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  String pathToImage;

  Teacher(this.name,this.description,this.pathToImage);
  
  String toString() => name; // For print()
}
