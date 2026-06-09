import 'package:flutter/material.dart';

import '../game/game_devil_game.dart';
import '../game/game_mode.dart';
import 'controls.dart';
import 'finished_screen.dart';
import 'hud.dart';
import 'level_menu.dart';

class GameUi extends StatelessWidget {
  const GameUi({super.key, required this.game});

  final GameDevilGame game;

  @override
  Widget build(BuildContext context) {
    switch (game.mode) {
      case GameMode.menu:
        return LevelMenu(game: game);
      case GameMode.playing:
        return Stack(
          children: [
            Hud(game: game),
            Controls(game: game),
          ],
        );
      case GameMode.finished:
        return FinishedScreen(game: game);
    }
  }
}
