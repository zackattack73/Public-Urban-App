import 'package:flutter/material.dart';
import 'database.dart';
import 'dart:io';
import 'dart:async';
import 'package:transparent_image/transparent_image.dart';
import 'ListeNotes.dart';
import 'package:flutter/services.dart';

final dbHelper = DatabaseHelper.instance;

class Content extends StatefulWidget {
  @override
  BodyLayout createState() => new BodyLayout();
}

class BodyLayout extends State<Content> {
  List data = [];
  @override
  void initState() {
    super.initState();
    dbHelper.getObjets("Banc").then((result) {
      setState(() {
        data = result;
        print(data.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des objets"),
      ),
      body: _myListView(context, data),
    );
  }
}

Widget _myListView(BuildContext context, List data) {
  return data.length > 0
      ? ListView.separated(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Image.asset("lib/assets/banc.png", width: 50, height: 50),
               title :  Column(mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Lat : " +
                          data[index]["lat"] +
                          " Long : " +
                          data[index]["long"],
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
              FittedBox(
                fit: BoxFit.fitWidth, child : Text(
                      "Adresse : " + data[index]["adresse"],
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    )),
                    Text(
                      "Orientation : " + data[index]["orientation"].toString(),
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              trailing: new IconButton(
                icon: new Icon(Icons.send,color: Colors.green,),
                onPressed: () { sendData(data[index]["_id"],data,index);},
              ),

              onTap: () => _ackAlert(context, index ,data[index]["_id"], data),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        )
      : Text("Pas d'objets", textAlign: TextAlign.center);
}

Future<Null> sendData(int id, List data, int index) async {
  const androidMethodChannel = const MethodChannel('team.native.io/dataToMail');
  List datarep = [];
  dbHelper.getReponses(data[index]["idrep"]).then((result) {
      datarep = result;
      print(data[index]);
      print(datarep);
      String content = data[index].toString()+datarep.toString();
      print(content);
      androidMethodChannel.invokeMethod('dataToMail',{'filePath':data[index]["pathimg"],'content':content});
    });
}


Future<void> _ackAlert(BuildContext context, int index, int id, List data) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: new Container(
            width: 300.0,
            height: 300.0,
            child: Stack(
              children: <Widget>[
                Center(child: CircularProgressIndicator()),
                Center(
                    child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: FileImage(File(data[index]["pathimg"])),
                )),
              ],
            )),
        actions: <Widget>[
          FlatButton(
            child: Text('Supprimer',style: TextStyle(color: Colors.red),),
            onPressed: () {
              print("ID :"+id.toString());
              dbHelper.deleteObject(id);
              Navigator.of(context).pop();

            },
          ),
          FlatButton(
            child: Text('Réponses'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => notes(id: data[index]["idrep"])),
              );
            },
          ),
          FlatButton(
            child: Text('Fermer'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
