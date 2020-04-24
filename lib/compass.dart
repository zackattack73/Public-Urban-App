import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Compass extends StatefulWidget {
  @override
  _CompassState createState() => new _CompassState();
}

class _CompassState extends State<Compass> {
  double _direction;

  @override
  void initState() {
    super.initState();
    FlutterCompass.events.listen((double direction) {
      if (mounted){
        setState(() {
          _direction = direction;
          print(direction);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Flutter Compass'),
        ),
        body: new Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: new Transform.rotate(
            angle: ((_direction ?? 0) * (math.pi / 180) * -1),
            child: new Image.asset('lib/assets/compass.jpg'),
          ),
        ),
      ),
    );
  }
}