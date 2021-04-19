import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'student_model.dart';
const studentDbName = 'students';
class UpdateStudent extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  final index;
  UpdateStudent({Key key, @required this.index}) : super(key: key);
  @override
  _UpdateStudentState createState() => _UpdateStudentState();
}

class _UpdateStudentState extends State<UpdateStudent> {
  
  Box<Student> studentBox = Hive.box<Student>(studentDbName);
  String name;
  String description;
  String pathToImage;
  @override
  initState(){
    super.initState();
    name = studentBox.getAt(widget.index).name;
    description = studentBox.getAt(widget.index).description;
    pathToImage = studentBox.getAt(widget.index).pathToImage;
  }
  onFormSubmit(){
    studentBox.putAt(widget.index,Student(name,description,pathToImage));
    Navigator.of(context).pop();
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
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    initialValue: name,
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
                    initialValue: description,
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