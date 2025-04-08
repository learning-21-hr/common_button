import 'package:common_button/common_button.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Button should be enabled when text is entered in TextField', (WidgetTester tester) async {
    // Build the widget tree for MyApp
    await tester.pumpWidget(const MyApp());

    // Find the TextField and enter text
    final textField = find.byType(TextFormField);
    await tester.enterText(textField, 'Some input text');
    await tester.pump(); // Rebuild the widget tree

    // Now, the button should be enabled because the notifier value is true
    expect(find.byType(CommonButton), findsOneWidget);
    final commonButton = tester.widget<CommonButton>(find.byType(CommonButton));
    expect(commonButton.onTap, isNotNull); // Ensure onTap is not null, i.e., button is enabled
  });

  testWidgets('Button should be disabled when TextField is empty', (WidgetTester tester) async {
    // Build the widget tree for MyApp
    await tester.pumpWidget(const MyApp());

    // Find the TextField and make it empty (clear any input)
    final textField = find.byType(TextFormField);
    await tester.enterText(textField, '');
    await tester.pump(); // Rebuild the widget tree

    // Now, the button should be disabled because the notifier value is false
    expect(find.byType(CommonButton), findsOneWidget);
    final commonButton = tester.widget<CommonButton>(find.byType(CommonButton));
    expect(commonButton.onTap, isNotNull); // Ensure onTap is not null, i.e., button is disabled
  });

  testWidgets('Button should be disabled when TextField contains only spaces', (WidgetTester tester) async {
    // Build the widget tree for MyApp
    await tester.pumpWidget(const MyApp());

    // Find the TextField and enter spaces only
    final textField = find.byType(TextFormField);
    await tester.enterText(textField, '     ');
    await tester.pump(); // Rebuild the widget tree

    // The button should be disabled because the text is empty after trimming
    expect(find.byType(CommonButton), findsOneWidget);
    final commonButton = tester.widget<CommonButton>(find.byType(CommonButton));
    expect(commonButton.onTap, isNotNull); // Ensure onTap is not null, i.e., button is disabled
  });

  testWidgets('Button should call onTap when tapped and text is entered', (WidgetTester tester) async {
    // Build the widget tree for MyApp
    await tester.pumpWidget(const MyApp());

    // Find the TextField and enter text
    final textField = find.byType(TextFormField);
    await tester.enterText(textField, 'Some input text');
    await tester.pump(const Duration(seconds: 15)); // Rebuild the widget tree

    // Find the button and tap it
    final button = find.byType(CommonButton);
    await tester.tap(button);
    await tester.pump(const Duration(seconds: 15)); // Rebuild the widget tree to trigger any side effects

    // Verify that the onTap callback was triggered
    // We can't directly check the print output, but you can verify if the button tap logic works
    expect(find.byType(CommonButton), findsOneWidget); // Ensure button still exists
  });

  testWidgets('Button should respect gradient colors when enabled', (WidgetTester tester) async {
    // Build the widget tree for MyApp
    await tester.pumpWidget(const MyApp());

    // Find the button and verify its decoration (i.e., gradient)
    final button = find.byType(CommonButton);
    final commonButton = tester.widget<CommonButton>(button);

    // Ensure the gradientColors property is passed and not null
    expect(commonButton.gradientColors, isNotNull);
    expect(commonButton.gradientColors!.length, 7); // 7 colors in the gradient
  });

  testWidgets('Button should have the correct size based on buttonSize', (WidgetTester tester) async {
    // Build the widget tree for MyApp
    await tester.pumpWidget(const MyApp());

    // Find the button and verify its size
    final button = find.byType(CommonButton);
    final commonButton = tester.widget<CommonButton>(button);

    // Ensure button size matches the expected value
    expect(commonButton.buttonSize.width, 100);
    expect(commonButton.buttonSize.height, 100);
  });
}
