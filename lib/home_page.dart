import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/item.dart';
import 'models/favorites_model.dart'; // ใช้ FavoritesModel ตามที่คุณมีอยู่ในโปรเจกต์
import 'repositories/item_repository.dart';
import 'favorites_page.dart'; // ใช้ FavoritesPage

class HomePage extends StatefulWidget {
  final ItemRepository repository;

  const HomePage({super.key, required this.repository});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Item>> _itemsFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _itemsFuture = widget.repository.getItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Marketplace'),
        actions: [
          IconButton(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite),
                // ใช้ FavoritesModel แทน CartModel
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
      body: Column(
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
          Expanded(
            child: FutureBuilder<List<Item>>(
              future: _itemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('ไม่พบสินค้าในระบบ'));
                }

                final items = snapshot.data!;
                final filteredCatalog = items.where((item) {
                  return item.title.toLowerCase().contains(_searchQuery.toLowerCase().trim());
                }).toList();

                if (filteredCatalog.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(
                      child: Text(
                        'ไม่พบสินค้าที่ตรงกับการค้นหา',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredCatalog.length,
                  itemBuilder: (context, index) {
                    final item = filteredCatalog[index];
                    final favorites = context.watch<FavoritesModel>();
                    final alreadySaved = favorites.items.any((i) => i.id == item.id);

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text('฿${item.price.toStringAsFixed(2)}'),
                        trailing: ElevatedButton(
                          onPressed: alreadySaved
                              ? null
                              : () {
                                  // ใช้ FavoritesModel สำหรับเพิ่มรายการ
                                  context.read<FavoritesModel>().add(item);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('บันทึก ${item.title} แล้ว')),
                                  );
                                },
                          child: Text(alreadySaved ? '❤️ บันทึกแล้ว' : '🤍 บันทึก'),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}