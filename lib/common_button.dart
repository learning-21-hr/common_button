library common_button;

import 'package:flutter/material.dart';

class CommonButton extends StatefulWidget {
  const CommonButton({required this.onPressed, super.key});
  final void Function()? onPressed;

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: widget.onPressed, icon: const Icon(Icons.add));
  }
}
