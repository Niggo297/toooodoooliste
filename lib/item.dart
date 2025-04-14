class Item {
  String bezeichnung;
  bool checked = false; 
  Item({required this.bezeichnung, required this.checked});

  String toSaveString(){
  return '$bezeichnung:$checked';

  }

  static Item fromSaveString(String saveString) {
    final parts = saveString.split(':');
    return Item(bezeichnung: parts[0], checked : parts[1] == 'true');
  }
}
