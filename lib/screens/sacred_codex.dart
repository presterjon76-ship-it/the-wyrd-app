import 'package:flutter/material.dart';
import '../theme/wyrd_theme.dart';
import '../services/codex_service.dart';
import '../models/rune_item.dart';

class SacredCodexScreen extends StatelessWidget {
  final CodexService codex;

  const SacredCodexScreen({super.key, required this.codex});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: WyrdTheme.voidBlack,
        appBar: AppBar(
          backgroundColor: WyrdTheme.voidBlack,
          title: Text("THE SACRED CODEX", style: WyrdTheme.titleStyle.copyWith(fontSize: 16)),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: WyrdTheme.brassGild,
            labelColor: WyrdTheme.brassGild,
            tabs: [
              Tab(text: "ELDER FUTHARK"),
              Tab(text: "IMPERIAL TAROT"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: codex.runes.length,
              itemBuilder: (ctx, i) {
                final r = codex.runes[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: WyrdTheme.ironCardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("\${r.name} [\${r.letter}]", style: WyrdTheme.titleStyle.copyWith(fontSize: 15)),
                          Text("AETT: \${r.aett.toUpperCase()}", style: WyrdTheme.subtitleStyle.copyWith(fontSize: 10)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        children: r.keywords.map((k) => Chip(
                          backgroundColor: WyrdTheme.voidBlack,
                          label: Text(k, style: const TextStyle(fontSize: 10, color: WyrdTheme.brassGild)),
                        )).toList(),
                      ),
                      const SizedBox(height: 8),
                      Text("UPRIGHT: \${r.uprightMeaning}", style: WyrdTheme.bodyStyle.copyWith(fontSize: 12)),
                      const SizedBox(height: 4),
                      Text("SHADOW: \${r.shadowMeaning}", style: WyrdTheme.bodyStyle.copyWith(fontSize: 12, color: WyrdTheme.shadowCrimson)),
                    ],
                  ),
                );
              },
            ),
            ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: codex.cards.length,
              itemBuilder: (ctx, i) {
                final c = codex.cards[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: WyrdTheme.ironCardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(c.name, style: WyrdTheme.titleStyle.copyWith(fontSize: 15)),
                          Text(c.suit.toUpperCase(), style: WyrdTheme.subtitleStyle.copyWith(fontSize: 10)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text("UPRIGHT: \${c.uprightMeaning}", style: WyrdTheme.bodyStyle.copyWith(fontSize: 12)),
                      const SizedBox(height: 4),
                      Text("REVERSED: \${c.reversedMeaning}", style: WyrdTheme.bodyStyle.copyWith(fontSize: 12, color: WyrdTheme.shadowCrimson)),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
