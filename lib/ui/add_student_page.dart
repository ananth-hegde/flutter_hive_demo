import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import '../models/student_model.dart';
import '../repositories/student_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'dart:io';

final studentStore = StudentStore();

class AddStudent extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  void onFormSubmit() {
    if (widget.formKey.currentState.validate()) {
      studentStore.addStudent();
      Navigator.of(context).pop();
    }
  }

  void _uploadImage() async {
    final _picker = ImagePicker();
    var _pickedImage = await _picker.getImage(source: ImageSource.gallery);
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    initialValue: "",
                    decoration: const InputDecoration(
                      labelText: "Name",
                    ),
                    onChanged: (value) {
                      studentStore.changeName(value);
                    },
                  ),
                  TextFormField(
                    initialValue: "",
                    decoration: const InputDecoration(
                      labelText: "Description",
                    ),
                    onChanged: (value) {
                      studentStore.changeDescription(value);
                    },
                  ),
                  Observer(builder: (_) {
                    if (studentStore.pathToImage != null) {
                      File f = File(studentStore.pathToImage);
                      print(f.existsSync());
                      if (f.existsSync() == true) {
                        return Center(
                          child: Image.file(
                            File(studentStore.pathToImage),
                            fit: BoxFit.cover,
                            height: 150.0,
                            width: 150.0,
                          ),
                        );
                      } else
                        return Container(
                          child: Text(''),
                        );
                    } else
                      return Container(
                        child: Text(''),
                      );
                  }),
                  TextButton(
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Upload image'),
                    )),
                    onPressed: _uploadImage,
                  ),
                  OutlinedButton(
                    child: Text("Submit"),
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
