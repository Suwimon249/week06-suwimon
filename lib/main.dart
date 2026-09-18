import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/favorites_model.dart';
import 'repositories/item_repository_api.dart'; 
import 'home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoritesModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Marketplace',
      debugShowCheckedModeBanner: false,
      // เปลี่ยนจาก itemRepository เป็น repository ให้ตรงกับ HomePage
      home: HomePage(repository: ItemRepositoryApi()),
    );
  }
}