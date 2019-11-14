import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fryo/globals.dart';
class DatabaseSample extends StatelessWidget {
  final DBref = FirebaseDatabase.instance.reference();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        child: Text('Write Data'),
        onPressed: ()
        {
          writeData();
          },
      
      ),
      
    );
  }


void writeData()
{
DBref.child('1').set({
'id': 'ID1',
'name':'Anirudh'

});


}

}