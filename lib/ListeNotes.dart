import 'package:flutter/material.dart';
import 'database.dart';

final dbHelper = DatabaseHelper.instance;

class notes extends StatefulWidget {
  final int id;
  notes({Key key, @required this.id}) : super(key: key);
  @override
  BodyLayout createState() => new BodyLayout(id);
}

class BodyLayout extends State<notes> {
  int id;
  List datarep = [];
  List dataquest = [];
  BodyLayout(this.id);
  @override
  void initState() {
    super.initState();
    final dbHelper = DatabaseHelper.instance;
    dbHelper.getReponses(id).then((result) {
      setState(() {
        datarep = result;
      });
    });
    dbHelper.getQuestions("Banc").then((result) {
      setState(() {
        dataquest = result;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des Réponses"),
      ),
      body: _myListView(context, datarep, dataquest),
    );
  }
}

Widget _myListView(BuildContext context, List datarep, List dataquest) {
  return datarep.length > 0
      ? ListView.separated(
          itemCount: datarep.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Center(
              child: Column(
                children: <Widget>[
                  Text(
                    "Question : " + dataquest[datarep[index]["idquest"]-1]["quest"].toString(),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Réponse : " + datarep[index]["rep"].toString(),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Temps : " + datarep[index]["timeanswer"].toString(),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ));
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        )
      : Text("Pas d'objets", textAlign: TextAlign.center);
}
