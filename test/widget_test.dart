import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:campus_marketplace/main.dart';
import 'package:campus_marketplace/models/favorites_model.dart';

void main() {
  testWidgets('Search box filters items case-insensitively', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => FavoritesModel(),
        child: const MyApp(),
      ),
    );

    // Verify initial state shows all catalog items
    expect(find.text('หนังสือ Calculus มือสอง'), findsOneWidget);
    expect(find.text('หูฟังไร้สาย (สภาพดี 90%)'), findsOneWidget);
    expect(find.text('โคมไฟตั้งโต๊ะหอพัก'), findsOneWidget);

    // Enter search keyword 'calculus' (lowercase)
    await tester.enterText(find.byType(TextField), 'calculus');
    await tester.pump();

    // Verify only 'หนังสือ Calculus มือสอง' is shown
    expect(find.text('หนังสือ Calculus มือสอง'), findsOneWidget);
    expect(find.text('หูฟังไร้สาย (สภาพดี 90%)'), findsNothing);
    expect(find.text('โคมไฟตั้งโต๊ะหอพัก'), findsNothing);

    // Enter non-matching search keyword
    await tester.enterText(find.byType(TextField), 'โน้ตบุ๊ก');
    await tester.pump();

    // Verify empty search result message is displayed
    expect(find.text('ไม่พบสินค้าที่ตรงกับการค้นหา'), findsOneWidget);
    expect(find.text('หนังสือ Calculus มือสอง'), findsNothing);
  });

  testWidgets('Clear all favorites shows dialog and clears items when confirmed', (WidgetTester tester) async {
    final favoritesModel = FavoritesModel();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: favoritesModel,
        child: const MyApp(),
      ),
    );

    // Add an item to favorites
    await tester.tap(find.text('🤍 บันทึกเป็นรายการโปรด').first);
    await tester.pump();
    expect(favoritesModel.itemCount, 1);

    // Open Favorites page
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();

    // Verify clear button (delete_sweep) is visible
    expect(find.byIcon(Icons.delete_sweep), findsOneWidget);

    // Tap clear button to show confirmation dialog
    await tester.tap(find.byIcon(Icons.delete_sweep));
    await tester.pumpAndSettle();

    // Verify AlertDialog is visible
    expect(find.text('ยืนยันการล้างรายการโปรด'), findsOneWidget);

    // Tap confirm clear button
    await tester.tap(find.text('ล้างทั้งหมด'));
    await tester.pumpAndSettle();

    // Verify favorites list is cleared
    expect(favoritesModel.itemCount, 0);
    expect(find.text('ยังไม่มีสินค้าที่บันทึกไว้'), findsOneWidget);
    expect(find.byIcon(Icons.delete_sweep), findsNothing);
  });
}
