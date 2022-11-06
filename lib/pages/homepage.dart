import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/api/notification_api.dart';
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

  SampleItem selectedMenu = SampleItem.getAllTasks;
  String searchText = '';
  var listTaskCards = [];
  var listTaskCardsSearch = [];
  TextEditingController controller = new TextEditingController();

  late final LocalNotificationService service;

  @override
  void initState() {
    // TODO: implement initState
    service = LocalNotificationService();
    listenToNotification();
    service.intialize();
    super.initState();
  }

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
                  Row(children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: 100,
                        margin: EdgeInsets.only(bottom: 10.0, left: 0),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: onSearchTextChanged,
                      controller: controller,
                      decoration: InputDecoration(
                          labelText: "Search",
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)))),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTaks(),
                      builder: ((context, snapshot) {
                        var listToday = [];
                        var listUpcoming = [];
                        if (snapshot.data!.length != null) {
                          for (var i = 0; i < snapshot.data!.length; i++)
                            if (snapshot.data?[i].deadline != null) {
                              if (DateTime.now()
                                      .difference(DateTime.parse(
                                          snapshot.data?[i].deadline))
                                      .inDays ==
                                  0) {
                                listToday.add(snapshot.data?[i]);
                             
                              } else if (DateTime.now()
                                      .difference(DateTime.parse(
                                          snapshot.data?[i].deadline))
                                      .inDays <
                                  0) listUpcoming.add(snapshot.data?[i]);
                            }
                          switch (selectedMenu) {
                            case SampleItem.getAllTasks:
                              {
                                listTaskCards = [...snapshot.data!];
                                break;
                              }
                            case SampleItem.getTodayTasks:
                              {
                                listTaskCards = [...listToday];
                                break;
                              }
                            case SampleItem.getUpcomingTasks:
                              {
                                listTaskCards = [...listUpcoming];
                                break;
                              }
                          }
                        }
                        return listTaskCardsSearch.length != 0 ||
                                controller.text.isNotEmpty
                            ? ListView.builder(
                                itemCount: listTaskCardsSearch.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TaskPage(
                                              task: listTaskCardsSearch[index],
                                            ),
                                          ),
                                        ).then((value) {
                                          setState(() {});
                                        });
                                      },
                                      child: TaskCardWidget(
                                        title: listTaskCardsSearch[index].title,
                                        desc: listTaskCardsSearch[index]
                                            .description,
                                        status:
                                            listTaskCardsSearch[index].status,
                                        deadline:
                                            listTaskCardsSearch[index].deadline,
                                      ));
                                },
                              )
                            : ListView.builder(
                                itemCount: listTaskCards.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TaskPage(
                                              task: listTaskCards[index],
                                            ),
                                          ),
                                        ).then((value) {
                                          setState(() {});
                                        });
                                      },
                                      child: TaskCardWidget(
                                        title: listTaskCards[index].title,
                                        desc: listTaskCards[index].description,
                                        status: listTaskCards[index].status,
                                        deadline: listTaskCards[index].deadline,
                                      ));
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
                  onTap: () async {
					
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskPage(task: null)),
                    ).then((value) {
                      setState(() {});
                    });
                    // NotificationApi.showNotification(
                    // 	title: 'aa',
                    // 	body: 'bbbb',
                    // );
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

  onSearchTextChanged(String text) async {
    listTaskCardsSearch.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    listTaskCards.forEach((task) {
      if ((task.title != null && task.title.contains(text)) ||
          (task.description != null && task.description.contains(text)))
        listTaskCardsSearch.add(task);
    });

    setState(() {});
  }

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNotificationListener);

  void onNotificationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) print('payload $payload');

    //Navigator.push(context, MaterialPageRoute(builder: ((context) => {})));
  }
}
