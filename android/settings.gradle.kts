pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.7.3" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")

// Fix namespace issue for photo_gallery package automatically
// This ensures the namespace is set even if the package is updated
gradle.beforeProject {
    if (project.name == "photo_gallery") {
        val buildFile = project.buildFile
        if (buildFile.exists() && buildFile.name == "build.gradle") {
            var content = buildFile.readText()
            if (!content.contains("namespace")) {
                // Add namespace to android block
                content = content.replace(
                    Regex("android\\s*\\{"),
                    "android {\n    namespace = \"com.morbit.photogallery\""
                )
                buildFile.writeText(content)
                println("✅ Fixed namespace for photo_gallery package")
            }
        }
    }
}
