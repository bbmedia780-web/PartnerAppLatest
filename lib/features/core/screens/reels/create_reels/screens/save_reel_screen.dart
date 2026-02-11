
import '../../../../../../utils/library_utils.dart';
import '../widgets/hashtag_selection_bottom_sheet.dart';

class SaveReelScreen extends StatefulWidget {
  const SaveReelScreen({super.key});

  @override
  State<SaveReelScreen> createState() => _SaveReelScreenState();
}

class _SaveReelScreenState extends State<SaveReelScreen> {
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _hashtagsController = TextEditingController();
  final GlobalKey _captionFieldKey = GlobalKey();
  OverlayEntry? _hashtagOverlay;
  bool _isHashtagBoxOpen = false;
  Uint8List? _videoThumbnail;
  bool _isLoadingThumbnail = false;
  String? _lastMediaPath;

  @override
  void initState() {
    super.initState();
    _captionController.addListener(_onCaptionChanged);
    _ensureVideoInitialized();
  }
  Future<void> _ensureVideoInitialized() async {
    final ctrl = Get.find<CreateReelsController>();
    if (ctrl.isVideo.value) {
      final media = ctrl.processedVideoFile.value ??
          ctrl.generatedVideo.value ??
          ctrl.selectedMedia.value;
      
      if (media != null) {
        if (ctrl.videoController.value == null ||
            !ctrl.isVideoInitialized.value ||
            !ctrl.videoController.value!.value.isInitialized) {
          await ctrl.reinitializeVideo(media);
        } else if (!ctrl.videoController.value!.value.isPlaying) {
          await ctrl.videoController.value!.play();
        }
      }
    }
  }

  @override
  void dispose() {
    _captionController.removeListener(_onCaptionChanged);
    _closeHashtagBox();
    _captionController.dispose();
    _hashtagsController.dispose();
    super.dispose();
  }

  // Listen for "#" character in caption
  void _onCaptionChanged() {
    final text = _captionController.text;
    final selection = _captionController.selection;
    final cursorPosition = selection.baseOffset;

    // Check if "#" was just typed
    if (cursorPosition > 0 && cursorPosition <= text.length) {
      final charBeforeCursor = text.substring(
        cursorPosition - 1,
        cursorPosition,
      );

      if (charBeforeCursor == '#') {
        // "#" was typed, show hashtag box
        _showHashtagBox();
      } else if (_isHashtagBoxOpen) {
        // Check if we're still in a hashtag context (after #)
        // Find the last "#" before cursor
        int lastHashIndex = text.lastIndexOf('#', cursorPosition - 1);
        if (lastHashIndex != -1) {
          // Check if there's a space or newline between # and cursor
          String textAfterHash = text.substring(
            lastHashIndex + 1,
            cursorPosition,
          );
          if (textAfterHash.contains(' ') || textAfterHash.contains('\n')) {
            // Space or newline found after "#", close the box
            _closeHashtagBox();
          }
        } else {
          // No "#" found before cursor, close the box
          _closeHashtagBox();
        }
      }
    }
  }

  // Insert hashtag at cursor position in caption field
  void _insertHashtagAtCursor(String hashtag) {
    final text = _captionController.text;
    final selection = _captionController.selection;

    // Get cursor position
    final cursorPosition = selection.baseOffset;

    // Find the "#" that triggered the hashtag selection
    // Look backwards from cursor to find the last "#"
    int hashtagStart = -1;
    for (int i = cursorPosition - 1; i >= 0; i--) {
      if (text[i] == '#') {
        hashtagStart = i;
        break;
      } else if (text[i] == ' ' || text[i] == '\n') {
        // Stop if we hit a space or newline before finding "#"
        break;
      }
    }

    if (hashtagStart == -1) {
      // No "#" found, just insert at cursor
      final beforeCursor = text.substring(0, cursorPosition);
      final afterCursor = text.substring(cursorPosition);
      final newText = '$beforeCursor#$hashtag $afterCursor';
      _captionController.text = newText;
      _captionController.selection = TextSelection.collapsed(
        offset: (cursorPosition + hashtag.length + 2).clamp(0, newText.length),
      );
    } else {
      // Replace from "#" to cursor with the selected hashtag
      final beforeHashtag = text.substring(0, hashtagStart);
      final afterCursor = text.substring(cursorPosition);

      // Insert the selected hashtag (including the #)
      final newText = '$beforeHashtag#$hashtag $afterCursor';
      _captionController.text = newText;

      // Set cursor position after the inserted hashtag
      final newCursorPosition =
          hashtagStart + hashtag.length + 2; // +2 for "#" and space
      _captionController.selection = TextSelection.collapsed(
        offset: newCursorPosition.clamp(0, newText.length),
      );
    }

    // Close the hashtag box
    _closeHashtagBox();
  }

  // Show hashtag selection box (400 height overlay)
  void _showHashtagBox() {
    if (_isHashtagBoxOpen) return;

    final overlay = Overlay.of(context);
    final RenderBox? renderBox =
        _captionFieldKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _hashtagOverlay = OverlayEntry(
      builder: (context) => Positioned(
        left: 16,
        right: 16,
        top: position.dy + size.height + 8, // Position below caption field
        child: Material(
          color: Colors.transparent,
          child: HashtagSelectionBottomSheet(
            onHashtagSelected: (hashtag) {
              _insertHashtagAtCursor(hashtag);
            },
            onClose: () {
              _closeHashtagBox();
            },
          ),
        ),
      ),
    );

    overlay.insert(_hashtagOverlay!);
    setState(() {
      _isHashtagBoxOpen = true;
    });
  }

  // Close hashtag selection box
  void _closeHashtagBox() {
    if (_hashtagOverlay != null) {
      _hashtagOverlay!.remove();
      _hashtagOverlay = null;
      setState(() {
        _isHashtagBoxOpen = false;
      });
    }
  }

  // Show hashtag selection box (for button tap - insert "#" first, then open box)
  void _showHashtagSelection() {
    final text = _captionController.text;
    final selection = _captionController.selection;
    final cursorPosition = selection.baseOffset;

    if(text.isEmpty) {
      _captionController.selection;
    }
    // Insert "#" at cursor position if not already there
    final beforeCursor = text.substring(0, cursorPosition);
    final afterCursor = text.substring(cursorPosition);

    // Check if there's already a "#" right before cursor
    if (cursorPosition == 0 || text[cursorPosition - 1] != '#') {
      // Insert "#" at cursor
      final newText = '$beforeCursor#$afterCursor';
      _captionController.text = newText;

      // Set cursor position after the "#"
      _captionController.selection = TextSelection.collapsed(
        offset: (cursorPosition + 1).clamp(0, newText.length),
      );
    }

    // Small delay to ensure text is updated, then show hashtag box
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showHashtagBox();
    });
  }

  // Load video thumbnail (use current video, not finalized)
  Future<void> _loadVideoThumbnail() async {
    final ctrl = Get.find<CreateReelsController>();
    // Use current video state (not finalized) - finalized is only created on Save
    final media = ctrl.processedVideoFile.value ??
        ctrl.generatedVideo.value ??
        ctrl.selectedMedia.value;

    if (media == null) {
      setState(() {
        _videoThumbnail = null;
        _lastMediaPath = null;
      });
      return;
    }

    // Skip if we already loaded thumbnail for this media
    if (_lastMediaPath == media.path && _videoThumbnail != null) {
      return;
    }

    _lastMediaPath = media.path;

    // If it's an image, use it directly
    if (!ctrl.isVideo.value) {
      try {
        final imageBytes = await media.readAsBytes();
        if (mounted) {
          setState(() {
            _videoThumbnail = imageBytes;
            _isLoadingThumbnail = false;
          });
        }
        return;
      } catch (e) {
        debugPrint('Error loading image: $e');
        if (mounted) {
          setState(() {
            _isLoadingThumbnail = false;
          });
        }
      }
    }

    // If it's a video, generate thumbnail
    if (mounted) {
      setState(() {
        _isLoadingThumbnail = true;
      });
    }

    try {
      // Ensure video controller is initialized if available
      if (ctrl.videoController.value != null && 
          !ctrl.videoController.value!.value.isInitialized) {
        await ctrl.videoController.value!.initialize();
      }
      
      // Generate thumbnail at 1 second (or middle of video if duration available)
      int timeMs = 1000; // Default to 1 second
      
      // Try to get video duration and use middle frame
      try {
        if (ctrl.videoController.value != null && 
            ctrl.videoController.value!.value.isInitialized) {
          final duration = ctrl.videoController.value!.value.duration;
          if (duration.inMilliseconds > 0) {
            // Use 1 second or middle of video, whichever is smaller
            final middleMs = (duration.inMilliseconds / 2).toInt();
            timeMs = middleMs > 1000 ? middleMs : 1000;
          }
        }
      } catch (e) {
        debugPrint('Could not get video duration, using default: $e');
      }

      debugPrint('Generating thumbnail from video: ${media.path} at ${timeMs}ms');

      // OPTIMIZED: Reduced quality and use faster settings for faster thumbnail generation
      final thumbnailData = await VideoThumbnail.thumbnailData(
        video: media.path,
        imageFormat: ImageFormat.JPEG,
        timeMs: timeMs,
        quality: 50, // Reduced from 85 for faster generation
        maxWidth: 400, // Limit width for faster processing
        maxHeight: 400, // Limit height for faster processing
      );

      if (thumbnailData != null && mounted) {
        setState(() {
          _videoThumbnail = thumbnailData;
          _isLoadingThumbnail = false;
        });
        debugPrint('Thumbnail generated successfully');
      } else if (mounted) {
        setState(() {
          _isLoadingThumbnail = false;
        });
        debugPrint('Thumbnail data is null');
      }
    } catch (e) {
      debugPrint('Error generating video thumbnail: $e');
      if (mounted) {
        setState(() {
          _isLoadingThumbnail = false;
        });
      }
    }
  }

  // Edit thumbnail - allow user to select different frame or image
  Future<void> _editThumbnail() async {
    final ctrl = Get.find<CreateReelsController>();
    // Use current video state (not finalized) - finalized is only created on Save
    final media = ctrl.processedVideoFile.value ??
        ctrl.generatedVideo.value ??
        ctrl.selectedMedia.value;

    if (media == null || !ctrl.isVideo.value) return;

    // Show dialog to select frame position
    final timeMs = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Select Thumbnail Frame',
          style: TextStyle(color: whiteColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose a frame position (in seconds)',
              style: TextStyle(color: Colors.grey),
            ),
            20.height,
            TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(color: whiteColor),
              decoration: InputDecoration(
                hintText: 'Enter time (seconds)',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: (value) {
                try {
                  final seconds = double.parse(value);
                  final ms = (seconds * 1000).toInt();
                  Get.back(result: ms);
                } catch (e) {
                  // ShowToast.show(
                  //   message: 'Invalid time format',
                  //   type: ToastType.error,
                  // );
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: 1000); // Default to 1 second
            },
            child: Text('Use Default', style: TextStyle(color: appColor)),
          ),
        ],
      ),
    );

    if (timeMs != null && mounted) {
      setState(() {
        _isLoadingThumbnail = true;
      });

      try {
        // OPTIMIZED: Reduced quality for faster thumbnail generation
        final thumbnailData = await VideoThumbnail.thumbnailData(
          video: media.path,
          imageFormat: ImageFormat.JPEG,
          timeMs: timeMs,
          quality: 50, // Reduced from 85 for faster generation
          maxWidth: 400, // Limit width for faster processing
          maxHeight: 400, // Limit height for faster processing
        );

        if (thumbnailData != null && mounted) {
          setState(() {
            _videoThumbnail = thumbnailData;
            _isLoadingThumbnail = false;
          });
          // ShowToast.show(
          //   message: 'Thumbnail updated',
          //   type: ToastType.success,
          // );
        } else if (mounted) {
          setState(() {
            _isLoadingThumbnail = false;
          });
        }
      } catch (e) {
        debugPrint('Error generating thumbnail: $e');
        if (mounted) {
          setState(() {
            _isLoadingThumbnail = false;
          });
          // ShowToast.show(
          //   message: 'Failed to generate thumbnail',
          //   type: ToastType.error,
          // );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF0c0f14),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            AppBar(
        backgroundColor: Color(0XFF0c0f14),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () async {
            // CRITICAL: Resume video and music when going back from save screen
            final ctrl = Get.find<CreateReelsController>();
            
            // CRITICAL: Ensure video is properly initialized before resuming (especially for multi-image videos)
            if (ctrl.isVideo.value) {
              try {
                // Get the video file
                final videoFile = ctrl.processedVideoFile.value ?? 
                                 ctrl.generatedVideo.value ?? 
                                 ctrl.selectedMedia.value;
                
                // If video controller is null or not initialized, reinitialize it
                if (videoFile != null && 
                    (ctrl.videoController.value == null || 
                     !ctrl.videoController.value!.value.isInitialized ||
                     !ctrl.isVideoInitialized.value)) {
                  debugPrint('Video controller not initialized, reinitializing...');
                  await ctrl.reinitializeVideo(videoFile);

                  // Wait for initialization to complete
                  await Future.delayed(Duration(milliseconds: 500));
                }
                
                // Now check if video is properly initialized
                if (ctrl.videoController.value != null && 
                    ctrl.videoController.value!.value.isInitialized) {
                  // Re-add auto-play listener
                  ctrl.videoController.value!.addListener(ctrl.ensureVideoLooping);
                  
                  // Reset music selection active flag
                  ctrl.isMusicSelectionActive.value = false;
                  
                  if (!ctrl.isMusicAppliedToVideo.value) {
                    // If music is NOT applied to video, play video (muted) and background music
                    // First, ensure video is muted
                    await ctrl.videoController.value!.setVolume(0.0);
                    
                    // Play video
                    await ctrl.videoController.value!.play();
                    debugPrint('✅ Video resumed when going back from save screen');
                    
                    // CRITICAL: Resume background music if it was selected (for multi-image videos)
                    if (ctrl.selectedMusicPath.value.isNotEmpty && 
                        !ctrl.isMusicPlaying.value) {
                      // Wait a bit for video to start
                      await Future.delayed(Duration(milliseconds: 400));
                      
                      // Play background music without pausing video
                      await ctrl.playBackgroundMusicWithVideo();
                      debugPrint('✅ Background music resumed when going back from save screen');
                    }
                  } else {
                    await ctrl.videoController.value!.setVolume(1);

                    // If music IS applied to video, just play video (music is part of video audio)
                    await ctrl.videoController.value!.play();
                    debugPrint('✅ Video with embedded music resumed when going back from save screen');
                  }
                } else {
                  debugPrint('⚠️ Video controller still not initialized after reinitialization attempt');
                }
              } catch (e) {
                debugPrint('Error resuming video/music: $e');
              }
            }
            Get.back();
          },
        ),
        title: Text(
          'New reel',
          style: AppTextStyles.subHeading.copyWith(
            color: whiteColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
            Expanded(
              child: GetBuilder<CreateReelsController>(
        builder: (ctrl) {
          return Obx(() {
            // Get current video (not finalized) - finalized is only created on Save
            final media = ctrl.processedVideoFile.value ??
                ctrl.generatedVideo.value ??
                ctrl.selectedMedia.value;

            // Reload thumbnail when media changes
            if (media != null && _lastMediaPath != media.path) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _loadVideoThumbnail();
              });
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Cover image preview (thumbnail)
                  Container(
                    width: Get.width * 0.6,
                    height: Get.width * 0.9,
                    // 9:16 aspect ratio
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                              alpha: 0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Cover image
                          _buildCoverImagePreview(ctrl),
                          // Edit button overlay
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Material(
                              color: Colors.black.withValues(
                                  alpha: 0.5),
                              borderRadius: BorderRadius.circular(20),
                              child: InkWell(
                                onTap: _editThumbnail,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.edit,
                                    color: whiteColor,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Edit cover button
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 16),
                  //   child: ElevatedButton.icon(
                  //     onPressed: () {
                  //       // Edit cover button - no functionality needed
                  //       debugPrint('Edit cover pressed');
                  //     },
                  //     icon: Icon(Icons.edit, color: whiteColor, size: 18),
                  //     label: Text(
                  //       'Edit cover',
                  //       style: TextStyle(
                  //         color: whiteColor,
                  //         fontSize: 14,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.grey[800],
                  //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(8),
                  //       ),
                  //       elevation: 0,
                  //     ),
                  //   ),
                  // ),
                  20.height,
              Divider(color: Color(0xFF191a1f),),
                  // Caption input
                  Container(
                    key: _captionFieldKey,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    // decoration: BoxDecoration(
                    //   color: Colors.grey[900],
                    //   borderRadius: BorderRadius.circular(8),
                    //   border: Border.all(
                    //     color: Colors.grey[700]!,
                    //     width: 0.5,
                    //   ),
                    // ),
                    child: TextField(
                      controller: _captionController,
                      autofocus: true,
                      style: AppTextStyles.regular.copyWith(color: whiteColor),
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Write a caption and add hashtags...',
                        hintStyle: AppTextStyles.light.copyWith(color: Color(0xFF676b74),fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),

                  10.height,

                  // Hashtags button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: _showHashtagSelection,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xff25282d),

                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.tag, color: whiteColor, size: 14),
                              8.width,
                              Text(
                                'Hashtags',
                                style: AppTextStyles.light.copyWith(
                                  color: whiteColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  40.height,

                  // Save button
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    width: Get.width,
                    child: CustomButton(
                      onTap: () async {
                        // Save finalized reel - creates finalized video and saves it
                        try {
                          await ctrl.saveFinalizedReel();
                        } catch (e) {
                          debugPrint('Error saving reel: $e');
                        }
                      },
                      title: 'Save', isDisable: false,
                    ),
                  ),

                  // Add bottom padding for safe area
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                ],
              ),
            );
          });
        },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build cover image preview (thumbnail with filters and text)
  Widget _buildCoverImagePreview(CreateReelsController ctrl) {
    return Obx(() {
      final media = ctrl.processedVideoFile.value ??
          ctrl.generatedVideo.value ??
          ctrl.selectedMedia.value;

      if (media == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.grey, size: 32),
              8.height,
              Text(
                'No media available',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        );
      }

      // Get filter and gradient settings
      ColorFilter? colorFilter;
      bool needsGradient = false;

      try {
        colorFilter = ctrl.getSelectedColorFilter();
        needsGradient = ctrl.needsGradientOverlay();
      } catch (e) {
        debugPrint('Error accessing filter methods: $e');
        colorFilter = null;
        needsGradient = false;
      }

      // If it's an image, show with filters and text
      if (!ctrl.isVideo.value) {
        return Stack(
          fit: StackFit.expand,
          children: [
            ColorFiltered(
              colorFilter: colorFilter ??
                  ColorFilter.mode(Colors.transparent, BlendMode.dst),
              child: Image.file(
                media,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.grey, size: 32),
                        8.height,
                        Text(
                          'Failed to load image',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
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
            // Text overlays
            ..._buildTextOverlaysForThumbnail(ctrl),
          ],
        );
      }

      // If it's a video, show thumbnail with filters and text
      if (_isLoadingThumbnail) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(appColor),
          ),
        );
      }

      if (_videoThumbnail != null) {
        return Stack(
          fit: StackFit.expand,
          children: [
            ColorFiltered(
              colorFilter: colorFilter ??
                  ColorFilter.mode(Colors.transparent, BlendMode.dst),
              child: Image.memory(
                _videoThumbnail!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.grey, size: 32),
                        8.height,
                        Text(
                          'Failed to load thumbnail',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
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
                        Colors.black.withValues(alpha:0.5),
                        Colors.black.withValues(alpha:0.8),
                      ],
                      stops: [0.0, 0.5, 0.8, 1.0],
                    ),
                  ),
                ),
              ),
            // Text overlays
            ..._buildTextOverlaysForThumbnail(ctrl),
          ],
        );
      }

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, color: Colors.grey, size: 48),
            8.height,
            Text(
              'No thumbnail available',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    });
  }

  // Build text overlays for thumbnail (scaled to container size)
  List<Widget> _buildTextOverlaysForThumbnail(CreateReelsController ctrl) {
    if (ctrl.addedTexts.isEmpty) {
      return [];
    }

    // Container dimensions
    final containerWidth = Get.width * 0.6;
    final containerHeight = Get.width * 0.9;
    final screenWidth = Get.width;
    final screenHeight = Get.height;

    return ctrl.addedTexts.map((textData) {
      final text = textData['text'] as String? ?? '';
      final color = textData['color'] as Color? ?? Colors.white;
      final fontSize = textData['fontSize'] as double? ?? 20.0;
      final position = textData['position'] as Offset? ?? Offset.zero;
      final isBold = textData['isBold'] as bool? ?? false;
      final isItalic = textData['isItalic'] as bool? ?? false;
      final hasUnderline = textData['hasUnderline'] as bool? ?? false;
      final backgroundColor = textData['backgroundColor'] as Color?;
      final textAlign = textData['textAlign'] as TextAlign? ?? TextAlign.center;
      final rotation = textData['rotation'] as double? ?? 0.0;
      final scale = textData['scale'] as double? ?? 1.0;

      // Scale position from screen coordinates to container coordinates
      final xRatio = position.dx / screenWidth;
      final yRatio = position.dy / screenHeight;
      final displayPosition = Offset(
        xRatio * containerWidth,
        yRatio * containerHeight,
      );

      // Scale font size proportionally
      final scaledFontSize = fontSize * (containerWidth / screenWidth);

      return Positioned(
        left: displayPosition.dx,
        top: displayPosition.dy,
        child: Transform.rotate(
          angle: rotation,
          child: Transform.scale(
            scale: scale,
            child: Container(
              padding: backgroundColor != null
                  ? EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                  : null,
              decoration: backgroundColor != null
                  ? BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(4),
                    )
                  : null,
              child: Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: scaledFontSize,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                  decoration: hasUnderline
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
                textAlign: textAlign,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}
