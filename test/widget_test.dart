import 'package:flutter_test/flutter_test.dart';
import 'package:pingme/main.dart';

void main() {
  testWidgets('PingMeApp renders successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const PingMeApp());
    expect(find.text('PingMe'), findsOneWidget);
  });
}
