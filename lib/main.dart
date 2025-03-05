import 'package:flutter/material.dart';
import 'package:wardy/theme/app_theme.dart';
import 'package:wardy/features/navigation/screens/main_navigation_screen.dart';
import 'package:flutter/services.dart';
import 'package:wardy/core/services/supabase_service.dart';
import 'package:provider/provider.dart';
import 'package:wardy/features/wardrobe/providers/wardrobe_provider.dart';
import 'package:wardy/core/config/env_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Load environment variables
  await EnvConfig.load();

  // Initialize Supabase with credentials from environment variables
  await SupabaseService.initialize(
    url: EnvConfig.supabaseUrl,
    anonKey: EnvConfig.supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => WardrobeProvider())],
      child: MaterialApp(
        title: 'Wardy',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const MainNavigationScreen(),
      ),
    );
  }
}
