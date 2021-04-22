import 'package:mobx/mobx.dart';
import '../models/student_model.dart';
import 'package:hive/hive.dart';
part 'student_store.g.dart';

Box<Student> studentBox = Hive.box<Student>(studentDbName);
const studentDbName = 'students'; 
class StudentStore = _StudentStore with _$StudentStore;

abstract class _StudentStore with Store{
  @observable
  String name='';

  @observable
  String description='';

  @observable
  String pathToImage='';

  
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
  void setDataFromIndex(index){
    name = studentBox.getAt(index).name;
    description = studentBox.getAt(index).description;
    pathToImage = studentBox.getAt(index).pathToImage;
  }
  @action
  void clearAll(){
    name = '';
    description = '';
    pathToImage = '';
  }
  @action
  void addStudent(){
    studentBox.add(Student(name, description,pathToImage));
    clearAll();
  }

  @action
  void updateStudent(index){
    studentBox.putAt(index,Student(name,description,pathToImage));
    clearAll();
  }
}