import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toooodoooliste/item.dart';

final refEinkaufsliste = NotifierProvider<EinkaufslisteNotifier, List<Item>>(EinkaufslisteNotifier.new);

class EinkaufslisteNotifier extends Notifier<List<Item>> {
  EinkaufslisteNotifier() : super() {
    _loadEinkaufsliste();
  }
  @override
  List<Item> build() {
    return [];
  }

  void addItemWithBezeichnung(String bezeichnung) async {
    if (bezeichnung.isNotEmpty) {
      final newBezeichung = bezeichnung.trim().replaceAll(':', ' ');
      final supabase = Supabase.instance.client;
      final newItem = Item(id: null, bezeichnung: newBezeichung, checked: false);
      final newJson = newItem.toJson();
      newJson.remove('id');
      final savedItems = await supabase.from('items').insert(newJson).select();
      final savedItem = Item.fromJson(savedItems.first);
      state = [...state, savedItem];
    }
  }

  // void _loadEinkaufsliste() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final gespeicherteListe = prefs.getStringList('einkaufsliste') ?? [];
  //   log('gespeicherteListe: $gespeicherteListe');
  //   final transformierteListe = gespeicherteListe.map((item) => Item.fromSaveString(item)).toList();
  //   state = transformierteListe;
  // }

  void _loadEinkaufsliste() async {
    final supabase = Supabase.instance.client;
    final jsons = await supabase.from('items').select();
    final items = jsons.map((json) => Item.fromJson(json)).toList();
    state = items;
  }

  void updateItemChecked(Item item, bool checked) {
    final newList = <Item>[];
    final newItem = Item(id: item.id, bezeichnung: item.bezeichnung, checked: checked);
    for (final i in state) {
      if (i == item) {
        newList.add(newItem);
      } else {
        newList.add(i);
      }
    }
    state = newList;
    final supabase = Supabase.instance.client;
    supabase.from('items').update(newItem.toJson()).eq('id', newItem.id!);
  }

  void removeItem(Item item) async {
    state = state.where((i) => i != item).toList();
    final supabase = Supabase.instance.client;
    final result = await supabase.from('items').delete().eq('id', item.id!);
    log('result: $result');
  }
}
