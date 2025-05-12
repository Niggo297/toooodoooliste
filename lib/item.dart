class Item {
  final int? id;
  final String bezeichnung;
  final bool checked;
  const Item({required this.id, required this.bezeichnung, required this.checked});

  static Item fromJson(Map<String, dynamic> json) =>
      Item(id: json['id'], bezeichnung: json['bezeichnung'] as String, checked: json['checked'] as bool);

  Map<String, dynamic> toJson() => {'id': id, 'bezeichnung': bezeichnung, 'checked': checked};
}
