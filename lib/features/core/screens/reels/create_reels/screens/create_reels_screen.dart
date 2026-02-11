import '../../../../../../utils/library_utils.dart';
class CreateReelsScreen extends StatefulWidget {
  const CreateReelsScreen({super.key});

  @override
  State<CreateReelsScreen> createState() => _CreateReelsScreenState();
}

class _CreateReelsScreenState extends State<CreateReelsScreen>
    with WidgetsBindingObserver {
  late final CreateReelsController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = Get.put(CreateReelsController(), permanent: false);

    // Clear selection ONCE when screen opens
    controller.clearGalleryState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller.reloadGalleryMedia();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateReelsController>();

    return SafeArea(
      top: false,
      bottom: true,
      left: false,
      right: false,
      child: Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.currentScreen.value == 0) {
          return _buildGallerySelectionScreen(controller, context);
        } else {
          return _buildEditingScreen(controller, context);
        }
      }),
      ),
    );
  }

  // Gallery Selection Screen (First Image)
  Widget _buildGallerySelectionScreen(
    CreateReelsController controller,
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: whiteColor),
          onPressed: () => controller.discardChanges(),
        ),
        title: Text(
          'New reel',
          style: AppTextStyles.subHeading.copyWith(
            color: whiteColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Obx(
            () => controller.isMultipleSelectionMode.value
                ? TextButton(
                    onPressed: () => controller.toggleMultipleSelectionMode(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Image.asset(
                          AppImages.cameraIcon,
                          color: whiteColor,
                          width: 20,
                          height: 20,
                        ),
                        onPressed: () => _showCameraOptions(controller),
                      ),
                      IconButton(
                        icon: Image.asset(
                          AppImages.multiImgIcon,
                          color: whiteColor,
                          height: 20,
                          width: 20,
                        ),
                        onPressed: () =>
                            controller.toggleMultipleSelectionMode(),
                        tooltip: 'Select multiple images',
                      ),
                    ],
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              // Check if gallery is loading
              if (controller.isLoadingGallery.value &&
                  !controller.isProcessingVideo.value) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(appColor),
                  ),
                );
              }
              if (!controller.isLoadingGallery.value &&
                  controller.isProcessingVideo.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // CircularProgressIndicator(
                      //   valueColor: AlwaysStoppedAnimation<Color>(appColor),
                      // ),
                      // 16.height,
                      Text(
                        'Processing....',
                        style: AppTextStyles.regular.copyWith(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Check if gallery media is empty
              if (controller.galleryMedia.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                children: [
                      Icon(
                        Icons.photo_library_outlined,
                        size: 64,
                        color: Colors.grey[600],
                      ),
                      16.height,
                      Text(
                        'Media not found',
                        style: AppTextStyles.subHeading.copyWith(
                          color: Colors.grey[400],
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      8.height,
                      Text(
                        'No photos or videos available in your gallery',
                        style: AppTextStyles.regular.copyWith(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              // Dynamically determine media type based on current selection
              GalleryMediaType mediaType;
              if (controller.isMultipleSelectionMode.value) {
                if (controller.multiSelectionType.value == 'images') {
                  // Images selected - only allow images
                  mediaType = GalleryMediaType.onlyImages;
                } else if (controller.multiSelectionType.value == 'video') {
                  // Video selected - only allow videos (though only one can be selected)
                  mediaType = GalleryMediaType.onlyVideos;
                } else {
                  // Nothing selected yet - allow all
                  mediaType = GalleryMediaType.all;
                }
              } else {
                // Single selection mode - allow all
                mediaType = GalleryMediaType.all;
              }

              return GalleryMediaPicker(
                key: ValueKey(controller.galleryPickerRefreshKey.value),
                pathList: (paths) {
                        controller.handleSelectedMediaFromPicker(paths);
                      },

                      mediaPickerParams: MediaPickerParamsModel(
                        appBarHeight: 50,
                  maxPickImages: 10,
                        crossAxisCount: 3,
                        childAspectRatio: .5,
                  singlePick: !controller.isMultipleSelectionMode.value,
                  appBarColor: blackColor,
                  gridViewBgColor: blackColor,
                        albumTextColor: Colors.white,
                        gridPadding: EdgeInsets.zero,
                  thumbnailBgColor: kColorGray.withValues(alpha: 0.9),
                        thumbnailBoxFix: BoxFit.cover,
                        selectedAlbumIcon: Icons.check,
                  selectedCheckColor: whiteColor,
                  albumSelectIconColor: whiteColor,
                  selectedCheckBgColor: appColor,
                  selectedAlbumBgColor: blackColor,
                  albumDropDownBgColor: blackColor,
                  albumSelectTextColor: whiteColor,
                        selectedAssetBgColor: appColor,
                        selectedAlbumTextColor: Colors.white,
                  mediaType: mediaType,
                  thumbnailQuality: ThumbnailQuality.medium,
                        gridViewPhysics: const BouncingScrollPhysics(),
                      ),
              );
            }),
          ),

          // Multiple selection bottom bar with selected images tray
          Obx(
            () => controller.isMultipleSelectionMode.value
                ? SafeArea(
                  child: Container(
                    height: 100,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      border: Border(
                        top: BorderSide(color: Colors.grey[800]!, width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                          // Selected media tray (images or video)
                        Expanded(
                            child: Obx(() {
                              // Show video if selected, otherwise show images
                              if (controller.selectedVideo.value != null) {
                                final videoFile = controller.selectedVideo.value!;
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 70,
                                      height: 70,
                                      margin: EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: appColor,
                                          width: 2,
                                        ),
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            child: Image.file(
                                              videoFile,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[800],
                                                      child: Icon(
                                                        Icons.videocam,
                                                        color: Colors.grey,
                                                        size: 24,
                                                      ),
                                                    );
                                                  },
                                            ),
                                          ),
                                          // Video icon overlay
                                          Positioned.fill(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black.withAlpha(
                                                  3
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.play_circle_filled,
                                                  color: whiteColor,
                                                  size: 24,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Remove button (X)
                                          Positioned(
                                            top: 2,
                                            right: 2,
                                            child: GestureDetector(
                                              onTap: () {
                                                controller
                                                    .removeVideoFromSelection();
                                              },
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withValues(
                                                    alpha: 0.7,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.close,
                                                  color: whiteColor,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              } else {
                                // Show images
                                return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.selectedImages.length,
                            itemBuilder: (context, index) {
                              final imageFile =
                                  controller.selectedImages[index];
                              return Container(
                                width: 70,
                                height: 70,
                                margin: EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: appColor,
                                          width: 2,
                                        ),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                      child: Image.file(
                                        imageFile,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey[800],
                                                child: Icon(
                                                  Icons.image,
                                                  color: Colors.grey,
                                                  size: 24,
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                    // Remove button (X)
                                    Positioned(
                                      top: 2,
                                      right: 2,
                                      child: GestureDetector(
                                        onTap: () {
                                                controller
                                                    .removeImageFromSelection(
                                            imageFile,
                                          );
                                        },
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(
                                              alpha:
                                              0.7,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: whiteColor,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                                );
                              }
                            }),
                        ),
                        // Next button
                        Container(
                          margin: EdgeInsets.only(left: 12),
                            child: Obx(() {
                              final hasImages =
                                  controller.selectedImages.isNotEmpty;
                              final hasVideo =
                                  controller.selectedVideo.value != null;
                              final hasSelection = hasImages || hasVideo;

                              return ElevatedButton(
                            onPressed:
                                    !hasSelection ||
                                    controller.isProcessingVideo.value
                                ? null
                                : () async {
                                        if (hasVideo) {
                                          // Handle selected video
                                          await controller
                                              .handleSelectedVideoInMultiMode();
                                        } else {
                                          // Handle selected images
                                    await controller
                                        .generateVideoFromMultipleImages();
                                        }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appColor,
                              disabledBackgroundColor: Colors.grey[700],
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                            ),
                            child: controller.isProcessingVideo.value
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                        whiteColor,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                            ' ',
                                        style: TextStyle(
                                          color: whiteColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      4.width,
                                      Icon(
                                        Icons.arrow_forward,
                                        color: whiteColor,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                              );
                            }),
                        ),
                      ],
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // Editing Screen (Third/Fifth Image)
  Widget _buildEditingScreen(
    CreateReelsController controller,
    BuildContext context,
  ) {
    // Auto-play selected music when screen loads or music changes (for multi-image videos and regular videos)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Wait a bit for screen to fully load
      await Future.delayed(Duration(milliseconds: 300));

      // Only play if music is selected and not already playing
      // Don't play if music is already applied to video (it's part of video audio)
      if (controller.selectedMusicPath.value.isNotEmpty &&
          !controller.isMusicPlaying.value &&
          !controller.isMusicAppliedToVideo.value) {
        debugPrint('Auto-playing music in editing screen...');
        debugPrint('Music path: ${controller.selectedMusicPath.value}');
        debugPrint('Is video: ${controller.isVideo.value}');
        debugPrint(
          'Video initialized: ${controller.videoController.value?.value.isInitialized}',
        );

        try {
          // For multi-image videos and regular videos, mute video audio and play music
          if (controller.isVideo.value &&
              controller.videoController.value != null &&
              controller.videoController.value!.value.isInitialized) {
            // Mute video audio
            await controller.videoController.value!.setVolume(0.0);

            // Find the music in the list and play it using selectMusic method
            final musicIndex = controller.selectedMusicIndex.value >= 0
                ? controller.selectedMusicIndex.value
                : controller.musicList.indexWhere(
                    (m) => m['audio'] == controller.selectedMusicPath.value,
                  );

            if (musicIndex >= 0 && musicIndex < controller.musicList.length) {
              final music = controller.musicList[musicIndex];
              debugPrint('Playing music from list index: $musicIndex');
              // Ensure audio player is configured before selecting music
              await controller.selectMusic(music, musicIndex);
            } else {
              debugPrint('Music not found in list, trying direct play...');
              // Fallback: try direct play
              controller.playSelectedMusicInReel();
            }
          } else {
            debugPrint('Video not ready, using fallback...');
            // Fallback: use playSelectedMusicInReel
            controller.playSelectedMusicInReel();
          }
        } catch (e) {
          debugPrint('Error auto-playing music: $e');
        }
      } else {
        debugPrint('Music not selected or already playing/applied');
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: "Create Reels",
        children: [
          GestureDetector(
            onTap: () async {
              try {
                await controller.postReel();
              } catch (e) {
                debugPrint('Error in appbar Next button: $e');
              }
            },
            child: CircleAvatar(
              radius: 15,
              backgroundColor: whiteColor,
              child: Center(child: Icon(Icons.arrow_forward, color: appColor)),
            ),
          ),
          10.width,
        ],
      ),

      body: GetBuilder<CreateReelsController>(
        builder: (controller) {
          return Obx(() {
            // Build background widget (video or image)
            Widget backgroundWidget;

            final media = controller.selectedMedia.value;

            if (media == null) {
              backgroundWidget = Container(color: Colors.black);
            } else if (controller.isProcessingVideo.value &&
                !controller.isVideo.value) {
              // CRITICAL: While processing (e.g. creating video from image),
              // rely on the single global overlay loader instead of a second loader here.
              // Keep a simple black background so only ONE loader is visible in the whole UI.
              backgroundWidget = Container(
                width: Get.width,
                height: Get.height,
                color: Colors.black,
              );
            } else if (controller.isVideo.value) {


              // VIDEO
              if (!controller.isVideoInitialized.value ||
                  controller.videoController.value == null ||
                  !controller.videoController.value!.value.isInitialized) {
                backgroundWidget = const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                // 0.5625
                backgroundWidget = GetBuilder<CreateReelsController>(
                  builder: (controller) {
                    // Double-check video is initialized
                    if (controller.videoController.value == null ||
                        !controller
                            .videoController
                            .value!
                            .value
                            .isInitialized) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Container(
                      width: Get.width,
                      height: Get.height,
                      color: Colors.black,
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: controller.lockedAspectRatio ??= controller.videoController.value!.value.aspectRatio,
                          child: Obx(() {
                            // Access filter methods safely
                            ColorFilter? colorFilter;
                            bool needsGradient = false;

                            try {
                              colorFilter = controller.getSelectedColorFilter();
                              needsGradient = controller.needsGradientOverlay();
                            } catch (e) {
                              debugPrint('Error accessing filter methods: $e');
                              colorFilter = null;
                              needsGradient = false;
                            }

                            return Stack(
                              children: [
                                // CRITICAL: Safety check before rendering VideoPlayer
                                if (controller.videoController.value != null &&
                                    controller
                                        .videoController
                                        .value!
                                        .value
                                        .isInitialized)
                                ColorFiltered(
                                  colorFilter:
                                      colorFilter ??
                                      ColorFilter.mode(
                                        Colors.transparent,
                                        BlendMode.dst,
                                      ),
                                  child: VideoPlayer(
                                    controller.videoController.value!,
                                      key: ValueKey(
                                        controller
                                                .processedVideoFile
                                                .value
                                                ?.path ??
                                            controller
                                                .generatedVideo
                                                .value
                                                ?.path ??
                                            controller
                                                .selectedMedia
                                                .value
                                                ?.path ??
                                            'video_${DateTime.now().millisecondsSinceEpoch}',
                                      ),
                                    ),
                                  )
                                else
                                  Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        appColor,
                                      ),
                                  ),
                                ),
                                // Vignette gradient overlay for video
                                if (needsGradient)
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: RadialGradient(
                                          center: Alignment.center,
                                          radius: 1.2,
                                          colors: [
                                            Colors.transparent,
                                            Colors.transparent,
                                            Colors.black.withValues(
                                                alpha:0.5),
                                            Colors.black.withValues(
                                                alpha: 0.8),
                                          ],
                                          stops: [0.0, 0.5, 0.8, 1.0],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),
                    );
                  },
                );
              }
            } else {
              // ✅ IMAGE
              backgroundWidget = Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black,
                alignment: Alignment.center,
                child: Obx(() {
                  // Access filter methods safely
                  ColorFilter? colorFilter;
                  bool needsGradient = false;

                  try {
                    colorFilter = controller.getSelectedColorFilter();
                    needsGradient = controller.needsGradientOverlay();
                  } catch (e) {
                    debugPrint('Error accessing filter methods: $e');
                    colorFilter = null;
                    needsGradient = false;
                  }

                  return Stack(
                    children: [
                      // Music indicator (if music is selected) - Modern design

                      // Bottom editing tools - Modern UI
                      ColorFiltered(
                        colorFilter:
                            colorFilter ??
                            ColorFilter.mode(Colors.transparent, BlendMode.dst),
                        child: Image.file(
                          media,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                'Failed to load image',
                                style: TextStyle(color: whiteColor),
                              ),
                            );
                          },
                        ),
                      ),
                      // Vignette gradient overlay
                      if (needsGradient)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment.center,
                                radius: 1.2,
                                colors: [
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.black.withValues(
                                      alpha:0.5),
                                  Colors.black.withValues(
                                      alpha:0.8),
                                ],
                                stops: [0.0, 0.5, 0.8, 1.0],
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              );
            }

            return GetBuilder<CreateReelsController>(
              builder: (controller) {
                return Stack(
                  children: [
                    backgroundWidget,
                    // Draggable text overlays - positioned relative to media bounds
                    Obx(() {
                      if (controller.addedTexts.isEmpty) {
                        return SizedBox.shrink();
                      }

                      // Calculate media bounds for text positioning
                      Size? mediaSize;
                      Offset? mediaOffset;

                      if (controller.isVideo.value &&
                          controller.videoController.value != null) {
                        final aspectRatio =
                            controller.videoController.value!.value.aspectRatio;
                        final screenWidth = MediaQuery.of(context).size.width;
                        final screenHeight = MediaQuery.of(context).size.height;

                        // Calculate actual video display size (centered with BoxFit.contain)
                        double videoWidth, videoHeight;
                        if (screenWidth / screenHeight > aspectRatio) {
                          // Screen is wider than video aspect ratio
                          videoHeight = screenHeight;
                          videoWidth = videoHeight * aspectRatio;
                        } else {
                          // Screen is taller than video aspect ratio
                          videoWidth = screenWidth;
                          videoHeight = videoWidth / aspectRatio;
                        }

                        mediaSize = Size(videoWidth, videoHeight);
                        mediaOffset = Offset(
                          (screenWidth - videoWidth) / 2,
                          (screenHeight - videoHeight) / 2,
                        );
                      } else if (media != null) {
                        // For images, we need to calculate based on BoxFit.contain
                        // This is approximate - actual size depends on image dimensions
                        final screenWidth = MediaQuery.of(context).size.width;
                        final screenHeight = MediaQuery.of(context).size.height;

                        // Use screen dimensions as base (image will be contained within)
                        mediaSize = Size(screenWidth, screenHeight);
                        mediaOffset = Offset.zero;
                      }

                      return Stack(
                        children: controller.addedTexts
                            .where((textData) {
                              // Hide text being edited
                              final textId = textData['id'] as String?;
                              return textId != controller.editingTextId.value;
                            })
                            .map((textData) {
                          return DraggableTextWidget(
                            textData: textData,
                            controller: controller,
                            mediaSize: mediaSize,
                            mediaOffset: mediaOffset,
                          );
                            })
                            .toList(),
                      );
                    }),

                    // Video processing indicator
                    Positioned(
                      left: 10,
                      top: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => controller.discardChanges(),
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: appWhite.withValues(alpha: 0.2),
                              ),
                              child: Icon(
                                Icons.close_outlined,
                                color: whiteColor,
                                size: 25,
                              ),
                            ),
                          ),
                          20.width,
                          Obx(() {
                            // Don't show music indicator when bottom sheets are open
                            if (Get.isBottomSheetOpen ?? false) {
                              return const SizedBox.shrink();
                            }

                            if (controller.selectedMusic.value.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            return GestureDetector(
                              onTap: () async {
                                // CRITICAL: Track if music was playing before opening bottom sheet
                                final wasMusicPlaying = controller.isMusicPlaying.value;
                                final hadMusicSelected = controller.selectedMusicPath.value.isNotEmpty;
                                
                                // Step 5: Pause previous music (only pause, not remove) and open music selection sheet
                                if (wasMusicPlaying) {
                                  controller
                                      .toggleMusicPlayPause(); // Pause if playing
                                }

                                // CRITICAL: Pause video when opening music selection from top indicator
                                if (controller.isVideo.value &&
                                    controller.videoController.value != null &&
                                    controller
                                        .videoController
                                        .value!
                                        .value
                                        .isInitialized) {
                                  try {
                                    // Pause video first to stop playback
                                    await controller.videoController.value!
                                        .pause();
                                    // Then mute to release audio focus
                                    await controller.videoController.value!
                                        .setVolume(0.0);
                                    debugPrint(
                                      '✅ Video paused and muted for music selection from top indicator',
                                    );
                                  } catch (e) {
                                    debugPrint('Error pausing video: $e');
                                  }
                                }
                                controller.selectedMusic.value = '';
                                controller.selectedMusicArtist.value = '';
                                controller.selectedMusicPath.value = '';
                                controller.selectedMusicImgPath.value = '';
                                controller.selectedMusicIndex.value = (-1);
                                controller.isNextForTrim.value=false;

                                Get.bottomSheet(
                                  MusicSelectionBottomSheet(
                                    controller: controller,
                                  ),
                                  isScrollControlled: true,
                                  isDismissible: true,
                                  enableDrag: true,
                                ).then((_) async {
                                  debugPrint('Bottom sheet closed, wasMusicPlaying: $wasMusicPlaying, isMusicAppliedToVideo: ${controller.isMusicAppliedToVideo.value}');
                                  await Future.delayed(const Duration(milliseconds: 150));

                                  // CRITICAL: Ensure music selection state is preserved and UI updates
                                  if (controller.selectedMusicPath.value.isNotEmpty) {
                                    controller.selectedMusic.refresh();
                                    controller.selectedMusicArtist.refresh();
                                    controller.selectedMusicImgPath.refresh();
                                    controller.isMusicAppliedToVideo.refresh();
                                    controller.update();
                                  }
                                  if(!controller.isNextForTrim.value){
                                    Map<String, dynamic>? data=await TrimmedMusicDB.getStoredTrimmedMusic();

                                    if(data!=null){
                                      controller.selectedMusic.value=data['musicName'].toString();
                                      controller.selectedMusicArtist.value=data['musicArtist'].toString();
                                      controller.selectedMusicImgPath.value=data['musicImagePath'].toString();
                                      controller.selectedMusicPath.value=data['musicPath'].toString();
                                      controller.musicStartTime.value=double.tryParse(data['startTime'].toString())??0.0;
                                      controller.musicEndTime.value=double.tryParse(data['endTime'].toString())??0.0;
                                    }
                                  }

                                  // CRITICAL: Handle two cases:
                                  // 1. Music NOT applied to video: Resume separate audio player
                                  // 2. Music IS applied to video: Resume video (which contains music)
                                  
                                  if (controller.isMusicAppliedToVideo.value) {
                                    // Music is embedded in video - resume video
                                    if (controller.isVideo.value &&
                                        controller.videoController.value != null &&
                                        controller.videoController.value!.value.isInitialized) {
                                      try {
                                        // Re-add auto-play listener
                                        controller.videoController.value!.addListener(
                                          controller.ensureVideoLooping,
                                        );
                                        // Resume video with music
                                        await controller.videoController.value!.setVolume(1.0);
                                        await controller.videoController.value!.play();
                                        debugPrint('✅ Video (with embedded music) resumed after closing bottom sheet');
                                      } catch (e) {
                                        debugPrint('Error resuming video with embedded music: $e');
                                      }
                                    }
                                  } else {
                                    // Music is separate - resume audio player first, then video
                                    if (wasMusicPlaying &&
                                        controller.selectedMusicPath.value.isNotEmpty) {
                                      debugPrint('✅ Resuming separate music after bottom sheet');
                                      await controller.resumeMusic();
                                    }

                                    // Resume video (muted if music is playing separately)
                                    if (controller.isVideo.value &&
                                        controller.videoController.value != null &&
                                        controller.videoController.value!.value.isInitialized) {
                                      try {
                                        // Re-add auto-play listener
                                        controller.videoController.value!.addListener(
                                          controller.ensureVideoLooping,
                                        );
                                        
                                        // If music is playing separately, mute video; otherwise play with sound
                                        if (wasMusicPlaying && controller.selectedMusicPath.value.isNotEmpty) {
                                          await controller.videoController.value!.setVolume(0.0);
                                        } else {
                                          await controller.videoController.value!.setVolume(1.0);
                                        }
                                        await controller.videoController.value!.play();
                                        debugPrint('✅ Video resumed after closing bottom sheet');
                                      } catch (e) {
                                        debugPrint('Error resuming video: $e');
                                      }
                                    }
                                  }
                                }
                                ).catchError((error) {
                                  // CRITICAL: Handle errors and still resume playback if needed
                                  debugPrint('Error in bottom sheet callback: $error');
                                  
                                  controller.isMusicSelectionActive.value = false;
                                  
                                  // CRITICAL: Ensure music state is preserved even on error
                                  if (controller.selectedMusicPath.value.isNotEmpty) {
                                    controller.selectedMusic.refresh();
                                    controller.selectedMusicArtist.refresh();
                                    controller.selectedMusicImgPath.refresh();
                                    controller.isMusicAppliedToVideo.refresh();
                                    controller.update();
                                  }
                                  
                                  // Handle based on whether music is applied to video
                                  if (controller.isMusicAppliedToVideo.value) {
                                    // Resume video with embedded music
                                    if (controller.isVideo.value &&
                                        controller.videoController.value != null &&
                                        controller.videoController.value!.value.isInitialized) {
                                      try {
                                        controller.videoController.value!.addListener(
                                          controller.ensureVideoLooping,
                                        );
                                        controller.videoController.value!.setVolume(1.0);
                                        controller.videoController.value!.play();
                                      } catch (e) {
                                        debugPrint('Error resuming video in error handler: $e');
                                      }
                                    }
                                  } else {
                                    // Resume separate music
                                    if (hadMusicSelected && 
                                        controller.selectedMusicPath.value.isNotEmpty &&
                                        wasMusicPlaying && 
                                        !controller.isMusicPlaying.value) {
                                      controller.playSelectedMusic();
                                    }
                                    // Resume video
                                    if (controller.isVideo.value &&
                                        controller.videoController.value != null &&
                                        controller.videoController.value!.value.isInitialized) {
                                      try {
                                        controller.videoController.value!.addListener(
                                          controller.ensureVideoLooping,
                                        );
                                        if (wasMusicPlaying && controller.selectedMusicPath.value.isNotEmpty) {
                                          controller.videoController.value!.setVolume(0.0);
                                        } else {
                                          controller.videoController.value!.setVolume(1.0);
                                        }
                                        controller.videoController.value!.play();
                                      } catch (e) {
                                        debugPrint('Error resuming video in error handler: $e');
                                      }
                                    }
                                  }
                                });
                              },
                                    child: Container(
                                padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: blackColor.withValues(
                                            alpha:0.3),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                      padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: appColor.withValues(
                                                  alpha: 0.2),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.music_note,
                                              color: appColor,
                                              size: 16,
                                            ),
                                          ),
                                          10.width,
                                          Flexible(
                                            child: Text(
                                              controller.selectedMusic.value,
                                              style: TextStyle(
                                                color: whiteColor,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          10.width,
                                    // Obx(() => GestureDetector(
                                    //   onTap: () {
                                    //     controller.toggleMusicPlayPause();
                                    //   },
                                    //   behavior: HitTestBehavior.opaque,
                                    //   child: Container(
                                    //     padding: const EdgeInsets.all(4),
                                    //     decoration: BoxDecoration(
                                    //       color: appColor.withValues(alpha:0.2),
                                    //       shape: BoxShape.circle,
                                    //     ),
                                    //     child: Icon(
                                    //       controller.isMusicPlaying.value
                                    //           ? Icons.pause
                                    //           : Icons.play_arrow,
                                    //       color: appColor,
                                    //       size: 18,
                                    //     ),
                                    //   ),
                                    // )),
                                        ],
                                      ),
                                    ),
                            );
                          }),
                        ],
                      ),
                    ),
                    Obx(
                      () => controller.isProcessingVideo.value &&
                                  !(Get.isBottomSheetOpen ?? false)
                          ? Positioned.fill(
                              child: Container(
                                    color: Colors.black.withValues(
                                        alpha: 0.85),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              appColor,
                                            ),
                                            strokeWidth: 3,
                                      ),
                                      20.height,
                                      Text(
                                            !controller.isVideo.value &&
                                                    controller
                                                            .selectedMedia
                                                            .value !=
                                                        null
                                                ? 'Creating video from image...'
                                                : controller
                                                            .selectedMusicPath
                                                            .value
                                                            .isNotEmpty &&
                                                        controller
                                                                .musicStartTime
                                                                .value >
                                                            0
                                                    ? 'Replacing audio with selected music'
                                                    : 'Processing video...',
                                        style: TextStyle(
                                          color: whiteColor,
                                          fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                        ),
                                            textAlign: TextAlign.center,
                                      ),
                                      10.height,
                                      Text(
                                            'Please wait',
                                        style: TextStyle(
                                              color: Colors.grey[400],
                                          fontSize: 12,
                                        ),
                                            textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 20,
                          bottom: MediaQuery.of(context).padding.bottom,
                          left: 16,
                          right: 16,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(
                                  alpha: 0.95),
                              Colors.black.withValues(
                                  alpha: 0.88),
                              Colors.transparent,
                            ],
                            stops: [0.0, 0.5, 1.0],
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildEditTool(
                                  icon: AppImages.audioIcon,
                                  label: 'Audio',
                                  onTap: () =>
                                      _showMusicBottomSheet(controller),
                                ),
                                _buildEditTool(
                                  icon: AppImages.textIcon,
                                  label: 'Text',
                                  onTap: () => _showTextEditor(controller),
                                ),
                                _buildEditTool(
                                  icon: AppImages.imageFilterIcon,
                                  label: 'Filter',
                                  onTap: () =>
                                      _showFilterBottomSheet(controller),
                                ),
                                _buildEditTool(
                                  icon: AppImages.trimIcon,
                                  label: 'Trim',
                                  onTap: () =>
                                      _showTrimmingBottomSheet(controller),
                                ),
                              ],
                            ),
                            10.height,
                            SafeArea(
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () => controller.backToGallery(),
                                    child: Text(
                                      'Back',
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                12.width,
                                ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      await controller.postReel();
                                    } catch (e) {
                                      debugPrint('Error in Next button: $e');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: appColor,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 0,
                                      horizontal: 16,
                                    ),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Next',
                                        style: TextStyle(
                                          color: whiteColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      8.width,
                                      Icon(
                                        Icons.arrow_forward,
                                        color: whiteColor,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          });
        },
      ),
    );
  }

  // Edit tool button - Modern design
  Widget _buildEditTool({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                  alpha:0.15),
              borderRadius: BorderRadius.circular(8),
              // border: Border.all(
              //   color: Colors.white.withValues(alpha:0.3),
              //   width: 1.5,
              // ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                      alpha:0.2),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(icon, color: whiteColor),
            ),
          ),
          8.height,
          Text(
            label,
            style: AppTextStyles.regular.copyWith(
              color: whiteColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Show camera options
  void _showCameraOptions(CreateReelsController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('Select Option', style: TextStyle(color: whiteColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.videocam, color: whiteColor),
              title: Text('Record Video', style: TextStyle(color: whiteColor)),
              onTap: () {
                Get.back();
                controller.openCamera(isVideo: true);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: whiteColor),
              title: Text('Take Photo', style: TextStyle(color: whiteColor)),
              onTap: () {
                Get.back();
                controller.openCamera(isVideo: false);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Step 1: Show audio bottom sheet (from music button)
  void _showMusicBottomSheet(CreateReelsController controller) async {
    // CRITICAL: Track if music was playing before opening bottom sheet
    final wasMusicPlaying = controller.isMusicPlaying.value;
    final _ = controller.selectedMusicPath.value.isNotEmpty;
    
    // CRITICAL: Don't clear music selection - just pause it if playing
    // This preserves the selected music so it can resume if user doesn't change it
    if (wasMusicPlaying) {
      await controller.toggleMusicPlayPause(); // Pause if playing
    }

    // CRITICAL: Set music selection active flag to prevent auto-play
    controller.isMusicSelectionActive.value = true;

    // CRITICAL: Pause video when opening music bottom sheet
    if (controller.isVideo.value &&
        controller.videoController.value != null &&
        controller.videoController.value!.value.isInitialized) {
      try {
        // Remove auto-play listener temporarily
        controller.videoController.value!.removeListener(
          controller.ensureVideoLooping,
        );

        // Pause video first to stop playback
        await controller.videoController.value!.pause();
        // Then mute to release audio focus
        await controller.videoController.value!.setVolume(0.0);
        debugPrint('✅ Video paused and muted for music selection');
      } catch (e) {
        debugPrint('Error pausing video: $e');
      }
    }
    controller.selectedMusic.value = '';
    controller.selectedMusicArtist.value = '';
    controller.selectedMusicPath.value = '';
    controller.selectedMusicImgPath.value = '';
    controller.selectedMusicIndex.value = (-1);
    controller.isNextForTrim.value=false;
    Get.bottomSheet(
      MusicSelectionBottomSheet(
        controller: controller,
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
    ).then((_) async {
      debugPrint(
          'Bottom sheet closed, wasMusicPlaying: $wasMusicPlaying, isMusicAppliedToVideo: ${controller
              .isMusicAppliedToVideo.value}');
      await Future.delayed(const Duration(milliseconds: 150));

      // CRITICAL: Ensure music selection state is preserved and UI updates
      if (controller.selectedMusicPath.value.isNotEmpty) {
        controller.selectedMusic.refresh();
        controller.selectedMusicArtist.refresh();
        controller.selectedMusicImgPath.refresh();
        controller.isMusicAppliedToVideo.refresh();
        controller.update();
      }

      if(!controller.isNextForTrim.value){
        Map<String, dynamic>? data=await TrimmedMusicDB.getStoredTrimmedMusic();

        if(data!=null){
          controller.selectedMusic.value=data['musicName'].toString();
          controller.selectedMusicArtist.value=data['musicArtist'].toString();
          controller.selectedMusicImgPath.value=data['musicImagePath'].toString();
          controller.selectedMusicPath.value=data['musicPath'].toString();
          controller.musicStartTime.value=double.tryParse(data['startTime'].toString())??0.0;
          controller.musicEndTime.value=double.tryParse(data['endTime'].toString())??0.0;
        }
      }

      // CRITICAL: Handle two cases:
      // 1. Music NOT applied to video: Resume separate audio player
      // 2. Music IS applied to video: Resume video (which contains music)

      if (controller.isMusicAppliedToVideo.value) {
        // Music is embedded in video - resume video
        if (controller.isVideo.value &&
            controller.videoController.value != null &&
            controller.videoController.value!.value.isInitialized) {
          try {// Re-add auto-play listener
            controller.videoController.value!.addListener(
              controller.ensureVideoLooping,
            );
            // Resume video with music
            await controller.videoController.value!.setVolume(1.0);
            await controller.videoController.value!.play();
            debugPrint(
                '✅ Video (with embedded music) resumed after closing bottom sheet');
          } catch (e) {
            debugPrint('Error resuming video with embedded music: $e');
          }
        }
      } else {
        // Music is separate - resume audio player first, then video
        if (wasMusicPlaying &&
            controller.selectedMusicPath.value.isNotEmpty) {
          debugPrint('✅ Resuming separate music after bottom sheet');
          await controller.resumeMusic();
        }

        // Resume video (muted if music is playing separately)
        if (controller.isVideo.value &&
            controller.videoController.value != null &&
            controller.videoController.value!.value.isInitialized) {
          try {
            // Re-add auto-play listener
            controller.videoController.value!.addListener(
              controller.ensureVideoLooping,
            );

            // If music is playing separately, mute video; otherwise play with sound
            if (wasMusicPlaying &&
                controller.selectedMusicPath.value.isNotEmpty) {
              await controller.videoController.value!.setVolume(0.0);
            } else {
              await controller.videoController.value!.setVolume(1.0);
            }
            await controller.videoController.value!.play();
            debugPrint('✅ Video resumed after closing bottom sheet');
          } catch (e) {
            debugPrint('Error resuming video: $e');
          }
        }
      }
    });
    // Get.bottomSheet(
    //   MusicSelectionBottomSheet(controller: controller),
    //   isScrollControlled: true,
    //   backgroundColor: Colors.transparent,
    //   isDismissible: true,
    //   enableDrag: true,
    // ).then((_) async {
    //   debugPrint('Bottom sheet closed (music button), wasMusicPlaying: $wasMusicPlaying, isMusicAppliedToVideo: ${controller.isMusicAppliedToVideo.value}');
    //
    //   // CRITICAL: Add small delay to ensure bottom sheet is fully closed
    //   await Future.delayed(Duration(milliseconds: 100));
    //
    //   controller.isMusicSelectionActive.value = false;
    //
    //   // CRITICAL: Handle two cases:
    //   // 1. Music NOT applied to video: Resume separate audio player
    //   // 2. Music IS applied to video: Resume video (which contains music)
    //
    //   if (controller.isMusicAppliedToVideo.value) {
    //     // Music is embedded in video - resume video
    //     if (controller.isVideo.value &&
    //         controller.videoController.value != null &&
    //         controller.videoController.value!.value.isInitialized) {
    //       try {
    //         // Re-add auto-play listener
    //         controller.videoController.value!.addListener(
    //           controller.ensureVideoLooping,
    //         );
    //         // Resume video with music
    //         await controller.videoController.value!.setVolume(1.0);
    //         await controller.videoController.value!.play();
    //         debugPrint('✅ Video (with embedded music) resumed after closing bottom sheet');
    //       } catch (e) {
    //         debugPrint('Error resuming video with embedded music: $e');
    //       }
    //     }
    //   } else {
    //     // Music is separate - resume audio player first, then video
    //     final currentMusicPath = controller.selectedMusicPath.value;
    //     if (hadMusicSelected &&
    //         currentMusicPath.isNotEmpty &&
    //         wasMusicPlaying &&
    //         !controller.isMusicPlaying.value) {
    //       debugPrint('✅ Resuming previous music after closing selection sheet (barrier tap)');
    //       await controller.playSelectedMusic();
    //     }
    //
    //     // Resume video (muted if music is playing separately)
    //     if (controller.isVideo.value &&
    //         controller.videoController.value != null &&
    //         controller.videoController.value!.value.isInitialized) {
    //       try {
    //         // Re-add auto-play listener
    //         controller.videoController.value!.addListener(
    //           controller.ensureVideoLooping,
    //         );
    //
    //         // If music is playing separately, mute video; otherwise play with sound
    //         if (wasMusicPlaying && controller.selectedMusicPath.value.isNotEmpty) {
    //           await controller.videoController.value!.setVolume(0.0);
    //         } else {
    //           await controller.videoController.value!.setVolume(1.0);
    //         }
    //         await controller.videoController.value!.play();
    //         debugPrint('✅ Video resumed after closing music selection');
    //       } catch (e) {
    //         debugPrint('Error resuming video: $e');
    //       }
    //     }
    //   }
    // }).catchError((error) {
    //   // CRITICAL: Handle errors and still resume music if needed
    //   debugPrint('Error in bottom sheet callback: $error');
    //
    //   controller.isMusicSelectionActive.value = false;
    //
    //   // Still try to resume music if it was playing
    //   if (hadMusicSelected &&
    //       controller.selectedMusicPath.value.isNotEmpty &&
    //       !controller.isMusicAppliedToVideo.value &&
    //       wasMusicPlaying &&
    //       !controller.isMusicPlaying.value) {
    //     controller.playSelectedMusic();
    //   }
    //
    //   // Still try to resume video
    //   if (controller.isVideo.value &&
    //       controller.videoController.value != null &&
    //       controller.videoController.value!.value.isInitialized &&
    //       !controller.isMusicAppliedToVideo.value) {
    //     try {
    //       controller.videoController.value!.addListener(
    //         controller.ensureVideoLooping,
    //       );
    //       controller.videoController.value!.setVolume(1.0);
    //       controller.videoController.value!.play();
    //     } catch (e) {
    //       debugPrint('Error resuming video in error handler: $e');
    //     }
    //   }
    // });
  }

  // Show text editor
  void _showTextEditor(CreateReelsController controller) {
    Get.bottomSheet(
      TextEditorBottomSheet(controller: controller),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // Show filter bottom sheet
  void _showFilterBottomSheet(CreateReelsController controller) {
    Get.bottomSheet(
      FilterSelectionBottomSheet(controller: controller),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // Show trimming bottom sheet
  void _showTrimmingBottomSheet(CreateReelsController controller) async {
    // CRITICAL: Ensure thumbnails are generated BEFORE opening bottom sheet (no loader shown)
    try {
      debugPrint('🔄 Ensuring thumbnails are generated before opening trimming sheet...');
      await controller.ensureThumbnailsGenerated();
      debugPrint('✅ Thumbnails ready, opening trimming bottom sheet');
    } catch (e) {
      debugPrint('Error ensuring thumbnails: $e');
      // Continue anyway - thumbnails will be generated in background if not ready
    }
    
    Get.bottomSheet(
      VideoTrimmingBottomSheet(controller: controller),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
    );
  }
}
