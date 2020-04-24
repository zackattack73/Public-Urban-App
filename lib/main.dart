import 'package:flutter/material.dart';
import 'debug.dart';
import 'objChooser.dart';
import 'Options.dart';
import 'ListeObj.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Gmap.dart';
import 'authentication.dart';
import 'mainauth.dart';

class Main extends StatefulWidget {
  Main({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  SharedPreferences prefs;
  int droits;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((pr) {
      setState(() {
        prefs = pr;
        droits = prefs.getInt('droits');
        if (droits == null) { droits = 0;}
      });
    });
  }
  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Accueil",
      home: Scaffold(
        appBar: AppBar(title: Text("Accueil"),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: _signOut)
          ],
        ),
        body: Center(
            child:SizedBox(
              width: 325,
              height: 500,
              child: GridView.count(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                // Generate 100 widgets that display their index in the List.
                children: List.generate(5, (index) {
                  return new GestureDetector(
                    child: Container(
                      decoration: new BoxDecoration(
                          color: Colors.black12,
                          border: new Border.all(color: Colors.grey)
                      ),
                      child: Center(
                          child: Column(
                            children:
                            getButton(index)
                            ,
                          )),
                    ),
                    onTap: () {

                      if (index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => view()),
                        );
                      } else if (index == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Content()),
                        );
                      } else if (index == 2){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => map()),
                        );
                      } else if (index == 3) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Options()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Debug()),
                        );
                      }


                    },
                  );
                }),

              ),

            )

        ),
      ),
    );
  }
}

  List<Widget> getButton(int index) {
    List listings = new List<Widget>();

    if (index == 0) {
      listings.add(Spacer());
      listings.add(Icon(Icons.add,size: 50));
      listings.add(Text('Ajouter un objet', style: TextStyle(fontSize: 20)));
      listings.add(Spacer());
    } else if (index == 1) {
      listings.add(Spacer());
      listings.add(Icon(Icons.list,size: 50));
      listings.add(Text('Liste des objets', style: TextStyle(fontSize: 20)));
      listings.add(Spacer());
    } else if (index == 2) {
      listings.add(Spacer());
      listings.add(Icon(Icons.map,size: 50));
      listings.add(Text('Carte des objets', style: TextStyle(fontSize: 20)));
      listings.add(Spacer());
    } else if (index == 3) {
      listings.add(Spacer());
      listings.add(Icon(Icons.settings,size: 50));
      listings.add(Text('Options', style: TextStyle(fontSize: 20)));
      listings.add(Spacer());
    } else {
      listings.add(Spacer());
      listings.add(Icon(Icons.bug_report,size: 50));
      listings.add(Text('Debug', style: TextStyle(fontSize: 20)));
      listings.add(Spacer());
    }
    return listings;
  }


void main() {
  runApp(MaterialApp(home: MyApp()));
}
