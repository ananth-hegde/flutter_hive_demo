import 'package:flutter/material.dart';
import 'functions.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'dart:io';
import 'student_store.dart';

class AddUpdateStudent extends StatefulWidget {
  final String addOrUpdate;
  final int index;
  AddUpdateStudent(this.addOrUpdate,{this.index});

  final formKey = GlobalKey<FormState>();
  @override
  _AddUpdateStudentState createState() => _AddUpdateStudentState();
}

class _AddUpdateStudentState extends State<AddUpdateStudent> {
  var studentStore,helper,buttonText;
  @override
  void initState() {
    super.initState();
    if(widget.addOrUpdate=='add')
      buttonText = 'Add';
    else
      buttonText = 'Update';
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    helper = Helper();
    studentStore = StudentStore();
  }

  void updateImagePath(String path){
    studentStore.changeImagePath(path); 
  }
  void onFormSubmit() {
    if (widget.formKey.currentState.validate()) {
      if(widget.addOrUpdate=='add') 
        studentStore.addStudent();
      else
        studentStore.updateStudent(widget.index);
      Navigator.of(context).pop();
    }
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
                    onPressed: (){
                      helper.showPicker(context,updateImagePath);
                    },
                  ),
                  OutlinedButton(
                    child: Text(buttonText),
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
