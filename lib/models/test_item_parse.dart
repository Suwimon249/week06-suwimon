import 'dart:convert';
import 'item.dart'; // อ้างอิงตามไฟล์ item.dart ที่มีอยู่ในโปรเจกต์ของคุณ

void main() {
  const rawJson = '''
  {
    "id": 1,
    "title": "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
    "price": 109.95,
    "description": "Your perfect pack for everyday use...",
    "category": "men's clothing",
    "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg"
  }
  ''';

  final json = jsonDecode(rawJson) as Map<String, dynamic>;
  final item = Item.fromJson(json);

  print('id: ${item.id}');
  print('title: ${item.title}');
  print('price: ${item.price}');
  print('description: ${item.description}');
  print('category: ${item.category}');
  print('imageUrl: ${item.imageUrl}'); // ปรับชื่อฟิลด์ตาม Property จริงในคลาส Item ของคุณ (เช่น item.image หรือ item.imageUrl)
}