import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game_mode.dart';
import 'game_world.dart';
import 'level_data.dart';
import 'player.dart';

class GameDevilGame extends FlameGame {
  final ValueNotifier<int> uiTick = ValueNotifier<int>(0);
  final Player player = Player();

  GameMode mode = GameMode.menu;
  int currentLevel = 0;
  int unlockedLevel = 0;

  bool leftHeld = false;
  bool rightHeld = false;
  bool doorOpen = false;
  bool hasLeftStart = false;

  int sequenceProgress = 0;
  int knocks = 0;
  double waitTimer = 0;
  double idleTimer = 0;
  double knockCooldown = 0;
  double animTime = 0;
  double uiClock = 0;

  Set<int> padsDown = <int>{};

  bool get playing => mode == GameMode.playing;
  bool get hideControls => playing && currentLevel == 3;
  bool get reverseControls => playing && currentLevel == 5;

  Rect get playerRect => player.rect;
  Rect get doorRect => Rect.fromLTWH(GameWorld.width - 135, GameWorld.floorY - 78, 42, 78);
  Rect get spawnZone => Rect.fromLTWH(54, GameWorld.floorY - 12, 90, 12);
  Rect get pitRect => Rect.fromLTWH(360, GameWorld.floorY - 2, 86, 90);

  String get levelTitle => 'Level ${currentLevel + 1}/${levels.length}';
  String get currentHint => levels[currentLevel].hint;

  String get statusLine {
    if (!playing) return '';
    if (doorOpen) return 'Porta aberta!';
    if (currentLevel == 1) return 'Sequência: $sequenceProgress/3';
    if (currentLevel == 2) return 'Esperando: ${waitTimer.clamp(0, 2.5).toStringAsFixed(1)}s/2.5s';
    if (currentLevel == 4) return 'Batidas: $knocks/3';
    if (currentLevel == 7) return 'Sequência: $sequenceProgress/4';
    if (currentLevel == 8) return idleTimer > 1.0 ? 'O botão apareceu.' : 'Fique parado...';
    if (currentLevel == 9) return hasLeftStart ? 'Agora volte ao começo.' : 'Saia do começo primeiro.';
    return 'Procure a saída.';
  }

  void notifyUi() {
    uiTick.value = uiTick.value + 1;
  }

  void startLevel(int index) {
    currentLevel = index.clamp(0, levels.length - 1);
    mode = GameMode.playing;

    player.reset();
    leftHeld = false;
    rightHeld = false;
    doorOpen = levels[currentLevel].doorStartsOpen;
    sequenceProgress = 0;
    knocks = 0;
    waitTimer = 0;
    idleTimer = 0;
    knockCooldown = 0;
    hasLeftStart = false;
    padsDown.clear();

    notifyUi();
  }

  void restartLevel() {
    if (!playing) return;
    startLevel(currentLevel);
  }

  void backToMenu() {
    mode = GameMode.menu;
    leftHeld = false;
    rightHeld = false;
    notifyUi();
  }

  void setLeft(bool value) {
    leftHeld = value;
  }

  void setRight(bool value) {
    rightHeld = value;
  }

  void pressJump() {
    if (!playing || !player.grounded) return;
    player.vy = -430;
    player.grounded = false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!playing) return;

    animTime += dt;
    uiClock += dt;
    if (knockCooldown > 0) knockCooldown -= dt;

    final movingInput = leftHeld || rightHeld;
    if (movingInput || !player.grounded) {
      idleTimer = 0;
    } else {
      idleTimer += dt;
    }

    _movePlayer(dt);
    _updateLevelRules(dt);
    _checkButtons();
    _handleDoor();

    if (player.y > GameWorld.height + 80) {
      restartLevel();
      return;
    }

    if (uiClock > 0.1) {
      uiClock = 0;
      notifyUi();
    }
  }

  void _movePlayer(double dt) {
    final effectiveLeft = reverseControls ? rightHeld : leftHeld;
    final effectiveRight = reverseControls ? leftHeld : rightHeld;
    final input = (effectiveRight ? 1 : 0) - (effectiveLeft ? 1 : 0);

    player.vx = input * 205;
    player.x += player.vx * dt;
    player.x = player.x.clamp(48, GameWorld.width - 70 - player.width);

    player.vy += 980 * dt;
    player.y += player.vy * dt;

    final centerX = player.x + player.width / 2;
    final hasGround = !(currentLevel == 6 && centerX > pitRect.left && centerX < pitRect.right);

    if (hasGround && player.y + player.height >= GameWorld.floorY) {
      player.y = GameWorld.floorY - player.height;
      player.vy = 0;
      player.grounded = true;
    } else {
      player.grounded = false;
    }
  }

  void _updateLevelRules(double dt) {
    final moving = leftHeld || rightHeld || !player.grounded;

    if (currentLevel == 2) {
      final waitZone = Rect.fromLTWH(doorRect.left - 72, GameWorld.floorY - player.height - 8, 70, player.height + 8);
      if (playerRect.overlaps(waitZone) && !moving) {
        waitTimer += dt;
        if (waitTimer >= 2.5) doorOpen = true;
      } else {
        waitTimer = 0;
      }
    }

    if (currentLevel == 4) {
      final closeToDoor = playerRect.right >= doorRect.left - 4 && playerRect.left < doorRect.left;
      if (closeToDoor && rightHeld && knockCooldown <= 0) {
        knocks += 1;
        knockCooldown = 0.45;
        player.x = doorRect.left - player.width - 1;
        if (knocks >= 3) doorOpen = true;
      }
    }

    if (currentLevel == 9) {
      if (player.x > 245) hasLeftStart = true;
      if (hasLeftStart && playerRect.overlaps(spawnZone.inflate(15))) {
        doorOpen = true;
      }
    }
  }

  void _checkButtons() {
    final rects = buttonRectsForLevel(currentLevel);
    final nowDown = <int>{};

    for (var i = 0; i < rects.length; i++) {
      if (currentLevel == 8 && idleTimer <= 1.0) continue;
      final hitBox = rects[i].inflate(8);
      if (playerRect.overlaps(hitBox)) {
        nowDown.add(i);
      }
    }

    for (final index in nowDown) {
      if (!padsDown.contains(index)) {
        _onPadPressed(index);
      }
    }

    padsDown = nowDown;
  }

  void _onPadPressed(int index) {
    if (doorOpen) return;

    if (currentLevel == 1) {
      const order = [0, 1, 2];
      if (index == order[sequenceProgress]) {
        sequenceProgress += 1;
        if (sequenceProgress == order.length) doorOpen = true;
      } else {
        sequenceProgress = 0;
      }
    }

    if (currentLevel == 5) {
      doorOpen = true;
    }

    if (currentLevel == 7) {
      const order = [2, 0, 3, 1];
      if (index == order[sequenceProgress]) {
        sequenceProgress += 1;
        if (sequenceProgress == order.length) doorOpen = true;
      } else {
        sequenceProgress = 0;
      }
    }

    if (currentLevel == 8 && idleTimer > 1.0 && index == 0) {
      doorOpen = true;
    }

    notifyUi();
  }

  void _handleDoor() {
    if (playerRect.overlaps(doorRect) && doorOpen) {
      if (currentLevel >= levels.length - 1) {
        unlockedLevel = math.max(unlockedLevel, currentLevel);
        mode = GameMode.finished;
        leftHeld = false;
        rightHeld = false;
        notifyUi();
      } else {
        unlockedLevel = math.max(unlockedLevel, currentLevel + 1);
        startLevel(currentLevel + 1);
      }
      return;
    }

    if (playerRect.overlaps(doorRect) && !doorOpen) {
      if (player.x + player.width / 2 < doorRect.center.dx) {
        player.x = doorRect.left - player.width - 1;
      } else {
        player.x = doorRect.right + 1;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final scale = math.min(size.x / GameWorld.width, size.y / GameWorld.height);
    final dx = (size.x - GameWorld.width * scale) / 2;
    final dy = (size.y - GameWorld.height * scale) / 2;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color(0xFF050B18),
    );

    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(scale);
    _drawWorld(canvas);
    canvas.restore();
  }

  void _drawWorld(Canvas c) {
    final bg = Paint()..color = const Color(0xFF0B2C55);
    final wall = Paint()..color = const Color(0xFF0E477E);
    final floor = Paint()..color = const Color(0xFF08213F);
    final line = Paint()
      ..color = const Color(0xFF2C7DBC).withOpacity(0.22)
      ..strokeWidth = 1;

    c.drawRect(const Rect.fromLTWH(0, 0, GameWorld.width, GameWorld.height), bg);
    c.drawRect(const Rect.fromLTWH(36, 52, GameWorld.width - 72, GameWorld.floorY - 52), wall);
    c.drawRect(const Rect.fromLTWH(50, 70, GameWorld.width - 100, GameWorld.floorY - 92), Paint()..color = const Color(0xFF164E89));
    c.drawRect(const Rect.fromLTWH(36, GameWorld.floorY, GameWorld.width - 72, GameWorld.height - GameWorld.floorY), floor);

    for (double x = 50; x < GameWorld.width - 50; x += 16) {
      c.drawLine(Offset(x, 70), Offset(x, GameWorld.floorY), line);
    }
    for (double y = 70; y < GameWorld.floorY; y += 16) {
      c.drawLine(Offset(50, y), Offset(GameWorld.width - 50, y), line);
    }

    _drawLevelChanges(c);
    _drawDoor(c);
    player.draw(c, animTime: animTime, leftHeld: leftHeld, rightHeld: rightHeld);
  }

  void _drawLevelChanges(Canvas c) {
    if (currentLevel == 6) {
      c.drawRect(pitRect, Paint()..color = const Color(0xFF050B18));
      final warn = Paint()
        ..color = const Color(0xFF7BB7E9).withOpacity(0.6)
        ..strokeWidth = 2;

      for (double x = pitRect.left + 8; x < pitRect.right - 8; x += 18) {
        c.drawLine(Offset(x, GameWorld.floorY + 5), Offset(x + 10, GameWorld.floorY + 28), warn);
      }
    }

    if (currentLevel == 9 && !doorOpen) {
      c.drawRect(spawnZone, Paint()..color = const Color(0xFF67D4FF).withOpacity(0.45));
    }

    final rects = buttonRectsForLevel(currentLevel);
    for (var i = 0; i < rects.length; i++) {
      if (currentLevel == 8 && idleTimer <= 1.0) continue;
      final active = padsDown.contains(i);
      _drawButtonPad(c, rects[i], i + 1, active);
    }
  }

  void _drawDoor(Canvas c) {
    final border = Paint()..color = doorOpen ? const Color(0xFF57C9FF) : const Color(0xFF041A3A);
    final inner = Paint()..color = doorOpen ? const Color(0xFF8BE2FF).withOpacity(0.7) : const Color(0xFF6DCBFF).withOpacity(0.32);
    final glow = Paint()..color = const Color(0xFF57C9FF).withOpacity(doorOpen ? 0.28 : 0.07);

    c.drawRect(doorRect.inflate(12), glow);
    c.drawRect(doorRect.inflate(5), border);
    c.drawRect(doorRect.deflate(6), inner);

    if (!doorOpen) {
      c.drawRect(
        Rect.fromLTWH(doorRect.left + 18, doorRect.top + 34, 7, 7),
        Paint()..color = const Color(0xFF001124),
      );
    }
  }

  void _drawButtonPad(Canvas c, Rect rect, int label, bool active) {
    final border = Paint()..color = const Color(0xFF35110A);
    final top = Paint()..color = active ? const Color(0xFFFFD36D) : const Color(0xFFFF6B34);
    final side = Paint()..color = const Color(0xFF8B2C1A);

    c.drawRect(rect.inflate(4), border);
    c.drawRect(rect.translate(0, 6), side);
    c.drawRect(rect, top);

    final painter = TextPainter(
      text: TextSpan(
        text: '$label',
        style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();

    painter.paint(c, Offset(rect.center.dx - painter.width / 2, rect.top - 18));
  }
}
