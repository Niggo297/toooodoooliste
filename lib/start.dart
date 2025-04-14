import 'logik.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:flutter/material.dart';
import 'item.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  List<Item> einkaufsliste = [];
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      ladeUndSetzeEinkaufsliste();
    });
  }

  void ladeUndSetzeEinkaufsliste() async {
    final prefs = await SharedPreferences.getInstance();
    final gespeicherteListe = prefs.getStringList('einkaufsliste') ?? [];
    final transformierteListe = gespeicherteListe.map((item) => Item.fromSaveString(item)).toList();

    setState(() {
      einkaufsliste = transformierteListe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 73, 117, 75),
        elevation: 4,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical()),
        title: const Text(
          '🛒 Einkaufsliste',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white, letterSpacing: 1.0),
        ),
        centerTitle: true,
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/bild3.jpg'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'Produkte hinzufügen',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white70,
                        ),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) {
                          setState(() {
                            hinzufuegentest(einkaufsliste, controller);
                          });
                          focusNode.requestFocus();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          hinzufuegentest(einkaufsliste, controller);
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Color.fromARGB(255, 73, 117, 75)),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Die Liste bekommt den Restplatz und zeigt ggf. nichts
              Expanded(
                child:
                    einkaufsliste.isEmpty
                        ? const Center(
                          child: Text(
                            "Keine Produkte in der Liste.",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: einkaufsliste.length,
                          itemBuilder: (context, index) {
                            final item = einkaufsliste[index];
                            return Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white70),
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                title: Text(item.bezeichnung),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: item.checked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          item.checked = value ?? false;
                                          saveEinkaufsliste(einkaufsliste);
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          einkaufsliste.removeAt(index);
                                          saveEinkaufsliste(einkaufsliste);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
