import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'teacher_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'dart:io';
import 'teacher_store.dart';
const teacherDbName = 'teachers';

final teacherStore = TeacherStore();

class UpdateTeacher extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  final index;
  UpdateTeacher({Key key, @required this.index}) : super(key: key);
  @override
  _UpdateTeacherState createState() => _UpdateTeacherState();
}

class _UpdateTeacherState extends State<UpdateTeacher> {
  
  Box<Teacher> teacherBox = Hive.box<Teacher>(teacherDbName);
  
  @override
  initState(){
    super.initState();
    teacherStore.name = teacherBox.getAt(widget.index).name;
    teacherStore.description = teacherBox.getAt(widget.index).description;
    teacherStore.pathToImage = teacherBox.getAt(widget.index).pathToImage;
  }
  onFormSubmit(){

    teacherBox.putAt(widget.index,Teacher(teacherStore.name,teacherStore.description,teacherStore.pathToImage));
    Navigator.of(context).pop();
  }

  void _uploadImage() async {

    final _picker = ImagePicker();

    var _pickedImage = await _picker.getImage(source: ImageSource.gallery);

    teacherStore.changeImagePath(_pickedImage.path);
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: widget.formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    initialValue: teacherStore.name,
                    decoration: const InputDecoration(
                      labelText: "Name",
                    ),
                    onChanged: (value) {
                      teacherStore.changeName(value);
                    },
                  ),
                  TextFormField(
                    initialValue: teacherStore.description,
                    decoration: const InputDecoration(
                      labelText: "Description",
                    ),
                    onChanged: (value) {
                      teacherStore.changeDescription(value);
                    },
                  ),
                  Observer(
                    builder: (_){
                      if(teacherStore.pathToImage!=null)
                      {
                        File f = File(teacherStore.pathToImage);
                      print(f.existsSync());
                        if(f.existsSync()==true)
                        {
                          return Center(
                            child: Image.file(
                                    File(teacherStore.pathToImage),
                                    fit: BoxFit.cover,
                                    height: 150.0,
                                    width: 150.0,
                                    
                                  ),
                          );
                        }
                        else
                        return Container(
                          child: Text(''),
                        );
                      }
                      else
                        return Container(
                          child: Text(''),
                        );
                    }
                  ),
                  TextButton(
                    child: Center(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Upload image'),
                      
                    )),
                    onPressed: _uploadImage,
                  ),
                  OutlinedButton(
                    child: Text("Update"),
                    onPressed: onFormSubmit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      
    );
  }
}

