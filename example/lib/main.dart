import 'package:flutter/material.dart';
import 'package:gemira/splash_screen.dart';
import 'package:gemira/app_wrapper.dart';
import 'package:gemira/services/downloaded_models_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemira - AI Chat',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const SafeArea(child: AppInitializer()),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Show splash screen immediately - no delay
      // All heavy initialization happens in background while splash is showing
      
      // Start background initialization immediately
      final initializationFuture = _backgroundInitialization();
      
      // Ensure minimum splash display time for good UX (reduced from 2.5s to 1.5s)
      final minimumDisplayFuture = Future.delayed(const Duration(milliseconds: 1500));
      
      // Wait for both initialization and minimum display time
      await Future.wait([initializationFuture, minimumDisplayFuture]);
      
    } catch (e) {
      // Handle initialization errors gracefully
      debugPrint('Error during app initialization: $e');
      // Still show splash for minimum time even on error
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _backgroundInitialization() async {
    try {
      // Initialize SharedPreferences first (most critical)
      await SharedPreferences.getInstance();
      
      // Initialize other services in parallel for better performance
      await Future.wait([
        _initializeDownloadedModelsService(),
        _preloadAssets(),
      ]);
      
    } catch (e) {
      debugPrint('Background initialization error: $e');
      // Don't throw - let app continue even if some services fail
    }
  }
  
  Future<void> _initializeDownloadedModelsService() async {
    try {
      final downloadedModelsService = DownloadedModelsService();
      await downloadedModelsService.getDownloadedModels();
    } catch (e) {
      debugPrint('Downloaded models service initialization error: $e');
    }
  }
  
  Future<void> _preloadAssets() async {
    try {
      // Preload critical images to avoid loading delays later
      if (mounted) {
        await Future.wait([
          precacheImage(const AssetImage('assets/gemira.png'), context),
          precacheImage(const AssetImage('assets/background.png'), context),
        ]);
      }
    } catch (e) {
      debugPrint('Asset preloading error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SplashScreen(
        onComplete: () {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        },
      );
    }
    
    return const AppWrapper();
  }
}
