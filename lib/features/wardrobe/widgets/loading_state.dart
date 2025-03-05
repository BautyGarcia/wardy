import 'package:flutter/material.dart';

/// A widget that displays a loading state.
class LoadingState extends StatelessWidget {
  /// The message to display.
  final String? message;

  /// Whether to show the loading indicator with a full-screen overlay.
  final bool isFullScreen;

  /// Creates a [LoadingState] widget.
  const LoadingState({super.key, this.message, this.isFullScreen = false});

  @override
  Widget build(BuildContext context) {
    final loadingContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        if (message != null)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              message!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
      ],
    );

    if (isFullScreen) {
      return Scaffold(body: Center(child: loadingContent));
    }

    return Center(child: loadingContent);
  }
}

/// A widget that displays an error state.
class ErrorState extends StatelessWidget {
  /// The error message to display.
  final String message;

  /// The callback to retry the operation.
  final VoidCallback? onRetry;

  /// Creates an [ErrorState] widget.
  const ErrorState({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (onRetry != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Retry'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A widget that displays an empty state.
class EmptyState extends StatelessWidget {
  /// The message to display.
  final String message;

  /// The icon to display.
  final IconData icon;

  /// The action button text.
  final String? actionText;

  /// The callback for the action button.
  final VoidCallback? onAction;

  /// Creates an [EmptyState] widget.
  const EmptyState({
    super.key,
    required this.message,
    this.icon = Icons.inbox,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.grey, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (actionText != null && onAction != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: onAction,
                  child: Text(actionText!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
