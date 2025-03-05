import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
import 'package:wardy/core/services/supabase_service.dart';
import 'package:wardy/features/wardrobe/models/clothing_item.dart';

/// A service that handles clothing item storage using Supabase.
class SupabaseWardrobeService {
  final SupabaseService _supabaseService = SupabaseService();
  static const String _tableName = 'clothing_items';

  /// Loads all clothing items from Supabase.
  Future<List<ClothingItem>> loadItems() async {
    try {
      final response = await _supabaseService.client
          .from(_tableName)
          .select()
          .order('dateadded', ascending: false);

      return response
          .map<ClothingItem>((item) => ClothingItem.fromMap(item))
          .toList();
    } catch (e) {
      print('Error loading wardrobe items from Supabase: $e');
      return [];
    }
  }

  /// Adds a new clothing item with an image to Supabase.
  Future<ClothingItem?> addItem({
    required XFile imageFile,
    required String name,
    required String category,
  }) async {
    try {
      // Generate a unique ID for the item
      final id = const Uuid().v4();

      // Create a unique filename for the image
      final fileExt = path.extension(imageFile.path).toLowerCase();
      final imageName = '$id$fileExt';

      // Upload the image to Supabase Storage
      final imageUrl = await _supabaseService.uploadImage(
        imageFile.path,
        imageName,
      );

      if (imageUrl == null) {
        throw Exception('Failed to upload image');
      }

      // Create a new clothing item
      final item = ClothingItem(
        id: id,
        name: name,
        category: category,
        imagePath: imageUrl, // Store the URL instead of local path
        dateAdded: DateTime.now(),
      );

      // Insert the item into the Supabase table
      await _supabaseService.client.from(_tableName).insert(item.toMap());
      print('Clothing item added successfully: ${item.id}');

      return item;
    } catch (e) {
      print('Error adding wardrobe item to Supabase: $e');
      return null;
    }
  }

  /// Deletes a clothing item from Supabase.
  Future<bool> deleteItem(String id) async {
    try {
      // Get the item to find the image filename
      final response =
          await _supabaseService.client
              .from(_tableName)
              .select()
              .eq('id', id)
              .single();

      if (response != null) {
        final imagePath = response['imagepath'] ?? response['imagePath'];
        if (imagePath == null) {
          print('Warning: Image path not found for item $id');
          return false;
        }

        // Extract just the filename from the URL
        final fileName = imagePath.toString().split('/').last;

        // Delete the image from Supabase Storage
        final imageDeleted = await _supabaseService.deleteImage(fileName);

        if (!imageDeleted) {
          print('Warning: Failed to delete image for item $id');
        }

        // Delete the item from the Supabase table
        await _supabaseService.client.from(_tableName).delete().eq('id', id);
        print('Clothing item deleted successfully: $id');

        return true;
      }

      return false;
    } catch (e) {
      print('Error deleting wardrobe item from Supabase: $e');
      return false;
    }
  }

  /// Gets items by category from Supabase.
  Future<List<ClothingItem>> getItemsByCategory(String? category) async {
    try {
      final query = _supabaseService.client.from(_tableName).select();

      if (category != null && category != 'All') {
        query.eq('category', category);
      }

      final response = await query.order('dateadded', ascending: false);

      return response
          .map<ClothingItem>((item) => ClothingItem.fromMap(item))
          .toList();
    } catch (e) {
      print('Error getting items by category from Supabase: $e');
      return [];
    }
  }
}
