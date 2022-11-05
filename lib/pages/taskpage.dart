import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todoapp/database_helper.dart';
import 'package:todoapp/models/task.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 24.0,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child:
                              Image.asset('assets/images/back.png', scale: 20),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          onSubmitted: (value) async {
                            if (value != '') {
                              DatabaseHelper _dbHelper = DatabaseHelper();

                              Task _newTask = Task(title: value);
                              await _dbHelper.insertTask(_newTask);
                              print('new task has been created');
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Task Title",
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF211551),
                          ),
                        ),
                      )
                    ],
                  )),
              TextField(
                decoration: InputDecoration(
                    hintText: "Enter Description for the task..",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 24.0)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
