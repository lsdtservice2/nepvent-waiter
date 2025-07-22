import 'package:flutter/material.dart';

class CustomCountController extends StatefulWidget {
  const CustomCountController({
    super.key,
    required this.count,
    required this.onChanged,
    this.decrementIcon = const Icon(Icons.remove),
    this.incrementIcon = const Icon(Icons.add),
    this.countStyle = const TextStyle(fontSize: 18),
    this.stepSize = 1,
    this.minimum,
    this.maximum,
    this.padding = const EdgeInsets.symmetric(horizontal: 4),
    this.spacing = 8,
    this.buttonSize = 30,
    this.buttonColor,
    this.disabledButtonColor,
    this.buttonShape = BoxShape.circle,
    this.enableHapticFeedback = true,
    this.animateOnChange = true,
    this.duration = const Duration(milliseconds: 200),
    this.buttonBorderRadius,
    this.buttonSplashColor,
  });

  final int count;
  final ValueChanged<int> onChanged;
  final Widget decrementIcon;
  final Widget incrementIcon;
  final TextStyle countStyle;
  final int stepSize;
  final int? minimum;
  final int? maximum;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final double buttonSize;
  final Color? buttonColor;
  final Color? disabledButtonColor;
  final BoxShape buttonShape;
  final bool enableHapticFeedback;
  final bool animateOnChange;
  final Duration duration;
  final BorderRadius? buttonBorderRadius;
  final Color? buttonSplashColor;

  @override
  State<CustomCountController> createState() => _CustomCountControllerState();
}

class _CustomCountControllerState extends State<CustomCountController> {
  late int _currentCount;
  bool _isDecrementing = false;
  bool _isIncrementing = false;

  @override
  void initState() {
    super.initState();
    _currentCount = widget.count;
  }

  @override
  void didUpdateWidget(covariant CustomCountController oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count && widget.count != _currentCount) {
      _currentCount = widget.count;
    }
  }

  bool get _canDecrement =>
      widget.minimum == null || _currentCount - widget.stepSize >= widget.minimum!;

  bool get _canIncrement =>
      widget.maximum == null || _currentCount + widget.stepSize <= widget.maximum!;

  Future<void> _changeCount(bool isIncrement) async {
    final canProceed = isIncrement ? _canIncrement : _canDecrement;
    if (!canProceed) return;

    if (widget.enableHapticFeedback) {
      Feedback.forTap(context);
    }

    setState(() {
      if (isIncrement) {
        _isIncrementing = true;
        _currentCount += widget.stepSize;
      } else {
        _isDecrementing = true;
        _currentCount -= widget.stepSize;
      }
    });

    widget.onChanged(_currentCount);

    if (widget.animateOnChange) {
      await Future.delayed(widget.duration);
    }

    if (mounted) {
      setState(() {
        _isIncrementing = false;
        _isDecrementing = false;
      });
    }
  }

  BorderRadius get _effectiveBorderRadius {
    if (widget.buttonBorderRadius != null) return widget.buttonBorderRadius!;
    return widget.buttonShape == BoxShape.circle
        ? BorderRadius.circular(widget.buttonSize / 2)
        : BorderRadius.zero;
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required bool enabled,
    required Widget icon,
    required bool isAnimating,
  }) {
    final effectiveColor = enabled
        ? widget.buttonColor ?? Theme.of(context).primaryColor
        : widget.disabledButtonColor ?? Colors.grey[300];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: _effectiveBorderRadius,
        splashColor: widget.buttonSplashColor,
        child: AnimatedContainer(
          duration: widget.duration,
          width: widget.buttonSize,
          height: widget.buttonSize,
          decoration: BoxDecoration(
            shape: widget.buttonShape,
            color: effectiveColor,
            borderRadius: widget.buttonShape == BoxShape.rectangle ? _effectiveBorderRadius : null,
          ),
          child: Center(
            child: AnimatedScale(
              scale: isAnimating ? 0.85 : 1.0,
              duration: widget.duration,
              child: IconTheme.merge(
                data: IconThemeData(
                  color: enabled ? Colors.white : Colors.grey[500],
                  size: widget.buttonSize * 0.5,
                ),
                child: icon,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            onPressed: () => _changeCount(false),
            enabled: _canDecrement,
            icon: widget.decrementIcon,
            isAnimating: _isDecrementing,
          ),
          SizedBox(width: widget.spacing),
          AnimatedSwitcher(
            duration: widget.duration,
            transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            ),
            layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[...previousChildren, if (currentChild != null) currentChild],
              );
            },
            child: Text(
              '$_currentCount',
              key: ValueKey<int>(_currentCount),
              style: widget.countStyle,
            ),
          ),
          SizedBox(width: widget.spacing),
          _buildButton(
            onPressed: () => _changeCount(true),
            enabled: _canIncrement,
            icon: widget.incrementIcon,
            isAnimating: _isIncrementing,
          ),
        ],
      ),
    );
  }
}
