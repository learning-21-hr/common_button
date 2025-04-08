import 'package:common_button/common_button.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController controller = TextEditingController();
  ValueNotifier<bool> notifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    controller.addListener(_checkIfUserCanPost);
  }

  void _checkIfUserCanPost() {
    if (controller.text.trim().isNotEmpty) {
      notifier.value = true;
    } else {
      notifier.value = false;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: const Text('Common Button Demo')),
            body: ColoredBox(
              color: Colors.red,
              child: Column(
                children: [
                  TextFormField(controller: controller),
                  Center(
                    child: ValueListenableBuilder<bool>(
                      valueListenable: notifier,
                      builder: (context, value, child) {
                        return CommonButton(
                          gradientColors: const [
                            Colors.red,
                            Colors.orange,
                            Colors.yellow,
                            Colors.green,
                            Colors.blue,
                            Colors.indigo,
                            Colors.purple
                          ],
                          multipleTapDisable: true,
                          makeDisabled: !value,
                          label: 'Text',
                          onTap: () => debugPrint('Title : ${DateTime.now().toString()}'),
                          buttonSize: const Size(100, 100),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )));
  }
}
