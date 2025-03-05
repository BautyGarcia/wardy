import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wardy/features/wardrobe/models/clothing_item.dart';

/// A widget that displays a clothing item's image.
///
/// This widget can handle both local file paths and remote URLs.
class ClothingImage extends StatelessWidget {
  /// The clothing item to display the image for.
  final ClothingItem item;

  /// Whether to show a placeholder while the image is loading.
  final bool showPlaceholder;

  /// The fit of the image.
  final BoxFit fit;

  /// The width of the image.
  final double? width;

  /// The height of the image.
  final double? height;

  /// The border radius of the image.
  final BorderRadius? borderRadius;

  /// Creates a [ClothingImage] widget.
  const ClothingImage({
    super.key,
    required this.item,
    this.showPlaceholder = true,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final Widget imageWidget =
        item.isImageUrl ? _buildNetworkImage() : _buildLocalImage();

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }

  /// Builds a network image widget.
  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: item.imagePath,
      fit: fit,
      width: width,
      height: height,
      placeholder:
          showPlaceholder ? (context, url) => _buildPlaceholder() : null,
      errorWidget: (context, url, error) => _buildErrorWidget(),
    );
  }

  /// Builds a local image widget.
  Widget _buildLocalImage() {
    return Image.file(
      File(item.imagePath),
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
    );
  }

  /// Builds a placeholder widget.
  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  /// Builds an error widget.
  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
    );
  }
}
