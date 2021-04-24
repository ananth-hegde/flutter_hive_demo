import 'package:mobx/mobx.dart';
import '../models/teacher_model.dart';
import 'package:hive/hive.dart';
part 'teacher_store.g.dart';
const teacherDbName = 'teachers';
Box<Teacher> teacherBox = Hive.box<Teacher>(teacherDbName);

class TeacherStore = _TeacherStore with _$TeacherStore;
abstract class _TeacherStore with Store{
  @observable
  String name;

  @observable
  String description;

  @observable
  String pathToImage;

  
  @action
  void changeName(String newName){
    name = newName;
  }

  @action
  void changeDescription(String newDesc){
    description = newDesc;
  }

  @action
  void changeImagePath(String newImagePath){
    pathToImage = newImagePath;
  }

  @action
  void clearAll(){
      name='';
      description='';
      pathToImage='';
  }

  @action
  void addTeacher(){
    
      teacherBox.add(Teacher(name, description, pathToImage));
      clearAll();
  }


  @action
  void setDataFromIndex(index){
    name = teacherBox.getAt(index).name;
    description = teacherBox.getAt(index).description;
    pathToImage = teacherBox.getAt(index).pathToImage;
  }

  @action
  void updateTeacher(index){
    teacherBox.putAt(index,Teacher(name,description,pathToImage));
  }
}