import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/database_helper.dart';
import 'package:todoapp/pages/taskpage.dart';
import 'package:todoapp/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          color: Color(0xFFF6F6F6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 32.0),
                    child: Image.asset(
                      'assets/images/logo.png',
                      scale: 8,
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTaks(),
                      builder: ((context, snapshot) {
                        return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskPage(
                                           task: snapshot.data?[index],
                                        ),
                                  ),
                                );
                              },
                              child: TaskCardWidget(
                                title: snapshot.data![index].title,
                              ),
                            );
                          },

                        );
                      }),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 32.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TaskPage(task: null)),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    child: Image.asset(
                      'assets/images/add.png',
                      scale: 12,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
