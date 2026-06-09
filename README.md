# Game Devil Flutter - versão refatorada

Protótipo 2D feito em Flutter + Flame.

## Estrutura principal

- `lib/main.dart`: entrada do app.
- `lib/src/game_devil_app.dart`: configura o MaterialApp.
- `lib/src/game_devil_screen.dart`: tela que junta Flame + UI + teclado.
- `lib/src/game/game_devil_game.dart`: lógica central do jogo.
- `lib/src/game/player.dart`: personagem.
- `lib/src/game/level_data.dart`: fases, dicas e posições dos botões.
- `lib/src/game/game_world.dart`: medidas do mundo.
- `lib/src/ui/`: menus, HUD, controles e tela final.

## Rodar

```bash
flutter pub get
flutter run -d chrome
```

## GitHub

Antes de enviar para o GitHub, garanta que o `.gitignore` está no projeto. Não envie `build/`, `.dart_tool/`, `ios/Flutter/ephemeral/`, `macos/Flutter/ephemeral/` nem `windows/flutter/ephemeral/`.
