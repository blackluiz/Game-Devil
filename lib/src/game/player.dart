import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import 'game_world.dart';

class Player {
  Player() {
    reset();
  }

  double x = 90;
  double y = GameWorld.floorY - 42;
  double vx = 0;
  double vy = 0;

  final double width = 20;
  final double height = 42;

  bool grounded = true;

  Rect get rect => Rect.fromLTWH(x, y, width, height);

  void reset() {
    x = 90;
    y = GameWorld.floorY - height;
    vx = 0;
    vy = 0;
    grounded = true;
  }

  void draw(Canvas c, {required double animTime, required bool leftHeld, required bool rightHeld}) {
    final p = Paint()..color = Colors.black;
    final head = Rect.fromLTWH(x + 3, y, 14, 14);
    final body = Rect.fromLTWH(x + 5, y + 14, 10, 18);

    c.drawRect(head, p);
    c.drawRect(body, p);

    final isWalking = grounded && (leftHeld || rightHeld);
    final legSwing = grounded ? math.sin(animTime * 12) * (isWalking ? 4 : 0) : -5.0;

    c.drawRect(Rect.fromLTWH(x + 4 + legSwing, y + 31, 5, 11), p);
    c.drawRect(Rect.fromLTWH(x + 11 - legSwing, y + 31, 5, 11), p);

    final eye = Paint()..color = const Color(0xFF164E89);
    c.drawRect(Rect.fromLTWH(x + 12, y + 5, 2, 2), eye);
  }
}
