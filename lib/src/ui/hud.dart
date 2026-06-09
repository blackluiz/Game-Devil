import 'package:flutter/material.dart';

import '../game/game_devil_game.dart';

class Hud extends StatelessWidget {
  const Hud({super.key, required this.game});

  final GameDevilGame game;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                SmallHudButton(text: 'MENU', onTap: game.backToMenu),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xAA06152A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF7DD9FF)),
                  ),
                  child: Column(
                    children: [
                      Text(game.levelTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(game.statusLine, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                ),
                const Spacer(),
                SmallHudButton(text: 'RESET', onTap: game.restartLevel),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xAA06152A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                game.currentHint,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: Color(0xFFE6F8FF)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SmallHudButton extends StatelessWidget {
  const SmallHudButton({super.key, required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xAA06152A),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7DD9FF)),
          ),
        ),
      ),
    );
  }
}
