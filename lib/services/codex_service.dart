import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/rune_item.dart';
import '../models/tarot_item.dart';

class CodexService {
  List<RuneItem> runes = [];
  List<TarotItem> cards = [];

  Future<void> loadCodex() async {
    final runesRaw = await rootBundle.loadString('assets/data/rune_codex.json');
    final runesList = jsonDecode(runesRaw) as List<dynamic>;
    runes = runesList.map((e) => RuneItem.fromJson(e)).toList();

    final tarotRaw = await rootBundle.loadString('assets/data/tarot_codex.json');
    final tarotList = jsonDecode(tarotRaw) as List<dynamic>;
    cards = tarotList.map((e) => TarotItem.fromJson(e)).toList();
  }

  RuneItem? getRune(String id) {
    try {
      return runes.firstWhere((r) => r.id == id);
    } catch (_) {
      return runes.isNotEmpty ? runes.first : null;
    }
  }

  TarotItem? getCard(String id) {
    try {
      return cards.firstWhere((c) => c.id == id);
    } catch (_) {
      return cards.isNotEmpty ? cards.first : null;
    }
  }
}
