import 'dart:io';

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

  File get imageFile => File(imagePath);

  // Convert a ClothingItem to a Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'imagePath': imagePath,
      'dateAdded': dateAdded.toIso8601String(),
      'metadata': metadata,
    };
  }

  // Create a ClothingItem from a Map
  factory ClothingItem.fromMap(Map<String, dynamic> map) {
    return ClothingItem(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      imagePath: map['imagePath'],
      dateAdded: DateTime.parse(map['dateAdded']),
      metadata: map['metadata'],
    );
  }
}
