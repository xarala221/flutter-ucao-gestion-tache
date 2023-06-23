import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

const firebaseOptions = FirebaseOptions(
  appId: 'a changer',
  apiKey: 'a changer',
  projectId: 'a changer',
  messagingSenderId: '...',
  authDomain: '...',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de tache',
      home: ListeTache(),
    );
  }
}

class ListeTache extends StatefulWidget {
  @override
  _ListeTacheState createState() => _ListeTacheState();
}

class _ListeTacheState extends State<ListeTache> {
  final _controllerLeText = TextEditingController();
  final _controllerLaDescription = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _ajouterTache() {
    DocumentReference ref = firestore.collection("taches").doc();
    String myId = ref.id;
    setState(() {
      firestore.collection("taches").add({
        "titre": _controllerLeText.text,
        "description": _controllerLaDescription.text,
        "complete": false,
        "id": myId,
      });
      // taches.add(Tache(_controllerLeText.text, false));
    });
    _controllerLeText.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Gestion tache'),
          backgroundColor: Colors.amber,
        ),
        body: Column(
          children: [
            TextField(
              controller: _controllerLeText,
              decoration: InputDecoration(
                  labelText: "Titre",
                  labelStyle: TextStyle(color: Colors.amber),
                  contentPadding: EdgeInsets.all(10)),
            ),
            TextField(
              controller: _controllerLaDescription,
              decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(color: Colors.amber),
                  contentPadding: EdgeInsets.all(10)),
              onSubmitted: (value) {
                _ajouterTache();
              },
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('taches').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Une erreur s'est produite");
                  }
                  if (!snapshot.hasData) return const Text('Chargement...');
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) =>
                        _buildListItem(context, snapshot.data!.docs[index]),
                  );
                },
              ),
            ),
          ],
        ));
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    final tache = Tache(
        titre: document['titre'],
        complete: document['complete'],
        description: document['description']);

    return ListTile(
      title: Text(tache.titre,
          style: TextStyle(
            decoration: tache.complete
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          )),
      subtitle: Text(tache.description),
      trailing: Checkbox(
        value: tache.complete,
        onChanged: (value) {
          setState(() {
            tache.complete = value ?? true;
          });
          firestore
              .collection("taches")
              .doc(document.reference.id)
              .update({'complete': tache.complete});
        },
      ),
    );
  }
}

class Tache {
  String titre;
  String description;
  bool complete;

  Tache(
      {required this.titre, required this.description, this.complete = false});
}
