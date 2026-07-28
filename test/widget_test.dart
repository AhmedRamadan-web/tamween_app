import 'package:flutter_test/flutter_test.dart';
import 'package:tamween_app/main.dart';

void main() {
  testWidgets('App loads test', (WidgetTester tester) async {
    await tester.pumpWidget(const TamweenApp());
    expect(find.byType(TamweenApp), findsOneWidget);
  });
}

