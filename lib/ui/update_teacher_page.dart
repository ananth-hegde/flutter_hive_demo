import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'dart:io';
import '../repositories/teacher_store.dart';
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
  
  
  @override
  initState(){
    super.initState();
    teacherStore.setDataFromIndex(widget.index);
  }
  onFormSubmit(){

    teacherStore.updateTeacher(widget.index);
    Navigator.of(context).pop();
  }

  void _showPicker(context){
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
                    _uploadImage('gallery');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Camera'),
                  onTap: (){
                    _uploadImage('camera');
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

  void _uploadImage(String type) async {
    var _pickedImage;
    
    final _picker = ImagePicker();
    if(type=='camera')
    {
      _pickedImage = await _picker.getImage(source: ImageSource.camera);
    }
    else{
      _pickedImage = await _picker.getImage(source: ImageSource.gallery);
    }
    if(_pickedImage!=null)
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
                    onPressed: (){
                      _showPicker(context);
                    },
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

