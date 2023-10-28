import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CustomCard extends StatelessWidget {
  final QuerySnapshot? snapshot;
  final int index;

  const CustomCard({super.key, required this.snapshot, required this.index});

  String textSnapshot(String string) {
    String title = snapshot!.docs[index][string];
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 9,
          child: ListTile(
            title: Text(textSnapshot('title')),
            subtitle: Text(textSnapshot('description')),
            leading: CircleAvatar(
              radius: 34,
              child: Text(textSnapshot('title').toString()[0]),
            ),
          ),
        ),
      ],
    );
  }
}
