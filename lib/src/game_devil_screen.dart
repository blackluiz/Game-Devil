import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game/game_devil_game.dart';
import 'ui/game_ui.dart';

// Esta tela junta duas partes importantes:
// 1) O GameWidget, que desenha o jogo feito com Flame.
// 2) A interface Flutter por cima, com menu, dicas, HUD e botões de toque.
class GameDevilScreen extends StatefulWidget {
  const GameDevilScreen({super.key});

  @override
  State<GameDevilScreen> createState() => _GameDevilScreenState();
}

class _GameDevilScreenState extends State<GameDevilScreen> {
  late final GameDevilGame game;

  @override
  void initState() {
    super.initState();
    
     // Cria uma única instância do jogo.
    // Essa instância guarda a fase atual, posição do personagem, porta aberta etc.
    game = GameDevilGame();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    final down = event is KeyDownEvent || event is KeyRepeatEvent;
    final up = event is KeyUpEvent;
    if (!down && !up) return KeyEventResult.ignored;

    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.arrowLeft || key == LogicalKeyboardKey.keyA) {
      game.setLeft(down);
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.arrowRight || key == LogicalKeyboardKey.keyD) {
      game.setRight(down);
      return KeyEventResult.handled;
    }

    if ((key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.space || key == LogicalKeyboardKey.keyW) &&
        event is KeyDownEvent) {
      game.pressJump();
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.keyR && event is KeyDownEvent) {
      game.restartLevel();
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.escape && event is KeyDownEvent) {
      game.backToMenu();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Focus(
        autofocus: true,
        onKeyEvent: _onKey,
        child: Stack(
          fit: StackFit.expand,
          children: [
            GameWidget(game: game),
            ValueListenableBuilder<int>(
              valueListenable: game.uiTick,
              builder: (context, _, __) => GameUi(game: game),
            ),
          ],
        ),
      ),
    );
  }
}
