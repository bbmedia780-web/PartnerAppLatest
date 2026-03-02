import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrimmedMusicDB {
  static const String _trimmedMusicKey = 'trimmed_music_data';
  
  // Store trimmed music information
  static Future<void> storeTrimmedMusic({
    required String musicName,
    required String musicArtist,
    required String musicImagePath,
    required String musicPath,
    required double startTime,
    required double endTime,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final musicData = {
        'musicName': musicName,
        'musicArtist': musicArtist,
        'musicImagePath': musicImagePath,
        'musicPath': musicPath,
        'startTime': startTime,
        'endTime': endTime,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      
      await prefs.setString(_trimmedMusicKey, jsonEncode(musicData));
      debugPrint('✅ Trimmed music stored in local DB: $musicName');
    } catch (e) {
      debugPrint('❌ Error storing trimmed music: $e');
    }
  }
  
  // Get stored trimmed music information
  static Future<Map<String, dynamic>?> getStoredTrimmedMusic() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final musicDataJson = prefs.getString(_trimmedMusicKey);
      
      if (musicDataJson != null) {
        final musicData = jsonDecode(musicDataJson) as Map<String, dynamic>;
        debugPrint('✅ Retrieved trimmed music from local DB: ${musicData['musicName']}');
        return musicData;
      }
      
      return null;
    } catch (e) {
      debugPrint('❌ Error retrieving trimmed music: $e');
      return null;
    }
  }
  
  // Clear stored trimmed music information
  static Future<void> clearStoredTrimmedMusic() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_trimmedMusicKey);
      debugPrint('✅ Cleared trimmed music from local DB');
    } catch (e) {
      debugPrint('❌ Error clearing trimmed music: $e');
    }
  }

}
