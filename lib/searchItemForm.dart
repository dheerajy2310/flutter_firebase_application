import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sample/retrieve.dart';
//import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';


class searchItemForm extends StatefulWidget{
  @override
  _searchItemState createState() {
     return new _searchItemState();
  }
}
String category;
double _value;


class _searchItemState extends State<searchItemForm>{
// String category;
// double _value;
  String value;
  var query=[];
  var temp=[];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        query = [];
        temp = [];
      });
    }
    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (query.length == 0 && value.length == 1) {
      retrieve().searchbyName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          query.add(docs.documents[i].data);
        }
      });
    } else {
      temp = [];
      query.forEach((element) {
        if (element['name'].startsWith(capitalizedValue)) {
          setState(() {
            temp.add(element);

          });
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
     return new Scaffold(
       body: ListView( children: <Widget>[
         Padding(
           padding: EdgeInsets.all(10.0),

           child: TextField(
               style: new TextStyle(
                   fontSize: 22.0,
                   fontWeight: FontWeight.w300,
                   height: 2.0,
                   color: Colors.black
               ),
             onChanged: (value){
               initiateSearch(value);
             },
             decoration: InputDecoration(
               contentPadding: EdgeInsets.all(5.0),
               hintText: 'Search by Item name',
               labelText: 'enter Item name',
               labelStyle: TextStyle(
                 fontSize: 15.0
               ),
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
               )

             ),
           ),
         ),
         new SizedBox(height: 10.0),

         GridView.count(
             padding: EdgeInsets.only(left: 10.0, right: 10.0),
             crossAxisCount: 2,
             crossAxisSpacing: 4.0,
             mainAxisSpacing: 4.0,
             primary: false,
             shrinkWrap: true,
             children: temp.map((element) {
               return showItems(element);
             }).toList())
       ],
       ),
     );
  }


  Widget showItems(data){
    return  Card(
      shape: RoundedRectangleBorder(
          side: new BorderSide(color: Colors.lightBlueAccent),
          borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: RaisedButton(
          child: Text(data['name'],
            style: TextStyle(fontSize: 20.0,
                fontWeight: FontWeight.w300),
          ),
          onPressed:(){
            print("yes");
            return updateItems(data);
          }
      ),
    );
  }



  Future<void> updateItems(data) async {


    return showDialog<void>(
      context: context,
      barrierDismissible: false, // must tap button!
      builder: (BuildContext context) {
        DocumentSnapshot currentdocumnet;
        return AlertDialog(
          title: Text(data['name']),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
               new TextFormField(
                    initialValue: data['category'],
                    decoration: new InputDecoration(
                        hintText: 'Enter the Category',
                        border: OutlineInputBorder(),
                        labelText: 'Category of the Item'),
                    validator: validateCategory,
                    onFieldSubmitted: (String val) {
                      category = val;
                    }
                ),
                new SizedBox(height:20.0),
                new TextFormField(
                    initialValue: data['quantity'],
                    decoration: new InputDecoration(hintText: 'Enter the quantity',
                        border: OutlineInputBorder(),
                        labelText: 'Quantity of the item'),
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (String val) {
                      _value = double.parse(val);
                    }
                ),
                new SizedBox(height:20.0),
              ],
            ),
          ),

          actions: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
                  child: Text('Update'),
                  onPressed: () {

                    if(category!=null && _value==null){
                      Firestore.instance.collection('inventory').document(data['name']).updateData({"category": "$category"});
                    }
                    if(category==null && _value!=null){
                      Firestore.instance.collection('inventory').document(data['name']).updateData({"quantity": "$_value"});
                    }
                    if(category!=null && _value!=null){
                      Firestore.instance.collection('inventory').document(data['name']).updateData({"category": "$category","quantity":"$_value"});
                    }
                    if(category==null && _value==null){
                      print('nothing is entered');
                    }
                    Navigator.of(context).pop();
                  },
                ),
                new SizedBox(width :10.0),
                FlatButton(
                  child: Text('Delete'),
                  onPressed: () {
                    Firestore.instance.collection('inventory').document(data['name']).delete();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  String validateCategory(String value) {
    String patttern = r'(^[a-zA-Z0-9 ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "category is Required";
    } else if (!regExp.hasMatch(value)) {
      return "category must be a-z and A-Z and 0-9";
    }
    return null;
  }
}

