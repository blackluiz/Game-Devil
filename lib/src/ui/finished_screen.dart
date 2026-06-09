import 'package:flutter/material.dart';

import '../game/game_devil_game.dart';

// Tela mostrada quando o jogador termina a última fase.
class FinishedScreen extends StatelessWidget {
  const FinishedScreen({super.key, required this.game});

  final GameDevilGame game;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xDD040915),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Card(
            color: const Color(0xFF071326),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'FIM DO PROTÓTIPO',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFF7DD9FF)),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Você terminou as 10 fases.Isso era apenas um prototipo nao espere muito',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: () => game.startLevel(0), child: const Text('Recomeçar')),
                      const SizedBox(width: 12),
                      OutlinedButton(onPressed: game.backToMenu, child: const Text('Menu')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
