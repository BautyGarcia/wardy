import 'package:flutter_dotenv/flutter_dotenv.dart';

/// A class that provides access to environment variables.
///
/// This class loads environment variables from a .env file and provides
/// getters for accessing them.
class EnvConfig {
  /// Loads environment variables from the .env file.
  ///
  /// This method should be called before accessing any environment variables,
  /// typically in the main.dart file before running the app.
  static Future<void> load() async {
    await dotenv.load();
  }

  /// Gets the Supabase URL from environment variables.
  static String get supabaseUrl {
    final url = dotenv.env['SUPABASE_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('SUPABASE_URL not found in environment variables');
    }
    return url;
  }

  /// Gets the Supabase anonymous key from environment variables.
  static String get supabaseAnonKey {
    final key = dotenv.env['SUPABASE_ANON_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('SUPABASE_ANON_KEY not found in environment variables');
    }
    return key;
  }
}
