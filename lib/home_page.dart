import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/item.dart';
import 'models/favorites_model.dart';
import 'widgets/item_list_section.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // กรองรายการสินค้าโดยเช็คว่า title มีคำค้นหาหรือไม่ (Case-insensitive)
    final filteredCatalog = catalog.where((item) {
      return item.title.toLowerCase().contains(_searchQuery.toLowerCase().trim());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Marketplace'),
        actions: [
          IconButton(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite),
                // .watch ทำให้ตัวเลขนี้อัปเดตเองทุกครั้งที่ FavoritesModel เปลี่ยน
                Text(' ${context.watch<FavoritesModel>().itemCount}'),
              ],
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesPage()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'ค้นหาสินค้า',
                  hintText: 'พิมพ์ชื่อสินค้าเพื่อค้นหา...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            filteredCatalog.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(
                      child: Text(
                        'ไม่พบสินค้าที่ตรงกับการค้นหา',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  )
                : ItemListSection(catalog: filteredCatalog),
          ],
        ),
      ),
    );
  }
}
