import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import '../screens/save_reel_screen.dart';
import '../../../../../../utils/library_utils.dart';

class CreateReelsController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final RxInt currentScreen = 0.obs;
  final Rx<File?> selectedMedia = Rx<File?>(null);
  final RxBool isVideo = false.obs;
  final Rx<VideoPlayerController?> videoController = Rx<VideoPlayerController?>(null);
  final RxBool isVideoInitialized = false.obs;
  final RxList<Map<String, dynamic>> galleryMedia = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingGallery = false.obs;
  final RxInt galleryPickerRefreshKey = 0.obs;
  final RxBool isMultipleSelectionMode = false.obs;
  final RxList<int> selectedImageIndices = <int>[].obs;
  final RxList<File> selectedImages = <File>[].obs;
  final RxMap<String, int> selectedImagePositions = <String, int>{}.obs;
  final Rx<File?> selectedVideo = Rx<File?>(null);
  final RxString multiSelectionType = 'none'.obs;
  final RxString selectedMusic = ''.obs;
  final RxString selectedMusicArtist = ''.obs;
  final RxString selectedMusicPath = ''.obs;
  final RxString selectedMusicImgPath = ''.obs;
  final RxBool isMusicPlaying = false.obs;
  final RxBool isNextForTrim = false.obs;
  final RxInt currentlyPlayingIndex = (-1).obs;
  final RxBool isMusicAppliedToVideo = false.obs;
  final RxList<Map<String, dynamic>> addedTexts = <Map<String, dynamic>>[].obs;
  final RxString editingTextId = ''.obs;
  final RxInt selectedFilterIndex = 0.obs;
  final RxInt selectedFilterTab = 0.obs;
  final RxDouble videoStartTime = 0.0.obs;
  final RxDouble videoEndTime = 0.0.obs;
  final RxDouble videoDuration = 0.0.obs;
  final RxDouble musicStartTime = 0.0.obs;
  final RxDouble musicEndTime = 60.0.obs;
  RxInt selectedMusicIndex = (-1).obs;
  final RxString selectedFilterName = 'No effect'.obs;
  final RxInt selectedMusicTab = 0.obs;
  final RxSet<String> savedMusicSet = <String>{}.obs;
  final RxBool isProcessingVideo = false.obs;
  final RxDouble processingProgress = 0.0.obs;
  final Rx<File?> processedVideoFile = Rx<File?>(null);
  Rx<File?> generatedVideo = Rx<File?>(null);
  final Rx<File?> finalizedVideo = Rx<File?>(null);
  final RxBool isMusicSelectionActive = false.obs;
  final RxList<Uint8List?> preloadedThumbnails = <Uint8List?>[].obs;
  final RxBool isLoadingThumbnails = false.obs;
  final RxString thumbnailMediaPath = ''.obs;
  double? lockedAspectRatio;

  final RxList<Map<String, dynamic>> musicList = <Map<String, dynamic>>[
    {
      'name': 'LOVE YOU LESS',
      'artist': 'Paresh Pahuja,Shiv Tandav',
      'reels': '2.4K',
      'duration': '4:34',
      'image': AppImages.img1,
      'audio': AppImages.audio1,
    },
    {
      'name': 'Gehra Hua (From "Dhurandhar")',
      'artist': 'Shashwat Sachdev, Arijit Singh, Irs...',
      'reels': '4.2M',
      'duration': '1:05',
      'image': AppImages.img2,
      'audio': AppImages.audio2,

    },
    {
      'name': 'Dooron Dooron',
      'artist': 'Paresh Pahuja, Shiv Tandan, Megh...',
      'reels': '1.2M',
      'duration': '2:15',
      'image': AppImages.img3,
      'audio': AppImages.audio3,

    },
    {
      'name': 'Mane Tu Mali Gai',
      'artist': 'Jigardan Gadhavi',
      'reels': '2.4K',
      'duration': '4:34',
      'image': AppImages.img4,
      'audio': AppImages.audio4,
    },
  ].obs;

  final List<Map<String, dynamic>> aestheticsFilters = [
    {'name': 'No effect', 'filter': 'none', 'icon': Icons.close,'preview':AppImages.forbiddenIcon,'isIcon':true},
    {'name': 'Vignette', 'filter': 'vignette', 'icon': Icons.blur_circular,'preview':AppImages.testImg},
    {'name': 'Fog', 'filter': 'fog', 'icon': Icons.cloud,'preview':AppImages.testImg},
    {'name': 'Ripple', 'filter': 'ripple', 'icon': Icons.waves,'preview':AppImages.testImg},
    {'name': 'CLOUD', 'filter': 'cloud', 'icon': Icons.cloud_queue,'preview':AppImages.testImg},
    {'name': 'Party Lights', 'filter': 'party_lights', 'icon': Icons.light_mode,'preview':AppImages.testImg},
  ];

  final List<Map<String, dynamic>> specialEffectsFilters = [
    {'name': 'No effect', 'filter': 'none', 'icon': Icons.close,'preview':AppImages.testImg},
    {'name': 'Vintage', 'filter': 'vintage', 'icon': Icons.filter_vintage,'preview':AppImages.testImg},
    {'name': 'Black & White', 'filter': 'bw', 'icon': Icons.filter_b_and_w,'preview':AppImages.testImg},
    {'name': 'Warm', 'filter': 'warm', 'icon': Icons.wb_sunny,'preview':AppImages.testImg},
    {'name': 'Cool', 'filter': 'cool', 'icon': Icons.ac_unit,'preview':AppImages.testImg},
    {'name': 'Bright', 'filter': 'bright', 'icon': Icons.brightness_high,'preview':AppImages.testImg},
    {'name': 'Sepia', 'filter': 'sepia', 'icon': Icons.auto_awesome,'preview':AppImages.testImg},
    {'name': 'Saturate', 'filter': 'saturate', 'icon': Icons.color_lens,'preview':AppImages.testImg},
  ];


  @override
  void onInit() {
    super.onInit();
    _clearAllSelections();
     clearGalleryState();
    _loadGalleryMediaInBackground();
    _setupAudioPlayerListeners();
    reloadGalleryMedia();  }

  void _clearAllSelections() {
    // Clear preloaded thumbnails
    clearPreloadedThumbnails();

    // Clear media selections
    selectedMedia.value = null;
    isVideo.value = false;
    isVideoInitialized.value = false;
    
    // CRITICAL: Clear gallery selections to remove pink selection indicators
    selectedImages.clear();
    selectedImageIndices.clear();
    selectedImagePositions.clear();
    selectedVideo.value = null;
    multiSelectionType.value = 'none';
    isMultipleSelectionMode.value = false;
    
    // CRITICAL: Update refresh key to force GalleryMediaPicker to clear its internal selection state
    galleryPickerRefreshKey.value = DateTime.now().millisecondsSinceEpoch;
    
    // Refresh all reactive lists to update UI
    selectedImages.refresh();
    selectedImageIndices.refresh();
    selectedImagePositions.refresh();
    selectedVideo.refresh();
    
    // Clear video controller
    if (videoController.value != null) {
      try {
        videoController.value!.removeListener(_ensureVideoLooping);
        videoController.value!.dispose();
      } catch (e) {
        debugPrint('Error disposing video controller: $e');
      }
    }
    videoController.value = null;
    
    // Clear processed/generated videos
    processedVideoFile.value = null;
    generatedVideo.value = null;
    finalizedVideo.value = null;
    
    // Clear editing state
    addedTexts.clear();
    editingTextId.value = '';
    selectedFilterIndex.value = 0;
    selectedFilterTab.value = 0;
    selectedFilterName.value = 'No effect';
    
    // Clear music selection
    selectedMusic.value = '';
    selectedMusicArtist.value = '';
    selectedMusicPath.value = '';
    selectedMusicImgPath.value = '';
    selectedMusicIndex.value = -1;
    isMusicPlaying.value = false;
    isMusicAppliedToVideo.value = false;
    musicStartTime.value = 0.0;
    musicEndTime.value = 60.0;
    
    // Clear video trim times
    videoStartTime.value = 0.0;
    videoEndTime.value = 0.0;
    videoDuration.value = 0.0;
    
    // CRITICAL: Clear multiple selection state (images/media selections)
    isMultipleSelectionMode.value = false;
    selectedImageIndices.clear();
    selectedImages.clear();
    selectedImagePositions.clear();
    selectedVideo.value = null;
    multiSelectionType.value = 'none';
    
    // Refresh gallery picker to clear visual selections
    galleryPickerRefreshKey.value++;
    
    // Refresh all reactive lists
    selectedImages.refresh();
    selectedImageIndices.refresh();
    selectedImagePositions.refresh();
    selectedVideo.refresh();
    
    // Reset screen state
    currentScreen.value = 0;
    isMusicSelectionActive.value = false;
    isProcessingVideo.value = false;
    processingProgress.value = 0.0;
    
    // Stop any playing music
    try {
      _audioPlayer.stop();
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
    
    // Force UI update
    update();
    
    debugPrint('✅ All selections cleared when entering create reels screen');
  }

  @override
  void onReady() {
    super.onReady();
    _checkAndReloadMedia();
  }

  @override
  void onClose() {
    if (videoController.value != null) {
      videoController.value!.removeListener(_ensureVideoLooping);
    }
    videoController.value?.dispose();
    _audioPlayer.dispose();

    super.onClose();
  }

  void _setupAudioPlayerListeners() async {
    // Configure audio player for device playback
    try {
      // Use PlayerMode.lowLatency for better Android compatibility
      await _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
      // Set release mode to stop (not loop) for preview
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      // Set volume to maximum
      await _audioPlayer.setVolume(1.0);
      debugPrint('✅ Audio player configured: mode=lowLatency, volume=1.0');
    } catch (e) {
      debugPrint('❌ Error configuring audio player: $e');
    }
    
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      debugPrint('Audio player state changed: $state');
      // CRITICAL: Update state based on actual player state
      if (state == PlayerState.playing) {
        isMusicPlaying.value = true;
        debugPrint('✅ Music is now playing');
      } else if (state == PlayerState.paused) {
        isMusicPlaying.value = false;
        debugPrint('⏸️ Music is paused');
      } else if (state == PlayerState.stopped) {
        isMusicPlaying.value = false;
        debugPrint('⏹️ Music is stopped');
      } else if (state == PlayerState.completed) {
        isMusicPlaying.value = false;
        debugPrint('✅ Music playback completed');
      }
      // Force UI update to reflect actual state
      update();
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      debugPrint('Audio playback completed');
      isMusicPlaying.value = false;
      currentlyPlayingIndex.value = -1;
      update();
    });
  }

  void _loadGalleryMediaInBackground() async {
    // Set loading state to show loading indicator
    isLoadingGallery.value = true;
    clearGalleryState();
    try {
      // Check permission without blocking
      PermissionState? ps;
      try {
        ps = await PhotoManager.requestPermissionExtend();
      } catch (e) {
        debugPrint('PhotoManager permission check failed (non-critical): $e');
        isLoadingGallery.value = false;
        return; // GalleryMediaPicker will handle permissions
      }

      if (!ps.isAuth) {
        // Permission not granted - GalleryMediaPicker will request it
        isLoadingGallery.value = false;
        return;
      }

      // Permission granted - load media in background
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.all, // images + videos
        onlyAll: true,
      );

      if (albums.isEmpty) {
        debugPrint('No albums found');
        isLoadingGallery.value = false;
        return;
      }

      final List<AssetEntity> media = await albums.first.getAssetListPaged(
        page: 0,
        size: 100,
      );

      if (media.isEmpty) {
        debugPrint('No media found');
        isLoadingGallery.value = false;
        galleryMedia.clear(); // Ensure list is empty
        return;
      }

      final List<Map<String, dynamic>> temp = [];

      for (final asset in media) {
        try {
        final thumb = await asset.thumbnailDataWithSize(
          const ThumbnailSize(200, 200),
        );

        if (thumb == null) continue;

        temp.add({
          'asset': asset,
          'type': asset.type == AssetType.video ? 'video' : 'image',
          'duration': asset.type == AssetType.video
              ? _formatDuration(asset.videoDuration)
              : null,
          'thumbnail': thumb,
        });
        } catch (e) {
          debugPrint('Error loading thumbnail: $e');
          continue;
        }
      }

      galleryMedia.assignAll(temp);
      isLoadingGallery.value = false;
    } catch (e) {
      debugPrint('Error loading gallery media in background: $e');
      isLoadingGallery.value = false;
    }
  }

  Future<void> _checkAndReloadMedia() async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      PermissionState? ps;
      try {
        ps = await PhotoManager.requestPermissionExtend();
    } catch (e) {
        debugPrint('Permission check failed: $e');
        return;
      }
      if (ps.isAuth) {
         _loadGalleryMediaInBackground();
        galleryPickerRefreshKey.value++;
      }
    } catch (e) {
      debugPrint('Error checking and reloading media: $e');
    }
  }
  Future<void> resumeMusic() async {
    try {
      if (selectedMusicPath.value.isEmpty) {
        debugPrint('❌ No music selected to resume');
        return;
      }
      PlayerState? currentState;
      try {
        currentState = _audioPlayer.state;
      } catch (e) {
        debugPrint('Error getting player state (non-critical): $e');
        currentState = PlayerState.stopped;
      }
      
      if (currentState == PlayerState.paused) {
        await _audioPlayer.resume();
        await _audioPlayer.setVolume(1.0);
        isMusicPlaying.value = true;
        debugPrint('✅ Music resumed from paused state');
      } else if (currentState == PlayerState.stopped || currentState == PlayerState.completed) {
        final audioPathForPlayer = selectedMusicPath.value.replaceFirst('assets/', '');
        await _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
        await _audioPlayer.setReleaseMode(ReleaseMode.stop);
        await _audioPlayer.setVolume(1.0);
        await Future.delayed(Duration(milliseconds: 100));
        await _audioPlayer.play(AssetSource(audioPathForPlayer), volume: 1.0);
        await Future.delayed(Duration(milliseconds: 300));
        try {
          isMusicPlaying.value = _audioPlayer.state == PlayerState.playing;
        } catch (e) {
          debugPrint('Error checking player state after play: $e');
          isMusicPlaying.value = false;
        }
        debugPrint('✅ Music restarted from stopped state');
      } else if (currentState == PlayerState.playing) {
        debugPrint('Music is already playing');
        isMusicPlaying.value = true;
      }
    } catch (e) {
      debugPrint('❌ Error resuming music: $e');
      isMusicPlaying.value = false;
    }
  }
  Future<void> reloadGalleryMedia() async {
    await _checkAndReloadMedia();
  }

  bool _isVideoFile(String path) {
    final lowerPath = path.toLowerCase();
    return lowerPath.endsWith('.mp4') ||
        lowerPath.endsWith('.mov') ||
        lowerPath.endsWith('.avi') ||
        lowerPath.endsWith('.mkv');
  }

  Future<void> handleSelectedMediaFromPicker(List<PickedAssetModel> mediaList) async {
    try {
      if (isMultipleSelectionMode.value) {
        if (mediaList.isEmpty) {
          selectedImages.clear();
          selectedImageIndices.clear();
          selectedImagePositions.clear();
          selectedVideo.value = null;
          multiSelectionType.value = 'none';
          selectedImages.refresh();
          selectedVideo.refresh();
          selectedImagePositions.refresh();
          update();
          return;
        }
        bool hasVideo = false;
        bool hasImage = false;
        
        for (final mediaFile in mediaList) {
          final path = mediaFile.path.toLowerCase();
          if (_isVideoFile(path)) {
            hasVideo = true;
          } else {
            hasImage = true;
          }
        }

        if (hasVideo && hasImage) {
          return;
        }

        final Set<String> currentSelectedPaths = selectedImages.map((f) => f.path).toSet();
        if (selectedVideo.value != null) {
          currentSelectedPaths.add(selectedVideo.value!.path);
        }
        final Set<String> newSelectedPaths = <String>{};
        for (final mediaFile in mediaList) {
          try {
          final file = File(mediaFile.path);
          if (await file.exists()) {
              newSelectedPaths.add(file.path);
            }
          } catch (e) {
            debugPrint('Error checking file existence: $e');
          }
        }
        final itemsToRemove = currentSelectedPaths.difference(newSelectedPaths);
        
        final itemsToAdd = newSelectedPaths.difference(currentSelectedPaths);
        for (final pathToRemove in itemsToRemove) {
          if (selectedVideo.value != null && selectedVideo.value!.path == pathToRemove) {
            selectedVideo.value = null;
            multiSelectionType.value = 'none';
          } else {
            selectedImages.removeWhere((f) => f.path == pathToRemove);
            selectedImagePositions.remove(pathToRemove);
            for (int i = 0; i < galleryMedia.length; i++) {
              try {
                final media = galleryMedia[i];
                if (media['type'] == 'video') continue;
                final asset = media['asset'] as AssetEntity;
                final file = await asset.file;
                if (file != null && file.path == pathToRemove) {
                  selectedImageIndices.remove(i);
                  break;
                }
              } catch (e) {
                debugPrint('Error checking gallery media: $e');
              }
            }
          }
        }
        for (final mediaFile in mediaList) {
          try {
            final file = File(mediaFile.path);
            if (!await file.exists()) continue;
            if (itemsToAdd.contains(file.path)) {
              final path = mediaFile.path.toLowerCase();
              final isVideo = _isVideoFile(path);
              if (isVideo) {
                if (multiSelectionType.value == 'images' || selectedImages.isNotEmpty) {
                  ShowToast.show(
                    message: 'Cannot select video. Images are already selected. Please clear images first.',
                    type: ToastType.error,
                  );
                  continue;
                }
                if (selectedVideo.value != null && selectedVideo.value!.path != file.path) {
                  ShowToast.show(
                    message: 'Only one video can be selected. Please deselect the current video first.',
                    type: ToastType.error,
                  );
                  continue; // Skip this video
                }
                selectedImages.clear();
                selectedImageIndices.clear();
                selectedImagePositions.clear();
                selectedVideo.value = file;
                multiSelectionType.value = 'video';
              } else {
                if (multiSelectionType.value == 'video' || selectedVideo.value != null) {
                  ShowToast.show(
                    message: 'Cannot select images. A video is already selected. Please deselect video first.',
                    type: ToastType.error,
                  );
                  continue; // Skip this image
                }
                if (!selectedImages.any((f) => f.path == file.path)) {
              selectedImages.add(file);
                  selectedImagePositions[file.path] = selectedImages.length;
                  multiSelectionType.value = 'images';
                  for (int i = 0; i < galleryMedia.length; i++) {
                    try {
                      final media = galleryMedia[i];
                      if (media['type'] == 'video') continue;
                      final asset = media['asset'] as AssetEntity;
                      final assetFile = await asset.file;
                      if (assetFile != null && assetFile.path == file.path) {
                        if (!selectedImageIndices.contains(i)) {
                          selectedImageIndices.add(i);
                        }
                        break;
                      }
                    } catch (e) {
                      debugPrint('Error checking gallery media: $e');
                    }
                  }
                }
              }
            }
          } catch (e) {
            debugPrint('Error processing media file ${mediaFile.path}: $e');
            continue;
          }
        }

        // Recalculate positions after all changes
        if (selectedImages.isNotEmpty) {
          _recalculateImagePositions();
        }

        // Update selection type if no items left
        if (selectedImages.isEmpty && selectedVideo.value == null) {
          multiSelectionType.value = 'none';
        }

        // Refresh UI
        selectedImages.refresh();
        selectedVideo.refresh();
        selectedImageIndices.refresh();
        selectedImagePositions.refresh();
        update();
        if (selectedVideo.value != null) {
          // ShowToast.show(
          //   message: '1 video selected',
          //   type: ToastType.success,
          // );
        } else if (selectedImages.isNotEmpty) {
          // ShowToast.show(
          //   message: '${selectedImages.length} image(s) selected',
          //   type: ToastType.success,
          // );
        }
      } else {
          final mediaFile = mediaList.first;
        try {
          final file = File(mediaFile.path);
          if (await file.exists()) {
            selectedMedia.value = file;
            final isVideoFile = _isVideoFile(mediaFile.path);
            
            if (isVideoFile) {
              isVideo.value = true;
              await _initializeVideo(file);
              selectedImages.clear();
              selectedImageIndices.clear();
              selectedImagePositions.clear();
              selectedVideo.value = null;
              multiSelectionType.value = 'none';
              galleryPickerRefreshKey.value++;
              selectedImages.refresh();
              selectedImageIndices.refresh();
              selectedImagePositions.refresh();
              selectedVideo.refresh();
              currentScreen.value = 1;
            } else {isVideo.value = false;
              isProcessingVideo.value = true;
              
              // Show processing indicator
              // ShowToast.show(
              //   message: 'Creating video from image...',
              //   type: ToastType.info,
              // );
            await _convertSingleImageToVideo(file);
              
              selectedImages.clear();
              selectedImageIndices.clear();
              selectedImagePositions.clear();
              selectedVideo.value = null;
              multiSelectionType.value = 'none';
              galleryPickerRefreshKey.value++;
              selectedImages.refresh();
              selectedImageIndices.refresh();
              selectedImagePositions.refresh();
              selectedVideo.refresh();
              currentScreen.value = 1;
          }
            
            debugPrint('Selected media: ${file.path}, isVideo: $isVideoFile');
          } else {
            // ShowToast.error('Selected file does not exist');
          }
        } catch (e) {
          debugPrint('Error processing selected media: $e');
          // ShowToast.error('Failed to process selected media: ${e.toString()}');
          isProcessingVideo.value = false;
        }
      }
    } catch (e) {
      debugPrint('Error handling selected media: $e');
      ShowToast.error('Failed to process selected media: ${e.toString()}');
    }
  }
  void toggleMultipleSelectionMode() {
    isMultipleSelectionMode.value = !isMultipleSelectionMode.value;
    if (!isMultipleSelectionMode.value) {
      selectedImageIndices.clear();
      selectedImages.clear();
      selectedImagePositions.clear();
      selectedVideo.value = null;
      multiSelectionType.value = 'none';
    }
  }

  Future<void> toggleImageSelection(int index) async {
    if (!isMultipleSelectionMode.value) {
      isMultipleSelectionMode.value = true;
    }

    final media = galleryMedia[index];
    if (media['type'] == 'video') {
      return;
    }

    if (selectedImageIndices.contains(index)) {
      selectedImageIndices.remove(index);
      final asset = media['asset'] as AssetEntity;
      final file = await asset.file;
      if (file != null) {
        final removedPath = file.path;
        selectedImages.removeWhere((f) => f.path == removedPath);
        selectedImagePositions.remove(removedPath);
        _recalculateImagePositions();
      }
    } else {
      selectedImageIndices.add(index);
      final asset = media['asset'] as AssetEntity;
      final file = await asset.file;
      if (file != null) {
        selectedImages.add(File(file.path));
        selectedImagePositions[file.path] = selectedImages.length;
      }
    }
    selectedImageIndices.refresh();
    selectedImages.refresh();
    selectedImagePositions.refresh();
    update();
  }

  void _recalculateImagePositions() {
    selectedImagePositions.clear();
    for (int i = 0; i < selectedImages.length; i++) {
      selectedImagePositions[selectedImages[i].path] = i + 1; // 1-based index
    }
  }

  Future<void> removeImageFromSelection(File imageFile) async {
    final imageIndex = selectedImages.indexWhere((f) => f.path == imageFile.path);
    if (imageIndex == -1) return;
    int? galleryIndex;
    for (int i = 0; i < galleryMedia.length; i++) {
      final media = galleryMedia[i];
      if (media['type'] == 'video') continue;
      
      try {
      final asset = media['asset'] as AssetEntity;
      final file = await asset.file;
      if (file != null && file.path == imageFile.path) {
        galleryIndex = i;
        break;
        }
      } catch (e) {
        debugPrint('Error checking gallery media: $e');
        continue;
      }
    }

    selectedImages.removeAt(imageIndex);
    selectedImagePositions.remove(imageFile.path);
    _recalculateImagePositions();
    
    if (galleryIndex != null) {
      selectedImageIndices.remove(galleryIndex);
    }

    if (selectedImages.isEmpty) {
      multiSelectionType.value = 'none';
    }

    galleryPickerRefreshKey.value++;
    
    selectedImages.refresh();
    selectedImageIndices.refresh();
    selectedImagePositions.refresh();
    update();
  }

  void removeVideoFromSelection() {
    selectedVideo.value = null;
    multiSelectionType.value = 'none';
    galleryPickerRefreshKey.value++;
    selectedVideo.refresh();
    update();
  }

  Future<void> handleSelectedVideoInMultiMode() async {
    if (selectedVideo.value == null) {
      return;
    }

    try {
      final videoFile = selectedVideo.value!;
      selectedMedia.value = videoFile;
      isVideo.value = true;
      
      await _initializeVideo(videoFile);
      
      selectedVideo.value = null;
      selectedImages.clear();
      selectedImageIndices.clear();
      selectedImagePositions.clear();
      multiSelectionType.value = 'none';
      isMultipleSelectionMode.value = false;
      galleryPickerRefreshKey.value++;
      selectedImages.refresh();
      selectedImageIndices.refresh();
      selectedImagePositions.refresh();
      selectedVideo.refresh();
      
      currentScreen.value = 1;
      
      debugPrint('Selected video in multi-mode: ${videoFile.path}');
    } catch (e) {
      debugPrint('Error handling selected video: $e');
    }
  }

  Future<void> generateVideoFromMultipleImages() async {
    if (selectedImages.isEmpty) {
      // ShowToast.error('Please select at least one image');
      return;
    }

    isProcessingVideo.value = true;
    processingProgress.value = 0.0;

    try {
      final tempDir = await getTemporaryDirectory();
      final outputPath = '${tempDir.path}/slideshow_video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      
      const double durationPerImage = 2.0;

      List<File> tempImages = [];
      for (int i = 0; i < selectedImages.length; i++) {
        final tempImage = await selectedImages[i].copy('${tempDir.path}/img_$i.jpg');
        tempImages.add(tempImage);
      }

      processingProgress.value = 0.2;

      List<File> segmentFiles = [];
      for (int i = 0; i < tempImages.length; i++) {
        final segmentPath = '${tempDir.path}/segment_$i.mp4';

        final segmentCommand = '-y '
            '-loop 1 '
            '-framerate 30 '
            '-i "${tempImages[i].path}" '
            '-f lavfi '
            '-i "anullsrc=channel_layout=stereo:sample_rate=44100" '
            '-vf "scale=720:1280:force_original_aspect_ratio=decrease,'
            'pad=720:1280:(ow-iw)/2:(oh-ih)/2,format=yuv420p" '
            '-t $durationPerImage '
            '-c:v libx264 '
            '-preset veryfast '
            '-crf 23 '
            '-pix_fmt yuv420p '
            '-profile:v main '
            '-level 3.1 '
            '-c:a aac '
            '-b:a 128k '
            '-ar 44100 '
            '-ac 2 '
            '-movflags +faststart '
            '"$segmentPath"';


        debugPrint('Creating segment $i: $segmentCommand');
        
        final segmentSession = await FFmpegKit.execute(segmentCommand);
        final segmentReturnCode = await segmentSession.getReturnCode();
        
        if (!ReturnCode.isSuccess(segmentReturnCode)) {
          final output = await segmentSession.getOutput();
          throw Exception('Failed to create segment $i: $output');
        }
        
        final segmentFile = File(segmentPath);
        if (await segmentFile.exists()) {
          segmentFiles.add(segmentFile);
        } else {
          throw Exception('Segment file $i not created');
        }
        
        processingProgress.value = 0.2 + (0.5 * (i + 1) / tempImages.length);
      }
      final concatListPath = '${tempDir.path}/concat_list_${DateTime.now().millisecondsSinceEpoch}.txt';
      final concatListFile = File(concatListPath);
      final concatListContent = segmentFiles.map((f) {
        final absPath = f.absolute.path.replaceAll("'", "'\\''");
        return "file '$absPath'";
      }).join('\n');
      await concatListFile.writeAsString(concatListContent);
      
      debugPrint('Concat list content:\n$concatListContent');
      
      processingProgress.value = 0.7;
      
      // Concatenate segments
      final concatCommand = '-y '
          '-f concat '
          '-safe 0 '
          '-i "$concatListPath" '
          '-c:v libx264 '
          '-profile:v main '
          '-level 3.1 '
          '-pix_fmt yuv420p '
          '-c:a aac '
          '-b:a 128k '
          '-movflags +faststart '
          '"$outputPath"';
      
      debugPrint('Concatenating segments: $concatCommand');
      
      final command = concatCommand;

      debugPrint('Generating slideshow video from ${selectedImages.length} images');

      processingProgress.value = 0.8;

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        final videoFile = File(outputPath);
        if (await videoFile.exists()) {
          for (final segmentFile in segmentFiles) {
            try {
              if (await segmentFile.exists()) {
                await segmentFile.delete();
              }
            } catch (e) {
              debugPrint('Error deleting segment file: $e');
            }
          }
          try {
            if (await concatListFile.exists()) {
              await concatListFile.delete();
            }
          } catch (e) {
            debugPrint('Error deleting concat list file: $e');
          }
          generatedVideo.value = videoFile;
          selectedMedia.value = videoFile;
          isVideo.value = true;
          processedVideoFile.value = null;
          await _initializeVideo(videoFile);
          await Future.delayed(Duration(milliseconds: 800));
          if (videoController.value != null && videoController.value!.value.isInitialized) {
            final duration = videoController.value!.value.duration;
            if (duration.inMilliseconds > 0) {
              videoDuration.value = duration.inMilliseconds / 1000.0;
              videoStartTime.value = 0.0;
              videoEndTime.value = videoDuration.value;
            }
            lockedAspectRatio = videoController.value!.value.aspectRatio;

          }
          isMultipleSelectionMode.value = false;
          selectedImageIndices.clear();
          selectedImages.clear();
          selectedImagePositions.clear();
          selectedVideo.value = null;
          multiSelectionType.value = 'none';
          galleryPickerRefreshKey.value++;
          selectedImages.refresh();
          selectedImageIndices.refresh();
          selectedImagePositions.refresh();
          selectedVideo.refresh();
          update();
          currentScreen.value = 1;
          update();
          await Future.delayed(Duration(milliseconds: 800));
          if (selectedMusicPath.value.isNotEmpty && !isMusicAppliedToVideo.value) {
            debugPrint('Music was selected before video creation, playing now...');
            debugPrint('Selected music path: ${selectedMusicPath.value}');
            debugPrint('Video initialized: ${videoController.value?.value.isInitialized}');
            debugPrint('Selected music index: ${selectedMusicIndex.value}');
            
            try {
              final musicIndex = selectedMusicIndex.value >= 0
                  ? selectedMusicIndex.value 
                  : musicList.indexWhere(
                      (m) => m['audio'] == selectedMusicPath.value,
                    );
              
              if (musicIndex >= 0 && musicIndex < musicList.length) {
                final music = musicList[musicIndex];
                debugPrint('Found music in list, index: $musicIndex, name: ${music['name']}');
                if (videoController.value != null && videoController.value!.value.isInitialized) {
                  await videoController.value!.setVolume(0.0);
                  await videoController.value!.pause();
                  try {
                    final currentPosition = videoController.value!.value.position;
                    await videoController.value!.seekTo(currentPosition);
                  } catch (e) {
                    debugPrint('Warning: Could not seek video: $e');
                  }
                  await Future.delayed(Duration(milliseconds: 500));
                }
                await selectMusic(music, musicIndex);
                
                debugPrint('Music playback initiated, isPlaying: ${isMusicPlaying.value}');
              } else {
                debugPrint('Music not found in list, trying direct play...');
                if (videoController.value != null && videoController.value!.value.isInitialized) {
                  await videoController.value!.pause();
                  try {
                    final currentPosition = videoController.value!.value.position;
                    await videoController.value!.seekTo(currentPosition);
                  } catch (e) {
                    debugPrint('Warning: Could not seek video: $e');
                  }
                  await videoController.value!.setVolume(0.0);
                  await Future.delayed(Duration(milliseconds: 400));
                }
                
                await _audioPlayer.stop();
                await Future.delayed(Duration(milliseconds: 300));
                try {
                  await _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
                  await _audioPlayer.setVolume(1.0);
                  await _audioPlayer.setReleaseMode(ReleaseMode.stop);
                  await Future.delayed(Duration(milliseconds: 100));
                } catch (e) {
                  debugPrint('Error configuring audio player: $e');
                }
                
                final audioPathForPlayer = selectedMusicPath.value.replaceFirst('assets/', '');
                await _audioPlayer.play(
                  AssetSource(audioPathForPlayer),
                  volume: 1.0,
                );
                await Future.delayed(Duration(milliseconds: 600));
                isMusicPlaying.value = _audioPlayer.state == PlayerState.playing;
                debugPrint('Direct play result: isPlaying=${isMusicPlaying.value}, state=${_audioPlayer.state}');
              }
              update();
            } catch (e) {
              debugPrint('Error playing music after video creation: $e');
            }
          } else {
            debugPrint('No music selected or music already applied to video');
            debugPrint('selectedMusicPath: ${selectedMusicPath.value}');
            debugPrint('isMusicAppliedToVideo: ${isMusicAppliedToVideo.value}');
          }
          isMultipleSelectionMode.value = false;
          selectedImageIndices.clear();
          selectedImages.clear();
          selectedImagePositions.clear();
          selectedVideo.value = null;
          multiSelectionType.value = 'none';
          galleryPickerRefreshKey.value++;
          selectedImages.refresh();
          selectedImageIndices.refresh();
          selectedImagePositions.refresh();
          selectedVideo.refresh();
          update();
          currentScreen.value = 1;

          processingProgress.value = 1.0;
        } else {
          throw Exception('Video file not created');
        }
      } else {
        final output = await session.getOutput();
        final failureStackTrace = await session.getFailStackTrace();
        debugPrint('FFmpeg slideshow error: $output');
        debugPrint('FFmpeg failure stack trace: $failureStackTrace');
        throw Exception('FFmpeg failed to create slideshow: ${output ?? failureStackTrace ?? "Unknown error"}');
      }
    } catch (e) {
      debugPrint('Error generating slideshow video: $e');
    } finally {
      isProcessingVideo.value = false;
      processingProgress.value = 0.0;
      update();
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
  Future<void> openCamera({bool isVideo = true}) async {
    try {
      if (isVideo) {
        final XFile? video = await _picker.pickVideo(
          source: ImageSource.camera,
          maxDuration: Duration(seconds: 60),
        );
        if (video != null) {
          selectedMedia.value = File(video.path);
          this.isVideo.value = true;
          await _initializeVideo(selectedMedia.value!);
          currentScreen.value = 1; // Move to editing screen
        }
      } else {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 90,
        );
        if (image != null) {
          final imageFile = File(image.path);
          selectedMedia.value = imageFile;
          isVideo = false;
          isProcessingVideo.value = true;
          
          // ShowToast.show(
          //   message: 'Creating video from image...',
          //   type: ToastType.info,
          // );
          
          await _convertSingleImageToVideo(imageFile);
          selectedImages.clear();
          selectedImageIndices.clear();
          selectedImagePositions.clear();
          selectedVideo.value = null;
          multiSelectionType.value = 'none';
          galleryPickerRefreshKey.value++;
          selectedImages.refresh();
          selectedImageIndices.refresh();
          selectedImagePositions.refresh();
          selectedVideo.refresh();
          currentScreen.value = 1;
        }
        debugPrint('Camera image selected: ${selectedMedia.value?.path}');
      }
    } catch (e) {
      debugPrint('e: ${e.toString()}');

    }
  }


  // Initialize video player
  // Public method to reinitialize video (for trimming)
  Future<void> reinitializeVideo(File videoFile) async {
    await _initializeVideo(videoFile);

  }
  
  Future<void> _initializeVideo(File videoFile) async {
    try {
      // CRITICAL: Dispose old controller completely before creating new one
      if (videoController.value != null) {
        try {
          // Remove listener first
          videoController.value!.removeListener(_ensureVideoLooping);
          // Pause and stop playback
          if (videoController.value!.value.isInitialized) {
            await videoController.value!.pause();
          }
          // Dispose the controller
          await videoController.value!.dispose();
          // Wait for disposal to complete
          await Future.delayed(Duration(milliseconds: 200));
        } catch (e) {
          debugPrint('Error disposing old video controller: $e');
        }
      }
      
      // CRITICAL: Reset state BEFORE creating new controller
      videoController.value = null;
      isVideoInitialized.value = false;
      
      // Force UI update to clear old video player and prevent rendering
      update();
      await Future.delayed(Duration(milliseconds: 300)); // Increased delay for proper cleanup
      
      // Use processed video if available, otherwise use provided videoFile
      final File videoToPlay = processedVideoFile.value ?? videoFile;
      
      debugPrint('Initializing video: ${videoToPlay.path}');
      debugPrint('Video file exists: ${await videoToPlay.exists()}');
      
      // Create new controller
      videoController.value = VideoPlayerController.file(videoToPlay);
      
      // Initialize the controller
      await videoController.value!.initialize();
      lockedAspectRatio = videoController.value!.value.aspectRatio;

      // Wait for initialization to complete and native player to be ready
      await Future.delayed(Duration(milliseconds: 300));
      
      // Verify initialization
      if (videoController.value == null || !videoController.value!.value.isInitialized) {
        throw Exception('Video controller failed to initialize');
      }
      
      // Set initialized flag AFTER verification
      isVideoInitialized.value = true;
      
      // Update video duration
      final duration = videoController.value!.value.duration;
      if (duration.inMilliseconds > 0) {
        videoDuration.value = duration.inMilliseconds / 1000.0;
        videoEndTime.value = videoDuration.value;
        videoStartTime.value = 0.0;
        debugPrint('Video duration: ${videoDuration.value}s');
      }
      
      // Set video to loop continuously
      // Note: Rotation metadata is removed during FFmpeg processing to prevent auto-rotation
      videoController.value!.setLooping(true);
      
      // Ensure video restarts when it ends (backup for looping)
      videoController.value!.addListener(_ensureVideoLooping);
      
      // Seek to start position
      await videoController.value!.seekTo(Duration.zero);
      
      // Play video automatically and continuously
      await videoController.value!.play();
      
      // Wait a bit to ensure playback started
      await Future.delayed(Duration(milliseconds: 200));
      
      // Verify video is playing
      if (!videoController.value!.value.isPlaying) {
        debugPrint('Video not playing after play() call, retrying...');
        await videoController.value!.play();
        await Future.delayed(Duration(milliseconds: 200));
      }
      
      // Final verification - if still not playing, try one more time
      if (!videoController.value!.value.isPlaying) {
        debugPrint('Video still not playing, final retry...');
        await videoController.value!.seekTo(Duration.zero);
        await videoController.value!.play();
        await Future.delayed(Duration(milliseconds: 300));
      }
      
      // Update UI multiple times to ensure refresh
      update();
      await Future.delayed(Duration(milliseconds: 100));
      update();
      
      debugPrint('Video initialized successfully: duration=${videoDuration.value}s, isPlaying=${videoController.value!.value.isPlaying}, isInitialized=${videoController.value!.value.isInitialized}');
      
      // CRITICAL: Preload thumbnails in background after video initialization
      _preloadThumbnailsInBackground(videoFile);
    } catch (e) {
      isVideoInitialized.value = false;
      videoController.value = null;
      // ShowToast.error('Failed to initialize video: ${e.toString()}');
      debugPrint('Video initialization error: $e');
      rethrow;
    }
  }
  
  // Preload thumbnails in background for video trimming (non-blocking)
  Future<void> _preloadThumbnailsInBackground(File? mediaFile) async {
    if (mediaFile == null) {
      preloadedThumbnails.clear();
      thumbnailMediaPath.value = '';
      return;
    }
    
    // Skip if thumbnails already loaded for this media
    if (thumbnailMediaPath.value == mediaFile.path && preloadedThumbnails.isNotEmpty) {
      debugPrint('✅ Thumbnails already preloaded for: ${mediaFile.path}');
      return;
    }
    
    // Don't preload if not a video
    if (!isVideo.value) {
      // For images, use the image itself as thumbnails
      try {
        final imageBytes = await mediaFile.readAsBytes();
        final thumbnails = List<Uint8List?>.filled(10, imageBytes);
        preloadedThumbnails.value = thumbnails;
        thumbnailMediaPath.value = mediaFile.path;
        isLoadingThumbnails.value = false;
        debugPrint('✅ Image thumbnails preloaded');
        return;
      } catch (e) {
        debugPrint('Error preloading image thumbnails: $e');
        preloadedThumbnails.clear();
        isLoadingThumbnails.value = false;
        return;
      }
    }
    
    // CRITICAL: Start loading thumbnails immediately (not in microtask for faster start)
    isLoadingThumbnails.value = true;
    thumbnailMediaPath.value = mediaFile.path;
    
    // Run in background without blocking UI
    Future.microtask(() async {
      try {
        final thumbnails = <Uint8List?>[];
        final thumbnailCount = 10;
        
        // CRITICAL: Get actual video duration from controller if available
        double maxDuration = 10.0; // Default fallback
        if (videoController.value != null && 
            videoController.value!.value.isInitialized) {
          final duration = videoController.value!.value.duration;
          if (duration.inMilliseconds > 0) {
            maxDuration = duration.inMilliseconds / 1000.0;
          }
        } else if (videoDuration.value > 0) {
          maxDuration = videoDuration.value;
        }
        
        debugPrint('🔄 Preloading $thumbnailCount thumbnails in background for: ${mediaFile.path}, duration: ${maxDuration}s');
        
        for (int i = 0; i < thumbnailCount; i++) {
          try {
            final timeMs = ((maxDuration / thumbnailCount) * i * 1000).toInt();
            final clampedTimeMs = timeMs.clamp(0, (maxDuration * 1000).toInt());
            
            final thumbnailData = await VideoThumbnail.thumbnailData(
              video: mediaFile.path,
              imageFormat: ImageFormat.JPEG,
              timeMs: clampedTimeMs,
              quality: 25, // Further reduced for faster generation
              maxWidth: 150, // Further reduced for faster processing
              maxHeight: 150, // Further reduced for faster processing
            );
            
            thumbnails.add(thumbnailData);
            debugPrint('✅ Generated thumbnail $i/$thumbnailCount at ${clampedTimeMs}ms');
          } catch (e) {
            debugPrint('Error generating video thumbnail $i: $e');
            thumbnails.add(null);
          }
        }
        if (thumbnailMediaPath.value == mediaFile.path) {
          preloadedThumbnails.value = thumbnails;
          isLoadingThumbnails.value = false;
          final successCount = thumbnails.where((t) => t != null).length;
          debugPrint('✅ $successCount/$thumbnailCount thumbnails preloaded successfully');
          
          // Force UI update
          update();
        }
      } catch (e) {
        debugPrint('Error preloading thumbnails: $e');
        if (thumbnailMediaPath.value == mediaFile.path) {
          preloadedThumbnails.clear();
          isLoadingThumbnails.value = false;
          update();
        }
      }
    });
  }
  
  // CRITICAL: Public method to ensure thumbnails are generated (called before opening trimming sheet)
  Future<void> ensureThumbnailsGenerated() async {
    final mediaFile = processedVideoFile.value ?? 
                     generatedVideo.value ?? 
                     selectedMedia.value;
    
    if (mediaFile == null) {
      debugPrint('⚠️ No media file available for thumbnail generation');
      return;
    }
    
    // Check if thumbnails are already generated for this media
    if (thumbnailMediaPath.value == mediaFile.path && 
        preloadedThumbnails.isNotEmpty) {
      debugPrint('✅ Thumbnails already generated for: ${mediaFile.path}');
      return;
    }
    
    // If thumbnails are currently loading, wait for them
    if (isLoadingThumbnails.value && 
        thumbnailMediaPath.value == mediaFile.path) {
      debugPrint('⏳ Thumbnails are loading, waiting...');
      // Wait up to 5 seconds for loading to complete
      for (int i = 0; i < 50; i++) {
        await Future.delayed(Duration(milliseconds: 100));
        if (preloadedThumbnails.isNotEmpty && 
            thumbnailMediaPath.value == mediaFile.path) {
          debugPrint('✅ Thumbnails ready after wait');
          return;
        }
        // If loading stopped but no thumbnails, break and generate
        if (!isLoadingThumbnails.value && preloadedThumbnails.isEmpty) {
          break;
        }
      }
    }
    
    // If no thumbnails available, generate them now (synchronously)
    if (preloadedThumbnails.isEmpty || 
        thumbnailMediaPath.value != mediaFile.path) {
      debugPrint('🔄 Generating thumbnails synchronously before opening trimming sheet...');
      await _generateThumbnailsSynchronously(mediaFile);
    }
  }
  
  // CRITICAL: Generate thumbnails synchronously (blocking) - called before opening bottom sheet
  Future<void> _generateThumbnailsSynchronously(File mediaFile) async {
    try {
      isLoadingThumbnails.value = true;
      thumbnailMediaPath.value = mediaFile.path;
      
      final thumbnails = <Uint8List?>[];
      final thumbnailCount = 10;
      
      // Get actual video duration
      double maxDuration = 10.0;
      if (videoController.value != null && 
          videoController.value!.value.isInitialized) {
        final duration = videoController.value!.value.duration;
        if (duration.inMilliseconds > 0) {
          maxDuration = duration.inMilliseconds / 1000.0;
        }
      } else if (videoDuration.value > 0) {
        maxDuration = videoDuration.value;
      }
      
      debugPrint('🔄 Generating $thumbnailCount thumbnails synchronously, duration: ${maxDuration}s');
      
      // Generate thumbnails sequentially
      for (int i = 0; i < thumbnailCount; i++) {
        try {
          final timeMs = ((maxDuration / thumbnailCount) * i * 1000).toInt();
          final clampedTimeMs = timeMs.clamp(0, (maxDuration * 1000).toInt());
          
          final thumbnailData = await VideoThumbnail.thumbnailData(
            video: mediaFile.path,
            imageFormat: ImageFormat.JPEG,
            timeMs: clampedTimeMs,
            quality: 25,
            maxWidth: 150,
            maxHeight: 150,
          );
          
          thumbnails.add(thumbnailData);
          debugPrint('✅ Generated thumbnail $i/$thumbnailCount');
        } catch (e) {
          debugPrint('Error generating thumbnail $i: $e');
          thumbnails.add(null);
        }
      }
      
      // Update thumbnails
      preloadedThumbnails.value = thumbnails;
      isLoadingThumbnails.value = false;
      final successCount = thumbnails.where((t) => t != null).length;
      debugPrint('✅ $successCount/$thumbnailCount thumbnails generated synchronously');
      
      update();
    } catch (e) {
      debugPrint('Error generating thumbnails synchronously: $e');
      preloadedThumbnails.clear();
      isLoadingThumbnails.value = false;
      update();
    }
  }
  
  // Clear preloaded thumbnails (call when media changes)
  void clearPreloadedThumbnails() {
    preloadedThumbnails.clear();
    thumbnailMediaPath.value = '';
    isLoadingThumbnails.value = false;
  }
  
  // Ensure video loops continuously
  // CRITICAL: Don't auto-play if music selection is active
  void _ensureVideoLooping() {
    if (videoController.value != null && !isMusicSelectionActive.value) {
      final position = videoController.value!.value.position;
      final duration = videoController.value!.value.duration;
      
      // If video reached the end, restart it (backup for setLooping)
      if (duration.inMilliseconds > 0 && 
          position.inMilliseconds >= duration.inMilliseconds - 100) {
        videoController.value!.seekTo(Duration.zero);
        if (!isMusicSelectionActive.value) {
        videoController.value!.play();
        }
      }
      
      // Ensure video is always playing (unless processing or music selection active)
      if (!isProcessingVideo.value && 
          !isMusicSelectionActive.value &&
          !videoController.value!.value.isPlaying &&
          videoController.value!.value.isInitialized) {
        videoController.value!.play();
      }
    }
  }
  

  
  // Public method to access _ensureVideoLooping for external use (for removing/adding listener)
  void ensureVideoLooping() {
    _ensureVideoLooping();
  }
  
  // Select audio and auto-play (Instagram Reels behavior)
  // Music plays automatically when selected, controlled by bottom play/pause button
  Future<void> selectMusic(Map<String, dynamic> music, int index) async {
    try {
      debugPrint('🎵 Selecting music: ${music['name']}, index: $index');

      // STEP 1: Stop any currently playing music
      await _audioPlayer.stop();
      isMusicPlaying.value = false;
      currentlyPlayingIndex.value = -1;

      // STEP 2: Update music selection state (don't play yet)
      selectedMusicIndex.value = index;
      selectedMusic.value = music['name'] ?? '';
      selectedMusicArtist.value = music['artist'] ?? '';
      selectedMusicPath.value = music['audio'] ?? '';
      selectedMusicImgPath.value = music['image'] ?? '';

      if (selectedMusicPath.value.isEmpty) {
        debugPrint('❌ Music path is empty');
        return;
      }
      
      // STEP 3: CRITICAL: Ensure video is paused (but don't play music yet)
      if (isVideo.value &&
          videoController.value != null &&
          videoController.value!.value.isInitialized) {
        // Remove auto-play listener to prevent video from restarting
        videoController.value!.removeListener(_ensureVideoLooping);
        
        // Set music selection active to prevent auto-play
        isMusicSelectionActive.value = true;
        
        // Pause video first to stop playback
        await videoController.value!.pause();
        // Set volume to 0 to release audio focus
        await videoController.value!.setVolume(0.0);
        debugPrint('✅ Video paused for music selection');
      }
      
      // Reset trim times to full audio duration when selecting new music
      musicStartTime.value = 0.0;
      // musicEndTime.value = 60.0; // Default max duration
      
      // STEP 4: Wait for audio focus release
      await Future.delayed(const Duration(milliseconds: 200));
      
      // STEP 5: Configure AudioPlayer BEFORE playing
      final audioPathForPlayer = selectedMusicPath.value.replaceFirst('assets/', '');
      debugPrint('🎵 Auto-playing selected music: $audioPathForPlayer');
      
      try {
        // Configure AudioPlayer to request audio focus (Android 12/13 compatible)
        await _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);
        await _audioPlayer.setReleaseMode(ReleaseMode.loop);
        await _audioPlayer.setVolume(1.0);
        debugPrint('✅ Audio player configured: mode=lowLatency, volume=1.0');
      } catch (e) {
        debugPrint('❌ Error configuring audio player: $e');
      }
      
      // Small delay to ensure configuration is applied
      await Future.delayed(Duration(milliseconds: 100));
      
      // STEP 6: Play music automatically after selection
      await _audioPlayer.play(AssetSource(audioPathForPlayer), volume: 1.0);
      update();
      
      debugPrint('✅ Music selected and playing: ${selectedMusic.value}, isPlaying: ${isMusicPlaying.value}');
    } catch (e) {
      isMusicPlaying.value = false;
      // ShowToast.error('Failed to select music: ${e.toString()}');
      debugPrint('❌ Music selection error: $e');
      update();
    }
  }

  // Helper method to retry music playback with full reconfiguration
  Future<void> _retryMusicPlayback(String audioPathForPlayer) async {
    try {
      await _audioPlayer.stop();
      await Future.delayed(Duration(milliseconds: 400));
      await _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await Future.delayed(Duration(milliseconds: 200));
        await _audioPlayer.play(
          AssetSource(audioPathForPlayer),
          volume: 1.0,
        );
      await Future.delayed(Duration(milliseconds: 800));
      final position = await _audioPlayer.getCurrentPosition();
      isMusicPlaying.value = _audioPlayer.state == PlayerState.playing && 
                             position != null && 
                             position.inMilliseconds > 0;
      debugPrint('🔄 Retry result: isPlaying=${isMusicPlaying.value}, position=${position?.inMilliseconds}ms');
    } catch (e) {
      debugPrint('❌ Error retrying music playback: $e');
      isMusicPlaying.value = false;
    }
  }

  // Toggle save/unsave music
  void toggleSaveMusic(String musicName) {
    if (savedMusicSet.contains(musicName)) {
      savedMusicSet.remove(musicName);
    } else {
      savedMusicSet.add(musicName);
    }
    savedMusicSet.refresh();
    update();
  }

  // Check if music is saved
  bool isMusicSaved(String musicName) {
    return savedMusicSet.contains(musicName);
  }

  // Get filtered music list based on selected tab
  List<Map<String, dynamic>> getFilteredMusicList() {
    switch (selectedMusicTab.value) {
      case 0: // For you - show all music
        return musicList.toList();
      case 1: // Trending - show all music (can be filtered by reels count later)
        return musicList.toList();
      case 2: // Saved - show only saved music
        return musicList.where((music) => savedMusicSet.contains(music['name'] as String)).toList();
      case 3: // Original audio - empty for now
        return [];
      default:
        return musicList.toList();
    }
  }

  // Change music tab
  void changeMusicTab(int tabIndex) {
    selectedMusicTab.value = tabIndex;
    update();
  }

  
  // Convert single image to 10-second video (for single image selection)
  Future<void> _convertSingleImageToVideo(File imageFile) async {
    try {
      isProcessingVideo.value = true;
      processingProgress.value = 0.0;

      final tempDir = await getTemporaryDirectory();
      final tempImage = await imageFile.copy(
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final outputPath =
          '${tempDir.path}/single_image_video_${DateTime.now().millisecondsSinceEpoch}.mp4';

      processingProgress.value = 0.2;

      // FFmpeg command to convert image to 10-second video
      // OPTIMIZED FOR MAXIMUM SPEED: Lower resolution, lower framerate, fastest preset, higher CRF
      // -loop 1: Loop the image
      // -framerate 10: 10 fps (reduced from 15 for faster encoding)
      // -vf "scale=640:1136:force_original_aspect_ratio=decrease,pad=640:1136:(ow-iw)/2:(oh-ih)/2,format=yuv420p": 
      //   Lower resolution (640p) for faster processing, maintain aspect ratio, ensure even dimensions
      // -t 10: 10 seconds duration (reduced from 15)
      // -f lavfi -i "anullsrc=channel_layout=stereo:sample_rate=22050": Add silent audio track (lower sample rate)
      // -c:a aac: Encode audio to AAC (MP4-compatible)
      // -preset ultrafast: Use fastest preset for 1-2 second processing
      // -crf 30: Higher CRF (lower quality) for faster encoding
      // -metadata:s:v:0 rotate=0: Set rotation metadata to 0 (prevents auto-rotation)
      // -shortest: Finish encoding when shortest input stream ends
      final command =
          '-y '
          '-loop 1 '
          // '-framerate 10 '
          '-framerate 10 '
          '-i "${tempImage.path}" '
          '-f lavfi '
          '-i "anullsrc=channel_layout=stereo:sample_rate=22050" '
          '-vf "scale=640:1136:force_original_aspect_ratio=decrease,pad=640:1136:(ow-iw)/2:(oh-ih)/2,format=yuv420p" '
          '-t 5 '
          '-c:v libx264 '
          '-preset ultrafast '
          '-crf 30 '
          '-pix_fmt yuv420p '
          '-profile:v baseline '
          '-level 3.0 '
          '-c:a aac '
          '-b:a 32k '
          '-ar 22050 '
          '-ac 2 '
          '-metadata:s:v:0 rotate=0 '
          '-shortest '
          '-movflags +faststart '
          '-f mp4 '
          '"$outputPath"';

      debugPrint('FFmpeg command for single image to 10s video:\n$command');
      processingProgress.value = 0.5;

      final session = await FFmpegKit.execute(command);
      final rc = await session.getReturnCode();

      if (!ReturnCode.isSuccess(rc)) {
        final output = await session.getOutput();
        final failureStackTrace = await session.getFailStackTrace();
        final logs = await session.getAllLogsAsString();
        debugPrint('❌ FFmpeg logs:\n$logs');
        debugPrint('❌ FFmpeg output: $output');
        debugPrint('❌ FFmpeg failure stack trace: $failureStackTrace');
        throw Exception(
          'FFmpeg failed to convert image to video: ${output ?? failureStackTrace ?? "Unknown error"}',
        );
      }

      final video = File(outputPath);
      if (!await video.exists()) {
        throw Exception('Output video not created');
      }

      processingProgress.value = 0.8;

      /// ✅ Update controller state
      generatedVideo.value = video;
      selectedMedia.value = video;
      isVideo.value = true;

      // Initialize video player
      await _initializeVideo(video);

      // Update times for the newly created 10-second video
      videoStartTime.value = 0.0;
      videoEndTime.value = 10.0;
      videoDuration.value = 10.0;

      processingProgress.value = 1.0;
      
      debugPrint('✅ Single image → 10s video success: $outputPath');
      
      // ShowToast.show(
      //   message: 'Video created successfully',
      //   type: ToastType.success,
      // );
    } catch (e) {
      debugPrint('❌ Error converting single image to video: $e');
      // ShowToast.error('Failed to create video: ${e.toString()}');
      rethrow;
    } finally {
      isProcessingVideo.value = false;
      processingProgress.value = 0.0;
      update();
    }
  }

  // Apply trimmed music segment to video (Done button functionality)
  // CRITICAL: Stops preview, trims audio, mixes with video, replaces audio, reinitializes player
  Future<void> applyTrimmedMusicToVideo() async {
    // Check for video file - prioritize processedVideoFile, then generatedVideo (for multi-image), then selectedMedia
    final videoFile = processedVideoFile.value ?? generatedVideo.value ?? selectedMedia.value;
    
    if (videoFile == null || !isVideo.value || selectedMusicPath.value.isEmpty) {
      // ShowToast.error('No video or music selected');
      return;
    }

    try {
      isProcessingVideo.value = true;
      processingProgress.value = 0.1;

      final tempDir = await getTemporaryDirectory();
      final outputPath =
          '${tempDir.path}/video_with_trimmed_music_${DateTime.now().millisecondsSinceEpoch}.mp4';

      // Get video duration
      final videoDurationObj = videoController.value?.value.duration ?? Duration(seconds: 5);
      final videoDurationSeconds = videoDurationObj.inSeconds.toDouble();

      // Get trimmed segment duration
      final segmentDuration = (musicEndTime.value - musicStartTime.value).clamp(0.1, 60.0);

      // STEP 1: Copy audio asset to temp
      final audioPath = await _copyAssetToTemp(selectedMusicPath.value);
      processingProgress.value = 0.2;

      // STEP 2: Extract trimmed audio segment via FFmpeg
      final trimmedAudioPath = '${tempDir.path}/trimmed_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
      final trimCommand = '-y -i "$audioPath" -ss ${musicStartTime.value.toStringAsFixed(3)} -t ${segmentDuration.toStringAsFixed(3)} -c:a aac -b:a 192k -ar 44100 -ac 2 -f mp4 "$trimmedAudioPath"';

      debugPrint('🎵 Extracting trimmed audio segment: $trimCommand');
      final trimSession = await FFmpegKit.execute(trimCommand);
      final trimReturnCode = await trimSession.getReturnCode();

      if (!ReturnCode.isSuccess(trimReturnCode)) {
        final output = await trimSession.getOutput();
        throw Exception('Failed to extract audio segment: $output');
      }

      processingProgress.value = 0.4;

      // STEP 3: Loop trimmed audio to match video duration (if needed)
      String finalAudioPath = trimmedAudioPath;
      if (videoDurationSeconds > segmentDuration) {
        // Need to loop the audio
        final loopedAudioPath = '${tempDir.path}/looped_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        final loopCount = (videoDurationSeconds / segmentDuration).ceil() + 1;
        
        // Create concat file for looping
        final concatListPath = '${tempDir.path}/audio_concat_${DateTime.now().millisecondsSinceEpoch}.txt';
        final concatListFile = File(concatListPath);
        final absTrimmedPath = File(trimmedAudioPath).absolute.path.replaceAll("'", "'\\''");
        final concatListContent = List.generate(loopCount, (_) => "file '$absTrimmedPath'").join('\n');
        await concatListFile.writeAsString(concatListContent);

        // Concatenate (loop) the audio and trim to exact video duration
        final loopCommand = '-y -f concat -safe 0 -i "$concatListPath" -t ${videoDurationSeconds.toStringAsFixed(3)} -c:a aac -b:a 192k -ar 44100 -ac 2 -f mp4 "$loopedAudioPath"';
        
        debugPrint('🔄 Looping audio: $loopCommand');
        final loopSession = await FFmpegKit.execute(loopCommand);
        final loopReturnCode = await loopSession.getReturnCode();

        if (ReturnCode.isSuccess(loopReturnCode)) {
          finalAudioPath = loopedAudioPath;
          // Clean up concat file
          try {
            if (await concatListFile.exists()) {
              await concatListFile.delete();
            }
          } catch (e) {
            debugPrint('Error deleting concat file: $e');
          }
        } else {
          final output = await loopSession.getOutput();
          debugPrint('Warning: Failed to loop audio: $output, using single segment');
        }
        processingProgress.value = 0.6;
      } else {
        // Video is shorter than segment, trim the audio to match video
        final trimmedToVideoPath = '${tempDir.path}/trimmed_to_video_${DateTime.now().millisecondsSinceEpoch}.m4a';
        final trimToVideoCommand = '-y -i "$trimmedAudioPath" -t ${videoDurationSeconds.toStringAsFixed(3)} -c:a aac -b:a 192k -ar 44100 -ac 2 -f mp4 "$trimmedToVideoPath"';
        
        debugPrint(' Trimming audio to video duration: $trimToVideoCommand');
        final trimToVideoSession = await FFmpegKit.execute(trimToVideoCommand);
        final trimToVideoReturnCode = await trimToVideoSession.getReturnCode();
        
        if (ReturnCode.isSuccess(trimToVideoReturnCode)) {
          finalAudioPath = trimmedToVideoPath;
        }
        processingProgress.value = 0.6;
      }

      // STEP 4: Mix trimmed audio into video and replace original audio
      // CRITICAL: -c:v copy preserves video quality (no re-encoding)
      // -map 0:v:0 maps video stream, -map 1:a:0 maps new audio stream
      // final replaceCommand = '-y -i "${videoFile.path}" -i "$finalAudioPath" -c:v copy -c:a aac -b:a 192k -ar 44100 -ac 2 -shortest -map 0:v:0 -map 1:a:0 -metadata:s:v:0 rotate=0 -avoid_negative_ts make_zero -movflags +faststart -f mp4 "$outputPath"';
      final replaceCommand = '''
-y
-i "${videoFile.path}"
-i "$finalAudioPath"
-map 0:v:0
-map 1:a:0
-c:v copy
-c:a aac
-b:a 192k
-ar 44100
-ac 2
-copyts
-start_at_zero
-avoid_negative_ts make_zero
-movflags +faststart
-shortest
"$outputPath"
'''.replaceAll('\n', ' ');

      debugPrint('🎬 Replacing video audio with trimmed music: $replaceCommand');
      processingProgress.value = 0.7;

      final session = await FFmpegKit.execute(replaceCommand);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        final processedFile = File(outputPath);
        if (await processedFile.exists()) {
          // STEP 5: Stop music preview (music is now in video)
          // CRITICAL: Use stopMusic() instead of direct _audioPlayer.stop() to prevent "No active player" errors
          try {
            await stopMusic();
          } catch (e) {
            debugPrint('Error stopping music (non-critical): $e');
            // Continue even if stopping music fails
            isMusicPlaying.value = false;
          }
          
          // STEP 6: Update state with processed video
          processedVideoFile.value = processedFile;
          
          // STEP 7: CRITICAL: Initialize new video controller BEFORE disposing old one
          // This prevents loader from showing during reinitialization
          VideoPlayerController? oldController = videoController.value;
          
          // Create and initialize new controller first (keep old one visible)
          final newController = VideoPlayerController.file(processedFile);
          await newController.initialize();
          await Future.delayed(Duration(milliseconds: 300));
          
          // Verify new controller is initialized
          if (!newController.value.isInitialized) {
            await newController.dispose();
            throw Exception('New video controller failed to initialize');
          }
          
          // Set video to loop continuously
          newController.setLooping(true);
          
          // Update video duration
          final duration = newController.value.duration;  // Returns Duration
          if (duration.inMilliseconds > 0) {                       // Same pattern
            videoDuration.value = duration.inMilliseconds / 1000.0;
            videoEndTime.value = videoDuration.value;
            videoStartTime.value = 0.0;
          }
          
          // Now dispose old controller and swap
          if (oldController != null) {
            try {
              // Remove listener first
              oldController.removeListener(_ensureVideoLooping);
              // Pause and stop playback
              if (oldController.value.isInitialized) {
                await oldController.pause();
              }
              // Dispose the controller completely
              await oldController.dispose();
            } catch (e) {
              debugPrint('Error disposing old controller: $e');
            }
          }
          
          // Swap to new controller (no gap - no loader shown)
          videoController.value = newController;
          isVideoInitialized.value = true;
          
          // Add listener for looping
          newController.addListener(_ensureVideoLooping);
          
          // Seek to start and play
          await newController.seekTo(Duration.zero);
          await newController.play();
          await Future.delayed(Duration(milliseconds: 200));
          
          // STEP 8: Preload thumbnails for the new processed video
          _preloadThumbnailsInBackground(processedFile);
          
          // STEP 9: Ensure video is playing with music
          if (videoController.value != null && videoController.value!.value.isInitialized) {
            try {
              // Ensure volume is correct and video is playing
              await videoController.value!.setVolume(1.0);
              if (!videoController.value!.value.isPlaying) {
                await videoController.value!.play();
              }
              debugPrint('✅ Video reinitialized and playing with trimmed music');
            } catch (e) {
              debugPrint('❌ Error ensuring video playback: $e');
            }
          }
          
          // Force UI update
          update();

          // STEP 10: Mark music as applied to video
          isMusicAppliedToVideo.value = true;
          
          // CRITICAL: Ensure music selection state is preserved
          // This ensures the music indicator shows even after music is applied to video
          if (selectedMusic.value.isEmpty && selectedMusicPath.value.isNotEmpty) {
            // Restore music info from path if somehow cleared
            final musicIndex = selectedMusicIndex.value;
            if (musicIndex >= 0 && musicIndex < musicList.length) {
              final music = musicList[musicIndex];
              selectedMusic.value = music['name'] ?? '';
              selectedMusicArtist.value = music['artist'] ?? '';
              selectedMusicImgPath.value = music['image'] ?? '';
            }
          }
          
          processingProgress.value = 1.0;
          
          // CRITICAL: Stop processing immediately after video is ready to remove loader
          isProcessingVideo.value = false;
          processingProgress.value = 0.0;

          // ShowToast.success('Trimmed music applied successfully!');
          
          // STEP 11: Update UI to show music indicator
          // Force reactive updates to ensure UI rebuilds
          selectedMusic.refresh();
          selectedMusicArtist.refresh();
          selectedMusicImgPath.refresh();
          isMusicAppliedToVideo.refresh();
          update();
          
          debugPrint('✅ Trimmed music applied: video=${processedFile.path}, music=${selectedMusic.value}');
        } else {
          throw Exception('Processed video file not found');
        }
      } else {
        final output = await session.getOutput();
        debugPrint('❌ FFmpeg trimmed audio replace error: $output');
        throw Exception('FFmpeg audio replacement failed: $output');
      }

      // Clean up temp audio files
      try {
        final trimmedFile = File(trimmedAudioPath);
        if (await trimmedFile.exists()) {
          await trimmedFile.delete();
        }
        if (finalAudioPath != trimmedAudioPath) {
          final loopedFile = File(finalAudioPath);
          if (await loopedFile.exists()) {
            await loopedFile.delete();
          }
        }
      } catch (e) {
        debugPrint('Error cleaning up temp audio files: $e');
      }
    } catch (e) {
      debugPrint('❌ Error applying trimmed music: $e');
      // ShowToast.error('Failed to apply trimmed music: ${e.toString()}');
      // CRITICAL: Ensure loader is removed even on error
      isProcessingVideo.value = false;
      processingProgress.value = 0.0;
      update();
    } finally {
      // CRITICAL: Double-check loader is removed (in case it wasn't set in try block)
      if (isProcessingVideo.value) {
        isProcessingVideo.value = false;
        processingProgress.value = 0.0;
        update();
      }
    }
}

  // Copy asset file to temporary location
  Future<String> _copyAssetToTemp(String assetPath) async {
    try {
      // Read asset file
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      
      // Write to temp file
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = '${tempDir.path}/temp_audio_${DateTime.now().millisecondsSinceEpoch}.${assetPath.split('.').last}';
      final File tempFile = File(tempPath);
      await tempFile.writeAsBytes(bytes);
      
      return tempPath;
    } catch (e) {
      debugPrint('Error copying asset to temp: $e');
      rethrow;
    }
  }
  
  // Toggle music play/pause (Instagram Reels behavior)
  // CRITICAL: Ensures video is paused and audio focus is released
  Future<void> toggleMusicPlayPause() async {
    try {
      if (selectedMusicPath.value.isEmpty) {
        // ShowToast.show(message: 'No music selected', type: ToastType.info);
        return;
      }

      // CRITICAL: Get player state with error handling to prevent "No active player" errors
      PlayerState? currentState;
      try {
        currentState = _audioPlayer.state;
        debugPrint('🎵 Toggle music play/pause - Current state: $currentState, isMusicPlaying: ${isMusicPlaying.value}');
      } catch (e) {
        debugPrint('Error getting player state (non-critical): $e');
        // If we can't get state, assume stopped
        currentState = PlayerState.stopped;
      }
      
      if (currentState == PlayerState.playing) {
        // Currently playing - pause it
      await _audioPlayer.pause();
      isMusicPlaying.value = false;
        debugPrint('⏸️ Music paused');
      } else if (currentState == PlayerState.paused) {
        // Currently paused - resume it
        // CRITICAL: Release video audio focus before resuming music
        if (isVideo.value &&
            videoController.value != null &&
            videoController.value!.value.isInitialized) {
          await videoController.value!.pause();
          try {
            final currentPosition = videoController.value!.value.position;
            await videoController.value!.seekTo(currentPosition);
          } catch (e) {
            debugPrint('Warning: Could not seek video: $e');
          }
          await videoController.value!.setVolume(0.0);
          await Future.delayed(Duration(milliseconds: 400));
        }
        
      await _audioPlayer.resume();
        await Future.delayed(Duration(milliseconds: 600));
        try {
          isMusicPlaying.value = _audioPlayer.state == PlayerState.playing;
        } catch (e) {
          debugPrint('Error checking player state after resume: $e');
          isMusicPlaying.value = false;
        }
        debugPrint('▶️ Music resumed, isPlaying: ${isMusicPlaying.value}');
      } else {
        // Stopped or completed - start playing from beginning
        final audioPathForPlayer = selectedMusicPath.value.replaceFirst('assets/', '');
        debugPrint('🎵 Starting music from beginning: $audioPathForPlayer');
        
      // CRITICAL FIX #1: Release video audio focus COMPLETELY before playing music
      if (isVideo.value &&
          videoController.value != null &&
          videoController.value!.value.isInitialized) {
        // Set volume to 0 FIRST (before pause) to release audio focus on Android
        await videoController.value!.setVolume(0.0);
        await videoController.value!.pause();
        try {
          final currentPosition = videoController.value!.value.position;
          await videoController.value!.seekTo(currentPosition);
        } catch (e) {
          debugPrint('Warning: Could not seek video: $e');
        }
        await Future.delayed(Duration(milliseconds: 500));
      }
        
        // CRITICAL FIX #2: Ensure single AudioPlayer instance - stop completely first
        await _audioPlayer.stop();
        await Future.delayed(Duration(milliseconds: 400));
        
        // Configure audio player for device playback
        try {
          await _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
          await _audioPlayer.setVolume(1.0);
          await _audioPlayer.setReleaseMode(ReleaseMode.stop);
          await Future.delayed(Duration(milliseconds: 100));
        } catch (e) {
          debugPrint('❌ Error configuring audio player: $e');
        }
        
        await _audioPlayer.play(
          AssetSource(audioPathForPlayer),
          volume: 1.0,
        );
        
        // Wait for playback to start and audio focus to be granted
        await Future.delayed(Duration(milliseconds: 800));
        
        // CRITICAL: Verify playback started AND position is advancing (prevent silent failures)
        try {
          if (_audioPlayer.state == PlayerState.playing) {
            await Future.delayed(Duration(milliseconds: 200));
            try {
              final position = await _audioPlayer.getCurrentPosition();
              if (position != null && position.inMilliseconds > 0) {
      isMusicPlaying.value = true;
                debugPrint('✅ Music started from beginning successfully, position: ${position.inMilliseconds}ms');
              } else {
                debugPrint('⚠️ Music state is playing but position is 0, retrying...');
                await _retryMusicPlayback(audioPathForPlayer);
              }
            } catch (e) {
              debugPrint('Error getting position: $e');
              // Assume playing if state check passed
              isMusicPlaying.value = true;
            }
          } else {
            try {
              final state = _audioPlayer.state;
              debugPrint('⚠️ Music did not start, state: $state, retrying...');
            } catch (e) {
              debugPrint('⚠️ Music did not start, error getting state: $e, retrying...');
            }
            await _retryMusicPlayback(audioPathForPlayer);
          }
        } catch (e) {
          debugPrint('Error verifying playback: $e');
          // Try retry anyway
          await _retryMusicPlayback(audioPathForPlayer);
        }
      }
      
      // Force UI update
      update();
    } catch (e) {
      debugPrint('❌ Error toggling music play/pause: $e');
      // ShowToast.show(message: 'Failed to toggle music: ${e.toString()}', type: ToastType.error);
      isMusicPlaying.value = false;
      update();
    }
  }
  
  // Stop music
  Future<void> stopMusic() async {
    try {
      // CRITICAL: Check if player is still valid before accessing state
      // This prevents "Bad state: No active player" errors
      try {
        final currentState = _audioPlayer.state;
        if (currentState == PlayerState.playing ||
            currentState == PlayerState.paused) {
          await _audioPlayer.pause(); // IMPORTANT
          await _audioPlayer.setReleaseMode(ReleaseMode.release);
        }
      } catch (playerError) {
        // Player might be disposed or not active - this is okay
        debugPrint('Audio player not active (non-critical): $playerError');
      }

      isMusicPlaying.value = false;
      currentlyPlayingIndex.value = -1;

      debugPrint('✅ Music stopped successfully');
    } catch (e) {
      debugPrint('Error in stopMusic (non-critical): $e');
      // Ensure state is updated even if stopping fails
      isMusicPlaying.value = false;
      currentlyPlayingIndex.value = -1;
    }
  }

  // Play selected music (called from bottom play/pause button when music is paused/stopped)
  Future<void> playSelectedMusic() async {
    try {
      if (selectedMusicPath.value.isEmpty) {
        debugPrint('❌ No music selected to play');
        return;
      }
      
      // If already playing, do nothing (toggleMusicPlayPause handles pause)
      try {
        if (isMusicPlaying.value && _audioPlayer.state == PlayerState.playing) {
          debugPrint('Music is already playing');
          return;
        }
      } catch (e) {
        debugPrint('Error checking player state (non-critical): $e');
        // Continue to play music
      }
      
      // CRITICAL: Ensure video is paused before playing music
      if (isVideo.value &&
          videoController.value != null &&
          videoController.value!.value.isInitialized) {
        await videoController.value!.pause();
        await videoController.value!.setVolume(0.0);
        videoController.value!.removeListener(_ensureVideoLooping);
        isMusicSelectionActive.value = true;
      }
      
      // Wait for audio focus release
      await Future.delayed(const Duration(milliseconds: 500));
      
      // If paused, resume. Otherwise, stop and play from beginning
      PlayerState? currentState;
      try {
        currentState = _audioPlayer.state;
      } catch (e) {
        debugPrint('Error getting player state (non-critical): $e');
        currentState = PlayerState.stopped;
      }
      
      if (currentState == PlayerState.paused) {
        // Resume paused music
        await _audioPlayer.resume();
        await Future.delayed(Duration(milliseconds: 600));
        try {
          isMusicPlaying.value = _audioPlayer.state == PlayerState.playing;
        } catch (e) {
          debugPrint('Error checking player state after resume: $e');
          isMusicPlaying.value = false;
        }
        debugPrint('✅ Music resumed');
      } else {
        // Stop any existing playback and play from beginning
        await _audioPlayer.stop();
        await Future.delayed(Duration(milliseconds: 400));
        
        // Configure and play
        final audioPathForPlayer = selectedMusicPath.value.replaceFirst('assets/', '');
        await _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
        await _audioPlayer.setReleaseMode(ReleaseMode.stop);
        await _audioPlayer.setVolume(1.0);
        await Future.delayed(Duration(milliseconds: 100));
        
        await _audioPlayer.play(AssetSource(audioPathForPlayer), volume: 1.0);
        await Future.delayed(Duration(milliseconds: 800));
        
        // Verify playback
        try {
          if (_audioPlayer.state == PlayerState.playing) {
            await Future.delayed(Duration(milliseconds: 200));
            try {
              final position = await _audioPlayer.getCurrentPosition();
              if (position != null && position.inMilliseconds > 0) {
                isMusicPlaying.value = true;
                debugPrint('✅ Selected music started playing');
              } else {
                // Set state based on player state
                try {
                  isMusicPlaying.value = _audioPlayer.state == PlayerState.playing;
                } catch (e) {
                  isMusicPlaying.value = false;
                }
              }
            } catch (e) {
              debugPrint('Error getting position: $e');
              isMusicPlaying.value = false;
            }
          } else {
            isMusicPlaying.value = false;
          }
        } catch (e) {
          debugPrint('Error verifying playback: $e');
          isMusicPlaying.value = false;
        }
      }
      
      update();
    } catch (e) {
      debugPrint('❌ Error playing selected music: $e');
      isMusicPlaying.value = false;
      update();
    }
  }

  // Play background music while video is playing (for resume from save screen)
  // This method plays music without pausing the video
  Future<void> playBackgroundMusicWithVideo() async {
    try {
      if (selectedMusicPath.value.isEmpty) {
        debugPrint('❌ No music selected to play');
        return;
      }
      
      // If already playing, do nothing
      try {
        if (isMusicPlaying.value && _audioPlayer.state == PlayerState.playing) {
          debugPrint('Music is already playing');
          return;
        }
      } catch (e) {
        debugPrint('Error checking player state (non-critical): $e');
        // Continue to play music
      }
      
      // CRITICAL: Don't pause video - just ensure it's muted
      if (isVideo.value &&
          videoController.value != null &&
          videoController.value!.value.isInitialized) {
        // Ensure video is muted (don't pause it)
        await videoController.value!.setVolume(0.0);
        // Keep video playing - don't remove listener
        debugPrint('✅ Video muted for background music');
      }
      
      // Wait for audio focus
      await Future.delayed(const Duration(milliseconds: 300));
      
      // If paused, resume. Otherwise, stop and play from beginning
      PlayerState? currentState;
      try {
        currentState = _audioPlayer.state;
      } catch (e) {
        debugPrint('Error getting player state (non-critical): $e');
        currentState = PlayerState.stopped;
      }
      
      if (currentState == PlayerState.paused) {
        // Resume paused music
        await _audioPlayer.resume();
        await Future.delayed(Duration(milliseconds: 400));
        try {
          isMusicPlaying.value = _audioPlayer.state == PlayerState.playing;
        } catch (e) {
          debugPrint('Error checking player state after resume: $e');
          isMusicPlaying.value = false;
        }
        debugPrint('✅ Background music resumed');
      } else {
        // Stop any existing playback and play from beginning
        await _audioPlayer.stop();
        await Future.delayed(Duration(milliseconds: 300));
        
        // Configure and play
        final audioPathForPlayer = selectedMusicPath.value.replaceFirst('assets/', '');
        await _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer); // Use mediaPlayer for better compatibility
        await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop music
        await _audioPlayer.setVolume(1.0);
        await Future.delayed(Duration(milliseconds: 100));
        
        await _audioPlayer.play(AssetSource(audioPathForPlayer), volume: 1.0);
        await Future.delayed(Duration(milliseconds: 600));
        
        // Verify playback
        try {
          if (_audioPlayer.state == PlayerState.playing) {
            await Future.delayed(Duration(milliseconds: 200));
            try {
              final position = await _audioPlayer.getCurrentPosition();
              if (position != null && position.inMilliseconds > 0) {
                isMusicPlaying.value = true;
                debugPrint('✅ Background music started playing with video');
              } else {
                try {
                  isMusicPlaying.value = _audioPlayer.state == PlayerState.playing;
                } catch (e) {
                  isMusicPlaying.value = false;
                }
              }
            } catch (e) {
              debugPrint('Error getting position: $e');
              isMusicPlaying.value = false;
            }
          } else {
            isMusicPlaying.value = false;
            debugPrint('⚠️ Music failed to start playing');
          }
        } catch (e) {
          debugPrint('Error verifying playback: $e');
          isMusicPlaying.value = false;
        }
      }
      
      update();
    } catch (e) {
      debugPrint('❌ Error playing background music with video: $e');
      isMusicPlaying.value = false;
      update();
    }
  }
  
  // Get current music playback position (for waveform UI binding)
  // CRITICAL FIX #3: Expose position for waveform UI
  Future<Duration?> getCurrentMusicPosition() async {
    try {
      if (isMusicPlaying.value) {
        try {
          if (_audioPlayer.state == PlayerState.playing) {
            return await _audioPlayer.getCurrentPosition();
          }
        } catch (e) {
          debugPrint('Error getting player state/position (non-critical): $e');
          return null;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error getting music position: $e');
      return null;
    }
  }
  
  // Get audio duration (for trimming UI)
  Future<Duration?> getAudioDuration() async {
    try {
      if (selectedMusicPath.value.isNotEmpty) {
        // Try to get duration from the audio player with error handling
        try {
          final duration = await _audioPlayer.getDuration();
          if (duration != null && duration.inMilliseconds > 0) {
            return duration;
          }
        } catch (e) {
          debugPrint('Error getting audio duration from player (non-critical): $e');
          // Return null if player is not active
          return null;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error getting audio duration: $e');
      return null;
    }
  }
  
  // Play music at specific position (for trimming preview)
  // CRITICAL: Android audio focus - VideoPlayer releases focus, AudioPlayer gains it
  Future<void> playMusicAtPosition(double startTime, double endTime) async {
    try {
      if (selectedMusicPath.value.isEmpty) {
        debugPrint('❌ No music selected for preview');
        return;
      }

      // STEP 1: CRITICAL FIX #1: Release video audio focus COMPLETELY
      if (isVideo.value &&
          videoController.value != null &&
          videoController.value!.value.isInitialized) {
        // Set volume to 0 FIRST (before pause) to release audio focus on Android
        await videoController.value!.setVolume(0.0);
        await videoController.value!.pause();
        try {
          final currentPosition = videoController.value!.value.position;
          await videoController.value!.seekTo(currentPosition);
        } catch (e) {
          debugPrint('Warning: Could not seek video: $e');
        }
        await Future.delayed(Duration(milliseconds: 500));
      }

      // STEP 2: CRITICAL FIX #2: Ensure single AudioPlayer instance - stop completely
      await _audioPlayer.stop();
      await Future.delayed(Duration(milliseconds: 400));

      // STEP 3: Configure AudioPlayer to request focus
      // CRITICAL: Use PlayerMode.mediaPlayer for seeking support (lowLatency doesn't support seek)
      await _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await Future.delayed(Duration(milliseconds: 100));

      final audioPathForPlayer = selectedMusicPath.value.replaceFirst('assets/', '');
      final segmentDuration = (endTime - startTime).clamp(0.1, 60.0);

      // STEP 4: Play from start time position (AudioPlayer requests focus)
      // CRITICAL: mediaPlayer mode supports seeking to specific position
      await _audioPlayer.play(
        AssetSource(audioPathForPlayer),
        position: Duration(milliseconds: (startTime * 1000).toInt()),
      );

      // Wait for playback to start
      await Future.delayed(Duration(milliseconds: 600));

      // Verify playback started (prevent silent failures)
      try {
        if (_audioPlayer.state == PlayerState.playing) {
          isMusicPlaying.value = true;
        } else {
          debugPrint('⚠️ Music preview did not start, retrying...');
          await _audioPlayer.stop();
          await Future.delayed(Duration(milliseconds: 300));
          // Ensure mediaPlayer mode is set for retry
          await _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);
          await _audioPlayer.setVolume(1.0);
          await Future.delayed(Duration(milliseconds: 100));
          await _audioPlayer.play(
            AssetSource(audioPathForPlayer),
            position: Duration(milliseconds: (startTime * 1000).toInt()),
          );
          await Future.delayed(Duration(milliseconds: 600));
          try {
            isMusicPlaying.value = _audioPlayer.state == PlayerState.playing;
          } catch (e) {
            debugPrint('Error checking player state after retry: $e');
            isMusicPlaying.value = false;
          }
        }
      } catch (e) {
        debugPrint('Error verifying playback state: $e');
        isMusicPlaying.value = false;
      }

      // Auto-stop after segment duration
      Future.delayed(Duration(milliseconds: (segmentDuration * 1000).toInt()), () async {
        try {
          if (_audioPlayer.state == PlayerState.playing) {
            await _audioPlayer.stop();
            isMusicPlaying.value = false;
          }
        } catch (e) {
          debugPrint('Error in auto-stop callback: $e');
          isMusicPlaying.value = false;
        }
      });

      debugPrint('✅ Playing music segment: ${startTime}s - ${endTime}s');
    } catch (e) {
      debugPrint('❌ Error playing music at position: $e');
      isMusicPlaying.value = false;
    }
  }

  // Play selected music in reel (for editing screen) - Only used if music is already applied
  Future<void> playSelectedMusicInReel() async {
    try {
      if (selectedMusicPath.value.isEmpty) {
        return;
      }

      // Only play if music is already applied to video
      if (!isMusicAppliedToVideo.value) {
        // Music not applied yet - just play preview
        return;
      }
      
      // Stop any currently playing music
      await stopMusic();
      
      // Convert path from "assets/audio/audio1.mpeg" to "audio/audio1.mpeg"
      String audioPath = selectedMusicPath.value.replaceFirst('assets/', '');
      
      // If video exists and music is applied, play from video
      // Use processedVideoFile if available (has music), otherwise use selectedMedia
      final videoToProcess = processedVideoFile.value ?? generatedVideo.value ?? selectedMedia.value;
      if (isVideo.value && videoToProcess != null && processedVideoFile.value != null) {
        // Video already has music applied - just play it
        // The video player will handle audio playback
        debugPrint('Music already applied to video, playing from video');
      } else {
        // Fallback: play audio separately
        await _audioPlayer.setReleaseMode(ReleaseMode.loop);
        await _audioPlayer.play(AssetSource(audioPath));
        isMusicPlaying.value = true;
      }
    } catch (e) {
      // ShowToast.error('Failed to play music in reel: ${e.toString()}');
      debugPrint('Audio path error: $selectedMusicPath');
    }
  }
  
  // Add text with draggable functionality
  void addText(
    String text,
    Color color,
    double fontSize,
    Offset position, {
    String fontStyle = 'Roboto',
    bool isBold = false,
    bool isItalic = false,
    bool hasUnderline = false,
    Color? backgroundColor,
    TextAlign textAlign = TextAlign.center,
  }) {
    addedTexts.add({
      'text': text,
      'color': color,
      'fontSize': fontSize,
      'position': position,
      'fontStyle': fontStyle,
      'isBold': isBold,
      'isItalic': isItalic,
      'hasUnderline': hasUnderline,
      'backgroundColor': backgroundColor,
      'textAlign': textAlign,
      'scale': 1.0,
      'baseFontSize': fontSize, // Store base font size for zoom calculations
      'rotation': 0.0,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }
  
  // Update text position
  void updateTextPosition(String id, Offset position) {
    final index = addedTexts.indexWhere((t) => t['id'] == id);
    if (index != -1) {
      addedTexts[index]['position'] = position;
      addedTexts.refresh(); // 🔥 REQUIRED
    }
  }
  
  // Update text scale - inversely affects font size (zoom in = smaller text, zoom out = larger text)
  void updateTextScale(String id, double scale) {
    final index = addedTexts.indexWhere((t) => t['id'] == id);
    if (index != -1) {
      final currentFontSize = addedTexts[index]['fontSize'] as double;
      final baseFontSize = addedTexts[index]['baseFontSize'] as double? ?? currentFontSize;
      
      // Store base font size if not already stored
      if (addedTexts[index]['baseFontSize'] == null) {
        addedTexts[index]['baseFontSize'] = currentFontSize;
      }
      
      // Inverse relationship: scale up = font size down, scale down = font size up
      // Formula: fontSize = baseFontSize / scale
      final newFontSize = (baseFontSize / scale).clamp(8.0, 72.0);
      
      addedTexts[index]['scale'] = scale;
      addedTexts[index]['fontSize'] = newFontSize;
      addedTexts.refresh(); // 🔥 REQUIRED
    }
  }
  
  // Update text rotation
  void updateTextRotation(String id, double rotation) {
    final index = addedTexts.indexWhere((t) => t['id'] == id);
    if (index != -1) {
      addedTexts[index]['rotation'] = rotation;
      addedTexts.refresh(); // 🔥 REQUIRED
    }
  }
  
  // Remove text
  void removeText(String id) {
    addedTexts.removeWhere((text) => text['id'] == id);
  }
  
  void updateTextStyle(
    String id, {
    bool? isBold,
    bool? isItalic,
    bool? hasUnderline,
    Color? color,
    double? fontSize,
    String? fontStyle,
    Color? backgroundColor,
    TextAlign? textAlign,
  }) {
    final index = addedTexts.indexWhere((t) => t['id'] == id);
    if (index != -1) {
      if (isBold != null) {
        addedTexts[index]['isBold'] = isBold;
      }
      if (isItalic != null) {
        addedTexts[index]['isItalic'] = isItalic;
      }
      if (hasUnderline != null) {
        addedTexts[index]['hasUnderline'] = hasUnderline;
      }
      if (color != null) {
        addedTexts[index]['color'] = color;
      }
      if (fontSize != null) {
        addedTexts[index]['fontSize'] = fontSize;
        // Update base font size when manually changing fontSize
        addedTexts[index]['baseFontSize'] = fontSize;
      }
      if (fontStyle != null) {
        addedTexts[index]['fontStyle'] = fontStyle;
      }
      if (backgroundColor != null || backgroundColor == null) {
        addedTexts[index]['backgroundColor'] = backgroundColor;
      }
      if (textAlign != null) {
        addedTexts[index]['textAlign'] = textAlign;
      }
      addedTexts.refresh(); // 🔥 REQUIRED
    }
  }
  
  void toggleTextBackground(String id) {
    final index = addedTexts.indexWhere((t) => t['id'] == id);
    if (index != -1) {
      final currentBg = addedTexts[index]['backgroundColor'] as Color?;
      Color? newBg;
      
      if (currentBg == null) {
        // No background → White background
        newBg = Colors.white;
      } else if (currentBg == Colors.white) {
        // White background → Black background
        newBg = Colors.black;
      } else if (currentBg == Colors.black) {
        // Black background → Remove background (transparent)
        newBg = null;
      } else {
        // Any other color → White background
        newBg = Colors.white;
      }
      
      addedTexts[index]['backgroundColor'] = newBg;
      
      // Auto-adjust text color based on background (only for white/black text colors)
      Color currentTextColor = addedTexts[index]['color'] as Color;
      // Only change text color if it's white or black
      if (currentTextColor == Colors.white || currentTextColor == Colors.black) {
      if (newBg == Colors.white) {
        // White background → black text
        addedTexts[index]['color'] = Colors.black;
      } else if (newBg == Colors.black) {
        // Black background → white text
        addedTexts[index]['color'] = Colors.white;
      }
        // If removing background, keep current text color
      }
      // If text color is other than white/black, don't change it
      
      addedTexts.refresh(); // 🔥 REQUIRED
    }
  }

  
  // Apply filter (custom implementation using ColorFilter)
  void applyFilter(int index, int tabIndex) {
    selectedFilterIndex.value = index;
    selectedFilterTab.value = tabIndex;
    
    final filters = tabIndex == 0 ? aestheticsFilters : specialEffectsFilters;
    final filter = filters[index];
    final filterName = filter['name'] as String;

    selectedFilterName.value = filterName;
    
    // ShowToast.show(message: 'Filter applied: $filterName', type: ToastType.success);
  }
  
  // Get ColorFilter for the selected filter
  ColorFilter? getSelectedColorFilter() {
    if (selectedFilterIndex.value == 0) {
      return null; // No filter
    }
    
    final filters = selectedFilterTab.value == 0 
        ? aestheticsFilters 
        : specialEffectsFilters;
    final filter = filters[selectedFilterIndex.value];
    final filterType = filter['filter'] as String;
    
    return _getColorFilterForType(filterType);
  }
  
  // Get ColorFilter matrix for filter type
  ColorFilter? _getColorFilterForType(String filterType) {
    switch (filterType) {
      case 'vintage':
        // Vintage filter: warm sepia tone
        return ColorFilter.matrix([
          0.9, 0.5, 0.1, 0, 0,
          0.3, 0.8, 0.1, 0, 0,
          0.2, 0.3, 0.5, 0, 0,
          0, 0, 0, 1, 0,
        ]);
      
      case 'bw':
        // Black and white filter
        return ColorFilter.matrix([
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0, 0, 0, 1, 0,
        ]);
      
      case 'warm':
        // Warm filter: increased red/yellow
        return ColorFilter.matrix([
          1.2, 0, 0, 0, 0,
          0.1, 1.1, 0, 0, 0,
          0, 0, 0.9, 0, 0,
          0, 0, 0, 1, 0,
        ]);
      
      case 'cool':
        // Cool filter: increased blue
        return ColorFilter.matrix([
          0.9, 0, 0, 0, 0,
          0, 0.9, 0, 0, 0,
          0, 0, 1.2, 0, 0,
          0, 0, 0, 1, 0,
        ]);
      
      case 'bright':
        // Bright filter: increased brightness
        return ColorFilter.matrix([
          1.3, 0, 0, 0, 20,
          0, 1.3, 0, 0, 20,
          0, 0, 1.3, 0, 20,
          0, 0, 0, 1, 0,
        ]);
      
      case 'sepia':
        // Sepia filter
        return ColorFilter.matrix([
          0.393, 0.769, 0.189, 0, 0,
          0.349, 0.686, 0.168, 0, 0,
          0.272, 0.534, 0.131, 0, 0,
          0, 0, 0, 1, 0,
        ]);
      
      case 'saturate':
        // High saturation
        return ColorFilter.matrix([
          1.5, 0, 0, 0, 0,
          0, 1.5, 0, 0, 0,
          0, 0, 1.5, 0, 0,
          0, 0, 0, 1, 0,
        ]);
      
      case 'vignette':
        // Vignette effect (darkened edges) - applied via gradient overlay
        return null; // Will be handled separately
      
      case 'fog':
        // Fog effect: desaturated and slightly brightened
        return ColorFilter.matrix([
          0.8, 0.1, 0.1, 0, 30,
          0.1, 0.8, 0.1, 0, 30,
          0.1, 0.1, 0.8, 0, 30,
          0, 0, 0, 1, 0,
        ]);
      
      case 'ripple':
        // Ripple effect: slight color shift
        return ColorFilter.matrix([
          1, 0.1, 0, 0, 0,
          0, 1, 0.1, 0, 0,
          0.1, 0, 1, 0, 0,
          0, 0, 0, 1, 0,
        ]);
      
      case 'cloud':
        // Cloud effect: soft, desaturated
        return ColorFilter.matrix([
          0.9, 0.05, 0.05, 0, 20,
          0.05, 0.9, 0.05, 0, 20,
          0.05, 0.05, 0.9, 0, 20,
          0, 0, 0, 1, 0,
        ]);
      
      case 'party_lights':
        // Party lights: vibrant colors
        return ColorFilter.matrix([
          1.2, 0, 0, 0, 0,
          0, 1.2, 0, 0, 0,
          0, 0, 1.2, 0, 0,
          0, 0, 0, 1, 0,
        ]);
      
      default:
        return null;
    }
  }
  void clearGalleryState() {
    selectedImages.clear();
    selectedImageIndices.clear();
    selectedImagePositions.clear();
    selectedVideo.value = null;
    multiSelectionType.value = 'none';
    isMultipleSelectionMode.value = false;
    isProcessingVideo.value = false;

    galleryPickerRefreshKey.value++; // force rebuild
  }
  // Check if filter needs gradient overlay (for vignette)
  bool needsGradientOverlay() {
    if (selectedFilterIndex.value == 0) return false;
    
    final filters = selectedFilterTab.value == 0 
        ? aestheticsFilters 
        : specialEffectsFilters;
    final filter = filters[selectedFilterIndex.value];
    final filterType = filter['filter'] as String;
    
    return filterType == 'vignette';
  }
  
  // Set video trim times
  void setVideoTrimTimes(double start, double end) {
    videoStartTime.value = start;
    videoEndTime.value = end;
    if (videoController.value != null) {
      videoController.value!.seekTo(Duration(milliseconds: (start * 1000).toInt()));
    }
  }
  
  // Create finalized video with all edits (trim, text, filters, music)
  Future<File?> createFinalizedVideo(BuildContext context) async {
    if (selectedMedia.value == null) {
      // ShowToast.error('Please select media first');
      return null;
    }
    
    isProcessingVideo.value = true;
    
    try {
      // Get the base video (prioritize processed > generated > selected)
      File? baseVideo = processedVideoFile.value ?? 
                       generatedVideo.value ?? 
                       selectedMedia.value;
      
      if (baseVideo == null || !await baseVideo.exists()) {
        throw Exception('Base video file not found');
      }
      
      // If it's an image, we need to convert it first
      if (!isVideo.value && generatedVideo.value == null) {
        throw Exception('Image must be converted to video first');
      }
      
      final tempDir = await getTemporaryDirectory();
      final outputPath = '${tempDir.path}/finalized_video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      
      // Build FFmpeg command to apply all edits
      String videoInput = baseVideo.path;
      List<String> videoFilters = [];
      List<String> audioInputs = [];
      
      // 1. Apply trim if needed
      double startTime = videoStartTime.value;
      double duration = (videoEndTime.value - videoStartTime.value).clamp(0.1, 3600.0);
      
      // 2. Build text overlay filters
      // Note: FFmpeg drawtext on Android requires a font file path
      // We'll try to use a system font or skip if not available
      
      // Get video dimensions for proper text positioning
      int? videoWidth;
      int? videoHeight;
      try {
        if (videoController.value != null && videoController.value!.value.isInitialized) {
          final size = videoController.value!.value.size;
          videoWidth = size.width.toInt();
          videoHeight = size.height.toInt();
        }
      } catch (e) {
        debugPrint('Error getting video dimensions: $e');
      }
      
      // Default dimensions if not available
      videoWidth ??= 720;
      videoHeight ??= 1280;
      
      // Try to find a system font file on Android
      // Common Android system font paths
      List<String> possibleFontPaths = [
        '/system/fonts/Roboto-Regular.ttf',
        '/system/fonts/DroidSans.ttf',
        '/system/fonts/NotoSans-Regular.ttf',
        '/system/fonts/AndroidClock.ttf',
      ];
      
      String? fontPath;
      for (String path in possibleFontPaths) {
        try {
          final fontFile = File(path);
          if (await fontFile.exists()) {
            fontPath = path;
            debugPrint('Found system font: $fontPath');
            break;
          }
        } catch (e) {
          // Continue to next font path
        }
      }
      
      // Build text overlays if font is available
      if (addedTexts.isNotEmpty && fontPath != null) {
        for (int i = 0; i < addedTexts.length; i++) {
          final textData = addedTexts[i];
          final text = textData['text'] as String? ?? '';
          if (text.isEmpty) continue;
          
          final color = textData['color'] as Color? ?? Colors.white;
          final fontSize = textData['fontSize'] as double? ?? 20.0;
          final position = textData['position'] as Offset? ?? Offset.zero;
          final isBold = textData['isBold'] as bool? ?? false;
          final backgroundColor = textData['backgroundColor'] as Color?;
          
          // Escape text for FFmpeg (escape special characters)
          String escapedText = text
              .replaceAll('\\', '\\\\')
              .replaceAll(':', '\\:')
              .replaceAll('[', '\\[')
              .replaceAll(']', '\\]')
              .replaceAll("'", "\\'")
              .replaceAll('"', '\\"')
              .replaceAll('\n', '\\n');
          
          // Convert color to hex (format: 0xRRGGBB)
          int r = color.r.round();
          int g = color.g.round();
          int b = color.b.round();
          String colorHex = '0x${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
          
          // Calculate position relative to video dimensions
          // Position is stored relative to screen, need to scale to video dimensions
          double xRatio = position.dx / (MediaQuery.of(context).size.width);
          double yRatio = position.dy / (MediaQuery.of(context).size.height);
          int x = (xRatio * videoWidth).toInt().clamp(0, videoWidth);
          int y = (yRatio * videoHeight).toInt().clamp(0, videoHeight);
          
          // Build text box if background color is set
          String boxParams = '';
          if (backgroundColor != null) {
            int bgR = backgroundColor.r.round();
            int bgG = backgroundColor.g.round();
            int bgB = backgroundColor.b.round();
            String bgColorHex = '0x${bgR.toRadixString(16).padLeft(2, '0')}${bgG.toRadixString(16).padLeft(2, '0')}${bgB.toRadixString(16).padLeft(2, '0')}';
            boxParams = ':box=1:boxcolor=$bgColorHex@0.8:boxborderw=5';
          }
          
          // Build font size (increase for bold effect)
          int finalFontSize = isBold ? (fontSize * 1.2).toInt() : fontSize.toInt();
          
          // Add text overlay filter with font file
          videoFilters.add(
            "drawtext=fontfile='$fontPath':text='$escapedText':fontcolor=$colorHex:x=$x:y=$y:fontsize=$finalFontSize$boxParams"
          );
        }
      } else if (addedTexts.isNotEmpty && fontPath == null) {
        debugPrint('Warning: No system font found. Text overlays will not be rendered in final video.');
        debugPrint('Text overlays (${addedTexts.length}) are visible in UI but not in exported video.');
      }
      
      // 3. Build filter complex
      String filterComplex = '';
      if (videoFilters.isNotEmpty) {
        filterComplex = '-vf "${videoFilters.join(',')}"';
      }
      
      // 4. Handle audio
      // String audioCommand = '';
      if (selectedMusicPath.value.isNotEmpty) {
        // Copy audio asset to temp
        String audioAssetPath = selectedMusicPath.value;
        String audioPath = await _copyAssetToTemp(audioAssetPath);
        audioInputs.add('-i "$audioPath"');
        // audioCommand = '-map 0:v:0 -map 1:a:0 -c:a aac -b:a 128k -ar 44100 -ac 2 -shortest';
      } else {
        // Keep original audio
        // audioCommand = '-c:a copy';
      }
      
      // 5. Build final FFmpeg command
      // If no filters, don't include -vf parameter
      // Added codec parameters to avoid MediaCodec warnings
      String command = '-y '
          '-ss ${startTime.toStringAsFixed(3)} '
          '-i "$videoInput" '
          '${audioInputs.isNotEmpty ? '${audioInputs.join(' ')} ' : ''}'
          '-t ${duration.toStringAsFixed(3)} '
          '${filterComplex.isNotEmpty ? '$filterComplex ' : ''}'
          '-c:v libx264 '
          '-preset veryfast '
          '-crf 23 '
          '-pix_fmt yuv420p '
          '-c:a aac -b:a 128k -ar 44100 -ac 2 '
          '-metadata:s:v:0 rotate=0 '
          '-movflags +faststart '
          '-avoid_negative_ts make_zero '
          '"$outputPath"';


      debugPrint('Finalizing video with command: $command');
      
      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();
      
      if (!ReturnCode.isSuccess(returnCode)) {
        final output = await session.getOutput();
        final failureStackTrace = await session.getFailStackTrace();
        debugPrint('FFmpeg finalization error: $output');
        debugPrint('FFmpeg failure stack trace: $failureStackTrace');
        throw Exception('FFmpeg failed to finalize video: ${output ?? failureStackTrace ?? "Unknown error"}');
      }
      
      final finalizedFile = File(outputPath);
      if (!await finalizedFile.exists()) {
        throw Exception('Finalized video file not created');
      }
      
      finalizedVideo.value = finalizedFile;
      update();
      debugPrint('✅ Video finalized successfully: $outputPath');

      return finalizedFile;
    } catch (e) {
      debugPrint('❌ Error finalizing video: $e');
      // ShowToast.error('Failed to finalize video: ${e.toString()}');
      return null;
    } finally {
      isProcessingVideo.value = false;
    }
  }
  
  // Post reel - navigate to save reel screen (only generates cover image, preserves editing state)
  Future<void> postReel() async {
    if (selectedMedia.value == null) {
      // ShowToast.error('Please select media first');
      return;
    }
    
    try {
      // 🔴 STEP 1: Stop background music completely
      await stopMusic();
      debugPrint('✅ Background music stopped');

      // 🟡 STEP 2: Stop video and mute video's audio track
      if (isVideo.value &&
          videoController.value != null &&
          videoController.value!.value.isInitialized) {
        try {
          // Remove auto-play listener to prevent video from restarting
          videoController.value!.removeListener(_ensureVideoLooping);
          
          // Pause video first to stop playback
          await videoController.value!.pause();
          
          // Mute video's audio track to stop video's music/audio
          await videoController.value!.setVolume(0.0);
          
          // Set music selection active to prevent auto-play
          isMusicSelectionActive.value = true;
          
          debugPrint('✅ Video paused, muted, and auto-play disabled on Next button');
        } catch (e) {
          debugPrint('Error stopping video: $e');
        }
      }

      update();
      
      // Navigate to save reel screen
      await Get.to(() => const SaveReelScreen());
      
      // 🔵 STEP 3: Resume video and music when returning from save screen
      if (isVideo.value) {
        try {
          // CRITICAL: Ensure video is properly initialized before resuming (especially for multi-image videos)
          final videoFile = processedVideoFile.value ?? 
                           generatedVideo.value ?? 
                           selectedMedia.value;
          
          // If video controller is null or not initialized, reinitialize it
          if (videoFile != null && 
              (videoController.value == null || 
               !videoController.value!.value.isInitialized ||
               !isVideoInitialized.value)) {
            debugPrint('Video controller not initialized, reinitializing...');
            await reinitializeVideo(videoFile);
            // Wait for initialization to complete
            await Future.delayed(Duration(milliseconds: 500));
          }
          
          // Now check if video is properly initialized
          if (videoController.value != null && 
              videoController.value!.value.isInitialized) {
            // Re-add auto-play listener
            videoController.value!.addListener(_ensureVideoLooping);
            
            // Reset music selection active flag
            isMusicSelectionActive.value = false;
            
            if (!isMusicAppliedToVideo.value) {
              // If music is NOT applied to video, play video (muted) and background music
              // First, ensure video is muted
              await videoController.value!.setVolume(0.0);
              
              // Play video
              await videoController.value!.play();
              debugPrint('✅ Video resumed after returning from save screen');
              
              // CRITICAL: Resume background music if it was selected (for multi-image videos)
              if (selectedMusicPath.value.isNotEmpty && 
                  !isMusicPlaying.value) {
                // Wait a bit for video to start
                await Future.delayed(Duration(milliseconds: 400));
                
                // Play background music without pausing video
                await playBackgroundMusicWithVideo();
                debugPrint('✅ Background music resumed after returning from save screen');
              }
            } else {
              // If music IS applied to video, just play video (music is part of video audio)
              await videoController.value!.play();
              debugPrint('✅ Video with embedded music resumed after returning from save screen');
            }
          } else {
            debugPrint('⚠️ Video controller still not initialized after reinitialization attempt');
          }
        } catch (e) {
          debugPrint('Error resuming video/music: $e');
        }
      }

    } catch (e, stackTrace) {
      debugPrint('Navigation error: $e');
      debugPrint('Stack trace: $stackTrace');
      // ShowToast.error('Failed to navigate');
    }
  }
  
  // Save finalized reel - creates finalized video and saves it
  Future<void> saveFinalizedReel(BuildContext context) async {
    if (selectedMedia.value == null) {
      // ShowToast.error('Please select media first');
      return;
    }
    
    try {
      // Stop music before finalizing
      await stopMusic();
      
      // Create finalized video with all edits
      // ShowToast.show(message: 'Finalizing video...', type: ToastType.info);
      final finalized = await createFinalizedVideo(context);
      if (finalized == null) {
        // ShowToast.error('Failed to create finalized video');
        return;
      }
      
      debugPrint('Finalized video created: ${finalized.path}');
      
      // TODO: Save the finalized video to gallery/storage
      // For now, just show success message
      // ShowToast.show(message: 'Reel saved successfully!', type: ToastType.success);
      
      // Clear editing state after successful save
      clearAllEditingTools();
      
      // Navigate back to gallery or close
      Get.back(); // Close save reel screen
      Get.back(); // Close create reels screen (if needed)
      
      debugPrint('Reel saved successfully');
    } catch (e, stackTrace) {
      debugPrint('Error saving reel: $e');
      debugPrint('Stack trace: $stackTrace');
      // ShowToast.error('Failed to save reel: ${e.toString()}');
    }
  }

  // Clear all editing text and selected tools
  void clearAllEditingTools() {
    // Clear all added text overlays
    addedTexts.clear();
    
    // Clear selected music
    selectedMusic.value = '';
    selectedMusicArtist.value = '';
    selectedMusicPath.value = '';
    selectedMusicIndex.value = -1;
    isMusicAppliedToVideo.value = false;
    
    // Clear selected filters (reset to "No effect")
    selectedFilterIndex.value = 0;
    selectedFilterTab.value = 0;
    selectedFilterName.value = 'No effect';
    
    // Stop music playback if playing
    stopMusic();
    
    debugPrint('All editing tools and text cleared');
  }
  
  // Discard changes
  void discardChanges() async {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('Discard Changes?', style: TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to discard all changes?', style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              // CRITICAL: Stop music first
              await stopMusic();
              
              // CRITICAL: Use _clearAllSelections() to ensure consistent clearing
              // This clears all gallery selections including pink selection indicators
              _clearAllSelections();
              
              // Reset screen state
              currentScreen.value = 0;
              isMusicSelectionActive.value = false;
              isProcessingVideo.value = false;
              processingProgress.value = 0.0;
              
              // Force UI update to reflect cleared selections
              update();
              
              // Wait a bit to ensure UI updates are processed
              await Future.delayed(Duration(milliseconds: 100));
              await TrimmedMusicDB.clearStoredTrimmedMusic();
              // Close dialog and navigate back
              Get.back();
              Get.back();
              clearGalleryState();

              // Get.offAllNamed(AppRoutes.dashboard);// Close dialog
              // Get.offAllNamed(AppRoutes.dashboard); // Close create reels screen
              
              // CRITICAL: Delete controller to ensure fresh state on next entry
              // This ensures onInit() will be called when controller is recreated
              try {
                Get.delete<CreateReelsController>(force: true);
                debugPrint('✅ Controller deleted after discard');
              } catch (e) {
                debugPrint('Error deleting controller: $e');
              }
              
              debugPrint('✅ All changes discarded and selections cleared');
            },
            child: Text('Discard', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  
  // Reset to gallery view
  void backToGallery() async {
    await stopMusic();
    
    // Clean up processed video file
    if (processedVideoFile.value != null) {
      try {
        final file = processedVideoFile.value!;
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        debugPrint('Error deleting processed video: $e');
      }
      processedVideoFile.value = null;
    }
    
    // Clean up generated video file (from trimming or image conversion)
    if (generatedVideo.value != null) {
      try {
        final file = generatedVideo.value!;
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        debugPrint('Error deleting generated video: $e');
      }
      generatedVideo.value = null;
    }
    
    currentScreen.value = 0;
    selectedMedia.value = null;
    videoController.value?.dispose();
    videoController.value = null;
    isVideoInitialized.value = false;
    selectedMusic.value = '';
    selectedMusicArtist.value = '';
    selectedMusicPath.value = '';
    addedTexts.clear();
    selectedFilterIndex.value = 0;
    currentlyPlayingIndex.value = -1;
    selectedMusicIndex.value = -1;
    isProcessingVideo.value = false;
    processingProgress.value = 0.0;
    videoStartTime.value = 0.0;
    videoEndTime.value = 0.0;
    videoDuration.value = 0.0;
    isMusicAppliedToVideo.value = false; // Reset music applied flag
    
    // CRITICAL: Clear multiple selection state (images/media selections)
    isMultipleSelectionMode.value = false;
    selectedImageIndices.clear();
    selectedImages.clear();
    selectedImagePositions.clear();
    selectedVideo.value = null;
    multiSelectionType.value = 'none';
    
    // CRITICAL: Refresh gallery picker to clear visual selections
    galleryPickerRefreshKey.value++;
    
    // Refresh all reactive lists to update UI
    selectedImages.refresh();
    selectedImageIndices.refresh();
    selectedImagePositions.refresh();
    selectedVideo.refresh();
    
    // Force UI update
    update();
    
    debugPrint('✅ Back to gallery - all selections cleared');
  }
}
