import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:latihan_responsi/screens/login_screen.dart';

void main() {
  testWidgets('Login screen shows its fields', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      const MaterialApp(home: LoginScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsNWidgets(2));
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
