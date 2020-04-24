import 'package:flutter/material.dart';


class watch extends StatelessWidget {
  Stopwatch stopwatch = Stopwatch();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("StopWatch"),
        ),
        body:                   Align(
          alignment: Alignment(1,0.85),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Spacer(),
              ButtonTheme(
                minWidth: 5.0,
                height: 60.0,
                child: RaisedButton(
                    child: const Text("Stop"),
                    onPressed: () {
                      stop();
                    },
                    shape: new CircleBorder()),
                buttonColor: Colors.red,

              ),
              Padding(padding: EdgeInsets.all(10.0),),
              ButtonTheme(
                minWidth: 5.0,
                height: 60.0,
                child: RaisedButton(
                    child: const Text("Start"),
                    onPressed: () {
                      start();
                    },
                    shape: new CircleBorder()),
                buttonColor: Colors.green,

              ),
              Spacer(),

            ],
          ),
        ));
  }


  void start() {
    stopwatch.start();
  }
  void stop() {
    stopwatch.stop();
    print(stopwatch.elapsed);
    stopwatch.reset();
  }

}
