import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'teacher_model.dart';
import 'package:image_picker/image_picker.dart';
import 'teacher_store.dart';
const teacherDbName = 'teachers';


final teacherStore = TeacherStore();
class AddTeacher extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  
  @override
  _AddTeacherState createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  
  void onFormSubmit() {
    if (widget.formKey.currentState.validate()) {
      
      Box<Teacher> teacherBox = Hive.box<Teacher>(teacherDbName);
      teacherBox.add(Teacher(teacherStore.name, teacherStore.description,teacherStore.
      pathToImage));
      Navigator.of(context).pop();
    }
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    initialValue: "",
                    decoration: const InputDecoration(
                      labelText: "Name",
                    ),
                    onChanged: (value) {
                      teacherStore.changeName(value);
                    },
                  ),
                  TextFormField(
                    initialValue: "",
                    decoration: const InputDecoration(
                      labelText: "Description",
                    ),
                    onChanged: (value) {
                      teacherStore.changeDescription(value);
                    },
                  ),
                  TextButton(
                    child: Center(child: Padding(
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