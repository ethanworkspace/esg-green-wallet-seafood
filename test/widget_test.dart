import 'package:flutter_test/flutter_test.dart';
import 'package:esg_green_wallet/app.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ESGGreenWalletApp());
    expect(find.text('ESG Green Wallet'), findsOneWidget);
  });
}
