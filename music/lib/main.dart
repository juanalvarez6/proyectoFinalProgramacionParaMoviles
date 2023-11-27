import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music/pages/home_page.dart';
import 'package:music/models/favorites.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FavoriteModels>(
      create: (context) => FavoriteModels(),
      child: const MaterialApp(
        title: 'Musica',
        home: MyHomePage(),
      ),
    );
  }
}
