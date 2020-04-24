import 'package:flutter/material.dart';
import 'dummyQuest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Options extends StatefulWidget {
  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  int selectedRadioTileAv;
  int selectedRadioTileRep;
  SharedPreferences prefs;
  int avc;
  int rep;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((pr) {
      setState(() {
        prefs = pr;
        avc = prefs.getInt('avancement');
        if (avc == null) { avc = 1;}
        rep = prefs.getInt('reponse');
        if (rep == null) { rep = 1;}
        selectedRadioTileAv = avc;
        selectedRadioTileRep = rep;
      });
    });
  }

  setSelectedRadioTileAv(int val) {
    setState(() {
      selectedRadioTileAv = val;
      prefs.setInt('avancement', val);
    });
  }

  setSelectedRadioTileRep(int val) {
    setState(() {
      selectedRadioTileRep = val;
      prefs.setInt('reponse', val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: const Text('Options du questionnaire'),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 7),
            Text(
              "Avancement",
              style: TextStyle(fontSize: 25),
            ),
            Divider(),
            RadioListTile(
              value: 1,
              groupValue: selectedRadioTileAv,
              title: Text("Barre de progression"),
              subtitle: Text("Radio 1 Subtitle"),
              onChanged: (val) {
                print("Radio Tile pressed $val");
                setSelectedRadioTileAv(val);
              },
              secondary: OutlineButton(
                child: Text("Test"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dummy(type: 1)),
                  );
                },
              ),
            ),
            RadioListTile(
              value: 2,
              groupValue: selectedRadioTileAv,
              title: Text("Ronds de couleur"),
              subtitle: Text("Radio 2 Subtitle"),
              onChanged: (val) {
                print("Radio Tile pressed $val");
                setSelectedRadioTileAv(val);
              },
              secondary: OutlineButton(
                child: Text("Test"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dummy(type: 2)),
                  );
                },
              ),
            ),
            Divider(),
            Text(
              "Réponses",
              style: TextStyle(fontSize: 25),
            ),
            Divider(),
            RadioListTile(
              value: 1,
              groupValue: selectedRadioTileRep,
              title: Text("Smiley"),
              subtitle: Text("Avec 4 choix possibles"),
              onChanged: (val) {
                print("Radio Tile pressed $val");
                setSelectedRadioTileRep(val);
              },
              secondary: OutlineButton(
                child: Text("Test"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dummy(type: 3)),
                  );
                },
              ),
            ),
            RadioListTile(
              value: 2,
              groupValue: selectedRadioTileRep,
              title: Text("Scroller"),
              subtitle: Text("Barre de défilement"),
              onChanged: (val) {
                print("Radio Tile pressed $val");
                setSelectedRadioTileRep(val);
              },
              secondary: OutlineButton(
                child: Text("Test"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dummy(type: 4)),
                  );
                },
              ),
            ),
            RadioListTile(
              value: 3,
              groupValue: selectedRadioTileRep,
              title: Text("Voix"),
              subtitle: Text("Quelques bugs peuvent exister"),
              onChanged: (val) {
                print("Radio Tile pressed $val");
                setSelectedRadioTileRep(val);
              },
              secondary: OutlineButton(
                child: Text("Test"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dummy(type: 5)),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
