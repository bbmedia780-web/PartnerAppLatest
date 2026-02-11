import '../../../../../../utils/library_utils.dart';

class MusicTrimmingBottomSheet extends StatefulWidget {
  final CreateReelsController controller;

  const MusicTrimmingBottomSheet({
    super.key,
    required this.controller,
  });

  @override
  State<MusicTrimmingBottomSheet> createState() => _MusicTrimmingBottomSheetState();
}

class _MusicTrimmingBottomSheetState extends State<MusicTrimmingBottomSheet> {
  final ScrollController _scrollController = ScrollController();
  bool _isProcessing = false;

  // Waveform constants
  static const double dotWidth = 4;
  double dotSpacing = 8; // Will be calculated based on song duration
  // CRITICAL: 1 dot per 1 second of music
  static const double dotsPerSecond = 1.0;

  // Time calculation
  final double pixelsPerSecond = 100;
  double minSelectionWidth = 60; // Will be set to 1/3 of screen width

  // Handle positions (in pixels relative to waveform)
  double leftHandleX = 0;
  double rightHandleX = 150;
  double startTime = 0;
  double endTime = 0;

  // Audio duration
  double audioDuration = 30;
  int totalDots = 0;
  late List<double> dotHeights;
  double maxWaveWidth = 0;

  // Drag state
  bool isDraggingHandle = false;

  // Position tracking
  Timer? _positionSubscription;
  double _currentPlaybackPosition = 0.0;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_updateTimeFromScroll);
    _scrollController.addListener(_clampScrollToAudioDuration);

    // CRITICAL: Stop video when trimming sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.controller.isVideo.value &&
          widget.controller.videoController.value != null &&
          widget.controller.videoController.value!.value.isInitialized) {
        try {
          await widget.controller.videoController.value!.pause();
          await widget.controller.videoController.value!.setVolume(0.0);
          widget.controller.videoController.value!.removeListener(widget.controller.ensureVideoLooping);
          widget.controller.isMusicSelectionActive.value = true;
          debugPrint('✅ Video stopped when trimming sheet opened');
        } catch (e) {
          debugPrint('Error stopping video: $e');
        }
      }

      // Load audio duration and initialize
      await _loadAudioDuration();
      _initializeWaveform();

      // Setup position tracking when music is playing
      if (widget.controller.isMusicPlaying.value) {
        _setupPositionTracking();
      }
    });
  }

  // Load actual audio duration from controller
  Future<void> _loadAudioDuration() async {
    try {
      final duration = await widget.controller.getAudioDuration();
      if (duration != null && duration.inMilliseconds > 0) {
        setState(() {
          audioDuration = duration.inSeconds.toDouble();
        });
        debugPrint('✅ Audio duration loaded: ${audioDuration}s');
      } else {
        debugPrint('⚠️ Could not get audio duration, using default: ${audioDuration}s');
      }
    } catch (e) {
      debugPrint('Error loading audio duration: $e');
    }
  }

  void _initializeWaveform() {
    if (audioDuration > 0 && !audioDuration.isNaN && !audioDuration.isInfinite) {
      totalDots = (audioDuration * dotsPerSecond).ceil(); // 1 dot per second
      if (totalDots < 1) totalDots = 1;
    } else {
      totalDots = 1; // Fallback
    }
    dotHeights = _generateDotHeights(totalDots);
      if (totalDots > 1) {
      if (audioDuration <= 15) {
        // Very short songs: tight spacing (4-6px) like in 3rd image
        dotSpacing = 30;
      } else if (audioDuration <= 30) {
        // Short songs: moderate spacing
        dotSpacing = 25;
      } else if (audioDuration <= 60) {
        // Medium songs: normal spacing
        dotSpacing = 8.0;
      } else {
        // Long songs: more spacing for better visibility
        dotSpacing = 10.0;
      }
    } else {
      dotSpacing = 4; // Default spacing for single dot
    }
    final screenWidth = Get.width - 32;
    final selectionBoxWidth = screenWidth / 2;
    final sidePadding = (screenWidth - selectionBoxWidth) / 2;

// ✅ FIRST calculate wave width
    maxWaveWidth =
        (totalDots * dotWidth) + ((totalDots - 1) * dotSpacing);

// ✅ THEN calculate full scrollable width
    final fullWaveWidth = maxWaveWidth + (sidePadding * 2);

    debugPrint('maxWaveWidth: $maxWaveWidth');
    debugPrint('fullWaveWidth: $fullWaveWidth'); final calculatedWaveWidth = (totalDots * dotWidth) + ((totalDots - 1) * dotSpacing);
    maxWaveWidth = calculatedWaveWidth;

    // CRITICAL: Calculate pixels per second based on actual wave width
    // This ensures accurate time-to-pixel conversion
    double calculatedPixelsPerSecond = maxWaveWidth / audioDuration;

    // CRITICAL: Set selection box width to 1/3 of screen width
    minSelectionWidth = screenWidth / 2.0;

    // Initialize from controller if values are already set
    bool hasExistingSelection = widget.controller.musicStartTime.value > 0.0 &&
        widget.controller.musicEndTime.value > 0.0 &&
        widget.controller.musicEndTime.value <= audioDuration;

    if (hasExistingSelection) {
      startTime = widget.controller.musicStartTime.value;
      endTime = widget.controller.musicEndTime.value;
    } else {
      // CRITICAL: Get video duration for default selection duration - must match exactly
      double videoDuration = 10.0;
      if (widget.controller.isVideo.value &&
          widget.controller.videoController.value != null &&
          widget.controller.videoController.value!.value.isInitialized) {
        final duration = widget.controller.videoController.value!.value.duration;
        if (duration.inMilliseconds > 0) {
          videoDuration = duration.inSeconds.toDouble();
        }
      }

      // CRITICAL: Use video duration exactly for selection box duration
      // Ensure it doesn't exceed audio duration
      final selectionDuration = videoDuration.clamp(1.0, audioDuration);

      // Start selection at the beginning (left side)
      startTime = 0.0;
      endTime = selectionDuration; // Use video duration exactly
    }

    // CRITICAL: Selection box is FIXED at center of screen
    // No need to initialize handle positions - they're fixed on screen
    // Times will be calculated based on what's under the fixed selection box

    // CRITICAL: Initialize selection box FIXED at screen center
    // Selection box is fixed on screen, wave scrolls underneath
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final screenWidth = Get.width - 32;
        final selectionBoxWidth = screenWidth / 2.0;
        final viewportCenter = screenWidth / 2;
        final selectionBoxLeft = viewportCenter - (selectionBoxWidth / 2);

        // CRITICAL: Selection box is FIXED at center of screen
        // Calculate initial scroll position so that startTime is under selection box left
        if (!hasExistingSelection) {
          startTime = 0.0;
          endTime = (selectionBoxWidth / calculatedPixelsPerSecond).clamp(1.0, audioDuration);
        }
        final maxScroll = (fullWaveWidth - screenWidth).clamp(0.0, double.infinity);

        // Calculate initial scroll position: selectionBoxLeft = (startTime * pps) - scrollOffset
        // scrollOffset = (startTime * pps) - selectionBoxLeft
        final initialScrollOffset =
        (startTime * calculatedPixelsPerSecond - selectionBoxLeft)
            .clamp(0.0, maxScroll);
        debugPrint('maxWaveWidth: $maxWaveWidth');
        debugPrint('fullWaveWidth: $fullWaveWidth');
        // Scroll to initial position
        _scrollController.jumpTo(initialScrollOffset);

        // Update times based on what's under the fixed selection box
        _updateTimes();
        setState(() {});
      }
    });

    setState(() {});
  }

  List<double> _generateDotHeights(int count) {
    return List.generate(count, (i) {
      const pattern = [20.0, 40.0, 30.0, 35.0, 20.0, 12.0, 35.0, 20.0, 6.0];
      return pattern[i % pattern.length];
    });
  }

  double get _calculatedPixelsPerSecond {
    if (audioDuration <= 0 || audioDuration.isNaN || audioDuration.isInfinite) {
      return 100.0; // Default fallback
    }
    final pps = maxWaveWidth / audioDuration;
    if (pps.isNaN || pps.isInfinite || pps <= 0) {
      return 100.0; // Default fallback
    }
    return pps;
  }

  void _clampScrollToAudioDuration() {
    if (!_scrollController.hasClients) return;

    final screenWidth = Get.width - 32;

    final selectionBoxWidth = screenWidth / 2;
    final sidePadding = (screenWidth - selectionBoxWidth) / 2;
    final fullWaveWidth = maxWaveWidth + (sidePadding * 2);

    final maxScroll =
    (fullWaveWidth - screenWidth).clamp(0.0, double.infinity);
    // If scroll position exceeds max scroll, clamp it
    final currentScroll = _scrollController.offset;
    if (currentScroll > maxScroll || currentScroll.isNaN || currentScroll.isInfinite) {
      if (!maxScroll.isNaN && !maxScroll.isInfinite && maxScroll >= 0) {
        _scrollController.jumpTo(maxScroll.clamp(0.0, maxWaveWidth));
      } else {
        _scrollController.jumpTo(0.0);
      }
    }
  }

  void _updateTimeFromScroll() {
    if (!_scrollController.hasClients) return;

    // Validate values before calculation
    final scrollOffset = _scrollController.offset;
    if (scrollOffset.isNaN || scrollOffset.isInfinite) return;

    final pps = _calculatedPixelsPerSecond;
    if (pps <= 0 || pps.isNaN || pps.isInfinite) return;

    // CRITICAL: Selection box is FIXED at center of screen
    // Calculate what time is currently under the fixed selection box
    final screenWidth = Get.width - 32;
    final viewportCenter = screenWidth / 2;
    final selectionBoxWidth = screenWidth / 2.0;
    final selectionBoxLeft = viewportCenter - (selectionBoxWidth / 2);
    final selectionBoxRight = selectionBoxLeft + selectionBoxWidth;

    // Calculate times based on what's under the fixed selection box
    // When wave scrolls, content moves: absolutePosition = scrollOffset + screenPosition
    final calculatedStartTime = (scrollOffset + selectionBoxLeft) / pps;
    final calculatedEndTime = (scrollOffset + selectionBoxRight) / pps;

    // Validate calculated times
    if (calculatedStartTime.isNaN || calculatedStartTime.isInfinite ||
        calculatedEndTime.isNaN || calculatedEndTime.isInfinite) {
      return;
    }

    // CRITICAL: Clamp times to audio duration to prevent "Invalid argument(s)" error
    startTime = calculatedStartTime.clamp(0.0, audioDuration);
    endTime = calculatedEndTime.clamp(startTime + 0.1, audioDuration);

    // Final validation - ensure times don't exceed audio duration
    if (startTime > audioDuration) startTime = audioDuration;
    if (endTime > audioDuration) endTime = audioDuration;
    if (startTime.isNaN || startTime.isInfinite || endTime.isNaN || endTime.isInfinite) return;

    // CRITICAL: Update UI immediately when scrolling to show selection area changes in real-time
    setState(() {});
  }

  void _updateTimes() {
    if (!_scrollController.hasClients) return;

    // Validate values before calculation
    final scrollOffset = _scrollController.offset;
    if (scrollOffset.isNaN || scrollOffset.isInfinite) return;

    final pps = _calculatedPixelsPerSecond;
    if (pps <= 0 || pps.isNaN || pps.isInfinite) return;

    // CRITICAL: Selection box is FIXED at center of screen
    // Calculate what time is currently under the fixed selection box
    final screenWidth = Get.width - 32;
    final viewportCenter = screenWidth / 2;
    final selectionBoxWidth = screenWidth / 2.0;
    // final selectionBoxLeft = viewportCenter - (selectionBoxWidth / 2);
    final selectionBoxLeft = viewportCenter - (selectionBoxWidth / 2);
    final selectionBoxRight = selectionBoxLeft + selectionBoxWidth;

    // Calculate times based on what's under the fixed selection box
    final calculatedStartTime = (scrollOffset + selectionBoxLeft ) / pps;
    final calculatedEndTime = (scrollOffset + selectionBoxRight) / pps;

    // Validate calculated times
    if (calculatedStartTime.isNaN || calculatedStartTime.isInfinite ||
        calculatedEndTime.isNaN || calculatedEndTime.isInfinite) {
      return;
    }

    startTime = calculatedStartTime.clamp(0.0, audioDuration);
    endTime = calculatedEndTime.clamp(startTime + 0.1, audioDuration);

    // Final validation
    if (startTime.isNaN || startTime.isInfinite || endTime.isNaN || endTime.isInfinite) return;

    setState(() {});
  }

  // void _onLeftDrag(double dx) {
  //   try {
  //     if (!_scrollController.hasClients) return;
  //
  //     // Validate inputs
  //     if (dx.isNaN || dx.isInfinite) return;
  //
  //     final screenWidth = Get.width - 32;
  //     if (screenWidth <= 0 || screenWidth.isNaN || screenWidth.isInfinite) return;
  //
  //     final currentScroll = _scrollController.offset;
  //     if (currentScroll.isNaN || currentScroll.isInfinite) return;
  //
  //     final pps = _calculatedPixelsPerSecond;
  //     if (pps <= 0 || pps.isNaN || pps.isInfinite) return;
  //
  //     // CRITICAL: Selection box is FIXED at center of screen
  //     // Dragging left handle scrolls the wave to change what's under the selection box
  //     final viewportCenter = screenWidth / 2;
  //     final selectionBoxWidth = screenWidth / 2.0;
  //     final selectionBoxLeft = viewportCenter - (selectionBoxWidth / 2);
  //
  //     // Calculate current time under selection box left
  //     final currentTimeUnderSelection = (currentScroll + selectionBoxLeft) / pps;
  //
  //     // Calculate new time based on drag (negative dx means moving left, which should decrease time)
  //     final newTime = (currentTimeUnderSelection - (dx / pps)).clamp(0.0, audioDuration);
  //
  //     // Calculate new scroll position so that newTime is under selection box left
  //     // selectionBoxLeft = (newTime * pps) - newScroll
  //     // newScroll = (newTime * pps) - selectionBoxLeft
  //     final maxScroll = (maxWaveWidth ).clamp(0.0, double.infinity);
  //     final newScroll = (newTime * pps ).clamp(0.0, maxScroll);
  //
  //     if (!newScroll.isNaN && !newScroll.isInfinite) {
  //       _scrollController.jumpTo(newScroll);
  //       _updateTimes();
  //       setState(() {});
  //     }
  //   } catch (e) {
  //     debugPrint('Error in left drag: $e');
  //   }
  // }

  // void _onRightDrag(double dx) {
  //   try {
  //     if (!_scrollController.hasClients) return;
  //
  //     // Validate inputs
  //     if (dx.isNaN || dx.isInfinite) return;
  //
  //     final screenWidth = Get.width - 32;
  //     if (screenWidth <= 0 || screenWidth.isNaN || screenWidth.isInfinite) return;
  //
  //     final currentScroll = _scrollController.offset;
  //     if (currentScroll.isNaN || currentScroll.isInfinite) return;
  //
  //     final pps = _calculatedPixelsPerSecond;
  //     if (pps <= 0 || pps.isNaN || pps.isInfinite) return;
  //
  //     // CRITICAL: Selection box is FIXED at center of screen
  //     // Dragging right handle scrolls the wave to change what's under the selection box
  //     final viewportCenter = screenWidth / 2;
  //     final selectionBoxWidth = screenWidth / 2.0;
  //     final selectionBoxRight = viewportCenter + (selectionBoxWidth / 2);
  //
  //     // Calculate current time under selection box right
  //     final currentTimeUnderSelection = (currentScroll + selectionBoxRight) / pps;
  //
  //     // Calculate new time based on drag (positive dx means moving right, which should increase time)
  //     final newTime = (currentTimeUnderSelection + (dx / pps)).clamp(0.0, audioDuration);
  //
  //     // Calculate new scroll position so that newTime is under selection box right
  //     // selectionBoxRight = (newTime * pps) - newScroll
  //     // newScroll = (newTime * pps) - selectionBoxRight
  //     final maxScroll = (maxWaveWidth - screenWidth).clamp(0.0, double.infinity);
  //     final newScroll = (newTime * pps - selectionBoxRight).clamp(0.0, maxScroll);
  //
  //     if (!newScroll.isNaN && !newScroll.isInfinite) {
  //       _scrollController.jumpTo(newScroll);
  //       _updateTimes();
  //       setState(() {});
  //     }
  //   } catch (e) {
  //     debugPrint('Error in right drag: $e');
  //   }
  // }
  // Setup position tracking for playback indicator
  void _setupPositionTracking() {
    _positionSubscription?.cancel();

    // Start exactly at the selection start
    _currentPlaybackPosition = startTime;

    setState(() {});

    _positionSubscription = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted || !widget.controller.isMusicPlaying.value) {
        timer.cancel();
        _positionSubscription = null;
        return;
      }

      widget.controller.getCurrentMusicPosition().then((position) {
        if (!mounted || position == null) return;

        // Use double for precision (e.g., 1.5 seconds)
        final double currentPos = position.inMilliseconds / 1000.0;

        // Logic: Only update if we are within the selection bounds
        if (currentPos >= startTime && currentPos <= endTime) {
          // Only trigger setState if the 'integer' second has changed
          // This creates the "second-wise" jump effect
          if ((currentPos - _currentPlaybackPosition).abs() >= 0.05) {
            setState(() {
              _currentPlaybackPosition = currentPos;
            });
          }
        }
        // Stop if we pass the end
        else if (currentPos > endTime) {
          timer.cancel();
          _positionSubscription = null;
          widget.controller.stopMusic();
          setState(() {
            _currentPlaybackPosition = startTime;
          });
        }
      });
    });
  }

  // Done button - Apply trimmed music to video
  Future<void> _applyMusicSegment() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Stop music preview
      await widget.controller.stopMusic();

      // Store the selected segment times in controller
      widget.controller.musicStartTime.value = startTime;
      widget.controller.musicEndTime.value = endTime;

      // CRITICAL: Ensure music selection state is preserved before closing
      // This ensures the music indicator shows after applying music
      // if (widget.controller.selectedMusic.value.isEmpty) {
        // If music was somehow cleared, restore it from the path
        final musicIndex = widget.controller.selectedMusicIndex.value;
        if (musicIndex >= 0 && musicIndex < widget.controller.musicList.length) {
          final music = widget.controller.musicList[musicIndex];
          widget.controller.selectedMusic.value = music['name'] ?? '';
          widget.controller.selectedMusicArtist.value = music['artist'] ?? '';
          widget.controller.selectedMusicImgPath.value = music['image'] ?? '';
          TrimmedMusicDB.storeTrimmedMusic(musicName: music['name'], musicArtist: music['artist'], musicImagePath: music['image'], musicPath: music['audio'], startTime: startTime, endTime: endTime);
        }
      // }

      widget.controller.update();

      // Close the trimming sheet
      Get.back();

      // Also close the music selection sheet if it's still open
      if (Get.isBottomSheetOpen ?? false) {
        Get.back();
      }

      // Verify video is ready before applying music
      final videoFile = widget.controller.processedVideoFile.value ??
          widget.controller.generatedVideo.value ??
          widget.controller.selectedMedia.value;

      if (widget.controller.isVideo.value && videoFile != null) {
        // Apply trimmed music to video
        await widget.controller.applyTrimmedMusicToVideo();

        // CRITICAL: Force UI update after applying music to ensure music indicator shows
        widget.controller.update();

        // Also trigger reactive update
        widget.controller.selectedMusic.refresh();
        widget.controller.isMusicAppliedToVideo.refresh();
      }
    } catch (e) {
      debugPrint('❌ Error applying music segment: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    _scrollController.dispose();
    widget.controller.stopMusic();

    // Resume video if music is not applied
    if (widget.controller.isVideo.value &&
        widget.controller.videoController.value != null &&
        widget.controller.videoController.value!.value.isInitialized &&
        !widget.controller.isMusicAppliedToVideo.value) {
      try {
        widget.controller.videoController.value!.addListener(widget.controller.ensureVideoLooping);
        widget.controller.isMusicSelectionActive.value = false;
        widget.controller.videoController.value!.setVolume(1.0);
        widget.controller.videoController.value!.play();
        debugPrint('✅ Video resumed after closing trimming sheet');
      } catch (e) {
        debugPrint('Error resuming video: $e');
      }
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: true,
      child: Container(
        height: Get.height * 0.92,
        decoration: BoxDecoration(
          color: transparent,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header with Done button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isProcessing ? null : _applyMusicSegment,
                    child: _isProcessing
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(whiteColor),
                      ),
                    )
                        : Text(
                      'Done',
                      style: AppTextStyles.regular.copyWith(
                        color: whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Music info section
            Obx(() {
              if (widget.controller.selectedMusic.value.isEmpty) {
                return SizedBox.shrink();
              }

              return Column(
                children: [
                  // Music thumbnail/icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(8),
                      image: widget.controller.selectedMusicImgPath.value.isNotEmpty
                          ? DecorationImage(
                        image: AssetImage(widget.controller.selectedMusicImgPath.value),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: widget.controller.selectedMusicImgPath.value.isEmpty
                        ? Icon(Icons.music_note, color: whiteColor, size: 40)
                        : null,
                  ),

                  16.height,

                  // Song title
                  Text(
                    widget.controller.selectedMusic.value,
                    style: AppTextStyles.subHeading.copyWith(
                      color: whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  4.height,

                  // Artist name
                  Text(
                    widget.controller.selectedMusicArtist.value,
                    style: AppTextStyles.regular.copyWith(
                      color: greytextcolor,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  50.height,
                ],
              );
            }),

            24.height,

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Choose the part that you want for your reel.',
                      style: AppTextStyles.regular.copyWith(
                          color: greytextcolor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                    15.height,

                    // CRITICAL: Waveform UI with dynamic width based on wave length
                SizedBox(
                  width: Get.width - 32,
                  height: 90,
                  child: Container(
                    decoration: BoxDecoration(
                      color: appColor.withValues(alpha:0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        IgnorePointer(
                          ignoring: isDraggingHandle,
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (notification) {
                              // CRITICAL: Update UI immediately when scrolling to show selection changes in real-time
                              if (notification is ScrollUpdateNotification || 
                                  notification is ScrollEndNotification) {
                                // Update times based on new scroll position
                                _updateTimeFromScroll();
                                // Force UI rebuild to show updated selection colors
                                setState(() {});
                              }
                              return false;
                            },
                            child: ListView.builder(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              physics: const ClampingScrollPhysics(),
                              itemCount: totalDots, // +2 for spacers
                              itemBuilder: (_, index) {
                                final screenWidth = Get.width - 32;
                                final selectionBoxWidth = screenWidth / 2.0;
                                final sidePadding = (screenWidth - selectionBoxWidth) / 2.0;
                                // CRITICAL: Get current scroll offset for real-time updates
                                double scrollOffset = 0.0;
                                if (_scrollController.hasClients) {
                                  scrollOffset = _scrollController.offset;
                                }

                                // 1. LEFT SPACER
                                if (index == 0) {
                                  return Container(width: sidePadding);
                                }

                                // 2. RIGHT SPACER
                                if (index == totalDots + 1) {
                                  return Container(width: sidePadding);
                                }

                                // 3. ACTUAL DOT LOGIC
                                final i = index - 1;
                                final dotTime = i / dotsPerSecond;

                                // IDENTIFY THE LAST DOT
                                final bool isLastDot = (i == totalDots - 1);

                                // Modified check: If it's the last dot, don't shrink it even if time math is tight
                                if (dotTime >= audioDuration && !isLastDot) {
                                  return const SizedBox.shrink();
                                }

                                // CRITICAL: Calculate dot's absolute position in ListView
                                // Dot position = left spacer width + (dot index * (dot width + spacing))
                                final dotAbsolutePosition = sidePadding + (i * (dotWidth + dotSpacing));

                                // CRITICAL: Calculate dot's screen position (accounting for scroll)
                                // When scrolling right, content moves left, so subtract scrollOffset
                                final dotScreenPosition = dotAbsolutePosition - scrollOffset;

                                // CRITICAL: Selection box is FIXED at center of screen
                                final selectionBoxLeft = sidePadding;
                                final selectionBoxRight = sidePadding + selectionBoxWidth;

                                final double selectionStartX = selectionBoxLeft;
                                final double selectionEndX = selectionBoxRight;

                                final bool isInsideSelection =
                                    dotScreenPosition >= selectionStartX &&
                                        dotScreenPosition <= selectionEndX;
                                final double secondsFromSelectionStart =
                                ((dotAbsolutePosition - (scrollOffset + selectionStartX))
                                    / _calculatedPixelsPerSecond);

                                final int selectionDotIndex = secondsFromSelectionStart.floor();

                                final double playedInsideSelection =
                                (_currentPlaybackPosition - startTime).clamp(0.0, endTime - startTime);

                                final bool isCurrentlyPlaying =
                                    widget.controller.isMusicPlaying.value &&
                                        selectionDotIndex >= 0 &&
                                        playedInsideSelection >= selectionDotIndex &&
                                        playedInsideSelection < selectionDotIndex + 1;

                                final bool hasBeenPlayed =
                                    widget.controller.isMusicPlaying.value &&
                                        selectionDotIndex >= 0 &&
                                        playedInsideSelection >= selectionDotIndex + 1;
                                Color dotColor;

                                if (isInsideSelection && selectionDotIndex >= 0) {
                                  if (isCurrentlyPlaying) {
                                    dotColor = appColor;
                                  } else if (hasBeenPlayed) {
                                    dotColor = appColor.withValues(alpha:0.8);
                                  } else {
                                    dotColor = whiteColor;
                                  }
                                } else {
                                  dotColor = whiteColor.withValues(alpha:0.3);
                                }



                                return Padding(
                                  padding: EdgeInsets.only(right: dotSpacing),
                                  child: SizedBox(
                                    width: dotWidth,
                                    child: Center(
                                      child: AnimatedContainer(
                                        duration: isDraggingHandle 
                                            ? Duration.zero 
                                            : const Duration(milliseconds: 80),
                                        width: dotWidth,
                                        height: dotHeights[i],
                                        decoration: BoxDecoration(
                                          color: dotColor,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                    ),
                                  ),
                                );

                              },
                            ),
                          ),
                        ),

                        /// ─────────────────────────────────────────────
                        /// FIXED CENTER SELECTION BOX
                        /// ─────────────────────────────────────────────
                        Builder(
                          builder: (_) {
                            final screenWidth = Get.width - 32;
                            final selectionBoxWidth = screenWidth / 2;
                            final left = (screenWidth - selectionBoxWidth) / 2;

                            return Positioned(
                              left: left,
                              top: 10,
                              bottom: 10,
                              child: Container(
                                width: selectionBoxWidth,
                                decoration: BoxDecoration(
                                  border: Border.all(color: appColor, width: 2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            );
                          },
                        ),

                        /// ─────────────────────────────────────────────
                        /// LEFT HANDLE
                        /// ─────────────────────────────────────────────
                        // Builder(
                        //   builder: (_) {
                        //     final screenWidth = Get.width - 32;
                        //     final selectionBoxWidth = screenWidth / 2;
                        //     final left = (screenWidth - selectionBoxWidth) / 2;
                        //
                        //     return Positioned(
                        //       left: left - 10,
                        //       top: 0,
                        //       bottom: 0,
                        //       child: _TrimHandle(
                        //         onDrag: _onLeftDrag,
                        //         onDragStart: () {
                        //           setState(() => isDraggingHandle = true);
                        //           widget.controller.stopMusic();
                        //         },
                        //         onDragEnd: () {
                        //           setState(() => isDraggingHandle = false);
                        //         },
                        //       ),
                        //     );
                        //   },
                        // ),

                        /// ─────────────────────────────────────────────
                        /// RIGHT HANDLE
                        /// ─────────────────────────────────────────────
                        // Builder(
                        //   builder: (_) {
                        //     final screenWidth = Get.width - 32;
                        //     final selectionBoxWidth = screenWidth / 2;
                        //     final right =
                        //         (screenWidth + selectionBoxWidth) / 2;
                        //
                        //     return Positioned(
                        //       left: right - 12,
                        //       top: 0,
                        //       bottom: 0,
                        //       child: _TrimHandle(
                        //         onDrag: _onRightDrag,
                        //         onDragStart: () {
                        //           setState(() => isDraggingHandle = true);
                        //           widget.controller.stopMusic();
                        //         },
                        //         onDragEnd: () {
                        //           setState(() => isDraggingHandle = false);
                        //         },
                        //       ),
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),


                20.height,

                    // Play button
                    Obx(() {
                      if (widget.controller.selectedMusicPath.value.isEmpty) {
                        return SizedBox.shrink();
                      }

                      final isPlaying = widget.controller.isMusicPlaying.value;

                      return GestureDetector(
                          onTap: () async {
                            if (isPlaying) {
                              // CRITICAL: Stop position tracking first
                              _positionSubscription?.cancel();
                              _positionSubscription = null;
                              
                              // Pause/stop music
                              await widget.controller.toggleMusicPlayPause();
                              
                              // Update UI
                              setState(() {
                                // Keep current position for UI, but stop updating
                              });
                            } else {
                              // CRITICAL: Reset playback position to start of selection
                              _currentPlaybackPosition = startTime;
                              
                              // Stop any existing music and position tracking first
                              _positionSubscription?.cancel();
                              _positionSubscription = null;
                              await widget.controller.stopMusic();
                              
                              // Small delay to ensure stop completes
                              await Future.delayed(Duration(milliseconds: 150));
                              
                              // Play trimmed segment from start
                              await widget.controller.playMusicAtPosition(startTime, endTime);
                              
                              // CRITICAL: Wait for music to actually start playing
                              await Future.delayed(Duration(milliseconds: 300));
                              
                              // Verify music is playing before setting up tracking
                              if (mounted && widget.controller.isMusicPlaying.value) {
                                // CRITICAL: Initialize position to startTime to show first dot (second 0) of selection
                                // This ensures playback indicator starts from the first dot of the selected area
                                _currentPlaybackPosition = startTime;
                                _setupPositionTracking(); // This will also set position to startTime and update UI
                                setState(() {}); // Update UI when playing starts
                              } else {
                                // If music didn't start, reset position to show first dot
                                if (mounted) {
                                  setState(() {
                                    _currentPlaybackPosition = startTime; // First dot of selection
                                  });
                                }
                              }
                            }
                          },
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: appColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: appColor.withValues(alpha:0.5),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: SizedBox(
                              height: 25,
                              width: 25,
                              child: Center(
                                child: Padding(
                                  padding: !isPlaying
                                      ? EdgeInsets.only(left: 6, top: 4, bottom: 4, right: 4)
                                      : const EdgeInsets.all(4),
                                  child: Image.asset(
                                    isPlaying ? AppImages.pauseIcon : AppImages.playIcon,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                    20.height,
                  ],
                ),
              ),
            ),

            // Bottom spacing
            24.height,
          ],
        ),
      ),
    );
  }
}

// Trim handle widget (same as working code)
// class _TrimHandle extends StatelessWidget {
//   final Function(double) onDrag;
//   final VoidCallback onDragStart;
//   final VoidCallback onDragEnd;
//
//   const _TrimHandle({
//     required this.onDrag,
//     required this.onDragStart,
//     required this.onDragEnd,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onHorizontalDragStart: (_) => onDragStart(),
//       onHorizontalDragUpdate: (d) => onDrag(d.delta.dx),
//       onHorizontalDragEnd: (_) => onDragEnd(),
//       onHorizontalDragCancel: () => onDragEnd(),
//       child: SizedBox(
//         width: 28,
//         height: double.infinity,
//         child: Center(
//           child: Container(
//             width: 4,
//             height: 36,
//             decoration: BoxDecoration(
//               color: appColor,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
