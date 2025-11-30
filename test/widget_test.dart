import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Production Company App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProductionCompanyApp());
    await tester.pumpAndSettle();

    expect(find.text('شركة الإبداع'), findsOneWidget);
    expect(find.text('للإنتاج الفني والتصوير'), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt), findsWidgets);
  });

  testWidgets('NavBar Widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: const Center(child: Text('Test')),
          bottomNavigationBar: NavBarWidget(
            icons: const [Icons.home, Icons.work, Icons.photo_library, Icons.contact_mail],
            labels: const ['الرئيسية', 'الخدمات', 'الأعمال', 'اتصل بنا'],
            backgroundColor: Colors.deepPurple,
            iconColor: Colors.grey,
            selectedIconColor: Colors.amber,
            selectedIndex: 0,
          ),
        ),
      ),
    );

    expect(find.text('الرئيسية'), findsOneWidget);
    expect(find.text('الخدمات'), findsOneWidget);
    expect(find.text('الأعمال'), findsOneWidget);
    expect(find.text('اتصل بنا'), findsOneWidget);
  });

  testWidgets('Service Detail Page has required elements', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ServiceDetailPage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('تفاصيل الخدمة'), findsOneWidget);
    expect(find.text('تصوير المؤتمرات والفعاليات'), findsOneWidget);
  });

  testWidgets('Tabs work correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ServiceDetailPage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('نظرة عامة'), findsOneWidget);
    expect(find.text('الباقات'), findsOneWidget);
    expect(find.text('التقييمات'), findsOneWidget);

    await tester.tap(find.text('الباقات'));
    await tester.pumpAndSettle();

    expect(find.text('الباقة الأساسية'), findsOneWidget);
    expect(find.text('الباقة الفضية'), findsOneWidget);
    expect(find.text('الباقة الذهبية'), findsOneWidget);
  });

  testWidgets('Booking dialog can be opened and closed', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ServiceDetailPage(),
      ),
    );

    await tester.pumpAndSettle();

    final bookingButton = find.text('احجز الآن').last;
    await tester.tap(bookingButton);
    await tester.pumpAndSettle();

    expect(find.text('حجز الخدمة'), findsOneWidget);
    expect(find.text('الاسم الكامل'), findsOneWidget);

    await tester.tap(find.text('إلغاء'));
    await tester.pumpAndSettle();

    expect(find.text('حجز الخدمة'), findsNothing);
  });

  testWidgets('Package selection updates state', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ServiceDetailPage(),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('الباقات'));
    await tester.pumpAndSettle();

    final silverPackage = find.text('الباقة الفضية');
    expect(silverPackage, findsOneWidget);

    await tester.tap(silverPackage);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('Favorite button toggles state', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ServiceDetailPage(),
      ),
    );

    await tester.pumpAndSettle();

    final favoriteButton = find.byIcon(Icons.favorite_border);
    expect(favoriteButton, findsOneWidget);

    await tester.tap(favoriteButton);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.text('تمت الإضافة للمفضلة'), findsOneWidget);
  });
}
