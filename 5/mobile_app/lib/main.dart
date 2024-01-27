import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Електронне табло',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ClockScreen(),
    );
  }
}

class ClockScreen extends StatefulWidget {
  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  late String _currentTime;

  @override
  void initState() {
    super.initState();
    _updateTime();
    Timer.periodic(const Duration(seconds: 1), (Timer timer) => _updateTime());
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PixelatedDigit(_currentTime[0]),
                const SizedBox(width: 5),
                PixelatedDigit(_currentTime[1]),
                const SizedBox(width: 5),
                PixelatedColon(),
                const SizedBox(width: 5),
                PixelatedDigit(_currentTime[3]),
                const SizedBox(width: 5),
                PixelatedDigit(_currentTime[4]),
                const SizedBox(width: 5),
                PixelatedColon(),
                const SizedBox(width: 5),
                PixelatedDigit(_currentTime[6]),
                const SizedBox(width: 5),
                PixelatedDigit(_currentTime[7]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PixelatedDigit extends StatelessWidget {
  final String digit;

  PixelatedDigit(this.digit);

  @override
  Widget build(BuildContext context) {
    List<List<int>> pixelMatrix1 =
        List.from(digitMatrices[int.parse(digit[0])]);

    return Row(children: [
      Column(
        children: [
          for (int i = 0; i < pixelMatrix1.length; i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int j = 0; j < pixelMatrix1[i].length; j++)
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: pixelMatrix1[i][j] == 1
                          ? Colors.red
                          : Colors.transparent,
                      border: pixelMatrix1[i][j] == 1
                          ? Border.all(color: Colors.black, width: 0.5)
                          : null,
                    ),
                  ),
              ],
            ),
        ],
      ),
    ]);
  }
}

class PixelatedColon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<List<int>> pixelMatrix = List.from(digitMatrices[10]);

    return Column(
      children: [
        for (int i = 0; i < pixelMatrix.length; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int j = 0; j < pixelMatrix[i].length; j++)
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: pixelMatrix[i][j] == 1
                        ? Colors.red
                        : Colors.transparent,
                    border: pixelMatrix[i][j] == 1
                        ? Border.all(color: Colors.black, width: 0.5)
                        : null,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

final List<List<List<int>>> digitMatrices = [
  // 0
  [
    [1, 1, 1],
    [1, 0, 1],
    [1, 0, 1],
    [1, 0, 1],
    [1, 1, 1],
  ],
  // 1
  [
    [0, 1, 0],
    [0, 1, 0],
    [0, 1, 0],
    [0, 1, 0],
    [0, 1, 0],
  ],
  // 2
  [
    [1, 1, 1],
    [0, 0, 1],
    [1, 1, 1],
    [1, 0, 0],
    [1, 1, 1],
  ],
  // 3
  [
    [1, 1, 1],
    [0, 0, 1],
    [1, 1, 1],
    [0, 0, 1],
    [1, 1, 1],
  ],
  // 4
  [
    [1, 0, 1],
    [1, 0, 1],
    [1, 1, 1],
    [0, 0, 1],
    [0, 0, 1],
  ],
  // 5
  [
    [1, 1, 1],
    [1, 0, 0],
    [1, 1, 1],
    [0, 0, 1],
    [1, 1, 1],
  ],
  // 6
  [
    [1, 1, 1],
    [1, 0, 0],
    [1, 1, 1],
    [1, 0, 1],
    [1, 1, 1],
  ],
  // 7
  [
    [1, 1, 1],
    [0, 0, 1],
    [0, 0, 1],
    [0, 0, 1],
    [0, 0, 1],
  ],
  // 8
  [
    [1, 1, 1],
    [1, 0, 1],
    [1, 1, 1],
    [1, 0, 1],
    [1, 1, 1],
  ],
  // 9
  [
    [1, 1, 1],
    [1, 0, 1],
    [1, 1, 1],
    [0, 0, 1],
    [1, 1, 1],
  ],
  // Colon
  [
    [0, 0, 0],
    [0, 1, 0],
    [0, 0, 0],
    [0, 1, 0],
    [0, 0, 0],
  ],
];
