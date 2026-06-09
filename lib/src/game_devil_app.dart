import 'package:flutter/material.dart';

import 'game_devil_screen.dart';

class GameDevilApp extends StatelessWidget {
  const GameDevilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game Devil',
      theme: ThemeData.dark(useMaterial3: true),
      home: const GameDevilScreen(),
    );
  }
}
