import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todoapp/api/notification_api.dart';
import 'package:todoapp/database_helper.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/widget/datetimePicker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TaskPage extends StatefulWidget {
  final Task? task;

  const TaskPage({required this.task});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late final LocalNotificationService service;

  String _taskTitle = "";
  String _taskDesc = "";
  int _taskStatus = -1;
  DateTime? _taskDeadline;
  int _taskID = 0;
  int _taskNoti = 0;

  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;
  DatabaseHelper _dbHelper = DatabaseHelper();

  bool contentVisible = false;

  @override
  void initState() {
    service = LocalNotificationService();
    listenToNotification();
    service.intialize();
    if (widget.task != null) {
      _taskTitle = widget.task!.title!;
      //  _taskStatus = widget.task!.status!;
      _taskID = widget.task!.id!;
      if (widget.task!.description != null)
        _taskDesc = widget.task!.description!;
      if (widget.task!.status != null) _taskStatus = widget.task!.status!;
      if (widget.task!.deadline != null)
        _taskDeadline = DateTime.parse(widget.task!.deadline!);
      if (widget.task!.noti != null) _taskNoti = widget.task!.noti!;
      contentVisible = true;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Stack(children: [
            Column(
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
                            child: Image.asset('assets/images/back.png',
                                scale: 20),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            onSubmitted: (value) async {
                              if (value != '') {
                                if (widget.task == null) {
                                  _taskStatus = -1;
                                  Task _newTask = Task(
                                    title: value,
                                    status: -1,
                                    noti: 0,
                                  );
                                  _taskID =
                                      await _dbHelper.insertTask(_newTask);
                                  setState(() {
                                    contentVisible = true;
                                    _taskTitle = value;
                                  });
                                  print('new task has been created');
                                } else {
                                  await _dbHelper.updateTitleTask(
                                    _taskID,
                                    value,
                                  );
                                  print('Task updated');
                                }

                                _descriptionFocus.requestFocus();
                              }
                            },
                            controller: TextEditingController(text: _taskTitle),
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
                        ),
                        InkWell(
                          onTap: () async {
                            
                            setState(() {
                              _taskNoti == 1 ? _taskNoti = 0 : _taskNoti = 1;
                              if (_taskNoti == 1) {
                                service.showScheduledNotification(
                                    id: 0,
                                    title: 'Todo',
                                    body:
                                        'Nhắc nhở! Sắp đến thời gian deadline!',
                                    seconds: (_taskDeadline?.difference((DateTime.now())))!.inSeconds - 600);
                              }
                              _dbHelper.updateNotification(_taskID, _taskNoti);
                            });
                            Fluttertoast.showToast(
                                msg: _taskNoti == 1
                                    ? "Đã bật thông báo"
                                    : "Đã tắt thông báo",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Color(0xFF868290),
                                textColor: Colors.white,
                                fontSize: 16.0);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: _taskNoti == 0
                                ? Image.asset('assets/images/bell_unactive.png',
                                    scale: 20)
                                : Image.asset('assets/images/bell.png',
                                    scale: 20),
                          ),
                        ),
                      ],
                    )),
                Visibility(
                    visible: contentVisible,
                    child: TextField(
                      onSubmitted: ((value) {
                        if (_taskID != 0) {
                          _dbHelper.updateDescriptionTask(_taskID, value);
                        }
                      }),
                      focusNode: _descriptionFocus,
                      controller: TextEditingController(text: _taskDesc),
                      decoration: InputDecoration(
                          hintText: "Enter description for the task..",
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 24.0)),
                    )),
                Visibility(
                  visible: contentVisible,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 50.0, horizontal: 24.0),
                    child: DatetimePickerWidget(
                      dateTime: _taskDeadline,
                      taskID: _taskID,
                    ),
                  ),
                )
              ],
            ),
            Visibility(
                visible: contentVisible,
                child: Positioned(
                  bottom: 32.0,
                  right: 0.0,
                  child: GestureDetector(
                    onTap: () async {
                      if (_taskID != 0) {
                        await _dbHelper.deleteTask(_taskID);
                        Navigator.pop(context);
                      }
                      Fluttertoast.showToast(
                          msg: "Deleted task!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0xFF868290),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    },
                    child: Container(
                      child: Image.asset(
                        'assets/images/delete.png',
                        scale: 9,
                      ),
                    ),
                  ),
                )),
            Visibility(
                visible: contentVisible,
                child: Positioned(
                  bottom: 32.0,
                  left: 0.0,
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        _taskStatus == 1 ? _taskStatus = -1 : _taskStatus = 1;
                      });
                      if (_taskID != 0) {
                        await _dbHelper.updateStatus(_taskID, _taskStatus);
                        print(_taskStatus);
                      }
                      Fluttertoast.showToast(
                                msg: _taskStatus == 1
                                    ? "Đã đánh dấu hoàn thành!"
                                    : "Chế độ chỉnh sửa!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Color(0xFF868290),
                                textColor: Colors.white,
                                fontSize: 16.0);
                    },
                    child: Container(
                      child: _taskStatus == 1
                          ? Image.asset('assets/images/edit.png', scale: 9)
                          : Image.asset('assets/images/check.png', scale: 9),
                    ),
                  ),
                ))
          ]),
        ),
      ),
    );
  }

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNotificationListener);

  void onNotificationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) print('payload $payload');

    //Navigator.push(context, MaterialPageRoute(builder: ((context) => {})));
  }
}
