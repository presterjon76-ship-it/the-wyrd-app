import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/wyrd_theme.dart';

class InscriptionLedgerScreen extends StatefulWidget {
  const InscriptionLedgerScreen({super.key});

  @override
  State<InscriptionLedgerScreen> createState() => _InscriptionLedgerScreenState();
}

class _InscriptionLedgerScreenState extends State<InscriptionLedgerScreen> {
  List<String> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadLedger();
  }

  Future<void> _loadLedger() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _entries = prefs.getStringList('wyrd_ledger_entries') ?? [];
    });
  }

  void _exportLedger() {
    if (_entries.isEmpty) return;
    final text = "THE WYRD - SACRED INSCRIPTION LEDGER\n\n" + _entries.join("\n\n");
    Share.share(text, subject: 'Wyrd Divination Journal Export');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WyrdTheme.voidBlack,
      appBar: AppBar(
        backgroundColor: WyrdTheme.voidBlack,
        title: Text("INSCRIPTION LEDGER", style: WyrdTheme.titleStyle.copyWith(fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: WyrdTheme.brassGild),
            onPressed: _exportLedger,
          ),
        ],
      ),
      body: _entries.isEmpty
          ? Center(
              child: Text(
                "NO RITES RECORDED YET.\nVISIT THE DIVINATION CHAMBER.",
                textAlign: TextAlign.center,
                style: WyrdTheme.subtitleStyle,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _entries.length,
              itemBuilder: (ctx, i) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: WyrdTheme.ironCardDecoration,
                child: Text(_entries[i], style: WyrdTheme.bodyStyle),
              ),
            ),
    );
  }
}
