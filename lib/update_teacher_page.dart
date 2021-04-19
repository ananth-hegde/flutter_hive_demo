import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'teacher_model.dart';
import 'package:image_picker/image_picker.dart';
const teacherDbName = 'teachers';

class UpdateTeacher extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  final index;
  UpdateTeacher({Key key, @required this.index}) : super(key: key);
  @override
  _UpdateTeacherState createState() => _UpdateTeacherState();
}

class _UpdateTeacherState extends State<UpdateTeacher> {
  
  Box<Teacher> teacherBox = Hive.box<Teacher>(teacherDbName);
  String name;
  String description;
  String pathToImage;
  @override
  initState(){
    super.initState();
    name = teacherBox.getAt(widget.index).name;
    description = teacherBox.getAt(widget.index).description;
    pathToImage = teacherBox.getAt(widget.index).pathToImage;
  }
  onFormSubmit(){

    teacherBox.putAt(widget.index,Teacher(name,description,pathToImage));
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

