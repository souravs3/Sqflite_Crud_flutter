import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_crud/db/db_helper.dart';
import 'package:sqflite_crud/models/task.dart';
import 'package:sqflite_crud/styles/text_style.dart';

class AddScreen extends StatefulWidget {
  final Task? task;
  final Function? updateTask;

  AddScreen({this.task, this.updateTask});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  String? _priority = 'Low';
  DateTime _date = DateTime.now();
  String btnText = 'Add Task';
  String titleText = 'Add Task';

  TextEditingController _dateController = TextEditingController();

  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _name = widget.task!.name!;
      _description = widget.task!.description!;
      _date = widget.task!.date!;
      _priority = widget.task!.priority!;
      setState(() {
        btnText = 'Update Task';
        titleText = 'Update Task';
      });
    }
    _dateController.text = _dateFormatter.format(_date);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  _handleDatePicker() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2200),
    );
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Task task = Task(
        name: _name,
        description: _description,
        date: _date,
        priority: _priority,
      );
      if (widget.task == null) {
        task.status = 0;
        DatabaseHelper.instance.insertTask(task).then((value) {
          if (value > 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Task added successfully')),
            );
            widget.updateTask!();
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add task')),
            );
          }
        });
      } else {
        task.id = widget.task!.id;
        task.status = widget.task!.status;
        DatabaseHelper.instance.updateTask(task).then((value) {
          if (value > 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Task updated successfully')),
            );
            widget.updateTask!();
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to update task')),
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Item',
                  style: titleStyle(),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _name,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        validator: (value) => value!.trim().isEmpty
                            ? 'Please Enter Your Name!'
                            : null,
                        onSaved: (newValue) => _name = newValue!,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        initialValue: _description,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        validator: (value) => value!.trim().isEmpty
                            ? 'Please Enter The Description!'
                            : null,
                        onSaved: (newValue) => _description = newValue!,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        readOnly: true,
                        controller: _dateController,
                        onTap: _handleDatePicker,
                        decoration: InputDecoration(
                          labelText: 'Deadline',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        value: _priority,
                        items: _priorities
                            .map((priority) => DropdownMenuItem(
                                value: priority, child: Text(priority)))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _priority = value.toString()),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: _submit,
                        child: Container(
                          margin: EdgeInsets.only(left: 50, right: 50),
                          alignment: Alignment.center,
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.pink,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            btnText,
                            style: saveButtonStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(titleText, style: titleStyle()),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.pink,
    );
  }
}
