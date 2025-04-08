library common_button;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

mixin TapBlocker {
  final bool _isTapEnabled = true;

  void handleTap(void Function()? onPressed, void Function({required bool enable}) updateState) {
    if (_isTapEnabled) {
      updateState(enable: false);
      onPressed?.call();
      Future.delayed(const Duration(milliseconds: 10000), () {
        updateState(enable: true);
      });
    }
  }
}

class CommonButton extends StatefulWidget {
  const CommonButton({
    required this.onTap,
    this.label = '',
    this.labelColor = Colors.black,
    this.labelDisableColor = Colors.white,
    this.buttonColor = Colors.white,
    this.buttonDisableColor = Colors.black,
    this.buttonSize = const Size(50, 50),
    this.suffixIcon,
    this.suffixIconSize = const Size(24, 24),
    this.suffixIconColor,
    this.prefixIcon,
    this.prefixIconSize = const Size(24, 24),
    this.prefixIconColor,
    this.borderColor = Colors.transparent,
    this.gradientColors,
    this.borderRadius = 8.0,
    this.labelStyle,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.margin = const EdgeInsets.all(8),
    this.padding = const EdgeInsets.all(8),
    this.multipleTapDisable = false,
    this.makeDisabled = false,
    super.key,
  });
  final void Function()? onTap;
  final String label;
  final Color labelColor;
  final Color labelDisableColor;
  final TextStyle? labelStyle;
  final Size buttonSize;
  final Color buttonColor;
  final Color buttonDisableColor;
  final String? suffixIcon;
  final Size suffixIconSize;
  final Color? suffixIconColor;
  final String? prefixIcon;
  final Size prefixIconSize;
  final Color? prefixIconColor;
  final Color borderColor;
  final List<Color>? gradientColors;
  final double borderRadius;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool multipleTapDisable;
  final bool makeDisabled;
  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> with TapBlocker {
  bool _isBlocked = false;

  void _updateTapBlocker({required bool enable}) {
    if (mounted) {
      setState(() => _isBlocked = !enable);
    }
  }

  bool get _shouldDisableButton => (_isBlocked && widget.multipleTapDisable) || widget.makeDisabled;

  @override
  Widget build(BuildContext context) {
    final bool isGradient = widget.gradientColors != null && widget.gradientColors!.isNotEmpty && !_shouldDisableButton;
    final Color resolvedTextColor = _shouldDisableButton ? widget.labelDisableColor : widget.labelColor;

    return GestureDetector(
      onTap: _shouldDisableButton ? null : () => handleTap(widget.onTap, _updateTapBlocker),
      child: Container(
        height: widget.buttonSize.height,
        width: widget.buttonSize.width,
        margin: widget.margin,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: _shouldDisableButton ? widget.buttonDisableColor : widget.buttonColor,
          border: Border.all(color: widget.borderColor),
          gradient: isGradient ? LinearGradient(colors: widget.gradientColors!) : null,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Row(
          mainAxisAlignment: widget.mainAxisAlignment,
          crossAxisAlignment: widget.crossAxisAlignment,
          children: [
            if (widget.prefixIcon != null) ...[
              _buildIcon(iconPath: widget.prefixIcon, size: widget.prefixIconSize, color: widget.prefixIconColor),
            ],
            Flexible(
              child: Text(widget.label,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: widget.labelStyle?.copyWith(color: resolvedTextColor) ??
                      TextStyle(fontSize: 14, color: resolvedTextColor)),
            ),
            if (widget.suffixIcon != null) ...[
              _buildIcon(iconPath: widget.suffixIcon, size: widget.suffixIconSize, color: widget.suffixIconColor),
            ],
          ],
        ),
      ),
    );
  }

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
}
