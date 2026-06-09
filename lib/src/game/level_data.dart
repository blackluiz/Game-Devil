import 'dart:ui';

import 'game_world.dart';

class LevelInfo {
  const LevelInfo({required this.hint, this.doorStartsOpen = false});

  final String hint;
  final bool doorStartsOpen;
}

const List<LevelInfo> levels = [
  LevelInfo(
    hint: 'Apenas uma porta. O que poderia dar errado?',
    doorStartsOpen: true,
  ),
  LevelInfo(
    hint: 'A ordem pode abrir novas portas',
  ),
  LevelInfo(
    hint: 'Paciencia é o caminho',
  ),
  LevelInfo(
    hint: 'Para onde foram parar os botoes?',
    doorStartsOpen: true,
  ),
  LevelInfo(
    hint: 'Avise que chegou',
  ),
  LevelInfo(
    hint: 'Algo parece diferente',
  ),
  LevelInfo(
    hint: 'Cuidado com o buraco',
    doorStartsOpen: true,
  ),
  LevelInfo(
    hint: 'Mais botoes? talvez ordens diferentes',
  ),
  LevelInfo(
    hint: 'Espere e a resposta chegara',
  ),
  LevelInfo(
    hint: 'A resposta pode estar onde tudo comecou',
  ),
];

List<Rect> buttonRectsForLevel(int currentLevel) {
  switch (currentLevel) {
    case 1:
      return [
        Rect.fromLTWH(205, GameWorld.floorY - 12, 42, 12),
        Rect.fromLTWH(380, GameWorld.floorY - 12, 42, 12),
        Rect.fromLTWH(555, GameWorld.floorY - 12, 42, 12),
      ];
    case 5:
      return [Rect.fromLTWH(175, GameWorld.floorY - 12, 48, 12)];
    case 7:
      return [
        Rect.fromLTWH(160, GameWorld.floorY - 12, 42, 12),
        Rect.fromLTWH(290, GameWorld.floorY - 12, 42, 12),
        Rect.fromLTWH(420, GameWorld.floorY - 12, 42, 12),
        Rect.fromLTWH(550, GameWorld.floorY - 12, 42, 12),
      ];
    case 8:
      return [Rect.fromLTWH(390, GameWorld.floorY - 12, 46, 12)];
    default:
      return [];
  }
}
