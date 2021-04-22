import 'package:mobx/mobx.dart';

part 'teacher_store.g.dart';

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

}