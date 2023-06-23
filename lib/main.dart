import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

const firebaseOptions = FirebaseOptions(
  appId: 'votre app id',
  apiKey: 'votre api key',
  projectId: 'votre projet id',
  messagingSenderId: '...',
  authDomain: '...',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion tache',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Applciation de gestion de taches'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controllerLeText = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final List<Tache> taches = [];

  void _ajouterTache() {
    DocumentReference ref = firestore.collection("taches").doc();
    String myId = ref.id;
    setState(() {
      firestore.collection("taches").add({
        "titre": _controllerLeText.text,
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
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            TextField(
              controller: _controllerLeText,
              onSubmitted: (valeur) {
                _ajouterTache();
              },
              decoration: InputDecoration(
                  labelText: "Ajouter une tache",
                  contentPadding: EdgeInsets.all(10)),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.all(20),
              ),
              child:
                  Text("Ajouter tache", style: TextStyle(color: Colors.white)),
              onPressed: _ajouterTache,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('taches').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Container(
                        height: 100,
                        margin: const EdgeInsets.only(bottom: 15.0),
                        child: ListTile(
                          title: Text(
                            data["titre"],
                            style: TextStyle(
                              decoration: data['complete']
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            )
          ],
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class Tache {
  String titre;
  bool complete;

  Tache(this.titre, this.complete);
}
