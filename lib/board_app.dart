import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_course_updated_master/ui/custom_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BoardApp extends StatefulWidget {
  const BoardApp({super.key});

  @override
  State<BoardApp> createState() => _BoardAppState();
}

class _BoardAppState extends State<BoardApp> {
  var firestoreDb = FirebaseFirestore.instance.collection('board').snapshots();
  TextEditingController nameInputController = TextEditingController();
  TextEditingController titleInputController = TextEditingController();
  TextEditingController descriptionInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameInputController = TextEditingController();
    titleInputController = TextEditingController();
    descriptionInputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Board'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog(context);
        },
        child: const Icon(FontAwesomeIcons.pen),
      ),
      body: StreamBuilder(
        stream: firestoreDb,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            const CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              return CustomCard(snapshot: snapshot.data, index: index);
              //return Text(snapshot.data!.docs[index]['description']);
            },
          );
        },
      ),
    );
  }

  _showDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(10),
            content: Column(children: [
              Text('please fill out the form.'),
              Expanded(
                child: TextField(
                  autofocus: true,
                  autocorrect: true,
                  decoration: const InputDecoration(labelText: 'Your Name*'),
                  controller: nameInputController,
                ),
              ),
              Expanded(
                child: TextField(
                  autofocus: true,
                  autocorrect: true,
                  decoration: const InputDecoration(labelText: 'Title*'),
                  controller: titleInputController,
                ),
              ),
              Expanded(
                child: TextField(
                  autofocus: true,
                  autocorrect: true,
                  decoration: const InputDecoration(labelText: 'description*'),
                  controller: descriptionInputController,
                ),
              ),
            ]),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  nameInputController.clear();
                  titleInputController.clear();
                  descriptionInputController.clear();

                  Navigator.pop(context);
                },
                child: const Text('cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (titleInputController.text.isNotEmpty &&
                      nameInputController.text.isNotEmpty &&
                      descriptionInputController.text.isNotEmpty) {
                    FirebaseFirestore.instance.collection('board').add({
                      "name": nameInputController.text,
                      "title": titleInputController.text,
                      "description": descriptionInputController.text,
                      "timestamp": DateTime.now()
                    }).then((response) {
                      print(response.id);
                      Navigator.pop(context);
                      nameInputController.clear();
                      titleInputController.clear();
                      descriptionInputController.clear();
                    }).catchError((error) {
                      print(error);
                    });
                  }

                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
  }
}
