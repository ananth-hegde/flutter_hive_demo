import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/teacher_model.dart';
import 'dart:io';
import 'add_update_teacher_page.dart';

const teacherDbName = 'teachers';

class TeacherPage extends StatefulWidget {
  
  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Demo - Teachers'),
      ),
      body: Center(
        child: ValueListenableBuilder(
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
                              Text(
                                'Name: ' + currentTeacher.name,
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Description: ' + currentTeacher.description,
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
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
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      AddUpdateTeacher('update',index: index)));
                            },
                            child: Icon(Icons.edit),
                          ),
                          ElevatedButton(
                            onPressed: () async {
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddUpdateTeacher('add')));
        },
      ),
    );
  }
}
