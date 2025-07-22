import 'package:flutter/material.dart';

class ButtonOptions {
  const ButtonOptions({
    this.textStyle,
    this.elevation = 2.0,
    this.height = 50.0,
    this.width,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 8.0,
    ),
    this.color = Colors.blue,
    this.disabledColor = Colors.grey,
    this.disabledTextColor = Colors.white70,
    this.splashColor,
    this.iconSize = 24.0,
    this.iconColor,
    this.iconPadding = const EdgeInsets.only(right: 8.0),
    this.borderRadius = 8.0,
    this.borderSide = BorderSide.none,
    this.iconAlignment = MainAxisAlignment.start,
  });

  final TextStyle? textStyle;
  final double elevation;
  final double height;
  final double? width;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color disabledColor;
  final Color disabledTextColor;
  final Color? splashColor;
  final double iconSize;
  final Color? iconColor;
  final EdgeInsetsGeometry iconPadding;
  final double borderRadius;
  final BorderSide borderSide;
  final MainAxisAlignment iconAlignment;
}

class ButtonWidget extends StatefulWidget {
  const ButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconData,
    required this.options,
    this.showLoadingIndicator = false,
    this.isEnabled = true,
  });

  final String text;
  final Widget? icon;
  final IconData? iconData;
  final Function()? onPressed;
  final ButtonOptions options;
  final bool showLoadingIndicator;
  final bool isEnabled;

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  bool isLoading = false;

  Future<void> _handlePressed() async {
    if (!widget.isEnabled || widget.onPressed == null || isLoading) return;

    final result = widget.onPressed!.call();
    if (result is Future) {
      if (widget.showLoadingIndicator) {
        setState(() => isLoading = true);
      }
      try {
        await result;
      } finally {
        if (mounted && widget.showLoadingIndicator) {
          setState(() => isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textWidget = isLoading
        ? SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.options.textStyle?.color ?? Colors.white,
        ),
      ),
    )
        : Text(
      widget.text,
      style: widget.options.textStyle?.copyWith(
        color: widget.isEnabled
            ? widget.options.textStyle?.color
            : widget.options.disabledTextColor,
      ),
      overflow: TextOverflow.ellipsis,
    );

    final buttonStyle = ElevatedButton.styleFrom(
      elevation: widget.options.elevation,
      backgroundColor:
      widget.isEnabled ? widget.options.color : widget.options.disabledColor,
      foregroundColor: widget.options.textStyle?.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.options.borderRadius),
        side: widget.options.borderSide,
      ),
      padding: widget.options.padding,
    );

    final iconWidget = widget.icon ??
        (widget.iconData != null
            ? Icon(
          widget.iconData,
          size: widget.options.iconSize,
          color: widget.options.iconColor ??
              widget.options.textStyle?.color,
        )
            : null);

    final buttonContent = iconWidget != null
        ? Row(
      mainAxisAlignment: widget.options.iconAlignment,
      children: [
        if (widget.options.iconAlignment == MainAxisAlignment.start) ...[
          Padding(
            padding: widget.options.iconPadding,
            child: iconWidget,
          ),
          textWidget,
        ] else ...[
          textWidget,
          Padding(
            padding: widget.options.iconPadding,
            child: iconWidget,
          ),
        ],
      ],
    )
        : textWidget;

    return SizedBox(
      height: widget.options.height,
      width: widget.options.width,
      child: ElevatedButton(
        onPressed: widget.isEnabled ? _handlePressed : null,
        style: buttonStyle,
        child: buttonContent,
      ),
    );
  }
}
