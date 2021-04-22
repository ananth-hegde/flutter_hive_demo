import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'dart:io';
import '../repositories/student_store.dart';

const studentDbName = 'students';
final studentStore = StudentStore();
class UpdateStudent extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  final index;
  UpdateStudent({Key key, @required this.index}) : super(key: key);
  @override
  _UpdateStudentState createState() => _UpdateStudentState();
}

class _UpdateStudentState extends State<UpdateStudent> {
  
  @override
  initState(){
    super.initState();
    studentStore.setDataFromIndex(widget.index);
  }
  _onFormSubmit(){
    studentStore.updateStudent(widget.index);
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

    final _picker = ImagePicker();
    var _pickedImage;
    if(type=='camera')
    { 
      _pickedImage = await _picker.getImage(source: ImageSource.camera);
    }
    else
    {
      _pickedImage = await _picker.getImage(source: ImageSource.gallery);
    }
    if(_pickedImage!=null)
       studentStore.changeImagePath(_pickedImage.path);
    
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
                    initialValue: studentStore.name,
                    decoration: const InputDecoration(
                      labelText: "Name",
                    ),
                    onChanged: (value) {
                      studentStore.changeName(value);
                    },
                  ),
                  TextFormField(
                    initialValue: studentStore.description,
                    decoration: const InputDecoration(
                      labelText: "Description",
                    ),
                    onChanged: (value) {
                      studentStore.changeDescription(value);
                    },
                  ),
                  Observer(
                    builder: (_){
                      if(studentStore.pathToImage!=null)
                      {
                        File f = File(studentStore.pathToImage);
                      print(f.existsSync());
                        if(f.existsSync()==true)
                        {
                          return Center(
                            child: Image.file(
                                    File(studentStore.pathToImage),
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
                    onPressed: _onFormSubmit,
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