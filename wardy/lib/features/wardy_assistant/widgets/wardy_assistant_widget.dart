import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:wardy/core/constants/app_constants.dart';
import 'package:wardy/core/theme/app_theme.dart';

class WardyAssistantWidget extends StatefulWidget {
  final Function(String) onMessageSubmitted;
  final String initialMessage;
  final bool isThinking;
  final bool isAnimating;
  final VoidCallback? onAnimationComplete;

  const WardyAssistantWidget({
    super.key,
    required this.onMessageSubmitted,
    this.initialMessage = '',
    this.isThinking = false,
    this.isAnimating = false,
    this.onAnimationComplete,
  });

  @override
  State<WardyAssistantWidget> createState() => _WardyAssistantWidgetState();
}

class _WardyAssistantWidgetState extends State<WardyAssistantWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late TextEditingController _textController;
  late String _currentMessage;
  bool _isExpanded = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _textController = TextEditingController();
    _currentMessage =
        widget.initialMessage.isNotEmpty
            ? widget.initialMessage
            : _getRandomGreeting();

    if (widget.isAnimating) {
      _animationController.forward().then((_) {
        if (widget.onAnimationComplete != null) {
          widget.onAnimationComplete!();
        }
      });
    }
  }

  @override
  void didUpdateWidget(WardyAssistantWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !oldWidget.isAnimating) {
      _animationController.forward().then((_) {
        if (widget.onAnimationComplete != null) {
          widget.onAnimationComplete!();
        }
      });
    } else if (!widget.isAnimating && oldWidget.isAnimating) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    super.dispose();
  }

  String _getRandomGreeting() {
    final greetings = [
      'Hi there! I\'m Wardy, your style assistant.',
      'Hello! Need outfit ideas today?',
      'Hey! Ready to look amazing?',
      'Welcome back! Let\'s find you something great to wear.',
      'Hi! I\'m here to help with your wardrobe choices.',
    ];
    return greetings[_random.nextInt(greetings.length)];
  }

  String _getRandomThinkingPhrase() {
    final phrases = [
      'Hmm, let me think...',
      'Searching for the perfect outfit...',
      'Analyzing your style preferences...',
      'Checking the latest trends...',
      'Matching colors and patterns...',
    ];
    return phrases[_random.nextInt(phrases.length)];
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _handleSubmit() {
    if (_textController.text.isNotEmpty) {
      widget.onMessageSubmitted(_textController.text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = theme.extension<AppTheme>();

    if (appTheme == null) {
      // Fallback if theme extension is not available
      return Container(
        child: const Center(child: Text('Theme extension not available')),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isExpanded ? 300 : 120,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [appTheme.primaryGradientStart, appTheme.primaryGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Robot character animation
                GestureDetector(
                  onTap: _toggleExpanded,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Lottie.asset(
                      'assets/animations/assistant_animation.json',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Message bubble
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child:
                        widget.isThinking
                            ? AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  _getRandomThinkingPhrase(),
                                  textStyle: theme.textTheme.bodyLarge!
                                      .copyWith(color: appTheme.textColor),
                                  speed: const Duration(milliseconds: 50),
                                ),
                              ],
                              totalRepeatCount: 5,
                              displayFullTextOnTap: true,
                            )
                            : Text(
                              _currentMessage,
                              style: theme.textTheme.bodyLarge!.copyWith(
                                color: appTheme.textColor,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
          if (_isExpanded)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            'I can help you find the perfect outfit for any occasion. Just ask me!',
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: appTheme.textColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            decoration: InputDecoration(
                              hintText: 'Ask Wardy...',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                            ),
                            onSubmitted: (_) => _handleSubmit(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: appTheme.accentColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: _handleSubmit,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
