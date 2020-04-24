import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class fire extends StatefulWidget {

  @override
  BodyLayout createState() => new BodyLayout();
}
class BodyLayout extends State<fire> {
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    //anonymousLogin();
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Connect'),
      ),
      body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              RaisedButton(
                child: Text('Create Record'),
                onPressed: () {
                  createRecord();
                },
              ),

              RaisedButton(
                child: Text('View Record'),
                onPressed: () {
                  getData();
                },
              ),
              RaisedButton(
                child: Text('Udate Record'),
                onPressed: () {
                  updateData();
                },
              ),
              RaisedButton(
                child: Text('Delete Record'),
                onPressed: () {
                  deleteData();
                },
              ),
            ],
          )
      ),
    );
  }

  void createRecord() {
    databaseReference.child("1").set({
      'title': 'Mastering EJB',
      'description': 'Programming Guide for J2EE'
    });
    databaseReference.child("2").set({
      'title': 'Flutter in Action',
      'description': 'Complete Programming Guide to learn Flutter'
    });
  }

  void getData() {
    databaseReference.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });
  }

  void updateData() {
    databaseReference.child('1').update({
      'description': 'J2EE complete Reference'
    });
  }

  void deleteData() {
    databaseReference.child('1').remove();
  }
  /*void anonymousLogin() {
    FirebaseAuth.instance.onAuthStateChanged.listen((user) async {
      if (user != null) {
        var isAnonymous = user.isAnonymous;
        var uid = user.uid;
        print(
            'Already connected in FirestoreServices, isAnonymous = $isAnonymous and uid = $uid');
      } else {
        FirebaseAuth.instance.signInAnonymously().then((user) {
          print(
              'New connexion in FirestoreServices, isAnonymous = ${user.isAnonymous} and uid = ${user.uid}');
        });
      }
    });
  }*/
}
