import 'package:mobx/mobx.dart';

part 'student_store.g.dart';

class StudentStore = _StudentStore with _$StudentStore;

abstract class _StudentStore with Store{
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