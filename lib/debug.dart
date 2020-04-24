import 'package:flutter/material.dart';
import 'Questionnaire.dart';
import 'Photo.dart';
import 'testdb.dart';
import 'objChooser.dart';
import 'package:geolocator/geolocator.dart';
import 'global.dart' as global;
import 'compass.dart';
import 'Gmap.dart';
import 'firebase.dart';
import 'mainauth.dart';
import 'package:permission_handler/permission_handler.dart';


class Debug extends StatefulWidget {
  @override
  _DebugState createState() => _DebugState();
}

class _DebugState extends State<Debug> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text('Page de debug'),
      ),
        body: MainWidget(),
      );
  }
}

class MainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child:SingleChildScrollView(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              global.type = "Banc";
              global.path = "PATH DE L'IMAGE";
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuestPageBody()),
              );
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
              child: const Text('Test Questionnaire',
                  style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(height: 30),
          RaisedButton(
            onPressed: () {
              Geolocator().checkGeolocationPermissionStatus().then((status) {
                if (status.toString() == "GeolocationStatus.denied") {
                  Geolocator().getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.lowest);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraExample()),
                  );
                }
              });
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
              child: const Text('Test Photo', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(height: 30),
          RaisedButton(
            onPressed: () async {
              Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
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
              child: const Text('Permission photos', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(height: 30),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TestDB()),
              );},
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
              child: const Text('Test DB', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(height: 30),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => view()),
              );},
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
              child: const Text('Test Chooser', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(height: 30),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Compass()),
              );},
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
              child: const Text('Test Compass', style: TextStyle(fontSize: 20)),
            ),
          ),
          /*const SizedBox(height: 30),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => watch()),
              );},
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
              child: const Text('Test Stop Watch', style: TextStyle(fontSize: 20)),
            ),
          ),*/
          const SizedBox(height: 30),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => map()),
              );},
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
              child: const Text('Google Map', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(height: 30),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => fire()),
              );},
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
              child: const Text('Firebase', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(height: 30),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );},
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
              child: const Text('Auth Firebase', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    ));
  }
}