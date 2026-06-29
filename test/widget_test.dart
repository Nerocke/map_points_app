import 'package:flutter_test/flutter_test.dart';
import 'package:map_points_app/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MapPointsApp());
    expect(find.text('Carte des points'), findsOneWidget);
  });
}
