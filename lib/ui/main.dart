import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/teacher_model.dart';
import '../models/student_model.dart';
import 'dart:io';
import 'update_teacher_page.dart';
import 'student_page.dart';
import 'add_teacher_page.dart';
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


/**
 * TODO: remove ambiguity. separate ui and store. create the repo for boxes. navigation
*/