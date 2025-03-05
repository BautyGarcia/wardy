import 'package:flutter/material.dart';
import 'package:wardy/core/utils/database_helper.dart';
import 'package:wardy/features/outfit_recommendations/models/outfit_recommendation.dart';
import 'package:wardy/features/wardrobe/models/clothing_item.dart';

class OutfitRecommendationsProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<OutfitRecommendation> _recommendations = [];
  List<OutfitRecommendation> _filteredRecommendations = [];
  bool _isLoading = false;
  String _searchQuery = '';

  // Getters
  List<OutfitRecommendation> get recommendations =>
      _filteredRecommendations.isEmpty && _searchQuery.isEmpty
          ? _recommendations
          : _filteredRecommendations;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  // Initialize recommendations
  Future<void> initializeRecommendations(
    List<ClothingItem> allClothingItems,
  ) async {
    _setLoading(true);
    await _loadRecommendations(allClothingItems);
    _setLoading(false);
  }

  // Load recommendations from database
  Future<void> _loadRecommendations(List<ClothingItem> allClothingItems) async {
    final recommendationsMap = await _databaseHelper.getOutfitRecommendations();

    _recommendations = [];

    for (var map in recommendationsMap) {
      // Get clothing item IDs
      final clothingItemIds = map['clothingItemIds'].toString().split(',');

      // Find corresponding clothing items
      final outfitItems = <ClothingItem>[];
      for (var idStr in clothingItemIds) {
        if (idStr.isEmpty) continue;

        final id = int.tryParse(idStr);
        if (id != null) {
          final item = allClothingItems.firstWhere(
            (item) => item.id == id,
            orElse:
                () => ClothingItem(
                  id: id.toString(),
                  name: 'Unknown Item',
                  imagePath: '',
                  category: 'Unknown',
                  dateAdded: DateTime.now(),
                ),
          );

          if (item.id != -1) {
            outfitItems.add(item);
          }
        }
      }

      // Create outfit recommendation
      final recommendation = OutfitRecommendation(
        id: map['id'],
        title: map['title'],
        clothingItems: outfitItems,
        occasion: map['occasion'],
        weather: map['weather'],
        season: map['season'],
        rating: map['rating'],
        commentary: map['commentary'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
        isFavorite: map['isFavorite'] == 1,
        additionalInfo: OutfitRecommendation.jsonToAdditionalInfo(
          map['additionalInfo'] ?? '{}',
        ),
      );

      _recommendations.add(recommendation);
    }

    notifyListeners();
  }

  // Add a new recommendation
  Future<void> addRecommendation(OutfitRecommendation recommendation) async {
    _setLoading(true);
    final id = await _databaseHelper.insertOutfitRecommendation(
      recommendation.toMap(),
    );
    final newRecommendation = recommendation.copyWith(id: id);
    _recommendations.add(newRecommendation);
    _filterRecommendations();
    _setLoading(false);
  }

  // Update an existing recommendation
  Future<void> updateRecommendation(OutfitRecommendation recommendation) async {
    _setLoading(true);
    await _databaseHelper.updateOutfitRecommendation(recommendation.toMap());

    final index = _recommendations.indexWhere(
      (item) => item.id == recommendation.id,
    );
    if (index != -1) {
      _recommendations[index] = recommendation;
    }

    _filterRecommendations();
    _setLoading(false);
  }

  // Delete a recommendation
  Future<void> deleteRecommendation(int id) async {
    _setLoading(true);
    await _databaseHelper.deleteOutfitRecommendation(id);
    _recommendations.removeWhere((item) => item.id == id);
    _filterRecommendations();
    _setLoading(false);
  }

  // Toggle favorite status of a recommendation
  Future<void> toggleFavorite(OutfitRecommendation recommendation) async {
    final updatedRecommendation = recommendation.copyWith(
      isFavorite: !recommendation.isFavorite,
    );
    await updateRecommendation(updatedRecommendation);
  }

  // Rate a recommendation
  Future<void> rateRecommendation(
    OutfitRecommendation recommendation,
    int rating,
  ) async {
    final updatedRecommendation = recommendation.copyWith(rating: rating);
    await updateRecommendation(updatedRecommendation);
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterRecommendations();
  }

  // Generate outfit recommendations based on occasion, season, and weather
  Future<List<OutfitRecommendation>> generateRecommendations({
    required List<ClothingItem> availableItems,
    required String occasion,
    required String weather,
    String? season,
  }) async {
    // This is a simplified algorithm. In a real app, you would use a more
    // sophisticated algorithm or even connect to a recommendation API/ML model

    _setLoading(true);

    // Determine season if not provided
    final currentSeason = season ?? _getCurrentSeason();

    // Filter items suitable for the occasion and season
    final suitableItems =
        availableItems.where((item) {
          return item.occasions.contains(occasion) &&
              (item.seasons.contains(currentSeason) ||
                  item.seasons.contains('All Seasons'));
        }).toList();

    // Group items by category
    final Map<String, List<ClothingItem>> itemsByCategory = {};
    for (var item in suitableItems) {
      if (!itemsByCategory.containsKey(item.category)) {
        itemsByCategory[item.category] = [];
      }
      itemsByCategory[item.category]!.add(item);
    }

    // Create outfit combinations (simplified for this example)
    List<OutfitRecommendation> generatedOutfits = [];

    // Try to create at least one outfit
    if (itemsByCategory.containsKey('Tops') &&
        itemsByCategory.containsKey('Bottoms')) {
      // Get a top and bottom
      final top = itemsByCategory['Tops']!.first;
      final bottom = itemsByCategory['Bottoms']!.first;

      // Add outerwear if relevant to the weather
      List<ClothingItem> outfitItems = [top, bottom];
      if ((weather == 'Cold' || weather == 'Rainy' || weather == 'Windy') &&
          itemsByCategory.containsKey('Outerwear')) {
        outfitItems.add(itemsByCategory['Outerwear']!.first);
      }

      // Add footwear if available
      if (itemsByCategory.containsKey('Footwear')) {
        outfitItems.add(itemsByCategory['Footwear']!.first);
      }

      // Add accessory if available
      if (itemsByCategory.containsKey('Accessories')) {
        outfitItems.add(itemsByCategory['Accessories']!.first);
      }

      // Create the outfit recommendation
      final outfit = OutfitRecommendation(
        title: '$occasion Outfit',
        clothingItems: outfitItems,
        occasion: occasion,
        weather: weather,
        season: currentSeason,
        commentary:
            'Perfect outfit for $occasion in $weather weather during $currentSeason.',
      );

      generatedOutfits.add(outfit);
    }

    _setLoading(false);
    return generatedOutfits;
  }

  // Helper method to get current season based on date
  String _getCurrentSeason() {
    final now = DateTime.now();
    final month = now.month;

    if (month >= 3 && month <= 5) {
      return 'Spring';
    } else if (month >= 6 && month <= 8) {
      return 'Summer';
    } else if (month >= 9 && month <= 11) {
      return 'Fall';
    } else {
      return 'Winter';
    }
  }

  // Filter recommendations based on search query
  void _filterRecommendations() {
    if (_searchQuery.isEmpty) {
      _filteredRecommendations = [];
    } else {
      _filteredRecommendations =
          _recommendations.where((recommendation) {
            return recommendation.title.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                recommendation.occasion.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                recommendation.season.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                recommendation.weather.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                );
          }).toList();
    }

    notifyListeners();
  }

  // Helper method to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
