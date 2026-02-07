# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# path_provider
-keep class dev.fluttercommunity.plus.pathprovider.** { *; }
-keep class dev.flutter.pigeon.path_provider_android.** { *; }
-keep class dev.flutter.pigeon.path_provider_android.PathProviderApi { *; }
-keep class dev.flutter.pigeon.path_provider_android.PathProviderApi$** { *; }
-dontwarn dev.fluttercommunity.plus.pathprovider.**
-dontwarn dev.flutter.pigeon.path_provider_android.**
-keep class androidx.** { *; }

# photo_manager (if still used)
-keep class com.fluttercandies.photo_manager.** { *; }
-keep class androidx.** { *; }

# image_picker
-keep class io.flutter.plugins.imagepicker.** { *; }

# google_fonts
-keep class com.google.android.gms.** { *; }

# FFmpeg Kit
-keep class com.arthenica.ffmpegkit.** { *; }
-dontwarn com.arthenica.ffmpegkit.**

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Pigeon generated classes
-keep class dev.flutter.pigeon.** { *; }

# shared_preferences
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class dev.flutter.pigeon.shared_preferences_android.** { *; }
-keep class dev.flutter.pigeon.shared_preferences_android.SharedPreferencesApi { *; }
-keep class dev.flutter.pigeon.shared_preferences_android.SharedPreferencesApi$** { *; }
-dontwarn io.flutter.plugins.sharedpreferences.**
-dontwarn dev.flutter.pigeon.shared_preferences_android.**

# Keep all Pigeon API classes
-keep class * implements dev.flutter.pigeon.** { *; }
-keep class * extends dev.flutter.pigeon.** { *; }

# Keep all classes in the path_provider package
-keep class dev.fluttercommunity.plus.pathprovider.** { *; }

# Keep all classes in the photo_manager package
-keep class com.fluttercandies.photo_manager.** { *; }

# Preserve line numbers for debugging
-keepattributes SourceFile,LineNumberTable

# Keep generic signatures
-keepattributes Signature

# Keep exceptions
-keepattributes Exceptions

# Google Play Core (for Flutter deferred components)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.tasks.** { *; }
-dontwarn com.google.android.play.core.tasks.**

# Flutter deferred components
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
-dontwarn io.flutter.embedding.engine.deferredcomponents.**
