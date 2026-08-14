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
}
