
import '../../../../../../utils/library_utils.dart';

class ReelsController extends GetxController {
  var currentIndex = 0.obs;
  late PageController pageController;
  var videoControllers = <int, VideoPlayerController>{}.obs;
  var isPlaying = <int, bool>{}.obs;
  var showControls = <int, bool>{}.obs;
  var isInitialized = <int, bool>{}.obs;

  // CRITICAL: Track mute state for all videos
  var isMuted = <int, bool>{}.obs;
  var globalMuteState = false.obs; // Global mute state (affects all videos)
  
  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    
    // CRITICAL: Initialize videos after a small delay to ensure controller is ready
    Future.delayed(const Duration(milliseconds: 100), () {
    _initializeVideos();
    });
  }
  
  // CRITICAL: Toggle mute/unmute for all videos
  void toggleMute() {
    globalMuteState.value = !globalMuteState.value;
    
    // Update all video controllers
    for (var entry in videoControllers.entries) {
      try {
        final controller = entry.value;
        if (controller.value.isInitialized) {
          controller.setVolume(globalMuteState.value ? 0.0 : 1.0);
          isMuted[entry.key] = globalMuteState.value;
        }
      } catch (e) {
        debugPrint('Error toggling mute for video ${entry.key}: $e');
      }
    }
    
    update();
    debugPrint('✅ Mute toggled: ${globalMuteState.value}');
  }
  
  // CRITICAL: Check if videos are muted
  bool isVideoMuted() {
    return globalMuteState.value;
  }
  
  // CRITICAL: Reset video player state when entering reels screen
  void resetVideoPlayerState() {
    try {
      debugPrint('🔄 Resetting video player state...');
      
      // CRITICAL: Stop all videos completely first
      stopAllVideos();
      
      // CRITICAL: Reset current index to 0
      currentIndex.value = 0;
      
      // CRITICAL: Reset page controller to first page
      if (pageController.hasClients) {
        pageController.jumpToPage(0);
      }
      
      // CRITICAL: Reset all videos to beginning
      for (var entry in videoControllers.entries) {
        try {
          final controller = entry.value;
          if (controller.value.isInitialized) {
            // CRITICAL: Stop playback completely
            controller.pause();
            // CRITICAL: Reset to beginning
            controller.seekTo(Duration.zero);
            // CRITICAL: Set volume based on mute state
            controller.setVolume(globalMuteState.value ? 0.0 : 1.0);
            isMuted[entry.key] = globalMuteState.value;
          }
        } catch (e) {
          debugPrint('Error resetting video ${entry.key}: $e');
        }
      }
      
      // CRITICAL: Reset all playing states
      for (var key in isPlaying.keys.toList()) {
        isPlaying[key] = false;
      }
      
      // CRITICAL: Clear show controls
      for (var key in showControls.keys.toList()) {
        showControls[key] = false;
      }
      
      // CRITICAL: Defer update to avoid calling during widget tree lock
      Future.microtask(() {
        update();
      });
      
      debugPrint('✅ Video player state reset complete');
    } catch (e) {
      debugPrint('Error resetting video player state: $e');
    }
  }
  
  // CRITICAL: Method to ensure video plays when screen is entered/re-entered
  void ensureCurrentVideoPlaying() {
    try {
      final index = currentIndex.value;
      if (videoControllers.containsKey(index) && 
          isInitialized[index] == true) {
        final controller = videoControllers[index]!;
        if (controller.value.isInitialized) {
          // CRITICAL: Reset to beginning before playing
          controller.seekTo(Duration.zero);
          // CRITICAL: Set volume based on mute state
          controller.setVolume(globalMuteState.value ? 0.0 : 1.0);
          isMuted[index] = globalMuteState.value;
          // CRITICAL: Play if not already playing
          if (!controller.value.isPlaying) {
            playVideo(index);
            debugPrint('✅ Ensuring video $index is playing (screen re-entry, muted: ${globalMuteState.value})');
          } else {
            // Already playing, just ensure volume is correct
            controller.setVolume(globalMuteState.value ? 0.0 : 1.0);
          }
        }
      }
    } catch (e) {
      debugPrint('Error ensuring video is playing: $e');
    }
  }

  void _initializeVideos() {
    // Initialize video controllers for each reel
    for (int i = 0; i < reels.length; i++) {
      final videoUrl = reels[i]['videoUrl'] as String;
      if (videoUrl.isNotEmpty) {
        _initVideoController(i, videoUrl);
      } else {
        // If no video URL, mark as not initialized
        isInitialized[i] = false;
      }
    }
  }

  void _initVideoController(int index, String url) async {
    try {
      // CRITICAL: Don't initialize if already initialized
      if (videoControllers.containsKey(index) && 
          videoControllers[index]!.value.isInitialized) {
        debugPrint('Video $index already initialized');
        return;
      }
      
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      videoControllers[index] = controller;
      isPlaying[index] = false;
      showControls[index] = false;
      isInitialized[index] = false;
      
      // CRITICAL: Initialize video
      await controller.initialize();
      
      // CRITICAL: Only proceed if controller is still valid
      if (!videoControllers.containsKey(index) || 
          videoControllers[index] != controller) {
        controller.dispose();
        return;
      }
      
      controller.setLooping(true);
      // CRITICAL: Set volume based on global mute state
      controller.setVolume(globalMuteState.value ? 0.0 : 1.0);
      isMuted[index] = globalMuteState.value;
      isInitialized[index] = true;
      
      // CRITICAL: Listen to video player state changes
      controller.addListener(() {
        if (!videoControllers.containsKey(index)) return;
        
        final currentController = videoControllers[index];
        if (currentController == null || currentController != controller) return;
        
        // CRITICAL: Sync playing state with actual video state
        if (controller.value.isInitialized) {
          final wasPlaying = isPlaying[index] ?? false;
          final isNowPlaying = controller.value.isPlaying;
          
          // Only update if state actually changed
          if (wasPlaying != isNowPlaying) {
            isPlaying[index] = isNowPlaying;
            // CRITICAL: Defer update to avoid calling during widget tree lock
            Future.microtask(() {
              if (videoControllers.containsKey(index)) {
                update();
        }
            });
          }
        }
      });
      
      // CRITICAL: Defer update to avoid calling during widget tree lock
      Future.microtask(() {
        update();
      });
      
      // CRITICAL: Auto-play first video with audio only after initialization completes
      if (index == 0 && currentIndex.value == 0) {
        // Small delay to ensure UI is ready
        Future.delayed(const Duration(milliseconds: 500), () {
          if (videoControllers.containsKey(0) && 
              isInitialized[0] == true &&
              currentIndex.value == 0) {
            // CRITICAL: Ensure audio is enabled before playing (respect mute state)
            final videoController = videoControllers[0]!;
            if (videoController.value.isInitialized) {
              // CRITICAL: Reset to beginning
              videoController.seekTo(Duration.zero);
              // CRITICAL: Set volume based on mute state
              videoController.setVolume(globalMuteState.value ? 0.0 : 1.0);
              playVideo(0);
              debugPrint('✅ Auto-playing first video (muted: ${globalMuteState.value})');
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Error initializing video $index: $e');
      isInitialized[index] = false;
      update();
    }
  }

  // Sample reels data - Using working sample video URLs
  var reels = [
    {
      'id': '1',
      'title': 'Hair Styling Tips',
      'description': 'Learn the best hair styling techniques for your salon',
      'audio': 'Original Sound - Salon Pro',
      'likes': 1250,
      'comments': 45,
      'isLiked': false,
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'thumbnail': 'assets/images/beauty1.png',
    },
    {
      'id': '2',
      'title': 'Facial Treatment Demo',
      'description': 'Step by step facial treatment process',
      'audio': 'Trending Audio - Beauty Care',
      'likes': 890,
      'comments': 32,
      'isLiked': true,
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      'thumbnail': 'assets/images/beauty2.png',
    },
    {
      'id': '3',
      'title': 'Makeup Tutorial',
      'description': 'Professional makeup techniques for bridal looks',
      'audio': 'Original Sound - Makeup Artist',
      'likes': 2100,
      'comments': 78,
      'isLiked': false,
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      'thumbnail': 'assets/images/makeup.png',
    },
    {
      'id': '4',
      'title': 'Hair Color Transformation',
      'description': 'Amazing hair color transformation results',
      'audio': 'Trending Audio - Hair Color',
      'likes': 1560,
      'comments': 56,
      'isLiked': false,
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      'thumbnail': 'assets/images/cosmetic.png',
    },
  ].obs;

  void onPageChanged(int index) {
    // CRITICAL: Stop previous video completely (Instagram-like behavior)
    if (videoControllers.containsKey(currentIndex.value)) {
      final previousController = videoControllers[currentIndex.value]!;
      if (previousController.value.isInitialized) {
        // CRITICAL: Pause, mute, and reset previous video
        previousController.pause();
        previousController.setVolume(0.0);
        previousController.seekTo(Duration.zero);
        isPlaying[currentIndex.value] = false;
        debugPrint('✅ Stopped previous video ${currentIndex.value}');
      }
    }
    
    currentIndex.value = index;
    
    // CRITICAL: Play current video with audio after ensuring it's visible
    // Use a slightly longer delay to prevent race conditions
    Future.delayed(const Duration(milliseconds: 250), () {
      // CRITICAL: Verify we're still on the same page
      if (currentIndex.value != index) {
        debugPrint('Page changed during delay, skipping play for index $index');
        return;
      }
      
      if (videoControllers.containsKey(index) && isInitialized[index] == true) {
        // CRITICAL: Ensure video is initialized before playing
        final controller = videoControllers[index];
        if (controller != null && controller.value.isInitialized) {
          // CRITICAL: Reset video to beginning before playing
          controller.seekTo(Duration.zero);
          // CRITICAL: Set volume based on mute state
          controller.setVolume(globalMuteState.value ? 0.0 : 1.0);
        playVideo(index);
        } else {
          // Wait for initialization
          _waitForInitialization(index);
        }
      } else if (videoControllers.containsKey(index)) {
        // Wait for initialization
        _waitForInitialization(index);
      }
    });
  }

  void _waitForInitialization(int index) {
    // CRITICAL: Check if we're still on the same page
    if (currentIndex.value != index) {
      debugPrint('Page changed while waiting for initialization, index: $index');
      return;
    }
    
    // Check every 100ms if video is initialized (max 5 seconds)
    Future.delayed(const Duration(milliseconds: 100), () {
      // CRITICAL: Verify we're still on the same page
      if (currentIndex.value != index) {
        return;
      }
      
      if (isInitialized[index] == true) {
        final controller = videoControllers[index];
        if (controller != null && controller.value.isInitialized) {
        playVideo(index);
        }
      } else if (videoControllers.containsKey(index)) {
        _waitForInitialization(index);
      }
    });
  }

  void playVideo(int index) {
    // CRITICAL: Verify video exists and is initialized
    if (!videoControllers.containsKey(index)) {
      debugPrint('Video controller not found for index $index');
      return;
    }
    
    final controller = videoControllers[index]!;
    
    // CRITICAL: Ensure video is initialized before playing
    if (isInitialized[index] != true || !controller.value.isInitialized) {
      debugPrint('Video $index not initialized, waiting...');
      _waitForInitialization(index);
      return;
    }
    
    try {
      // CRITICAL: Set volume based on mute state (Instagram-like behavior)
      controller.setVolume(globalMuteState.value ? 0.0 : 1.0);
      isMuted[index] = globalMuteState.value;
      
      // CRITICAL: Reset video to beginning before playing
      controller.seekTo(Duration.zero);
      
      // CRITICAL: Play video and ensure state is synced
      controller.play();
      isPlaying[index] = true;
      
      // CRITICAL: Defer update to avoid calling during widget tree lock
      Future.microtask(() {
        if (videoControllers.containsKey(index)) {
          update();
        }
      });
      
      debugPrint('✅ Playing video $index (muted: ${globalMuteState.value})');
      
      // CRITICAL: Verify playback started after a short delay
      if (videoControllers.containsKey(index) &&
          videoControllers[index] == controller &&
          controller.value.isInitialized) {
        // Sync state with actual video state
        final actualPlaying = controller.value.isPlaying;
        if (isPlaying[index] != actualPlaying) {
          isPlaying[index] = actualPlaying;
          // CRITICAL: Defer update to avoid calling during widget tree lock
          Future.microtask(() {
            if (videoControllers.containsKey(index)) {
              update();
            }
          });
        }

        // CRITICAL: Ensure volume is set correctly
        if (actualPlaying) {
          controller.setVolume(globalMuteState.value ? 0.0 : 1.0);
        }
      }
    } catch (e) {
      debugPrint('Error playing video $index: $e');
      isPlaying[index] = false;
      // CRITICAL: Defer update to avoid calling during widget tree lock
      Future.microtask(() {
        if (videoControllers.containsKey(index)) {
      update();
        }
      });
    }
  }

  void pauseVideo(int index) {
    // CRITICAL: Verify video exists before pausing
    if (!videoControllers.containsKey(index)) {
      return;
    }
    
    final controller = videoControllers[index]!;
    
    // CRITICAL: Only pause if initialized
    if (!controller.value.isInitialized) {
      return;
    }
    
    try {
      // CRITICAL: Pause video but keep audio enabled (Instagram-like behavior)
      // Audio volume stays at 1.0 so when video resumes, audio plays immediately
      controller.pause();
      isPlaying[index] = false;
      
      // CRITICAL: Defer update to avoid calling during widget tree lock
      Future.microtask(() {
        if (videoControllers.containsKey(index)) {
          update();
        }
      });
      
      debugPrint('✅ Paused video $index (audio still enabled)');
    } catch (e) {
      debugPrint('Error pausing video $index: $e');
      isPlaying[index] = false;
      // CRITICAL: Defer update to avoid calling during widget tree lock
      Future.microtask(() {
        if (videoControllers.containsKey(index)) {
      update();
        }
      });
    }
  }

  void togglePlayPause(int index) {
    // CRITICAL: Get current playing state from video controller (more reliable)
    final controller = videoControllers[index];
    final currentlyPlaying = controller != null && 
                              controller.value.isInitialized && 
                              controller.value.isPlaying;
    
    if (currentlyPlaying || isPlaying[index] == true) {
      pauseVideo(index);
    } else {
      playVideo(index);
    }
  }

  void showVideoControls(int index) {
    showControls[index] = true;
    
    // CRITICAL: Defer update to avoid calling during widget tree lock
    Future.microtask(() {
    update();
    });
    
    // Hide controls after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (showControls[index] == true) {
        showControls[index] = false;
        // CRITICAL: Defer update to avoid calling during widget tree lock
        Future.microtask(() {
        update();
        });
      }
    });
  }

  void toggleLike(int index) {
    reels[index]['isLiked'] = !(reels[index]['isLiked'] as bool);
    if (reels[index]['isLiked'] as bool) {
      reels[index]['likes'] = (reels[index]['likes'] as int) + 1;
      ShowToast.success('Liked!');
    } else {
      reels[index]['likes'] = (reels[index]['likes'] as int) - 1;
      ShowToast.success('Unliked');
    }
    // CRITICAL: Defer refresh to avoid calling during widget tree lock
    Future.microtask(() {
    reels.refresh();
    });
  }

  void onDoubleTapLike(int index) {
    if (!(reels[index]['isLiked'] as bool)) {
      toggleLike(index);
    }
  }

  void onCommentTap(int index) async {
    try {
      final result = await Get.toNamed('/comments', arguments: {
        'reelId': reels[index]['id'],
        'reel': reels[index],
      });
      
      // Update comments count if a new comment was added
      if (result != null && result is Map && result.containsKey('commentsCount')) {
        reels[index]['comments'] = result['commentsCount'] as int;
        reels.refresh();
      }
    } catch (e) {
      debugPrint('Error navigating to comments: $e');
      ShowToast.error('Failed to open comments');
    }
  }

  void onShareTap(int index) async {
    try {
      final reel = reels[index];
      final title = reel['title'] as String;
      final description = reel['description'] as String;
      
      // Create share text
      final shareText = '$title\n$description\n\nWatch on Varnika App';
      
      // Share the reel
      await Share.share(
        shareText,
        subject: title,
      );
      
      ShowToast.success('Shared successfully!');
    } catch (e) {
      debugPrint('Error sharing reel: $e');
      ShowToast.error('Failed to share');
    }
  }

  // CRITICAL: Stop all videos forcefully (called when screen exits)
  void stopAllVideos() {
    try {
      // CRITICAL: Pause, mute, and reset all videos immediately
      for (var entry in videoControllers.entries) {
        try {
          final controller = entry.value;
          if (controller.value.isInitialized) {
            // CRITICAL: Stop playback immediately
            controller.pause();
            // CRITICAL: Mute to stop audio completely
            controller.setVolume(0.0);
            // CRITICAL: Seek to beginning to reset position (prevents looping issues)
            controller.seekTo(Duration.zero);
            // CRITICAL: Remove listener to prevent auto-playback
            controller.removeListener(() {});
            debugPrint('✅ Stopped video ${entry.key} completely');
          }
        } catch (e) {
          debugPrint('Error stopping video ${entry.key}: $e');
        }
      }
      
      // CRITICAL: Update playing state for all videos
      for (var key in isPlaying.keys.toList()) {
        isPlaying[key] = false;
      }
      
      // CRITICAL: Clear show controls
      for (var key in showControls.keys.toList()) {
        showControls[key] = false;
      }
      
      // CRITICAL: Defer update to avoid calling during widget tree lock
      Future.microtask(() {
        update();
      });
      
      debugPrint('✅ All reels videos stopped completely in controller');
    } catch (e) {
      debugPrint('Error in stopAllVideos: $e');
    }
  }

  @override
  void onClose() {
    // CRITICAL: Stop all videos forcefully before disposing
    stopAllVideos();
    
    // Dispose all video controllers
    for (var controller in videoControllers.values) {
      try {
        // Ensure video is stopped before disposing
        if (controller.value.isInitialized) {
          controller.pause();
          controller.setVolume(0.0);
        }
      controller.dispose();
      } catch (e) {
        debugPrint('Error disposing video controller: $e');
      }
    }
    videoControllers.clear();
    
    // Dispose page controller
    try {
    pageController.dispose();
    } catch (e) {
      debugPrint('Error disposing page controller: $e');
    }
    
    super.onClose();
    debugPrint('✅ ReelsController closed - all videos stopped');
  }
}
