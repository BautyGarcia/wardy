import 'dart:io';

/// A model representing a clothing item in the wardrobe.
class ClothingItem {
  final String id;
  final String name;
  final String category;
  final String imagePath;
  final DateTime dateAdded;
  final Map<String, dynamic>? metadata;

  ClothingItem({
    required this.id,
    required this.name,
    required this.category,
    required this.imagePath,
    required this.dateAdded,
    this.metadata,
  });

  /// Returns true if the image path is a URL.
  bool get isImageUrl => imagePath.startsWith('http');

  /// Returns the image as a File if it's a local path, otherwise null.
  File? get imageFile => isImageUrl ? null : File(imagePath);

  /// Returns the image URL if it's a URL, otherwise null.
  String? get imageUrl => isImageUrl ? imagePath : null;

  /// Convert a ClothingItem to a Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'imagepath': imagePath,
      'dateadded': dateAdded.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Create a ClothingItem from a Map
  factory ClothingItem.fromMap(Map<String, dynamic> map) {
    return ClothingItem(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      imagePath: map['imagepath'] ?? map['imagePath'],
      dateAdded: DateTime.parse(map['dateadded'] ?? map['dateAdded']),
      metadata: map['metadata'],
    );
  }

  /// Create a copy of this ClothingItem with the given fields replaced with new values.
  ClothingItem copyWith({
    String? id,
    String? name,
    String? category,
    String? imagePath,
    DateTime? dateAdded,
    Map<String, dynamic>? metadata,
  }) {
    return ClothingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      dateAdded: dateAdded ?? this.dateAdded,
      metadata: metadata ?? this.metadata,
    );
  }
}
