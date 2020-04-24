import 'package:flutter/material.dart';
import 'database.dart';

final dbHelper = DatabaseHelper.instance;

class TestDB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Test DB"),
        ),
        body: Center(
            child: ButtonTheme(
          minWidth: 5.0,
          height: 60.0,
          child: RaisedButton(
              child: const Text("Test"),
              onPressed: () {
                fctTest();
              },
              shape: new CircleBorder()),
          buttonColor: Colors.lightGreen,
        )));
  }



  void fctTest() async {
    String type = "Banc";
    String long = "42.1";
    String lat = "12.62";
    int IDrep = 6;
    String PathImg = "hello/world/test";
    List result;
    List quest;
    List rep;
    int id;

    rep = await dbHelper.getReponses(0);

    print(rep);
    result = await dbHelper.getObjets(type);
    print(result);
    /*await dbHelper.insertObjet(type, long ,lat, IDrep,PathImg);
    result = await dbHelper.getObjets(type);
    id = await dbHelper.getLastIdRep();
    quest = await dbHelper.getQuestions(type);
    await dbHelper.insertRep(1,6,"Hello rep");
    await dbHelper.insertRep(1,7,"World rep");
    await dbHelper.insertRep(1,8,"Cyao rep");
    rep = await dbHelper.getReponses(1);

    print(rep);
    print(id);
    print(result);
    print(quest);*/


  }

}
