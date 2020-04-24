import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:io';
import 'global.dart' as global;
import 'Questionnaire.dart';
import 'database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

final dbHelper = DatabaseHelper.instance;


class PhotoPreviewPage extends StatelessWidget {
  final String path;
  PhotoPreviewPage({Key key, @required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photo"),
      ),
      body: Center(
        child: path == null
            ? SizedBox(child: Text("Erreur aucune photo trouvée"))
            : Stack(
                children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                  Center(
                    child: FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: FileImage(File(path)),
                    ),
                  ),
                  Align(
                    alignment: Alignment(1,0.85),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Spacer(),
                        ButtonTheme(
                          minWidth: 5.0,
                          height: 60.0,
                          child: RaisedButton(
                              child: const Icon(Icons.close, size: 45),
                              onPressed: () {Navigator.pop(context);},
                              shape: new CircleBorder()),
                              buttonColor: Colors.red,

                        ),
                        Padding(padding: EdgeInsets.all(10.0),),
                        ButtonTheme(
                          minWidth: 5.0,
                          height: 60.0,
                          child: RaisedButton(
                              child: const Icon(Icons.check, size: 45),
                              onPressed: () {
                                global.path = path;
                                insertObj();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => QuestPageBody()),
                                );
                              },
                              shape: new CircleBorder()),
                              buttonColor: Colors.green,

                        ),
                        Spacer(),

                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
  void insertObj() async {
    int id;
    id = await dbHelper.getLastIdRep();
    if (id == null) id=0;
    id++;
    global.IDrep = id;
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(double.parse(global.lat),double.parse(global.long));
    String adresse = placemark[0].name+" "+placemark[0].thoroughfare+", "+placemark[0].postalCode+" "+placemark[0].locality+", "+placemark[0].country;
    global.date = new DateFormat("dd-MM-yyyy kk-mm-ss").format(DateTime.now());
    await dbHelper.insertObjet(global.type, global.long ,global.lat,id ,global.path,global.date,adresse,global.orientation);
    print(global.orientation);
  }
}
