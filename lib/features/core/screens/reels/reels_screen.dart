//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:parlour_app/constants/app_colors.dart';
// import 'package:parlour_app/controller/home_controller/main_navigation_controller.dart';
// import 'package:parlour_app/view/screen/reels/reels_binding.dart';
// import 'package:parlour_app/view/screen/reels/reels_controller.dart';
//
// import '../../widget/reel_item_widget.dart';
//
// class ReelsScreen extends StatefulWidget {
//   final bool isFromDashboard;
//
//   const ReelsScreen({super.key, this.isFromDashboard = false});
//
//   @override
//   State<ReelsScreen> createState() => _ReelsScreenState();
// }
//
// class _ReelsScreenState extends State<ReelsScreen> with WidgetsBindingObserver {
//   late ReelsController controller;
//   bool _isDisposed = false;
//   bool _isVisible = true;
//   Worker? _dashboardTabListener;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//
//     if (!Get.isRegistered<ReelsController>()) {
//       ReelsBinding().dependencies();
//     }
//     controller = Get.find<ReelsController>();
//     //
//     // if (widget.isFromDashboard) {
//     //   _listenToDashboardTabChanges();
//     // }
//     //
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   if (!_isDisposed && mounted) {
//     //     final route = ModalRoute.of(context);
//     //     if (route != null && route.isCurrent) {
//     //       controller.resetVideoPlayerState();
//     //       Future.delayed(const Duration(milliseconds: 500), () {
//     //         if (!_isDisposed && mounted) {
//     //           final route = ModalRoute.of(context);
//     //           if (route != null && route.isCurrent) {
//     //             _playCurrentVideo();
//     //           }
//     //         }
//     //       });
//     //     }
//     //   }
//     // });
//   }
//   // void _playCurrentVideo() {
//   //   try {
//   //     print('isVideo initialize ------> ');
//   //     if (controller.currentIndex.value != 0) {
//   //       controller.currentIndex.value = 0;
//   //       if (controller.pageController.hasClients) {
//   //         controller.pageController.jumpToPage(0);
//   //       }
//   //     }
//   //     final currentIndex = controller.currentIndex.value;
//   //     if (!controller.videoControllers.containsKey(currentIndex)) {
//   //       debugPrint('Video controller not found for index $currentIndex, waiting...');
//   //       Future.delayed(const Duration(milliseconds: 300), () {
//   //         if (!_isDisposed && mounted) {
//   //           _playCurrentVideo();
//   //         }
//   //       });
//   //       return;
//   //     }
//   //     final videoController = controller.videoControllers[currentIndex]!;
//   //     if (controller.isInitialized[currentIndex] == true &&
//   //         videoController.value.isInitialized) {
//   //         videoController.seekTo(Duration.zero);
//   //         videoController.setVolume(controller.globalMuteState.value ? 0.0 : 1.0);
//   //         controller.playVideo(currentIndex);
//   //         debugPrint('✅ Auto-playing video $currentIndex (muted: ${controller.globalMuteState.value})');
//   //     } else {
//   //       debugPrint('Video $currentIndex not initialized yet, waiting...');
//   //       Future.delayed(const Duration(milliseconds: 200), () {
//   //         if (!_isDisposed && mounted) {
//   //           _playCurrentVideo();
//   //         }
//   //       });
//   //     }
//   //   } catch (e) {
//   //     debugPrint('Error playing current video: $e');
//   //     Future.delayed(const Duration(milliseconds: 300), () {
//   //       if (!_isDisposed && mounted) {
//   //         _playCurrentVideo();
//   //       }
//   //     });
//   //   }
//   // }
//
//   // void _listenToDashboardTabChanges() {
//   //   try {
//   //     if (Get.isRegistered<MainNavigationController>()) {
//   //       final dashboardController = Get.find<MainNavigationController>();
//   //       _dashboardTabListener = ever(dashboardController.selectedBottomBarIndex, (int index) {
//   //         if (_isDisposed || !mounted) return;
//   //         if (index != 2) {
//   //           if (_isVisible) {
//   //             _isVisible = false;
//   //             _stopAllVideos();
//   //             controller.stopAllVideos();
//   //             debugPrint('✅ Tab changed away from Reels (index: $index) - videos and audio stopped');
//   //           }
//   //         } else {
//   //           _isVisible = true;
//   //           debugPrint('✅ Switched back to Reels tab - resetting and auto-playing video');
//   //           controller.resetVideoPlayerState();
//   //           Future.delayed(const Duration(milliseconds: 500), () {
//   //             if (!_isDisposed && mounted && _isVisible) {
//   //               if (Get.isRegistered<MainNavigationController>()) {
//   //                 final dashboardCtrl = Get.find<MainNavigationController>();
//   //                 if (dashboardCtrl.selectedBottomBarIndex.value == 2) {
//   //                   _playCurrentVideo();
//   //                 }
//   //               } else {
//   //                 _playCurrentVideo();
//   //               }
//   //             }
//   //           });
//   //         }
//   //       });
//   //     }
//   //   } catch (e) {
//   //     debugPrint('Error listening to dashboard tab changes: $e');
//   //   }
//   // }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     // Dispose dashboard tab listener
//     _dashboardTabListener?.dispose();
//     _dashboardTabListener = null;
//     _isDisposed = true;
//     // CRITICAL: Stop all videos when screen is disposed
//     // _stopAllVideos();
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     // CRITICAL: Stop all videos and audio when app goes to background, is paused, or is detached
//     if (state == AppLifecycleState.paused ||
//         state == AppLifecycleState.inactive ||
//         state == AppLifecycleState.hidden ||
//         state == AppLifecycleState.detached) {
//       // _stopAllVideos();
//       controller.stopAllVideos();
//       debugPrint('✅ App lifecycle changed to $state - videos and audio stopped');
//     } else if (state == AppLifecycleState.resumed) {
//       // CRITICAL: When app resumes, check if we're still on reels screen and play video
//       // _playCurrentVideo();
//     }
//   }
//
//   // void _stopAllVideos() {
//   //   if (_isDisposed) return;
//   //
//   //   try {
//   //     // CRITICAL: Stop all playing videos immediately and completely
//   //     for (var entry in controller.videoControllers.entries) {
//   //       try {
//   //         final videoController = entry.value;
//   //         if (videoController.value.isInitialized) {
//   //           // CRITICAL: Stop playback immediately
//   //           videoController.pause();
//   //           // CRITICAL: Mute audio to stop sound completely
//   //           videoController.setVolume(0.0);
//   //           // CRITICAL: Seek to beginning to reset position (prevents looping)
//   //           videoController.seekTo(Duration.zero);
//   //           // CRITICAL: Remove listeners to prevent auto-playback
//   //           videoController.removeListener(() {});
//   //           debugPrint('✅ Stopped video ${entry.key} completely');
//   //         }
//   //       } catch (e) {
//   //         debugPrint('Error stopping video ${entry.key}: $e');
//   //       }
//   //     }
//   //
//   //     // CRITICAL: Update playing state for all videos
//   //     for (var key in controller.isPlaying.keys.toList()) {
//   //       controller.isPlaying[key] = false;
//   //     }
//   //
//   //     // CRITICAL: Clear show controls
//   //     for (var key in controller.showControls.keys.toList()) {
//   //       controller.showControls[key] = false;
//   //     }
//   //
//   //     // CRITICAL: Defer update to avoid calling during widget tree lock
//   //     Future.microtask(() {
//   //       if (!_isDisposed) {
//   //         controller.update();
//   //       }
//   //     });
//   //
//   //     debugPrint('✅ All reels videos and audio stopped forcefully');
//   //   } catch (e) {
//   //     debugPrint('Error in _stopAllVideos: $e');
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     print('Reels list screen -------->');
//     // CRITICAL: Check if route is still active when building
//     // This catches cases where navigation happens but dispose() hasn't been called yet
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   if (!_isDisposed && mounted) {
//     //     final route = ModalRoute.of(context);
//     //     if (route == null || !route.isCurrent) {
//     //       // Route is no longer active, stop videos
//     //       _stopAllVideos();
//     //     }
//     //
//     //     // CRITICAL: Check dashboard tab index if from dashboard
//     //     if (widget.isFromDashboard) {
//     //       try {
//     //         if (Get.isRegistered<MainNavigationController>()) {
//     //           final dashboardController = Get.find<MainNavigationController>();
//     //           final currentTabIndex = dashboardController.selectedBottomBarIndex.value;
//     //
//     //           // Reels tab is index 2
//     //           if (currentTabIndex != 2) {
//     //             // CRITICAL: Not on reels tab, stop videos and audio immediately
//     //             if (_isVisible) {
//     //               _isVisible = false;
//     //               _stopAllVideos();
//     //               controller.stopAllVideos();
//     //             }
//     //           } else {
//     //             // CRITICAL: On reels tab - reset and ensure current video plays with audio automatically
//     //             // This ensures video plays every time user enters/returns to reels screen
//     //             if (!_isVisible || currentTabIndex == 2) {
//     //               _isVisible = true;
//     //
//     //               // CRITICAL: Reset video player state first
//     //               controller.resetVideoPlayerState();
//     //
//     //               // CRITICAL: Play current video with audio after reset
//     //               Future.delayed(const Duration(milliseconds: 500), () {
//     //                 if (!_isDisposed && mounted && currentTabIndex == 2 && _isVisible) {
//     //                   // Double-check we're still on reels tab
//     //                   if (Get.isRegistered<MainNavigationController>()) {
//     //                     final dashboardCtrl = Get.find<MainNavigationController>();
//     //                     if (dashboardCtrl.selectedBottomBarIndex.value == 2) {
//     //                       _playCurrentVideo();
//     //                     }
//     //                   } else {
//     //                     _playCurrentVideo();
//     //                   }
//     //                 }
//     //               });
//     //             }
//     //           }
//     //         }
//     //       } catch (e) {
//     //         debugPrint('Error checking dashboard tab in build: $e');
//     //       }
//     //     }
//     //   }
//     // });
//
//     // Use WillPopScope to detect back button press
//     return PopScope(
//       canPop: true, // allow pop
//       onPopInvokedWithResult: (didPop, result) {
//         if (didPop) {
//           // Stop all videos and audio
//           // _stopAllVideos();
//           controller.stopAllVideos();
//           debugPrint('✅ Back button pressed - all videos and audio stopped');
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: SafeArea(
//           top: false,
//           left: false,
//           right: false,
//           bottom: true,
//           child: GetBuilder<ReelsController>(
//             builder: (_) {
//               final hasFirstController =
//               controller.videoControllers.containsKey(0);
//               final firstInitialized =
//                   hasFirstController &&
//                       (controller.isInitialized[0] == true) &&
//                       controller.videoControllers[0]!.value.isInitialized;
//
//               if (!hasFirstController || !firstInitialized) {
//                 // Show a single centered loader until first video is ready
//                 return Center(
//                   child: CircularProgressIndicator(color: AppColors.white),
//                 );
//               }
//
//               return PageView.builder(
//                 controller: controller.pageController,
//                 scrollDirection: Axis.vertical,
//                 onPageChanged: controller.onPageChanged,
//                 itemCount: controller.reels.length,
//                 itemBuilder: (context, index) {
//                   final reel = controller.reels[index];
//                   return ReelItemWidget(
//                     reel: reel,
//                     index: index,
//                     onLike: () {},
//                     onComment: (){},
//                     onShare: (){},
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reels_viewer/reels_viewer.dart';
import 'package:varnika_app/features/core/screens/reels/reels_controller.dart';
import 'package:varnika_app/main.dart';

class ReelsScreen extends StatefulWidget {
  final bool isActive;

  const ReelsScreen({Key? key, required this.isActive}) : super(key: key);

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final ReelsController controller=Get.put(ReelsController());
  Key _reelsKey = UniqueKey();
  final List<ReelModel> reelsList = [
    ReelModel(
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      "BrightBrew",
      reelDescription: "Beautiful Nature 🌿",
      musicName: "Original Audio",
      isLiked: false,
    ),
    ReelModel(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      "Riddhi",
      reelDescription: "Beautiful 🌿",
      musicName: "Original Audio",
      isLiked: false,
    ),
  ];
  @override
  void didUpdateWidget(covariant ReelsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 👇 When tab becomes inactive
    if (!widget.isActive) {
      // Force dispose internal reels viewer
      setState(() {
        _reelsKey = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {


    return Obx(
            () {
          print("======>>>>>>${controller.isActiveReels.value}");
          return ReelsViewer(
            routeObserver: routeObserver,
            key: _reelsKey,
            reelsList: reelsList,
            showAppbar: false,
            isActiveScreen:controller.isActiveReels.value,
          );
        }
    );
  }
}
