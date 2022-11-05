import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TaskCardWidget extends StatelessWidget {
    final String title;
    final String desc;
  TaskCardWidget({ required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 32.0,
        horizontal: 24.0,
      ),
      margin: EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: Color(0xFFFFE082),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            this.title,
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 10.0,
            ),
            child: Text(
               this.desc ?? "No Description",
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF868290),
                height: 1.5,
              ),
            ),
          )
        ],
      ),
    );
  }
}