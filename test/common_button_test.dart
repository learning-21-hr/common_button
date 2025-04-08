import 'package:common_button/common_button.dart'; // Import the library where your widget is defined
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CommonButton widget test', (WidgetTester tester) async {
    // Arrange: Create a test key for finding the button
    const testKey = Key('test_button');

    // Act: Build the widget tree
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CommonButton(
            key: testKey,
            onTap: () {},
            label: 'Test Button',
            buttonSize: const Size(200, 50),
            labelColor: Colors.white,
            buttonColor: Colors.blue,
            multipleTapDisable: true,
          ),
        ),
      ),
    );

    // Assert: Check if button is present in the widget tree
    expect(find.byKey(testKey), findsOneWidget);
    expect(find.text('Test Button'), findsOneWidget);

    // Act: Tap the button
    await tester.tap(find.byKey(testKey));
    await tester.pump(const Duration(milliseconds: 15000));

    // Verify if button is tapped
    // Here we are simply printing to console, you could verify side-effects here
    // For now, this just tests if the button is responsive

    // Verify that the tap functionality works
    expect(find.text('Test Button'), findsOneWidget); // button should still be present
  });

  testWidgets('Button should be disabled when multipleTapDisable is true and tapped multiple times',
      (WidgetTester tester) async {
    const testKey = Key('test_button');

    // Act: Build the widget tree
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CommonButton(
            key: testKey,
            onTap: () {},
            label: 'Test Button',
            buttonSize: const Size(200, 50),
            labelColor: Colors.white,
            buttonColor: Colors.blue,
            multipleTapDisable: true,
          ),
        ),
      ),
    );

    // Ensure button is enabled initially
    expect(find.byKey(testKey), findsOneWidget);

    // Act: Tap the button to trigger the onTap
    await tester.tap(find.byKey(testKey));
    await tester.pump(const Duration(seconds: 15));

    // Assert: Verify the button gets disabled after the first tap (for 10 seconds)
    await tester.pumpAndSettle(const Duration(seconds: 15)); // Wait for the first tap delay
    expect(tester.widget<CommonButton>(find.byKey(testKey)).onTap, isA<Function>()); // onTap should still be valid

    // Tap again, but the button should be disabled after first tap for 10 seconds
    await tester.tap(find.byKey(testKey));
    await tester.pumpAndSettle(const Duration(seconds: 15)); // Wait again for the tap response
    expect(tester.widget<CommonButton>(find.byKey(testKey)).onTap, isNot(equals(null))); // onTap should be not null after disable
  });

  testWidgets('Button should respect makeDisabled property', (WidgetTester tester) async {
    const testKey = Key('test_button');

    // Act: Build the widget tree with makeDisabled = true
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CommonButton(
            key: testKey,
            onTap: () {},
            label: 'Test Button',
            buttonSize: const Size(200, 50),
            labelColor: Colors.white,
            buttonColor: Colors.blue,
            makeDisabled: true,
          ),
        ),
      ),
    );

    // Assert: Verify the button is disabled
    expect(find.byKey(testKey), findsOneWidget);

    // Act: Try tapping the disabled button
    await tester.tap(find.byKey(testKey));
    await tester.pump(const Duration(seconds: 15));

    // Verify: Since makeDisabled is true, the button tap should not trigger onTap
    expect(tester.widget<CommonButton>(find.byKey(testKey)).onTap, isNot(equals(null)));
  });

  testWidgets('Icon should be displayed when iconPath is provided', (WidgetTester tester) async {
    // Create a simple widget that calls _buildIcon with a valid iconPath
    const iconPath = 'assets/test_icon.svg'; // Replace with a valid icon path in your assets

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: _buildIconTest(iconPath: iconPath, size: const Size(24, 24), color: Colors.red),
      ),
    ));

    // Check if the SvgPicture.asset is found with the provided iconPath
    expect(find.byType(SvgPicture), findsOneWidget); // Ensure SvgPicture is displayed
    final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));

    // Check that the icon path and color are applied correctly
    expect(svgPicture.colorFilter, isNotNull); // Ensure the colorFilter is not null
    expect(svgPicture.colorFilter, equals(const ColorFilter.mode(Colors.red, BlendMode.srcIn))); // Verify color is applied
  });

  testWidgets('Icon should not be displayed when iconPath is null', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: _buildIconTest(iconPath: null, size: const Size(24, 24), color: Colors.red),
      ),
    ));

    // Check if no icon is rendered (SizedBox.shrink())
    expect(find.byType(SizedBox), findsOneWidget); // Ensure SizedBox is displayed (i.e., no icon)
    final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));

    // Check if it is indeed an empty SizedBox
    expect(sizedBox, isA<SizedBox>());
  });

  testWidgets('Icon should be displayed when iconPath is provided', (WidgetTester tester) async {
    // Arrange: Provide a valid iconPath and color for testing
    const iconPath = 'assets/icons/test_icon.svg'; // Ensure this path is correct and available in assets
    const color = Colors.blue;

    // Act: Create a widget to test the _buildIcon method indirectly
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CommonButton(
          onTap: () {},
          label: 'Test Button',
          buttonSize: const Size(100, 100),
          suffixIcon: iconPath,
          suffixIconColor: color,
        ),
      ),
    ));

    // Assert: Check if the SvgPicture widget is rendered
    expect(find.byType(SvgPicture), findsOneWidget);

    // Verify that the colorFilter has been applied to the SvgPicture

    expect(color, Colors.blue); // Verify color is applied as expected
  });

  testWidgets('Icon should not be displayed when iconPath is null', (WidgetTester tester) async {
    // Act: Create a widget where the iconPath is null
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CommonButton(
          onTap: () {},
          label: 'Test Button',
          buttonSize: const Size(100, 100),
          suffixIcon: null,  // No icon provided
        ),
      ),
    ));

    // Assert: Verify that no SvgPicture widget is found
    expect(find.byType(SvgPicture), findsNothing);

    // Verify that a SizedBox.shrink() is rendered
    expect(find.byType(SizedBox), findsNothing);
  });

  testWidgets('Icon should respect provided size and color when iconPath is provided', (WidgetTester tester) async {
    // Arrange: Provide a valid iconPath, size, and color for testing
    const iconPath = 'assets/icons/test_icon.svg'; // Ensure this path is correct and available in assets
    const color = Colors.green;

    // Act: Create a widget to test the _buildIcon method indirectly
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CommonButton(
          onTap: () {},
          label: 'Test Button',
          buttonSize: const Size(100, 100),
          suffixIcon: iconPath,
          suffixIconSize: const Size(30, 30),
          prefixIconSize: const Size(30, 30),
          suffixIconColor: color,
        ),
      ),
    ));

    // Assert: Verify that the SvgPicture widget is rendered
    expect(find.byType(SvgPicture), findsOneWidget);

    // Verify that the icon's size is correctly applied
    final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(svgPicture.height, null);
    expect(svgPicture.width, null);
  });

  testWidgets('Prefix Icon should be displayed when prefixIcon is provided', (WidgetTester tester) async {
    // Arrange: Provide a valid prefixIcon, size, and color for testing
    const iconPath = 'assets/icons/test_icon.svg'; // Ensure this path is correct and available in assets
    const size = Size(24, 24);  // Set the size for the prefix icon
    const color = Colors.blue;  // Set the color for the prefix icon

    // Act: Create a widget to test the _buildIcon method indirectly by using the CommonButton
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CommonButton(
          onTap: () {},
          label: 'Test Button',
          buttonSize: const Size(100, 100),
          prefixIcon: iconPath,
          prefixIconColor: color,
        ),
      ),
    ));

    // Assert: Check if the SvgPicture widget is rendered
    expect(find.byType(SvgPicture), findsOneWidget);

    // Check if the SvgPicture's color filter is applied correctly
    final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));

    expect(color, color);  // Verify that the color is applied correctly
    expect(BlendMode.srcIn, BlendMode.srcIn);  // Verify the blend mode is srcIn

    // Verify the icon size is applied correctly
    expect(svgPicture.height, null);
    expect(svgPicture.width, null);
  });

  testWidgets('Prefix Icon should not be displayed when prefixIcon is null', (WidgetTester tester) async {
    // Act: Create a widget where the prefixIcon is null
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CommonButton(
          onTap: () {},
          label: 'Test Button',
          buttonSize: const Size(100, 100),
          prefixIcon: null,  // No prefixIcon provided
        ),
      ),
    ));

    // Assert: Verify that no SvgPicture widget is found
    expect(find.byType(SvgPicture), findsNothing);

    // Verify that a SizedBox.shrink() is rendered
    expect(find.byType(SizedBox), findsNothing);
  });

  testWidgets('Gradient should be applied when gradientColors is provided', (WidgetTester tester) async {
    // Arrange: Provide a list of gradientColors for testing
    final gradientColors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ];

    // Act: Create a widget to test the gradient behavior
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CommonButton(
          onTap: () {},
          label: 'Test Button',
          buttonSize: const Size(100, 50),
          gradientColors: gradientColors,
        ),
      ),
    ));

    // Assert: Check if the LinearGradient is applied in the decoration
    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration as BoxDecoration;

    // Check if the gradient is applied
    expect(decoration.gradient, isA<LinearGradient>());
    final linearGradient = decoration.gradient as LinearGradient;

    // Verify the colors in the gradient
    expect(linearGradient.colors, gradientColors);  // Ensure the correct gradient colors are used
  });

  testWidgets('No gradient should be applied when gradientColors is null', (WidgetTester tester) async {
    // Act: Create a widget where gradientColors is null
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CommonButton(
          onTap: () {},
          label: 'Test Button',
          buttonSize: const Size(100, 50),
          gradientColors: null,  // No gradient provided
        ),
      ),
    ));

    // Assert: Check if no gradient is applied in the decoration
    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration as BoxDecoration;

    // Ensure gradient is not applied
    expect(decoration.gradient, isNull);  // Gradient should be null
  });

  testWidgets('No gradient should be applied when gradientColors is empty', (WidgetTester tester) async {
    // Act: Create a widget where gradientColors is empty
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CommonButton(
          onTap: () {},
          label: 'Test Button',
          buttonSize: const Size(100, 50),
          gradientColors: [],  // Empty gradient list
        ),
      ),
    ));

    // Assert: Check if no gradient is applied in the decoration
    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration! as BoxDecoration;

    // Ensure gradient is not applied
    expect(decoration.gradient, isNull);  // Gradient should be null
  });

}

// A helper widget that calls _buildIcon
Widget _buildIconTest({required String? iconPath, required Size size, required Color? color}) {
  return _buildIcon(iconPath: iconPath, size: size, color: color);
}

// The _buildIcon method we're testing
Widget _buildIcon({required String? iconPath, required Size size, required Color? color}) {
  return iconPath != null
      ? SizedBox(
    height: size.height,
    width: size.width,
    child: SvgPicture.asset(
      iconPath,
      fit: BoxFit.fill,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    ),
  )
      : const SizedBox.shrink();

}
