import 'package:wardy/features/wardrobe/models/clothing_item.dart';

class OutfitRecommendation {
  final int? id;
  final String title;
  final List<ClothingItem> clothingItems;
  final String occasion;
  final String weather;
  final String season;
  final int rating;
  final String commentary;
  final DateTime createdAt;
  final bool isFavorite;
  final Map<String, dynamic> additionalInfo;

  OutfitRecommendation({
    this.id,
    required this.title,
    required this.clothingItems,
    required this.occasion,
    required this.weather,
    required this.season,
    this.rating = 0,
    this.commentary = '',
    DateTime? createdAt,
    this.isFavorite = false,
    this.additionalInfo = const {},
  }) : createdAt = createdAt ?? DateTime.now();

  // Creates a copy of this outfit recommendation with the specified changes
  OutfitRecommendation copyWith({
    int? id,
    String? title,
    List<ClothingItem>? clothingItems,
    String? occasion,
    String? weather,
    String? season,
    int? rating,
    String? commentary,
    DateTime? createdAt,
    bool? isFavorite,
    Map<String, dynamic>? additionalInfo,
  }) {
    return OutfitRecommendation(
      id: id ?? this.id,
      title: title ?? this.title,
      clothingItems: clothingItems ?? this.clothingItems,
      occasion: occasion ?? this.occasion,
      weather: weather ?? this.weather,
      season: season ?? this.season,
      rating: rating ?? this.rating,
      commentary: commentary ?? this.commentary,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  // Convert to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'clothingItemIds': clothingItems.map((item) => item.id).join(','),
      'occasion': occasion,
      'weather': weather,
      'season': season,
      'rating': rating,
      'commentary': commentary,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isFavorite': isFavorite ? 1 : 0,
      'additionalInfo': additionalInfoToJson(),
    };
  }

  // Create from a map (from database)
  // Note: This is a stub, as full implementation would require loading
  // clothing items from their IDs
  static OutfitRecommendation fromMapStub(Map<String, dynamic> map) {
    return OutfitRecommendation(
      id: map['id'],
      title: map['title'],
      clothingItems:
          [], // This would need to be populated from a wardrobe service
      occasion: map['occasion'],
      weather: map['weather'],
      season: map['season'],
      rating: map['rating'],
      commentary: map['commentary'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      isFavorite: map['isFavorite'] == 1,
      additionalInfo: jsonToAdditionalInfo(map['additionalInfo']),
    );
  }

  // Helper methods for additional info serialization
  String additionalInfoToJson() {
    // In a real app, use proper JSON serialization
    return additionalInfo.toString();
  }

  static Map<String, dynamic> jsonToAdditionalInfo(String json) {
    // In a real app, use proper JSON deserialization
    return {};
  }
}
