import 'package:flutter/material.dart';
import 'package:pulse/pulse.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _colors = [
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.lightBlue,
    Colors.purple,
    Colors.deepPurple,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Pulse(
        pulseColor: _colors.first,
        onComplete: () {
          setState(() {
            final _color = _colors.first;

            _colors.remove(_color);
            _colors.add(_color);
          });
        },
      ),
    );
  }
}
