import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'dart:io';
import 'functions.dart';
import 'teacher_store.dart';
class AddUpdateTeacher extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  final int index;
  final String addOrUpdate;
  AddUpdateTeacher(this.addOrUpdate,{this.index});
  @override
  _AddUpdateTeacherState createState() => _AddUpdateTeacherState();
}

class _AddUpdateTeacherState extends State<AddUpdateTeacher> {
  var helper,teacherStore,buttonText;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    helper = Helper();
    teacherStore = TeacherStore();
    if(widget.addOrUpdate=='add')
    {
      buttonText = 'Add';
    }
    else
    {
      buttonText = 'Update';
      teacherStore.setDataFromIndex(widget.index);
    }
  }
  void onFormSubmit() {
    if (widget.formKey.currentState.validate()) {
      if(widget.addOrUpdate=='add')
        teacherStore.addTeacher();
      else
        teacherStore.updateTeacher(widget.index);
      Navigator.of(context).pop();
    }
  }

  void updateImagePath(String path){
    teacherStore.changeImagePath(path); 
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