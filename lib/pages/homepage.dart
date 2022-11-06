import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/database_helper.dart';
import 'package:todoapp/pages/taskpage.dart';
import 'package:todoapp/widget/taskCard.dart';

enum SampleItem { getAllTasks, getTodayTasks, getUpcomingTasks }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  SampleItem? selectedMenu;

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
                  Row(
					children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: 100,
                        margin: EdgeInsets.only(bottom: 32.0, left: 0),
                        child: Image.asset(
                          'assets/images/logo.png',
                          scale: 8,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.only(right: 0),
                        child: PopupMenuButton<SampleItem>(
                          initialValue: selectedMenu,
                          // Callback that sets the selected popup menu item.
                          onSelected: (SampleItem item) {
                            setState(() {
                              selectedMenu = item;
                            });
							print(selectedMenu);

                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<SampleItem>>[
                            const PopupMenuItem<SampleItem>(
                              value: SampleItem.getAllTasks,
                              child: Text('All'),
                            ),
                            const PopupMenuItem<SampleItem>(
                              value: SampleItem.getTodayTasks,
                              child: Text('Today'),
                            ),
                            const PopupMenuItem<SampleItem>(
                              value: SampleItem.getUpcomingTasks,
                              child: Text('Upcoming'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
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
                                ).then((value) {
                                  setState(() {});
                                });
                              },
                              child:  TaskCardWidget(
                                title: snapshot.data![index].title,
                                desc: snapshot.data![index].description,
                                status: snapshot.data![index].status,
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
                      MaterialPageRoute(
                          builder: (context) => TaskPage(task: null)),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    child: Image.asset(
                      'assets/images/add.png',
                      scale: 9,
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
