import 'package:flutter_test/flutter_test.dart';
import 'package:ssyok_finance/main.dart';

void main() {
  testWidgets('App loads with splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('ssyok Finance'), findsOneWidget);
    expect(find.text('Financial companion for young Malaysians'), findsOneWidget);
  });
}
