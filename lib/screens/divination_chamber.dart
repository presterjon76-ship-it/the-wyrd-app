import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../theme/wyrd_theme.dart';
import '../services/codex_service.dart';
import '../models/rune_item.dart';
import '../models/tarot_item.dart';

class DivinationChamberScreen extends StatefulWidget {
  final CodexService codex;

  const DivinationChamberScreen({super.key, required this.codex});

  @override
  State<DivinationChamberScreen> createState() => _DivinationChamberScreenState();
}

class _DivinationChamberScreenState extends State<DivinationChamberScreen> {
  RuneItem? _drawnRune;
  bool _isRuneReversed = false;

  TarotItem? _drawnCard;
  bool _isCardReversed = false;

  bool _isFlipped = false;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkDailyRiteState();
  }

  String get _todayKey => DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<void> _checkDailyRiteState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('wyrd_daily_date');

    if (savedDate == _todayKey) {
      final runeId = prefs.getString('wyrd_daily_rune_id') ?? 'fehu';
      final runeRev = prefs.getBool('wyrd_daily_rune_rev') ?? false;
      final cardId = prefs.getString('wyrd_daily_card_id') ?? 'fool';
      final cardRev = prefs.getBool('wyrd_daily_card_rev') ?? false;

      setState(() {
        _drawnRune = widget.codex.getRune(runeId);
        _isRuneReversed = runeRev;
        _drawnCard = widget.codex.getCard(cardId);
        _isCardReversed = cardRev;
        _isFlipped = true;
      });
    }
  }

  Future<void> _performDailyRite() async {
    await HapticFeedback.heavyImpact();
    await SystemSound.play(SystemSoundType.click);

    final rng = Random();
    
    // 1. Draw Rune
    final rList = widget.codex.runes;
    final r = rList[rng.nextInt(rList.length)];
    // Symmetrical rune constraint: never invert if canInvert is false
    final rRev = r.canInvert ? rng.nextBool() : false;

    // 2. Draw Tarot Card
    final cList = widget.codex.cards;
    final c = cList[rng.nextInt(cList.length)];
    final cRev = rng.nextBool();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('wyrd_daily_date', _todayKey);
    await prefs.setString('wyrd_daily_rune_id', r.id);
    await prefs.setBool('wyrd_daily_rune_rev', rRev);
    await prefs.setString('wyrd_daily_card_id', c.id);
    await prefs.setBool('wyrd_daily_card_rev', cRev);

    setState(() {
      _drawnRune = r;
      _isRuneReversed = rRev;
      _drawnCard = c;
      _isCardReversed = cRev;
      _isFlipped = true;
    });
  }

  Future<void> _recordToLedger() async {
    if (_drawnRune == null && _drawnCard == null) return;
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('wyrd_ledger_entries') ?? [];

    final timestamp = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    final cardStr = _drawnCard != null ? "\${_drawnCard!.name} (\${_isCardReversed ? 'Reversed' : 'Upright'})" : 'None';
    final runeStr = _drawnRune != null ? "\${_drawnRune!.name} (\${_isRuneReversed ? 'Merkstave' : 'Upright'})" : 'None';
    final note = _noteController.text.trim();

    final entry = "[$timestamp] TAROT: $cardStr | RUNE: $runeStr\nNOTE: \${note.isEmpty ? 'Communion recorded.' : note}\n---";
    history.insert(0, entry);
    await prefs.setStringList('wyrd_ledger_entries', history);

    _noteController.clear();
    await HapticFeedback.mediumImpact();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: WyrdTheme.darkIron,
          content: Text("SACRED RITE INSCRIBED IN LEDGER", style: TextStyle(color: WyrdTheme.brassGild)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WyrdTheme.voidBlack,
      appBar: AppBar(
        backgroundColor: WyrdTheme.voidBlack,
        title: Text("DIVINATION CHAMBER", style: WyrdTheme.titleStyle.copyWith(fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("THE DAILY RITE", style: WyrdTheme.subtitleStyle),
            const SizedBox(height: 16),
            if (!_isFlipped)
              GestureDetector(
                onTap: _performDailyRite,
                child: Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: WyrdTheme.darkIron,
                    border: Border.all(color: WyrdTheme.brassGild, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shield, size: 72, color: WyrdTheme.brassGild),
                      const SizedBox(height: 16),
                      Text("TAP TO COMMUNE WITH THE WYRD", style: WyrdTheme.titleStyle.copyWith(fontSize: 14)),
                      const SizedBox(height: 8),
                      Text("Invokes Imperial Tarot & Elder Futhark", style: WyrdTheme.subtitleStyle.copyWith(fontSize: 10)),
                    ],
                  ),
                ),
              )
            else ...[
              // Display Drawn Rune & Card Cards
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: WyrdTheme.ironCardDecoration,
                      child: Column(
                        children: [
                          Text("RUNIC TILE", style: WyrdTheme.subtitleStyle.copyWith(fontSize: 10)),
                          const SizedBox(height: 8),
                          Text(_drawnRune!.name.toUpperCase(), style: WyrdTheme.titleStyle.copyWith(fontSize: 16)),
                          Text(
                            _isRuneReversed ? "MERKSTAVE" : "UPRIGHT",
                            style: TextStyle(
                              color: _isRuneReversed ? WyrdTheme.shadowCrimson : WyrdTheme.glowGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isRuneReversed ? _drawnRune!.shadowMeaning : _drawnRune!.uprightMeaning,
                            style: WyrdTheme.bodyStyle.copyWith(fontSize: 11),
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: WyrdTheme.ironCardDecoration,
                      child: Column(
                        children: [
                          Text("IMPERIAL TAROT", style: WyrdTheme.subtitleStyle.copyWith(fontSize: 10)),
                          const SizedBox(height: 8),
                          Text(_drawnCard!.name.toUpperCase(), style: WyrdTheme.titleStyle.copyWith(fontSize: 14), textAlign: TextAlign.center),
                          Text(
                            _isCardReversed ? "REVERSED" : "UPRIGHT",
                            style: TextStyle(
                              color: _isCardReversed ? WyrdTheme.shadowCrimson : WyrdTheme.glowGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isCardReversed ? _drawnCard!.reversedMeaning : _drawnCard!.uprightMeaning,
                            style: WyrdTheme.bodyStyle.copyWith(fontSize: 11),
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _noteController,
                style: WyrdTheme.bodyStyle,
                cursorColor: WyrdTheme.brassGild,
                decoration: InputDecoration(
                  hintText: "Enter daily contemplation or physical mark...",
                  hintStyle: WyrdTheme.bodyStyle.copyWith(color: Colors.white24),
                  filled: true,
                  fillColor: WyrdTheme.darkIron,
                  border: OutlineInputBorder(borderSide: BorderSide(color: WyrdTheme.borderIron)),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _recordToLedger,
                icon: const Icon(Icons.history_edu, color: WyrdTheme.voidBlack),
                label: const Text("INSCRIBE IN LEDGER", style: TextStyle(color: WyrdTheme.voidBlack, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: WyrdTheme.brassGild),
              )
            ]
          ],
        ),
      ),
    );
  }
}
