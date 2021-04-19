import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'teacher_model.dart';
import 'student_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
const teacherDbName = 'teachers';
const studentDbName = 'students';
Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TeacherAdapter()); 
  Hive.registerAdapter(StudentAdapter());
  await Hive.openBox<Teacher>(teacherDbName);
  await Hive.openBox<Student>(studentDbName);  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Hive Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child:  ValueListenableBuilder(
          valueListenable: Hive.box<Teacher>(teacherDbName).listenable(),
          builder: (context, Box<Teacher> box, _) {
            if (box.values.isEmpty)
              return Center(
                child: Text("No Teachers"),
              );
            return ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                Teacher currentTeacher = box.getAt(index);
                return Card(
                  clipBehavior: Clip.antiAlias, 
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 5),
                            
                              Text('Name: ' + currentTeacher.name,
                              style: TextStyle(
                                fontSize: 20.0,
                              ),),
                              SizedBox(height: 5),
                              Text('Description: ' + currentTeacher.description,
                              style: TextStyle(
                                fontSize: 20.0,
                              ),),
                              SizedBox(height: 5),
                              Image.file(
                                File(currentTeacher.pathToImage),
                                fit: BoxFit.cover,
                                height: 150.0,
                                width: 150.0,
                                
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateTeacher(index: index)));
                            },
                            child: Icon(Icons.edit),
                          ),
                          ElevatedButton(
                            onPressed: () async{
                              await box.deleteAt(index);
                            },
                            child: Icon(Icons.delete),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),

        ),
        drawer: Drawer(
        child: ListView(
    // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
              color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Teachers'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Students'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => StudentPage()));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddTeacher()));
              },
            );
          }
      ),
    );
  }
}


class ImageInputAdapter {
  /// Initialize from either a URL or a file, but not both.
  ImageInputAdapter({
    this.file,
    this.url
  });

  /// An image file
  final File file;
  /// A direct link to the remote image
  final String url;

  /// Render the image from a file or from a remote source.
  Widget widgetize() {
    if (file != null) {
      return Image.file(file);
    } else {
      return FadeInImage(
        image: NetworkImage(url),
        placeholder: AssetImage("assets/images/placeholder.png"),
        fit: BoxFit.contain,
      );
    }
  }
}

class AddTeacher extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  
  @override
  _AddTeacherState createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  String name;
  String description;
  String pathToImage;
  void onFormSubmit() {
    if (widget.formKey.currentState.validate()) {
      print(pathToImage);
      Box<Teacher> teacherBox = Hive.box<Teacher>(teacherDbName);
      teacherBox.add(Teacher(name, description,pathToImage));
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


class StudentPage extends StatefulWidget {
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Demo - Students'),
      ),
      body: Center(
          child:  ValueListenableBuilder(
          valueListenable: Hive.box<Student>(studentDbName).listenable(),
          builder: (context, Box<Student> box, _) {
            if (box.values.isEmpty)
              return Center(
                child: Text("No Students"),
              );
            return ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                Student currentStudent = box.getAt(index);
                return Card(
                  clipBehavior: Clip.antiAlias, 
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 5),
                            
                              Text('Name: ' + currentStudent.name,
                              style: TextStyle(
                                fontSize: 20.0,
                              ),),
                              SizedBox(height: 5),
                              Text('Description: ' + currentStudent.description,
                              style: TextStyle(
                                fontSize: 20.0,
                              ),),
                              SizedBox(height: 5),
                              Image.file(
                                File(currentStudent.pathToImage),
                                fit: BoxFit.cover,
                                height: 150.0,
                                width: 150.0,
                                
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateStudent(index: index)));
                            },
                            child: Icon(Icons.edit),
                          ),
                          ElevatedButton(
                            onPressed: () async{
                              await box.deleteAt(index);
                            },
                            child: Icon(Icons.delete),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),

        ),
        drawer: Drawer(
        child: ListView(
    // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
              color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Teachers'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage(title:'Flutter Hive Demo : Teacher')));
                
              },
            ),
            ListTile(
              title: Text('Students'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddStudent()));
              },
            );
          }
      ),
    );
  }
}

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