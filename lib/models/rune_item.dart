class RuneItem {
  final String id;
  final String name;
  final String letter;
  final String aett;
  final bool canInvert;
  final List<String> keywords;
  final String uprightMeaning;
  final String shadowMeaning;

  RuneItem({
    required this.id,
    required this.name,
    required this.letter,
    required this.aett,
    required this.canInvert,
    required this.keywords,
    required this.uprightMeaning,
    required this.shadowMeaning,
  });

  factory RuneItem.fromJson(Map<String, dynamic> json) {
    return RuneItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      letter: json['letter'] ?? '',
      aett: json['aett'] ?? 'freyr',
      canInvert: json['canInvert'] ?? true,
      keywords: List<String>.from(json['keywords'] ?? []),
      uprightMeaning: json['upright_meaning'] ?? '',
      shadowMeaning: json['shadow_meaning'] ?? '',
    );
  }
}
