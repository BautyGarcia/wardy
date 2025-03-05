import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wardy/core/theme/app_theme.dart';

class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double height;
  final double width;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final bool useGradient;
  final LinearGradient? gradient;
  final Duration animationDuration;
  final bool showShadow;
  final double elevation;

  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.height = 160.0,
    this.width = double.infinity,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)),
    this.backgroundColor = Colors.white,
    this.useGradient = false,
    this.gradient,
    this.animationDuration = const Duration(milliseconds: 300),
    this.showShadow = true,
    this.elevation = 4.0,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _controller.reverse();
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        widget.useGradient
            ? null
            : (widget.backgroundColor == Colors.white && isDarkMode
                ? AppTheme.darkBackgroundColor
                : widget.backgroundColor);

    final decoration = BoxDecoration(
      color: cardColor,
      gradient:
          widget.useGradient
              ? (widget.gradient ?? AppTheme.primaryGradient)
              : null,
      borderRadius: widget.borderRadius,
      boxShadow:
          widget.showShadow
              ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: widget.elevation * (_isPressed ? 0.5 : 1.0),
                  spreadRadius:
                      widget.elevation * 0.25 * (_isPressed ? 0.5 : 1.0),
                  offset: Offset(
                    0,
                    widget.elevation * 0.5 * (_isPressed ? 0.5 : 1.0),
                  ),
                ),
              ]
              : null,
    );

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onLongPress: widget.onLongPress,
      child: AnimatedContainer(
            duration: widget.animationDuration,
            curve: Curves.easeOutCubic,
            height: widget.height,
            width: widget.width,
            decoration: decoration,
            transform:
                Matrix4.identity()
                  ..scale(_isPressed ? 0.98 : 1.0)
                  ..translate(0.0, _isPressed ? 2.0 : 0.0),
            child: ClipRRect(
              borderRadius: widget.borderRadius,
              child: Padding(padding: widget.padding, child: widget.child),
            ),
          )
          .animate(
            autoPlay: true,
            onInit: (controller) => controller.repeat(reverse: true),
          )
          .shimmer(duration: 3.seconds, color: Colors.white.withOpacity(0.1)),
    );
  }
}
