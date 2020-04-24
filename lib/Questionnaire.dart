import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'database.dart';
import 'global.dart' as global;
import 'rep.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestPageBody extends StatefulWidget {
  @override
  _QuestPageBodyState createState() {
    return _QuestPageBodyState();
  }
}

class _QuestPageBodyState extends State<QuestPageBody> {
  double _sliderValue = 10.0;
  int nbQuest = 0;
  int activeQuest = 0;
  List questions;
  String type = global.type;
  final dbHelper = DatabaseHelper.instance;
  List<Rep> reponses = [];
  Stopwatch stopwatch = Stopwatch();
  SharedPreferences prefs;
  int avc = 1;
  int rep = 1;

  @override
  void initState() {
    dbHelper.getQuestions(type).then((quest) {
      setState(() {
        questions = quest;
        nbQuest = quest.length - 1;
      });
    });
    SharedPreferences.getInstance().then((pr) {
      setState(() {
        prefs = pr;
        avc = prefs.getInt('avancement');
        if (avc == null) {
          avc = 1;
        }
        rep = prefs.getInt('reponse');
        if (rep == null) {
          rep = 1;
        }
      });
    });
    super.initState();
    stopwatch.start();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: const Text('Page Questionnaire'),
        ),
        body: Stack(children: <Widget>[
          Container(
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                questions != null
                    ? new Text(
                        questions[activeQuest]["quest"],
                        style: TextStyle(fontSize: 25),
                        textAlign: TextAlign.center,
                      )
                    : new Text(
                        "Erreur aucune question trouvée",
                        style: TextStyle(fontSize: 25),
                      ),

                //new Text("Note : " + (_sliderValue).round().toString() + "/15"),
                SizedBox(height: 15),
                getRep(),
              ])),
          Align(
              alignment: Alignment(1, -0.95),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: getQuestTop())),
          rep == 1 ? Container() : Align(
              alignment: Alignment(1, 0.80),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: getQuestBottom())),
        ]));
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

  Widget getRep() {
    if (rep == 1) {
      return Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FlatButton(
              onPressed: () {
                setState(() {
                  _sliderValue = 3;
                });
                setRep();
                print("Very sad");
              },
              padding: EdgeInsets.all(0.0),
              child: Image.asset('lib/assets/sad.png', height: 50, width: 50)),
          FlatButton(
              onPressed: () {
                setState(() {
                  _sliderValue = 7;
                });
                setRep();
                print("Sad");
              },
              padding: EdgeInsets.all(0.0),
              child: Image.asset('lib/assets/sad2.png', height: 50, width: 50)),
          FlatButton(
              onPressed: () {
                setState(() {
                  _sliderValue = 11;
                });
                setRep();
                print("Happy");
              },
              padding: EdgeInsets.all(0.0),
              child:
                  Image.asset('lib/assets/happy2.png', height: 50, width: 50)),
          FlatButton(
              onPressed: () {
                setState(() {
                  _sliderValue = 15;
                });
                setRep();
                print("Very happy");
              },
              padding: EdgeInsets.all(0.0),
              child:
                  Image.asset('lib/assets/happy.png', height: 50, width: 50)),
        ],
      ));
    } else {
      return SliderTheme(
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
      );
    }
  }

  List<Widget> getQuestTop() {
    List listings = new List<Widget>();

    if (avc == 1) {
      double value;
      if (activeQuest == 0) {
        value = 0.0;
      } else {
        value = activeQuest / nbQuest;
      }
      listings.add(Spacer());
      listings.add(new SizedBox(
        width: MediaQuery.of(context).size.width - 15,
        child: LinearProgressIndicator(
          value: value,
        ),
      ));
      listings.add(Spacer());
      return listings;
    } else {
      int i = 0;
      while (i <= nbQuest) {
        listings.add(Spacer());
        if (i <= activeQuest) {
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

  setRep() {
    if (activeQuest != nbQuest) {
      stopwatch.stop();
      print(stopwatch.elapsed);
      Rep rtemp = new Rep(global.IDrep, questions[activeQuest]["_id"],
          _sliderValue.round().toString(), stopwatch.elapsed.toString());
      reponses.add(rtemp);
      setState(() {
        activeQuest++;
      });
      stopwatch.reset();
      stopwatch.start();
    } else {
      stopwatch.stop();
      print(stopwatch.elapsed);
      Rep rtemp = new Rep(global.IDrep, questions[activeQuest]["_id"],
          _sliderValue.round().toString(), stopwatch.elapsed.toString());
      reponses.add(rtemp);
      addRep();
      stopwatch.reset(); // Au cas ou
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
  }

  List<Widget> getQuestBottom() {
    List listings = new List<Widget>();

    if (activeQuest != nbQuest) {
      listings.add(RaisedButton(
        onPressed: () {
          stopwatch.stop();
          print(stopwatch.elapsed);
          Rep rtemp = new Rep(global.IDrep, questions[activeQuest]["_id"],
              _sliderValue.round().toString(), stopwatch.elapsed.toString());
          reponses.add(rtemp);
          setState(() {
            activeQuest++;
            _sliderValue = 10.0;
          });
          stopwatch.reset();
          stopwatch.start();
        },
        textColor: Colors.white,
        padding: const EdgeInsets.all(0.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color(0xFF0D47A1),
                Color(0xFF1976D2),
                Color(0xFF42A5F5),
              ],
            ),
          ),
          padding: const EdgeInsets.all(10.0),
          child: const Text('Suivant', style: TextStyle(fontSize: 20)),
        ),
      ));
    } else {
      listings.add(ButtonTheme(
          minWidth: 100.0,
          child: RaisedButton(
            onPressed: () {
              stopwatch.stop();
              print(stopwatch.elapsed);
              Rep rtemp = new Rep(
                  global.IDrep,
                  questions[activeQuest]["_id"],
                  _sliderValue.round().toString(),
                  stopwatch.elapsed.toString());
              reponses.add(rtemp);
              addRep();
              stopwatch.reset(); // Au cas ou
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
            textColor: Colors.white,
            padding: const EdgeInsets.all(0.0),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFF0D47A1),
                    Color(0xFF1976D2),
                    Color(0xFF42A5F5),
                  ],
                ),
              ),
              width: 100.0,
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                'Fin',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          )));
    }
    return listings;
  }

  void addRep() async {
    for (var rep in reponses) {
      await dbHelper.insertRep(rep.ID, rep.IDquest, rep.rep, rep.time);
    }
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
