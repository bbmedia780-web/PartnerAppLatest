import '../../../../../../utils/library_utils.dart';

class ReelsScreen extends StatefulWidget {
  final bool isFromDashboard;
  
  const ReelsScreen({super.key, this.isFromDashboard = false});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> with WidgetsBindingObserver {
  late ReelsController controller;
  bool _isDisposed = false;
  bool _isVisible = true;
  Worker? _dashboardTabListener; // Store listener to dispose it later

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize controller if not already registered
    if (!Get.isRegistered<ReelsController>()) {
      ReelsBinding().dependencies();
    }
    controller = Get.find<ReelsController>();
    
    // CRITICAL: Listen to DashboardController's currentIndex to detect tab changes
    if (widget.isFromDashboard) {
      _listenToDashboardTabChanges();
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed && mounted) {
        final route = ModalRoute.of(context);
        if (route != null && route.isCurrent) {
          controller.resetVideoPlayerState();
          Future.delayed(const Duration(milliseconds: 500), () {
            if (!_isDisposed && mounted) {
              final route = ModalRoute.of(context);
              if (route != null && route.isCurrent) {
                _playCurrentVideo();
              }
            }
          });
        }
      }
    });
  }
  
  // CRITICAL: Play current video with audio (Instagram-like behavior)
  // This is called every time the screen is entered to ensure video plays automatically
  void _playCurrentVideo() {
    try {
      // CRITICAL: Ensure we're on index 0 (first video)
      if (controller.currentIndex.value != 0) {
        controller.currentIndex.value = 0;
        if (controller.pageController.hasClients) {
          controller.pageController.jumpToPage(0);
        }
      }
      
      final currentIndex = controller.currentIndex.value;
      
      // CRITICAL: Check if video controller exists
      if (!controller.videoControllers.containsKey(currentIndex)) {
        debugPrint('Video controller not found for index $currentIndex, waiting...');
        // Wait a bit and retry
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!_isDisposed && mounted) {
            _playCurrentVideo();
          }
        });
        return;
      }
      
      final videoController = controller.videoControllers[currentIndex]!;
      
      // CRITICAL: Check if video is initialized
      if (controller.isInitialized[currentIndex] == true && 
          videoController.value.isInitialized) {
        // CRITICAL: Reset video to beginning
        videoController.seekTo(Duration.zero);
        
        // CRITICAL: Set volume based on mute state
        videoController.setVolume(controller.globalMuteState.value ? 0.0 : 1.0);
        
        // CRITICAL: Play video
        controller.playVideo(currentIndex);
        debugPrint('✅ Auto-playing video $currentIndex (muted: ${controller.globalMuteState.value})');
      } else {
        // Wait for initialization
        debugPrint('Video $currentIndex not initialized yet, waiting...');
        Future.delayed(const Duration(milliseconds: 200), () {
          if (!_isDisposed && mounted) {
            _playCurrentVideo();
          }
        });
      }
    } catch (e) {
      debugPrint('Error playing current video: $e');
      // Retry after a delay
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!_isDisposed && mounted) {
          _playCurrentVideo();
        }
      });
    }
  }
  
  // Listen to dashboard tab changes to stop videos when switching away from reels
  void _listenToDashboardTabChanges() {
    try {
      // Get DashboardController if available
      if (Get.isRegistered<DashboardController>()) {
        final dashboardController = Get.find<DashboardController>();
        
        // Listen to currentIndex changes
        _dashboardTabListener = ever(dashboardController.currentIndex, (int index) {
          if (_isDisposed || !mounted) return;
          
          // Reels tab is index 2 (Home=0, Booking=1, Reels=2, Profile=3)
          if (index != 2) {
            // CRITICAL: User switched away from reels tab - stop all videos and audio immediately
            if (_isVisible) {
              _isVisible = false;
              _stopAllVideos();
              controller.stopAllVideos();
              debugPrint('✅ Tab changed away from Reels (index: $index) - videos and audio stopped');
            }
          } else {
            // CRITICAL: User switched back to reels tab - reset and play video automatically
            _isVisible = true;
            debugPrint('✅ Switched back to Reels tab - resetting and auto-playing video');
            
            // CRITICAL: Reset video player state first
            controller.resetVideoPlayerState();
            
            // CRITICAL: Play current video with audio after reset
            Future.delayed(const Duration(milliseconds: 500), () {
              if (!_isDisposed && mounted && _isVisible) {
                // Double-check we're still on reels tab
                if (Get.isRegistered<DashboardController>()) {
                  final dashboardCtrl = Get.find<DashboardController>();
                  if (dashboardCtrl.currentIndex.value == 2) {
                    _playCurrentVideo();
                  }
                } else {
                  _playCurrentVideo();
                }
              }
            });
          }
        });
      }
    } catch (e) {
      debugPrint('Error listening to dashboard tab changes: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Dispose dashboard tab listener
    _dashboardTabListener?.dispose();
    _dashboardTabListener = null;
    _isDisposed = true;
    // CRITICAL: Stop all videos when screen is disposed
    _stopAllVideos();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // CRITICAL: Stop all videos and audio when app goes to background, is paused, or is detached
    if (state == AppLifecycleState.paused || 
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      _stopAllVideos();
      controller.stopAllVideos();
      debugPrint('✅ App lifecycle changed to $state - videos and audio stopped');
    } else if (state == AppLifecycleState.resumed) {
      // CRITICAL: When app resumes, check if we're still on reels screen and play video
      _playCurrentVideo();
    }
  }

  // CRITICAL: Stop all videos and audio forcefully (Instagram-like behavior)
  void _stopAllVideos() {
    if (_isDisposed) return;
    
    try {
      // CRITICAL: Stop all playing videos immediately and completely
      for (var entry in controller.videoControllers.entries) {
        try {
          final videoController = entry.value;
          if (videoController.value.isInitialized) {
            // CRITICAL: Stop playback immediately
            videoController.pause();
            // CRITICAL: Mute audio to stop sound completely
            videoController.setVolume(0.0);
            // CRITICAL: Seek to beginning to reset position (prevents looping)
            videoController.seekTo(Duration.zero);
            // CRITICAL: Remove listeners to prevent auto-playback
            videoController.removeListener(() {});
            debugPrint('✅ Stopped video ${entry.key} completely');
          }
        } catch (e) {
          debugPrint('Error stopping video ${entry.key}: $e');
        }
      }
      
      // CRITICAL: Update playing state for all videos
      for (var key in controller.isPlaying.keys.toList()) {
        controller.isPlaying[key] = false;
      }
      
      // CRITICAL: Clear show controls
      for (var key in controller.showControls.keys.toList()) {
        controller.showControls[key] = false;
      }
      
      // CRITICAL: Defer update to avoid calling during widget tree lock
      Future.microtask(() {
        if (!_isDisposed) {
          controller.update();
        }
      });
      
      debugPrint('✅ All reels videos and audio stopped forcefully');
    } catch (e) {
      debugPrint('Error in _stopAllVideos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // CRITICAL: Check if route is still active when building
    // This catches cases where navigation happens but dispose() hasn't been called yet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed && mounted) {
        final route = ModalRoute.of(context);
        if (route == null || !route.isCurrent) {
          // Route is no longer active, stop videos
          _stopAllVideos();
        }
        
        // CRITICAL: Check dashboard tab index if from dashboard
        if (widget.isFromDashboard) {
          try {
            if (Get.isRegistered<DashboardController>()) {
              final dashboardController = Get.find<DashboardController>();
              final currentTabIndex = dashboardController.currentIndex.value;
              
              // Reels tab is index 2
              if (currentTabIndex != 2) {
                // CRITICAL: Not on reels tab, stop videos and audio immediately
                if (_isVisible) {
                  _isVisible = false;
                  _stopAllVideos();
                  controller.stopAllVideos();
                }
              } else {
                // CRITICAL: On reels tab - reset and ensure current video plays with audio automatically
                // This ensures video plays every time user enters/returns to reels screen
                if (!_isVisible || currentTabIndex == 2) {
                  _isVisible = true;
                  
                  // CRITICAL: Reset video player state first
                  controller.resetVideoPlayerState();
                  
                  // CRITICAL: Play current video with audio after reset
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (!_isDisposed && mounted && currentTabIndex == 2 && _isVisible) {
                      // Double-check we're still on reels tab
                      if (Get.isRegistered<DashboardController>()) {
                        final dashboardCtrl = Get.find<DashboardController>();
                        if (dashboardCtrl.currentIndex.value == 2) {
                          _playCurrentVideo();
                        }
                      } else {
                        _playCurrentVideo();
                      }
                    }
                  });
                }
              }
            }
          } catch (e) {
            debugPrint('Error checking dashboard tab in build: $e');
          }
        }
      }
    });
    
    // Use WillPopScope to detect back button press
    return PopScope(
      canPop: true, // allow pop
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // Stop all videos and audio
          _stopAllVideos();
          controller.stopAllVideos();
          debugPrint('✅ Back button pressed - all videos and audio stopped');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          top: false,
          left: false,
          right: false,
          bottom: true,
          child: GetBuilder<ReelsController>(
            builder: (_) {
              // CRITICAL: Ensure first reel video is fully initialized before building PageView
              // This prevents incorrect aspect ratio on the very first entry.
              final hasFirstController =
                  controller.videoControllers.containsKey(0);
              final firstInitialized =
                  hasFirstController &&
                  (controller.isInitialized[0] == true) &&
                  controller.videoControllers[0]!.value.isInitialized;

              if (!hasFirstController || !firstInitialized) {
                // Show a single centered loader until first video is ready
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return PageView.builder(
                controller: controller.pageController,
                scrollDirection: Axis.vertical,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.reels.length,
                itemBuilder: (context, index) {
                  final reel = controller.reels[index];
                  return ReelItemWidget(
                    reel: reel,
                    index: index,
                    onLike: () => controller.toggleLike(index),
                    onComment: () => controller.onCommentTap(index),
                    onShare: () => controller.onShareTap(index),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
