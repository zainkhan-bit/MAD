import 'package:flutter_test/flutter_test.dart';
import 'package:mad/main.dart';

void main() {
  testWidgets('LoginPage renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the login page elements exist.
    expect(find.text('LOGIN'), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
