import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

/// A service class that provides access to Supabase functionality.
///
/// This class is a singleton that provides access to the Supabase client
/// and helper methods for common Supabase operations.
class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;

  SupabaseService._internal();

  /// The Supabase client instance.
  SupabaseClient get client => Supabase.instance.client;

  /// The bucket name for storing clothing images.
  static const String clothingImagesBucket = 'clothing_images';

  /// Initializes the Supabase client.
  ///
  /// This method should be called before using any Supabase functionality,
  /// typically in the main.dart file before running the app.
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(url: url, anonKey: anonKey);

    // Note: We don't try to create the bucket automatically anymore
    // as it requires admin privileges. Instead, we check if it exists
    // and provide guidance if it doesn't.
    try {
      await _instance.client.storage.getBucket(clothingImagesBucket);
      print('Bucket $clothingImagesBucket exists and is accessible');
    } catch (e) {
      print('Warning: Could not access bucket $clothingImagesBucket');
      print(
        'Please ensure you have created the bucket in the Supabase dashboard',
      );
      print(
        'Follow the instructions in SUPABASE_SETUP.md to set up storage properly',
      );
    }
  }

  /// Uploads an image to Supabase Storage.
  ///
  /// Returns the public URL of the uploaded image.
  Future<String?> uploadImage(String filePath, String fileName) async {
    try {
      // Ensure the file exists
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File does not exist: $filePath');
      }

      // Get file extension
      final fileExt = path.extension(filePath).toLowerCase();

      // Validate file type (optional)
      final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
      if (!validExtensions.contains(fileExt)) {
        throw Exception(
          'Invalid file type. Supported types: ${validExtensions.join(', ')}',
        );
      }

      // Upload the file
      final fileBytes = await file.readAsBytes();
      final String storagePath = fileName;

      await client.storage
          .from(clothingImagesBucket)
          .uploadBinary(
            storagePath,
            fileBytes,
            fileOptions: FileOptions(contentType: _getContentType(fileExt)),
          );

      // Get the public URL
      final imageUrl = client.storage
          .from(clothingImagesBucket)
          .getPublicUrl(storagePath);
      print('Image uploaded successfully: $imageUrl');
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  /// Deletes an image from Supabase Storage.
  Future<bool> deleteImage(String fileName) async {
    try {
      await client.storage.from(clothingImagesBucket).remove([fileName]);
      print('Image deleted successfully: $fileName');
      return true;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }

  /// Gets the content type based on file extension.
  String _getContentType(String fileExt) {
    switch (fileExt) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }
}
