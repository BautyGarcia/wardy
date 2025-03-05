import 'package:flutter/material.dart';
import 'package:wardy/core/constants/app_constants.dart';
import 'package:wardy/core/utils/database_helper.dart';
import 'package:wardy/features/wardrobe/models/clothing_item.dart';

class WardrobeProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

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

  // Load all clothing items from database
  Future<void> _loadClothingItems() async {
    final clothingItemsMap = await _databaseHelper.getClothingItems();
    _allClothingItems =
        clothingItemsMap.map((item) => ClothingItem.fromMap(item)).toList();
    notifyListeners();
  }

  // Add a new clothing item
  Future<void> addClothingItem(ClothingItem clothingItem) async {
    _setLoading(true);
    final id = await _databaseHelper.insertClothingItem(clothingItem.toMap());
    final newItem = clothingItem.copyWith(id: id);
    _allClothingItems.add(newItem);
    _filterItems();
    _setLoading(false);
  }

  // Update an existing clothing item
  Future<void> updateClothingItem(ClothingItem clothingItem) async {
    _setLoading(true);
    await _databaseHelper.updateClothingItem(clothingItem.toMap());

    final index = _allClothingItems.indexWhere(
      (item) => item.id == clothingItem.id,
    );
    if (index != -1) {
      _allClothingItems[index] = clothingItem;
    }

    _filterItems();
    _setLoading(false);
  }

  // Delete a clothing item
  Future<void> deleteClothingItem(int id) async {
    _setLoading(true);
    await _databaseHelper.deleteClothingItem(id);
    _allClothingItems.removeWhere((item) => item.id == id);
    _filterItems();
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

  // Toggle favorite status of a clothing item
  Future<void> toggleFavorite(ClothingItem clothingItem) async {
    final updatedItem = clothingItem.copyWith(
      isFavorite: !clothingItem.isFavorite,
    );
    await updateClothingItem(updatedItem);
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
              item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item.brand.toLowerCase().contains(_searchQuery.toLowerCase());

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
