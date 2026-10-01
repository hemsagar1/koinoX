import 'package:flutter_test/flutter_test.dart';
import 'package:koinox/app/app.dart';

void main() {
  testWidgets('KoinoX App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KoinoXApp());
    expect(find.text('KoinoX'), findsWidgets);
  });
}
