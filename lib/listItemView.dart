import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class listItemView extends StatefulWidget {
  @override
  listItemState createState() {
    return new listItemState();
  }
}

class listItemState extends State<listItemView> {
  @override
  Widget build(BuildContext context) {
    return listitems();
  }
}

Widget listitems() {
  return new StreamBuilder(
      stream: Firestore.instance.collection('inventory').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: new CircularProgressIndicator());
          default:
            return new ListView(
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              return Card(
                margin: new EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                elevation: 15.0,
                child: new Container(
                  padding: new EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 25.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        'Name of the Item:         ' + document['name'],
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w600),
                      ),
                      new SizedBox(
                        height: 1.0,
                      ),
                      new Text(
                        'Category of the Item:    ' + document['category'],
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w300),
                      ),
                      new SizedBox(
                        height: 1.0,
                      ),
                      new Text(
                        'Quantity of the Item:     ' +
                            document['quantity'] +
                            'items',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );

        }

      });
}



