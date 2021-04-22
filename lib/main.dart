import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/teacher_model.dart';
import 'models/student_model.dart';
import 'ui/home_page.dart';
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



/**
 * TODO: remove ambiguity. separate ui and store. create the repo for boxes. navigation
*/