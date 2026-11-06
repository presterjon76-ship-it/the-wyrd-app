import 'package:flutter/material.dart';
import 'theme/wyrd_theme.dart';
import 'services/codex_service.dart';
import 'screens/divination_chamber.dart';
import 'screens/sacred_codex.dart';
import 'screens/inscription_ledger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final codex = CodexService();
  await codex.loadCodex();

  runApp(WyrdApp(codex: codex));
}

class WyrdApp extends StatelessWidget {
  final CodexService codex;

  const WyrdApp({super.key, required this.codex});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Wyrd',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: WyrdTheme.voidBlack,
      ),
      home: WyrdHubMenu(codex: codex),
    );
  }
}

class WyrdHubMenu extends StatelessWidget {
  final CodexService codex;

  const WyrdHubMenu({super.key, required this.codex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WyrdTheme.voidBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                "THE WYRD",
                textAlign: TextAlign.center,
                style: WyrdTheme.titleStyle.copyWith(fontSize: 26),
              ),
              const SizedBox(height: 4),
              Text(
                "IMPERIAL TAROT & SACRED RUNIC RECORD",
                textAlign: TextAlign.center,
                style: WyrdTheme.subtitleStyle.copyWith(fontSize: 10),
              ),
              const Spacer(),
              _buildMenuButton(
                context,
                icon: Icons.auto_awesome,
                title: "DIVINATION CHAMBER",
                subtitle: "Daily Rite, Tarot & Rune Casting",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DivinationChamberScreen(codex: codex))),
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                context,
                icon: Icons.menu_book,
                title: "SACRED CODEX",
                subtitle: "Full Reference of 25 Runes & Tarot",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SacredCodexScreen(codex: codex))),
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                context,
                icon: Icons.history_edu,
                title: "INSCRIPTION LEDGER",
                subtitle: "Divination Journal & Zero-Permission Export",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InscriptionLedgerScreen())),
              ),
              const Spacer(),
              Text(
                "ADEPTUS MECHANICUS COGITATOR PROTOCOL // v1.0",
                textAlign: TextAlign.center,
                style: WyrdTheme.subtitleStyle.copyWith(fontSize: 8, color: Colors.white24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: WyrdTheme.darkIron,
          border: Border.all(color: WyrdTheme.brassGild.withOpacity(0.6), width: 1.5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, color: WyrdTheme.brassGild, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: WyrdTheme.titleStyle.copyWith(fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: WyrdTheme.subtitleStyle.copyWith(fontSize: 10)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: WyrdTheme.brassGild),
          ],
        ),
      ),
    );
  }
}
