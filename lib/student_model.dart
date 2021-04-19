import 'package:hive/hive.dart';
part 'student_model.g.dart';
@HiveType(typeId: 1)
class Student extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  String pathToImage;

  Student(this.name,this.description,this.pathToImage);
  
  String toString() => name; // For print()
}
