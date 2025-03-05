import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:wardy/features/wardrobe/models/clothing_item.dart';
import 'package:image_picker/image_picker.dart';

class WardrobeStorageService {
  static const String _itemsFileName = 'wardrobe_items.json';
  static const String _imagesFolderName = 'wardrobe_images';

  // Get the application documents directory
  Future<Directory> get _appDir async =>
      await getApplicationDocumentsDirectory();

  // Get the wardrobe images directory
  Future<Directory> get _imagesDir async {
    final dir = await _appDir;
    final imagesDir = Directory('${dir.path}/$_imagesFolderName');

    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    return imagesDir;
  }

  // Get the path to the wardrobe items file
  Future<File> get _itemsFile async {
    final dir = await _appDir;
    return File('${dir.path}/$_itemsFileName');
  }

  // Load all clothing items
  Future<List<ClothingItem>> loadItems() async {
    try {
      final file = await _itemsFile;

      if (!await file.exists()) {
        return [];
      }

      final contents = await file.readAsString();
      final List<dynamic> itemsJson = jsonDecode(contents);

      return itemsJson.map((item) => ClothingItem.fromMap(item)).toList();
    } catch (e) {
      print('Error loading wardrobe items: $e');
      return [];
    }
  }

  // Save all clothing items
  Future<void> saveItems(List<ClothingItem> items) async {
    try {
      final file = await _itemsFile;
      final itemsJson = items.map((item) => item.toMap()).toList();
      await file.writeAsString(jsonEncode(itemsJson));
    } catch (e) {
      print('Error saving wardrobe items: $e');
    }
  }

  // Add a new clothing item with an image
  Future<ClothingItem?> addItem({
    required XFile imageFile,
    required String name,
    required String category,
  }) async {
    try {
      // Generate a unique ID for the item
      final id = const Uuid().v4();

      // Get the image directory
      final imagesDirectory = await _imagesDir;

      // Create a unique filename for the image
      final imageName = '$id.${imageFile.name.split('.').last}';
      final localImagePath = '${imagesDirectory.path}/$imageName';

      // Copy the image to the local storage
      final File newImage = File(localImagePath);
      await newImage.writeAsBytes(await imageFile.readAsBytes());

      // Create a new clothing item
      final item = ClothingItem(
        id: id,
        name: name,
        category: category,
        imagePath: localImagePath,
        dateAdded: DateTime.now(),
      );

      // Load existing items
      final items = await loadItems();

      // Add the new item
      items.add(item);

      // Save the updated items list
      await saveItems(items);

      return item;
    } catch (e) {
      print('Error adding wardrobe item: $e');
      return null;
    }
  }

  // Delete a clothing item
  Future<bool> deleteItem(String id) async {
    try {
      // Load existing items
      final items = await loadItems();

      // Find the item to delete
      final itemIndex = items.indexWhere((item) => item.id == id);

      if (itemIndex >= 0) {
        final item = items[itemIndex];

        // Delete the image file
        final imageFile = File(item.imagePath);
        if (await imageFile.exists()) {
          await imageFile.delete();
        }

        // Remove the item from the list
        items.removeAt(itemIndex);

        // Save the updated items list
        await saveItems(items);

        return true;
      }

      return false;
    } catch (e) {
      print('Error deleting wardrobe item: $e');
      return false;
    }
  }

  // Get items by category
  Future<List<ClothingItem>> getItemsByCategory(String? category) async {
    final items = await loadItems();

    if (category == null) {
      return items; // Return all items
    }

    return items.where((item) => item.category == category).toList();
  }
}
