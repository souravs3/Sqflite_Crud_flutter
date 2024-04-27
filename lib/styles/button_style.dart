import 'package:flutter/material.dart';
import 'package:sqflite_crud/styles/text_style.dart';

addButton() {
  return Container(
    width: 120,
    height: 40,
    child: Center(
        child: Text(
      '+ Add Task',
      style: btntextStyle(),
    )),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), color: Colors.pink),
  );
}

saveButton() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 50),
    child: Center(
        child: Text(
      'Save',
      style: saveButtonStyle(),
    )),
    height: 60,
    width: double.infinity,
    decoration: BoxDecoration(
        color: Colors.pink, borderRadius: BorderRadius.circular(20)),
  );
}
