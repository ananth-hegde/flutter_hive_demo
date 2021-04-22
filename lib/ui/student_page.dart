import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/student_model.dart';
import 'dart:io';
import 'add_student_page.dart';
import 'update_student_page.dart';
import 'main.dart';
const studentDbName = 'students';
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
