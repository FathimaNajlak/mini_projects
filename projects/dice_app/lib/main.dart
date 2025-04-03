import 'package:dice_app/dice_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Colors.green[900],
      appBar: AppBar(
        title: Text(
          'Roll the Dice',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.green[900],
        centerTitle: true,
      ),
      body: DicePage(),
    ),
  ));
}
