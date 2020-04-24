import 'package:flutter/material.dart';
import 'objets.dart';
import 'Photo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'global.dart' as global;


class view extends StatelessWidget {

  final List<Objet> data = [
    new Objet("lib/assets/banc.png", "Banc"),
    new Objet("lib/assets/poubelle.png", "Poubelle"),
    new Objet("lib/assets/lampadaire.png", "Lampadaire"),
    new Objet("lib/assets/jeux.png", "Jeux"),
    new Objet("lib/assets/velo.png", "Attache vélo"),
    new Objet("lib/assets/affichage.png", "Affichage"),
    new Objet("lib/assets/bouche_incendie.png", "Bouche"),
  ];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text('Choisir un objet'),
      ),
        body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(data.length, (index) {
            return new GestureDetector(
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.black12,
                    border: new Border.all(color: Colors.grey)
                ),
                child: Center(
                    child: Column(
                  children: <Widget>[
                    new Image.asset(data[index].path, width: 100, height: 100),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        data[index].name,
                        style: Theme.of(context).textTheme.headline,
                      ),
                    ),
                  ],
                )),
              ),
              onTap: () {
                if (index == 0) {
                  global.type = "Banc";
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraExample()),
                  );
                } else {
                  Fluttertoast.showToast(
                      msg: 'Pas encore implémenté',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white);
                }
              },
            );
          }),
        ),
      );
  }
}
