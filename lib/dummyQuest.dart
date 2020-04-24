import 'package:flutter/material.dart';
import 'dart:math' as math;

class Dummy extends StatefulWidget {
  final int type;
  Dummy({Key key, @required this.type}) : super(key: key);
  @override
  BodyLayout createState() => new BodyLayout(type);
}

class BodyLayout extends State<Dummy> {
  double _sliderValue = 10.0;
  int type;
  List datarep = [];
  List dataquest = [];
  BodyLayout(this.type);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text('Test questionnaire'),
      ),
      body: type < 3 ? getTop() : getRep(),
    );
  }

  Widget getTop() {
    List listings = new List<Widget>();
    if (type == 1) {
      return Align(
          alignment: Alignment(1, -0.95),
          child: LinearProgressIndicator(
            value: 0.3,
          ));
    } else if (type == 2) {
      return Align(
          alignment: Alignment(1, -0.95),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: getQuestTop()));
    }
  }

  Widget getRep() {
    List listings = new List<Widget>();
    if (type == 3) {
      return Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FlatButton(
              onPressed: (){
                print("Very sad");
              },
              padding: EdgeInsets.all(0.0),
              child: Image.asset('lib/assets/sad.png',height: 50,width: 50)),
          FlatButton(
              onPressed: (){
                print("Sad");
              },
              padding: EdgeInsets.all(0.0),
              child: Image.asset('lib/assets/sad2.png',height: 50,width: 50)),
          FlatButton(
              onPressed: (){
                print("Happy");
              },
              padding: EdgeInsets.all(0.0),
              child: Image.asset('lib/assets/happy2.png',height: 50,width: 50)),
          FlatButton(
              onPressed: (){
                print("Very happy");
              },
              padding: EdgeInsets.all(0.0),
              child: Image.asset('lib/assets/happy.png',height: 50,width: 50)),
        ],
      ));
    } else {
      return Center(
          child:SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: new _CustomThumbShape(),
              trackHeight: 4,
              overlayShape: RoundSliderOverlayShape(overlayRadius: 50),
            ),
            // https://api.flutter.dev/flutter/material/SliderThemeData-class.html#instance-properties
            child: Slider(
              activeColor: getColor(),
              min: 0.0,
              max: 15.0,
              onChanged: (newRating) {
                setState(() => _sliderValue = newRating);
              },
              value: _sliderValue.toDouble(),
            ),
          )
      );
    }
  }
  MaterialColor getColor() {
    if (_sliderValue <= 3) {
      return Colors.red;
    } else if (_sliderValue <= 6) {
      return Colors.amber;
    } else if (_sliderValue <= 9) {
      return Colors.grey;
    } else if (_sliderValue <= 12) {
      return Colors.lightGreen;
    } else {
      return Colors.green;
    }
  }

  List<Widget> getQuestTop() {
    List listings = new List<Widget>();

    int i = 0;
    while (i <= 5) {
      listings.add(Spacer());
      if (i <= 1) {
        listings.add(ButtonTheme(
          minWidth: 5.0,
          height: 60.0,
          child: RaisedButton(
            child: new Text((i + 1).toString()),
            onPressed: () {},
            shape: new CircleBorder(),
          ),
          buttonColor: Colors.blue,
        ));
      } else {
        listings.add(ButtonTheme(
          minWidth: 5.0,
          height: 60.0,
          child: RaisedButton(onPressed: () {}, shape: new CircleBorder()),
          buttonColor: Colors.grey,
        ));
      }

      i++;
    }
    listings.add(Spacer());
    return listings;
  }
}
class _CustomThumbShape extends SliderComponentShape {
  static const double _thumbSize = 4.0;
  static const double _disabledThumbSize = 5.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return isEnabled
        ? const Size.fromRadius(_thumbSize)
        : const Size.fromRadius(_disabledThumbSize);
  }

  static final Tween<double> sizeTween = new Tween<double>(
    begin: _disabledThumbSize,
    end: _thumbSize,
  );

  @override
  void paint(
      PaintingContext context,
      Offset thumbCenter, {
        Animation<double> activationAnimation,
        Animation<double> enableAnimation,
        bool isDiscrete,
        TextPainter labelPainter,
        RenderBox parentBox,
        SliderThemeData sliderTheme,
        TextDirection textDirection,
        double value,
      }) {
    final Canvas canvas = context.canvas;
    final ColorTween colorTween = new ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    final double size = _thumbSize * sizeTween.evaluate(enableAnimation);
    final Path thumbPath = _triangle(size, thumbCenter);
    canvas.drawPath(
        thumbPath, new Paint()..color = colorTween.evaluate(enableAnimation));
  }
}

Path _triangle(double size, Offset thumbCenter, {bool invert = false}) {
  final Path thumbPath = new Path();
  final double height = math.sqrt(3.0) / 2.0;
  final double halfSide = size / 2.0;
  final double centerHeight = size * height / 3.0;
  final double sign = invert ? -1.0 : 1.0;
  thumbPath.moveTo(
      thumbCenter.dx - halfSide, thumbCenter.dy + sign * centerHeight);
  thumbPath.lineTo(thumbCenter.dx, thumbCenter.dy - 2.0 * sign * centerHeight);
  thumbPath.lineTo(
      thumbCenter.dx + halfSide, thumbCenter.dy + sign * centerHeight);
  thumbPath.close();
  return thumbPath;
}
