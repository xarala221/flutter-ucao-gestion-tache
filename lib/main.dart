import 'package:flutter/material.dart';

void main() {
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
  bool _error = false;

  final List<Tache> taches = [];

  void _ajouterTache() {
    if (_controllerLeText.text.length > 0) {
      setState(() {
        taches.add(Tache(_controllerLeText.text, false));
      });
      _controllerLeText.text = "";
    } else {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
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
            child: Text("Ajouter tache", style: TextStyle(color: Colors.white)),
            onPressed: _ajouterTache,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: taches.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                value: taches[index].complete,
                onChanged: (bool? value) {
                  setState(() {
                    taches[index].complete = value ?? true;
                  });
                },
                title: Text(
                  taches[index].titre,
                  style: TextStyle(
                    decoration: taches[index].complete
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              );
            },
          )),
        ],
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Tache {
  String titre;
  bool complete;

  Tache(this.titre, this.complete);
}
