import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class addItemForm extends StatefulWidget {

  @override
  _addItemFormState createState() {
   return new _addItemFormState();
  }
}
class _addItemFormState extends State<addItemForm> {

  GlobalKey<FormState> _key = GlobalKey();
  bool _validate = false;
  String name, category,capname;
  double quantity;


  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: new Container(
        margin: new EdgeInsets.all(15.0),
        child: new Form(
          key: _key,
          autovalidate: _validate,
          child: itemform(),
        ),
      ),
    );
  }

  Widget itemform() {
    return Container(
      width: 300,

      child: new Column(

        children: <Widget>[


          new TextFormField(
              decoration: new InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name of the item',
                  hintText: 'Enter the name'),
              validator: validateName,
              onSaved: (String val) {

                this.capname = val;
                name=capname[0].toUpperCase()+capname.substring(1);
              }
          ),
          new SizedBox(height:15.0),
          new TextFormField(

              decoration: new InputDecoration(hintText: 'Enter the Category',
              border: OutlineInputBorder(),
              labelText: 'Category of the Item'),

              validator: validateCategory,
              onSaved: (String val) {

                this.category = val;
              }
          ),
          new SizedBox(height:15.0),

          new TextFormField(
              decoration: new InputDecoration(hintText: 'Enter the quantity',
              border: OutlineInputBorder(),

              labelText: 'Quantity of the item'),

              keyboardType: TextInputType.number,
              onSaved: (String val) {
                this.quantity = double.parse(val);
              }
          ),


          new SizedBox(height: 15.0),
          new RaisedButton(onPressed: _sendToServer, child: new Text('Upload'),
          ),

        ],
      ),
    );
  }

  String validateName(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Title is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Title must be a-z and A-Z";
    }
    return null;
  }

  String validateCategory(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Author is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Author must be a-z and A-Z";
    }
    return null;
  }



  _sendToServer() {

    if (_key.currentState.validate()) {
      _key.currentState.save();
      Firestore.instance.collection('inventory').document("$name")
          .setData(
          {"name": "$name", "category": "$category", "quantity": "$quantity","searchkey": "${name[0]}"})
          .catchError((e) {
        print(e);
      });
    } else {
      setState(() {
        _validate = true;
      });
    }
    _key.currentState.reset();

  }


}

