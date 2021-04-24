import 'package:flutter/material.dart';
import 'teacher_store.dart';
import 'student_store.dart';
import 'package:image_picker/image_picker.dart';
class Helper{
  var teacherStore = TeacherStore();
  var studentStore = StudentStore();
  // ignore: unused_element
  void showPicker(context,teacherOrStudent){  
    showModalBottomSheet(
      context: context, 
      builder: (BuildContext _){
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallery'),
                  onTap: (){
                    _uploadImage('gallery',teacherOrStudent);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Camera'),
                  onTap: (){
                    _uploadImage('camera',teacherOrStudent);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ),
        );
      }
    );
  }
  void _uploadImage(String type,String teacherOrStudent) async {
    final _picker = ImagePicker();
    var _pickedImage,store;
    if(teacherOrStudent == 'teacher')
      store = teacherStore;
    else
      store = studentStore;
    if(type=='camera')
    {
      _pickedImage = await _picker.getImage(source: ImageSource.camera);
    }
    else{
      _pickedImage = await _picker.getImage(source: ImageSource.gallery);
    }
    if(_pickedImage!=null)
      store.changeImagePath(_pickedImage.path); 
  }
}