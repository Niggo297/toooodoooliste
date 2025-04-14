import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toooodoooliste/item.dart';

void hinzufuegentest(List<Item> liste, TextEditingController controller) {
  if (controller.text.isNotEmpty) {
    liste.add(Item(bezeichnung: controller.text, checked: false));
    controller.clear();
    saveEinkaufsliste(liste);
  }
  if (controller.text == ":") {
    controller.text = "";
  }
}

void entferne(List<Item> liste, int index) {
  liste.removeAt(index);
  saveEinkaufsliste(liste);
}

Future<void> saveEinkaufsliste(List<Item> einkaufsliste) async {
  final prefs = await SharedPreferences.getInstance();
  final List<String> einkaufslisteString = einkaufsliste.map((item) => item.toSaveString()).toList();
  await prefs.setStringList('einkaufsliste', einkaufslisteString);
}
