import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wardy/core/constants/app_constants.dart';
import 'package:wardy/features/wardrobe/models/clothing_item.dart';
import 'package:wardy/features/wardrobe/services/supabase_wardrobe_service.dart';

class WardrobeProvider extends ChangeNotifier {
  final SupabaseWardrobeService _wardrobeService = SupabaseWardrobeService();

  List<ClothingItem> _allClothingItems = [];
  List<ClothingItem> _filteredClothingItems = [];
  String _currentCategory = AppConstants.clothingCategories[0];
  bool _isLoading = false;
  String _searchQuery = '';

  // Getters
  List<ClothingItem> get allClothingItems => _allClothingItems;
  List<ClothingItem> get filteredClothingItems => _filteredClothingItems;
  String get currentCategory => _currentCategory;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  // Initialize wardrobe
  Future<void> initializeWardrobe() async {
    _setLoading(true);
    await _loadClothingItems();
    _filterItems();
    _setLoading(false);
  }

  // Load all clothing items from Supabase
  Future<void> _loadClothingItems() async {
    _allClothingItems = await _wardrobeService.loadItems();
    notifyListeners();
  }

  // Add a new clothing item
  Future<void> addClothingItem({
    required XFile imageFile,
    required String name,
    required String category,
  }) async {
    _setLoading(true);
    final newItem = await _wardrobeService.addItem(
      imageFile: imageFile,
      name: name,
      category: category,
    );

    if (newItem != null) {
      _allClothingItems.add(newItem);
      _filterItems();
    }

    _setLoading(false);
  }

  // Delete a clothing item
  Future<void> deleteClothingItem(String id) async {
    _setLoading(true);
    final success = await _wardrobeService.deleteItem(id);

    if (success) {
      _allClothingItems.removeWhere((item) => item.id == id);
      _filterItems();
    }

    _setLoading(false);
  }

  // Set the current category filter
  void setCategory(String category) {
    _currentCategory = category;
    _filterItems();
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterItems();
  }

  // Filter items based on current category and search query
  void _filterItems() {
    _filteredClothingItems =
        _allClothingItems.where((item) {
          // First filter by category
          final categoryMatch =
              _currentCategory == 'All' || item.category == _currentCategory;

          // Then filter by search query if needed
          final searchMatch =
              _searchQuery.isEmpty ||
              item.name.toLowerCase().contains(_searchQuery.toLowerCase());

          return categoryMatch && searchMatch;
        }).toList();

    notifyListeners();
  }

  // Helper method to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
