import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:product_detail_page/app.dart';
import 'package:product_detail_page/mocks/mock_location.dart';

Widget makeTestableWidget() => const App();

void main() {
  testWidgets('test app startup', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(makeTestableWidget());

      final mockLocation = MockLocation.fetchAny();

      expect(find.text(mockLocation.name), findsOneWidget);
      expect(find.text('${mockLocation.name}blah'), findsNothing);
    });
  });
}
