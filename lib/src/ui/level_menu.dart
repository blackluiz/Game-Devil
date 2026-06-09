import 'package:flutter/material.dart';

import '../game/game_devil_game.dart';
import '../game/level_data.dart';

class LevelMenu extends StatelessWidget {
  const LevelMenu({super.key, required this.game});

  final GameDevilGame game;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xEE071326),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'GAME DEVIL',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 5,
                    color: Color(0xFF7DD9FF),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Selecione uma fase', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 26),
                GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: levels.length,
                  itemBuilder: (context, index) {
                    final locked = index > game.unlockedLevel;
                    return ElevatedButton(
                      onPressed: locked ? null : () => game.startLevel(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: locked ? const Color(0xFF0A2037) : const Color(0xFF114B82),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        side: const BorderSide(color: Color(0xFF7DD9FF), width: 2),
                      ),
                      child: Text(
                        locked ? '🔒' : '${index + 1}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28),
                const Text(
                  'Controles: setas na tela, teclado A/D/W, setas, espaço, R para reiniciar e Esc para menu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
