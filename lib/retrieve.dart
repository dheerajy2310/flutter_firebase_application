import 'package:cloud_firestore/cloud_firestore.dart';

class retrieve{
  searchbyName(String value)
  {
    return Firestore.instance.collection('inventory')
        .where('searchkey', isEqualTo: value.substring(0, 1).toUpperCase())
        .getDocuments();
  }
}