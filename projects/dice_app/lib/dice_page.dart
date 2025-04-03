import 'dart:math';

import 'package:flutter/material.dart';

class DicePage extends StatefulWidget {
  const DicePage({super.key});

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  var diceNum = 1;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              style: TextButton.styleFrom(),
              onPressed: () {
                setState(() {
                  print('$diceNum  pressed');
                  diceNum = Random().nextInt(6) + 1;
                });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: Image.asset(
                  'assets/images/dice$diceNum.jpg',
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ))
        ],
      ),
    );
  }
}
