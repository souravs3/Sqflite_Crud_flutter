import 'dart:math';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_crud/db/db_helper.dart';
import 'package:sqflite_crud/models/task.dart';
import 'package:sqflite_crud/screens/add_screen.dart';
import 'package:sqflite_crud/styles/button_style.dart';
import 'package:sqflite_crud/styles/text_style.dart';

class HomeScreen extends StatefulWidget {
  final Task? task;
  HomeScreen({this.task});
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Task>> _taskList;

  // DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  final DateFormat _dateFormatter = DateFormat('MMM dd, yyy');

  _deleteTask(Task task) {
    DatabaseHelper.instance.deleteTask(task.id!).then((value) {
      _updateTaskList(); // Update task list after deletion is successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }).catchError((error) {
      // Handle any errors that occur during deletion
      print("Error deleting task: $error");
      // Optionally show an error message to the user
    });
  }

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  Future<void> _updateTaskList() async {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  // Create the card function
  Widget _buildTask(Task task) {
    return GestureDetector(
      child: Slidable(
        endActionPane: ActionPane(motion: BehindMotion(), children: [
          SlidableAction(
            backgroundColor: Colors.red,
            autoClose: true,
            icon: Icons.delete,
            label: 'Delete',
            onPressed: (context) => _deleteTask(task),
          )
        ]),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(task.name!,
                            // style: titleStyle(),
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    letterSpacing: 5,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Colors.white))),
                        Text(
                          'Completed',
                          style: task.status == 0
                              ? GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.transparent))
                              : GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      letterSpacing: 5,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.white)),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        child: Text(
                          task.description!,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              letterSpacing: 3,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                              // decoration: task.status == 0
                              //     ? TextDecoration.none
                              //     : TextDecoration.lineThrough,
                            ),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Text(
                      '${_dateFormatter.format(task.date!)} - ${task.priority}',
                      style: btntextStyle(),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  VerticalDivider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                  Column(
                    children: [
                      Checkbox(
                        onChanged: (value) {
                          task.status = value! ? 1 : 0;
                          DatabaseHelper.instance.updateTask(task);
                          _updateTaskList();
                        },
                        activeColor: Colors.black,
                        value: task.status == 1,
                        shape: CircleBorder(),
                        checkColor: Colors.white,
                      ),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          'Todo',
                          style: btntextStyle(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          margin: EdgeInsets.only(top: 30),
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddScreen(
            updateTask: _updateTaskList,
            task: task,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            _topBarSection(context),
            _calenderSection(),
            Expanded(
              child: FutureBuilder(
                future: _taskList,
                builder: (context, AsyncSnapshot<List<Task>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) =>
                        _buildTask(snapshot.data![index]),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _calenderSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: Colors.pink,
        selectedTextColor: Colors.white,
        dateTextStyle: TextStyle(fontSize: 16),
        monthTextStyle: selectedColenderMonth(),
        dayTextStyle: selectedColenderDay(),
      ),
    );
  }

  Row _topBarSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: dateStyle(),
            ),
            Text(
              'Today',
              style: titleStyle(),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddScreen(
                updateTask: _updateTaskList,
              ),
            ),
          ),
          child: addButton(),
        ),
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      actions: [
        Container(
          margin: EdgeInsets.only(right: 20),
          child: CircleAvatar(
            backgroundImage: AssetImage('images/girl.jpg'),
            radius: 23,
          ),
        )
      ],
      title: Text(
        'TODO',
        style: titleStyle(),
      ),
    );
  }
}
