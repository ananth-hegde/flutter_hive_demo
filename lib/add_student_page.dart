import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'student_model.dart';
const studentDbName = 'students';
class AddStudent extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  String name;
  String description;
  String pathToImage;
  void onFormSubmit() {
    if (widget.formKey.currentState.validate()) {
      print(pathToImage);
      Box<Student> studentBox = Hive.box<Student>(studentDbName);
      studentBox.add(Student(name, description,pathToImage));
      Navigator.of(context).pop();
    }
  }
  void _uploadImage() async {

    final _picker = ImagePicker();

    var _pickedImage = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      pathToImage = _pickedImage.path;      
    });
    
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
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                  TextFormField(
                    initialValue: "",
                    decoration: const InputDecoration(
                      labelText: "Description",
                    ),
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
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

