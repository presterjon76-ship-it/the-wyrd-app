class TarotItem {
  final String id;
  final String name;
  final String suit;
  final int number;
  final String arcana;
  final List<String> keywords;
  final String uprightMeaning;
  final String reversedMeaning;

  TarotItem({
    required this.id,
    required this.name,
    required this.suit,
    required this.number,
    required this.arcana,
    required this.keywords,
    required this.uprightMeaning,
    required this.reversedMeaning,
  });

  factory TarotItem.fromJson(Map<String, dynamic> json) {
    return TarotItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      suit: json['suit'] ?? 'major',
      number: json['number'] ?? 0,
      arcana: json['arcana'] ?? 'major',
      keywords: List<String>.from(json['keywords'] ?? []),
      uprightMeaning: json['upright_meaning'] ?? '',
      reversedMeaning: json['reversed_meaning'] ?? '',
    );
  }
}
