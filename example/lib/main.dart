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
  Color _oldBgColor;
  var _bgColor = Colors.black;
  var _pulseColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Pulse(
        child: Center(child: Text('Ok')),
        pulseColor: _pulseColor,
        onTap: () {
          if (_oldBgColor != null) {
            setState(() {
              _pulseColor = _oldBgColor;
            });
          }
        },
        onComplete: () {
          _oldBgColor = _bgColor;

          setState(() {
            _oldBgColor = _bgColor;
            _bgColor = _pulseColor;
          });
        },
      ),
    );
  }
}
