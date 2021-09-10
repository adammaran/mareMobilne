import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final _databaseReference = FirebaseFirestore.instance;

  String searchKey = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pretraga transakcija")),
      body: Column(
        children: [
          TextField(
            onChanged: (text) {
              setState(() {
                searchKey = text;
              });
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10), hintText: 'Uneti ime'),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: (searchKey == null || searchKey.trim() == '')
                ? _databaseReference.collection('payment_history').snapshots()
                : _databaseReference
                    .collection('payment_history')
                    .where('uid',
                        isEqualTo: FirebaseAuth.instance.currentUser.uid)
                    .where('title', isEqualTo: searchKey)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error ${snapshot.error}');
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return SizedBox(
                    child: Center(
                      child: Text('Učitavanje...'),
                    ),
                  );
                case ConnectionState.none:
                  return Text('Transakcija nije pronadjena');
                default:
                  return new ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return Card(
                        child: ListTile(
                          title: Center(
                              child: Column(
                            children: [
                              Text(document['title']),
                              document['type'] == "added"
                                  ? Text(
                                      "+ ${document['amount'].toString()}",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      "- ${document['amount'].toString()}",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    )
                            ],
                          )),
                        ),
                      );
                    }).toList(),
                  );
              }
            },
          ))
        ],
      ),
    );
  }
}
