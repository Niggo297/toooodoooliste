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
        elevation: 4, // leicht schwebend
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
        child: Column(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
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
                            backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                              if (states.contains(WidgetState.hovered)) {
                                return const Color.fromARGB(255, 90, 140, 90); // heller bei Hover
                              }
                              return const Color.fromARGB(255, 73, 117, 75); // normal
                            }),
                            elevation: WidgetStateProperty.resolveWith<double>((states) {
                              if (states.contains(WidgetState.hovered)) {
                                return 8; // leicht mehr Schatten
                              }
                              return 4;
                            }),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                            shadowColor: WidgetStateProperty.all(Colors.black45),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [Icon(Icons.add, color: Colors.white), SizedBox(width: 8)],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    ListView(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      children:
                          einkaufsliste.map((item) {
                            return Material(
                              color: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white70,
                                ),
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
                                            einkaufsliste.remove(item);
                                            saveEinkaufsliste(einkaufsliste);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
