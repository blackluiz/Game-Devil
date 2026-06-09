import 'package:flutter/material.dart';

import '../game/game_devil_game.dart';

class Controls extends StatelessWidget {
  const Controls({super.key, required this.game});

  final GameDevilGame game;

  @override
  Widget build(BuildContext context) {
    final visibleOpacity = game.hideControls ? 0.0 : 0.86;

    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Opacity(
                opacity: visibleOpacity,
                child: Row(
                  children: [
                    PadButton(label: '◀', onDown: () => game.setLeft(true), onUp: () => game.setLeft(false)),
                    const SizedBox(width: 12),
                    PadButton(label: '▶', onDown: () => game.setRight(true), onUp: () => game.setRight(false)),
                  ],
                ),
              ),
              const Spacer(),
              Opacity(
                opacity: visibleOpacity,
                child: PadButton(label: '▲', onDown: game.pressJump, onUp: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PadButton extends StatelessWidget {
  const PadButton({super.key, required this.label, required this.onDown, required this.onUp});

  final String label;
  final VoidCallback onDown;
  final VoidCallback onUp;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => onDown(),
      onTapUp: (_) => onUp(),
      onTapCancel: onUp,
      child: Container(
        width: 72,
        height: 62,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xCC0A1D35),
          border: Border.all(color: const Color(0xFFE6F8FF), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
