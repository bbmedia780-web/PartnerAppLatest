import 'utils/library_utils.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Handle errors globally to suppress non-critical plugin errors in release mode
  runZonedGuarded(() async {
    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kReleaseMode) {
        final errorStr = details.exception.toString();
        // Suppress non-critical errors in release mode
        if (errorStr.contains('path_provider') ||
            errorStr.contains('PathProviderApi') ||
            errorStr.contains('shared_preferences') ||
            errorStr.contains('SharedPreferencesApi') ||
            errorStr.contains('photo_manager') ||
            errorStr.contains('MissingPluginException') ||
            errorStr.contains('PlatformException')) {
          // Silently ignore these errors - they're handled with fallbacks
          return;
        }
      }
      // In debug mode, show all errors
      FlutterError.presentError(details);
    };
    
    // Initialize SharedPreferences with error handling
    try {
      // await init();
    } catch (e) {
      // If init fails, app will continue but preferences won't work
      // This prevents crashes in release mode
      if (kDebugMode) {
        debugPrint('SharedPreferences init failed: $e');
      }
    }
    
    // runApp(DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => MyApp(),
    // ),);
    runApp(MyApp());
  }, (error, stack) {
    // Handle unhandled exceptions (including platform channel errors)
    if (kReleaseMode) {
      final errorStr = error.toString();
      // Suppress non-critical plugin errors in release mode
      if (errorStr.contains('path_provider') ||
          errorStr.contains('PathProviderApi') ||
          errorStr.contains('shared_preferences') ||
          errorStr.contains('SharedPreferencesApi') ||
          errorStr.contains('photo_manager') ||
          errorStr.contains('MissingPluginException') ||
          errorStr.contains('PlatformException') ||
          errorStr.contains('channel-error')) {
        // Silently ignore these errors - fonts/preferences will use fallbacks
        return;
      }
    }
    // In debug mode, print errors for debugging
    if (kDebugMode) {
      print('Unhandled error: $error');
      print('Stack trace: $stack');
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late AppLifecycleState _appLifecycleState;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _appLifecycleState = WidgetsBinding.instance.lifecycleState!;
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifecycleState = state;

    if (_appLifecycleState == AppLifecycleState.hidden ||
        _appLifecycleState == AppLifecycleState.paused ||
        _appLifecycleState == AppLifecycleState.inactive) {
      // setString('slug', '');
    }

    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: appColor,
          surface: whiteColor,
        ),

        dialogTheme: DialogThemeData(
          backgroundColor: whiteColor,
          surfaceTintColor: Colors.transparent, // Material 3 fix
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        popupMenuTheme: PopupMenuThemeData(
          color: whiteColor,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        datePickerTheme: DatePickerThemeData(
          backgroundColor: whiteColor,
          surfaceTintColor: Colors.transparent,
        ),

        timePickerTheme: TimePickerThemeData(
          backgroundColor: whiteColor,
          dialBackgroundColor: appColor,
        ),

        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: whiteColor,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
        ),
      ),
      title: 'Varnika',
      initialBinding: SplashBindings(),
      getPages: AppPages.pages,
      initialRoute: AppRoutes.splash,
      navigatorKey: Get.key,
    );
  }
}
