import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
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
                        scale: 12,
                      ),
                    ),
                    TaskCardWidget(title: "Task 1", desc: "Go to sleep"),
                    TaskCardWidget(title: "Task 2", desc: "Go to sleep"),
                    TaskCardWidget(title: "Task 3", desc: "Go to school"),
                  ],
                ),
				 Positioned(
					bottom: 0.0,
					right: 0.0,

                child: Container(
					
                  child: Image.asset(
                        'assets/images/add.png',
                        scale: 12,
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
