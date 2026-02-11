
import 'dart:io';

import '../../../../../../utils/library_utils.dart';

class VideoTrimmingBottomSheet extends StatefulWidget {
  final CreateReelsController controller;

  const VideoTrimmingBottomSheet({super.key, required this.controller});

  @override
  State<VideoTrimmingBottomSheet> createState() =>
      _VideoTrimmingBottomSheetState();
}

class _VideoTrimmingBottomSheetState extends State<VideoTrimmingBottomSheet> {
  double _startTime = 0.0;
  double _endTime = 5.0;
  bool _isProcessing = false;
  List<Uint8List?> _thumbnails = [];
  double _maxDuration = 5.0;

  @override
  void initState() {
    super.initState();
    _initializeTimes();
    // CRITICAL: Load thumbnails immediately (they should be preloaded from background)
    // No loader shown - thumbnails are generated in background during video initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
    _loadThumbnails();
    });
  }

  void _initializeTimes() {
    // Check if we have a generated video from image conversion
    if (widget.controller.generatedVideo.value != null) {
      // Use generated video duration
      final duration = widget.controller.videoController.value?.value.duration;
      if (duration != null && duration.inMilliseconds > 0) {
        final calculatedDuration = (duration.inMilliseconds / 1000.0);
        if (!calculatedDuration.isNaN &&
            !calculatedDuration.isInfinite &&
            calculatedDuration > 0) {
          _maxDuration = calculatedDuration.clamp(0.1, 3600.0);
          _endTime = _maxDuration;
        } else {
          _endTime = 5.0;
          _maxDuration = 5.0;
        }
      } else {
        _endTime = 5.0;
        _maxDuration = 5.0;
      }
    } else if (widget.controller.isVideo.value) {
      // Use existing video duration
      final duration = widget.controller.videoController.value?.value.duration;
      if (duration != null && duration.inMilliseconds > 0) {
        final calculatedDuration = (duration.inMilliseconds / 1000.0);
        if (!calculatedDuration.isNaN &&
            !calculatedDuration.isInfinite &&
            calculatedDuration > 0) {
          _maxDuration = calculatedDuration.clamp(0.1, 3600.0);
          _endTime = _maxDuration;
        } else {
          _endTime = 5.0;
          _maxDuration = 5.0;
        }
      } else {
        _endTime = 5.0;
        _maxDuration = 5.0;
      }
    } else {
      // For images, default to 5 seconds (will be converted to video)
      _endTime = 5.0;
      _maxDuration = 5.0;
    }

    // Use controller's trim times if available
    if (widget.controller.videoStartTime.value > 0 ||
        widget.controller.videoEndTime.value > 0) {
      _startTime = widget.controller.videoStartTime.value;
      if (!_startTime.isNaN && !_startTime.isInfinite && _startTime >= 0) {
        if (widget.controller.videoEndTime.value > 0) {
          final endTimeValue = widget.controller.videoEndTime.value;
          if (!endTimeValue.isNaN &&
              !endTimeValue.isInfinite &&
              endTimeValue > _startTime) {
            _endTime = endTimeValue.clamp(_startTime + 0.5, _maxDuration);
          }
        }
      } else {
        _startTime = 0.0;
      }
    }

    // Ensure start time is valid
    if (_startTime.isNaN || _startTime.isInfinite || _startTime < 0) {
      _startTime = 0.0;
    }

    // Ensure end time is greater than start time and within max duration
    if (_endTime.isNaN || _endTime.isInfinite || _endTime <= _startTime) {
      _endTime = (_startTime + 5.0).clamp(_startTime + 1.0, _maxDuration);
    }

    if (_endTime > _maxDuration || _endTime.isNaN || _endTime.isInfinite) {
      _endTime = _maxDuration;
    }

    // Final validation - ensure all values are valid
    if (_maxDuration.isNaN || _maxDuration.isInfinite || _maxDuration <= 0) {
      _maxDuration = 5.0;
    }
    if (_startTime.isNaN || _startTime.isInfinite || _startTime < 0) {
      _startTime = 0.0;
    }
    if (_endTime.isNaN || _endTime.isInfinite || _endTime <= _startTime) {
      _endTime = _maxDuration;
    }
    if (_endTime > _maxDuration) {
      _endTime = _maxDuration;
    }
  }

  // Load thumbnails from video or image (use preloaded if available)
  // CRITICAL: No loader shown - thumbnails are generated in background during video initialization
  Future<void> _loadThumbnails() async {
    final mediaFile =
        widget.controller.generatedVideo.value ??
        widget.controller.selectedMedia.value;
    if (mediaFile == null) {
      if (mounted) {
        setState(() {
      _thumbnails = List.filled(10, null);
        });
      }
      return;
    }

    // CRITICAL: Check if thumbnails are already preloaded in controller (from background generation)
    if (widget.controller.thumbnailMediaPath.value == mediaFile.path &&
        widget.controller.preloadedThumbnails.isNotEmpty) {
      debugPrint('✅ Using preloaded thumbnails (instant load - no loader)');
      if (mounted) {
    setState(() {
          _thumbnails = List<Uint8List?>.from(widget.controller.preloadedThumbnails);
        });
      }
      return;
    }

    // CRITICAL: If thumbnails are being loaded in background, wait silently (no loader shown)
    if (widget.controller.isLoadingThumbnails.value &&
        widget.controller.thumbnailMediaPath.value == mediaFile.path) {
      debugPrint('⏳ Thumbnails loading in background, waiting silently...');
      // Wait up to 3 seconds for background loading to complete (silently)
      for (int i = 0; i < 30; i++) {
        await Future.delayed(Duration(milliseconds: 100));
        if (widget.controller.preloadedThumbnails.isNotEmpty &&
            widget.controller.thumbnailMediaPath.value == mediaFile.path) {
          debugPrint('✅ Preloaded thumbnails ready after wait');
          if (mounted) {
            setState(() {
              _thumbnails = List<Uint8List?>.from(widget.controller.preloadedThumbnails);
    });
          }
          return;
        }
        // If loading stopped but no thumbnails, break and generate silently
        if (!widget.controller.isLoadingThumbnails.value && 
            widget.controller.preloadedThumbnails.isEmpty) {
          break;
        }
      }
    }

    // CRITICAL: If no preloaded thumbnails available, generate them silently in background
    // Show placeholder thumbnails while generating (no loader)
    if (mounted) {
      setState(() {
        // Show placeholder thumbnails while generating
        _thumbnails = List.filled(10, null);
      });
    }

    // Generate thumbnails silently in background (non-blocking)
    Future.microtask(() async {
    try {
      final thumbnails = <Uint8List?>[];
      final thumbnailCount = 10;

      // Check if it's an image
      if (!widget.controller.isVideo.value) {
        // For images, use the same image for all thumbnails
        try {
          final imageBytes = await mediaFile.readAsBytes();
          // Create thumbnails from the same image
          for (int i = 0; i < thumbnailCount; i++) {
            thumbnails.add(imageBytes);
          }
            debugPrint('✅ Image thumbnails loaded silently');
        } catch (e) {
          debugPrint('Error loading image for thumbnails: $e');
          // Fallback to null thumbnails
          thumbnails.addAll(List.filled(thumbnailCount, null));
        }
      } else {
          // CRITICAL: For videos, generate thumbnails at different time positions (silently)

          // Get actual video duration
          double maxDuration = _maxDuration;
          if (widget.controller.videoController.value != null &&
              widget.controller.videoController.value!.value.isInitialized) {
            final duration = widget.controller.videoController.value!.value.duration;
            if (duration.inMilliseconds > 0) {
              maxDuration = duration.inMilliseconds / 1000.0;
            }
          } else if (widget.controller.videoDuration.value > 0) {
            maxDuration = widget.controller.videoDuration.value;
          }
          
        for (int i = 0; i < thumbnailCount; i++) {
          try {
            // Calculate time position for each thumbnail
              final timeMs = ((maxDuration / thumbnailCount) * i * 1000).toInt();
              final clampedTimeMs = timeMs.clamp(0, (maxDuration * 1000).toInt());

              // OPTIMIZED: Reduced quality and use faster settings for faster thumbnail generation
            final thumbnailData = await VideoThumbnail.thumbnailData(
              video: mediaFile.path,
              imageFormat: ImageFormat.JPEG,
                timeMs: clampedTimeMs,
                quality: 25, // Further reduced for faster generation
                maxWidth: 150, // Further reduced for faster processing
                maxHeight: 150, // Further reduced for faster processing
            );

            thumbnails.add(thumbnailData);
              
              // Update UI progressively as thumbnails are generated (no loader, just update)
              if (mounted && i % 2 == 0) { // Update every 2 thumbnails to avoid too many rebuilds
                setState(() {
                  // Update existing thumbnails list
                  if (_thumbnails.length < thumbnailCount) {
                    _thumbnails = List<Uint8List?>.from(thumbnails);
                    _thumbnails.addAll(List.filled(thumbnailCount - thumbnails.length, null));
                  } else {
                    for (int j = 0; j < thumbnails.length && j < _thumbnails.length; j++) {
                      _thumbnails[j] = thumbnails[j];
                    }
                  }
                });
              }
          } catch (e) {
            debugPrint('Error generating video thumbnail $i: $e');
            thumbnails.add(null);
          }
        }
          
          // CRITICAL: Update controller's preloaded thumbnails for future use
          if (mounted && thumbnails.isNotEmpty) {
            widget.controller.preloadedThumbnails.value = thumbnails;
            widget.controller.thumbnailMediaPath.value = mediaFile.path;
            widget.controller.isLoadingThumbnails.value = false;
          }
      }

        // Final update with all thumbnails
      if (mounted) {
        setState(() {
          _thumbnails = thumbnails;
        });
          debugPrint('✅ ${thumbnails.where((t) => t != null).length}/$thumbnailCount thumbnails loaded silently');
      }
    } catch (e) {
        debugPrint('Error loading thumbnails silently: $e');
      if (mounted) {
        setState(() {
          _thumbnails = List.filled(10, null);
        });
      }
    }
    });
  }

  String _formatDuration(double seconds) {
    // Safety check for NaN, infinite, or invalid values
    if (seconds.isNaN || seconds.isInfinite || seconds < 0) {
      seconds = 0.0;
    }
    // Clamp to reasonable maximum (99:59 = 5999 seconds)
    seconds = seconds.clamp(0.0, 5999.0);
    final minutes = (seconds / 60).floor();
    final secs = (seconds % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  // Calculate handle position safely to avoid NaN
  double _calculateHandlePosition(double time, double totalTime, double width) {
    // Validate all inputs - check for NaN, infinite, and invalid values
    if (totalTime <= 0 ||
        totalTime.isNaN ||
        totalTime.isInfinite ||
        time.isNaN ||
        time.isInfinite ||
        width <= 0 ||
        width.isNaN ||
        width.isInfinite) {
      return 0.0;
    }
    // Clamp time to valid range
    time = time.clamp(0.0, totalTime);
    final position = (time / totalTime) * width;
    if (position.isNaN || position.isInfinite || position < 0) {
      return 0.0;
    }
    return position.clamp(0.0, width);
  }

  Future<void> _trimVideo() async {
    if (_isProcessing) return;
    if (!mounted) return;
    setState(() {
      _isProcessing = true;
    });

    try {
      // If image, convert to 5-second video first
      if (!widget.controller.isVideo.value) {
        debugPrint('Converting image to video...');
        await _convertImageToVideo();

        // After conversion, always check if trimming is needed
        if (widget.controller.generatedVideo.value != null) {
          // Update max duration from the newly created video
          final newDuration =
              widget.controller.videoController.value?.value.duration;
          if (newDuration != null && newDuration.inMilliseconds > 0) {
            final calculatedDuration = (newDuration.inMilliseconds / 1000.0);
            if (!calculatedDuration.isNaN &&
                !calculatedDuration.isInfinite &&
                calculatedDuration > 0) {
              _maxDuration = calculatedDuration.clamp(0.1, 3600.0);
              // Reset end time to max duration if it's beyond
              if (_endTime > _maxDuration ||
                  _endTime.isNaN ||
                  _endTime.isInfinite) {
                _endTime = _maxDuration;
              }
            }
          }

          // Only trim if user changed the default duration or handles are adjusted
          if (_startTime > 0 || (_endTime < _maxDuration && _endTime < 5.0)) {
            debugPrint(
              'Trimming converted video: start=$_startTime, end=$_endTime, max=$_maxDuration',
            );
            await _trimVideoFile();
          } else {
            debugPrint('No trimming needed for converted video');
            // Still update controller trim times
            widget.controller.setVideoTrimTimes(_startTime, _endTime);
          }
        } else {
          throw Exception('Failed to convert image to video');
        }
      } else {
        // Direct video trimming
        debugPrint('Trimming existing video: start=$_startTime, end=$_endTime');
        await _trimVideoFile();
      }

      // Force UI update before closing bottom sheet
      widget.controller.update();
      await Future.delayed(Duration(milliseconds: 200));
      widget.controller.update();

      Get.back();

      // Show success message
      // ShowToast.show(
      //   message: widget.controller.isVideo.value
      //       ? 'Video trimmed successfully'
      //       : 'Video created successfully',
      //   type: ToastType.success,
      // );

      // Final update after closing bottom sheet to ensure UI refreshes
      await Future.delayed(Duration(milliseconds: 300));
      widget.controller.update();
    } catch (e) {
      debugPrint('Error in _trimVideo: $e');
      // ShowToast.show(message: 'Error: ${e.toString()}', type: ToastType.error);
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _trimVideoFile() async {
    final videoFile =
        widget.controller.processedVideoFile.value ??
        widget.controller.generatedVideo.value ??
        widget.controller.selectedMedia.value;
    if (videoFile == null) {
      throw Exception('No video file available for trimming');
    }

    debugPrint('Trimming video file: ${videoFile.path}');

    // Validate and fix times
    if (_startTime.isNaN || _startTime < 0) {
      _startTime = 0.0;
    }
    if (_endTime.isNaN || _endTime <= 0) {
      _endTime = 5.0;
    }
    if (_endTime <= _startTime) {
      _endTime = _startTime + 1.0;
    }

    widget.controller.isProcessingVideo.value = true;

    try {
      final tempDir = await getTemporaryDirectory();
      final outputPath =
          '${tempDir.path}/trimmed_video_${DateTime.now().millisecondsSinceEpoch}.mp4';

      final startSeconds = _startTime;
      final duration = (_endTime - _startTime).clamp(
        0.1,
        60.0,
      ); // Max 60 seconds
      final command =
          '-y '
          '-i "${videoFile.path}" '
          '-ss $startSeconds '
          '-t $duration '
          '-map 0:v:0 '
          '-map 0:a:0 '
          '-c:v copy '
          '-c:a aac '
          '-b:a 128k '
          '-ar 44100 '
          '-ac 2 '
          '-f mp4 '
          '-avoid_negative_ts make_zero '
          '-metadata:s:v:0 rotate=0 '
          '-shortest '
          '-movflags +faststart '
          '"$outputPath"';

      debugPrint(
        'Trimming video: start=$startSeconds, duration=$duration, input=${videoFile.path}',
      );
      debugPrint('FFmpeg command: $command');

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        final trimmedFile = File(outputPath);
        if (await trimmedFile.exists()) {
          debugPrint('Trimmed video created: ${trimmedFile.path}');

          // Update controller with trimmed video BEFORE reinitializing
          // Clear processedVideoFile since we're creating a new trimmed version
          widget.controller.processedVideoFile.value = null;
          widget.controller.selectedMedia.value = trimmedFile;
          widget.controller.generatedVideo.value = trimmedFile;
          widget.controller.isVideo.value = true; // Ensure video flag is set

          // Force state update before reinitializing
          widget.controller.update();
          await Future.delayed(Duration(milliseconds: 100));

          // Reinitialize video player with trimmed video
          // This will properly dispose old controller and create new one
          await widget.controller.reinitializeVideo(trimmedFile);

          // Wait for video controller to fully initialize
          await Future.delayed(Duration(milliseconds: 500));

          // Verify and ensure video is playing with retry logic
          int retryCount = 0;
          const maxRetries = 5;

          while (retryCount < maxRetries) {
            if (widget.controller.videoController.value == null) {
              debugPrint(
                'Video controller is null, retrying initialization... (attempt ${retryCount + 1})',
              );
              await widget.controller.reinitializeVideo(trimmedFile);
              await Future.delayed(Duration(milliseconds: 500));
              retryCount++;
              continue;
            }

            if (!widget.controller.videoController.value!.value.isInitialized) {
              debugPrint(
                'Video not initialized, retrying... (attempt ${retryCount + 1})',
              );
              try {
                await widget.controller.videoController.value!.initialize();
                await Future.delayed(Duration(milliseconds: 300));
              } catch (e) {
                debugPrint('Error initializing video: $e');
                // Reinitialize completely
                await widget.controller.reinitializeVideo(trimmedFile);
                await Future.delayed(Duration(milliseconds: 500));
              }
              retryCount++;
              continue;
            }

            // Video is initialized, check if playing
            if (!widget.controller.videoController.value!.value.isPlaying) {
              debugPrint(
                'Video not playing, starting playback... (attempt ${retryCount + 1})',
              );
              try {
                await widget.controller.videoController.value!.seekTo(
                  Duration.zero,
                );
                await widget.controller.videoController.value!.play();
                await Future.delayed(Duration(milliseconds: 400));
              } catch (e) {
                debugPrint('Error playing video: $e');
              }
            }

            // Verify it's actually playing
            if (widget.controller.videoController.value!.value.isInitialized &&
                widget.controller.videoController.value!.value.isPlaying) {
              debugPrint(
                'Video playback verified: isPlaying=true, duration=${widget.controller.videoController.value!.value.duration}',
              );
              break;
            }

            retryCount++;
            if (retryCount < maxRetries) {
              await Future.delayed(Duration(milliseconds: 500));
            }
          }

          // Final verification
          if (widget.controller.videoController.value != null &&
              widget.controller.videoController.value!.value.isInitialized) {
            widget.controller.isVideoInitialized.value = true;
            debugPrint(
              'Final video state: isInitialized=true, isPlaying=${widget.controller.videoController.value!.value.isPlaying}',
            );
          }

          // Force UI update multiple times to ensure refresh
          widget.controller.update();
          await Future.delayed(Duration(milliseconds: 200));
          widget.controller.update();
          await Future.delayed(Duration(milliseconds: 200));
          widget.controller.update();

          // Update _maxDuration with the new trimmed video duration
          final newDuration =
              widget.controller.videoController.value?.value.duration;
          if (newDuration != null && newDuration.inMilliseconds > 0) {
            final calculatedDuration = (newDuration.inMilliseconds / 1000.0);
            // Validate and clamp duration to reasonable values
            if (!calculatedDuration.isNaN &&
                !calculatedDuration.isInfinite &&
                calculatedDuration > 0) {
              _maxDuration = calculatedDuration.clamp(
                0.1,
                3600.0,
              ); // Max 1 hour
            } else {
              _maxDuration = duration.clamp(0.1, 3600.0);
            }
          } else {
            // Use the trimmed duration as fallback
            _maxDuration = duration.clamp(0.1, 3600.0);
          }

          // Update trim times - reset to full trimmed video duration for next trim
          _startTime = 0.0;
          _endTime = _maxDuration;

          // Validate times
          if (_endTime.isNaN || _endTime.isInfinite || _endTime <= 0) {
            _endTime = _maxDuration;
          }
          if (_startTime.isNaN || _startTime.isInfinite || _startTime < 0) {
            _startTime = 0.0;
          }
          // Ensure end time is valid
          if (_endTime > _maxDuration) {
            _endTime = _maxDuration;
          }

          // Update trim times in controller (reset to full video)
          widget.controller.setVideoTrimTimes(_startTime, _endTime);

          // Re-initialize times to ensure state is correct for next trim
          _initializeTimes();

          // CRITICAL: Clear old thumbnails and reload with new duration
          widget.controller.clearPreloadedThumbnails();

          // Reload thumbnails with new duration only if widget is still mounted
          if (mounted) {
            await _loadThumbnails();
            setState(() {});
          }
          
          // CRITICAL: Ensure thumbnails are preloaded for future use
          widget.controller.ensureThumbnailsGenerated();

          debugPrint(
            'Video trimmed successfully: $outputPath, new duration: $_maxDuration, start: $_startTime, end: $_endTime',
          );
        } else {
          throw Exception('Trimmed video file not found');
        }
      } else {
        final output = await session.getOutput();
        final failureStackTrace = await session.getFailStackTrace();
        debugPrint('FFmpeg trimming error: $output');
        debugPrint('FFmpeg failure stack trace: $failureStackTrace');
        throw Exception(
          'FFmpeg trimming failed: ${output ?? failureStackTrace ?? "Unknown error"}',
        );
      }
    } catch (e) {
      debugPrint('Error trimming video: $e');
      rethrow;
    } finally {
      widget.controller.isProcessingVideo.value = false;
      // Don't call initialize here - it's already handled in reinitializeVideo
      widget.controller.update();
    }
  }

  Future<void> _convertImageToVideo() async {
    widget.controller.isProcessingVideo.value = true;

    try {
      final imageFile = widget.controller.selectedMedia.value!;
      final tempDir = await getTemporaryDirectory();

      final tempImage = await imageFile.copy(
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final outputPath =
          '${tempDir.path}/image_video_${DateTime.now().millisecondsSinceEpoch}.mp4';

      // FFmpeg command to convert image to 5-second video
      // Preserve original image dimensions (don't force specific size)
      // -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2": Ensure even dimensions for codec compatibility
      // -pix_fmt yuv420p: Required pixel format for compatibility
      // -f lavfi -i "anullsrc=channel_layout=stereo:sample_rate=44100": Add silent audio track
      // -c:a aac: Encode audio to AAC (MP4-compatible)
      // -metadata:s:v:0 rotate=0: Set rotation metadata to 0 (prevents auto-rotation)
      // -shortest: Finish encoding when shortest input stream ends
      final command =
          '-y '
          '-loop 1 '
          '-framerate 30 '
          '-i "${tempImage.path}" '
          '-f lavfi '
          '-i "anullsrc=channel_layout=stereo:sample_rate=44100" '
          '-vf "scale=trunc(iw/2)*2:trunc(ih/2)*2,format=yuv420p" '
          '-t 5 '
          '-c:v libx264 '
          '-preset medium '
          '-crf 23 '
          '-pix_fmt yuv420p '
          '-profile:v baseline '
          '-level 3.0 '
          '-c:a aac '
          '-b:a 128k '
          '-ar 44100 '
          '-ac 2 '
          '-metadata:s:v:0 rotate=0 '
          '-shortest '
          '-movflags +faststart '
          '-f mp4 '
          '"$outputPath"';

      debugPrint('FFmpeg command for image to video:\n$command');

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

      /// ✅ update controller
      widget.controller.generatedVideo.value = video;
      widget.controller.selectedMedia.value = video;
      widget.controller.isVideo.value = true;

      await widget.controller.reinitializeVideo(video);

      // Update times for the newly created 5-second video
      _startTime = 0;
      _endTime = 5;
      _maxDuration = 5;
      widget.controller.videoDuration.value = 5;

      // Reload thumbnails after video creation
      await _loadThumbnails();

      setState(() {});
      debugPrint('✅ Image → video success: $outputPath');
    } catch (e) {
      debugPrint('❌ Error converting image to video: $e');
      rethrow;
    } finally {
      widget.controller.isProcessingVideo.value = false;
    }
  }

  Future<File> copyToTemp(File original) async {
    final dir = await getTemporaryDirectory();
    final newPath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    return original.copy(newPath);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: true,
      child: Container(
      height: Get.height * 0.6,
      decoration: BoxDecoration(
        color: bottomsheetbgcolor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.controller.isVideo.value
                      ? 'Trim Video'
                      : 'Create Video',
                  style: AppTextStyles.subHeading.copyWith(
                    color: whiteColor,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: whiteColor),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),

          // Instruction text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Tap on a track to trim. Pinch to zoom.',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ),

          20.height,

          // Timeline
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  /// Timeline track
                  SizedBox(
                    height: 60,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        /// Thumbnails track
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                                  children: List.generate(10, (index) {
                                    return Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[600],
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                        ),
                                        child:
                                            _thumbnails.length > index &&
                                                _thumbnails[index] != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                child: Image.memory(
                                                  _thumbnails[index]!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Container(
                                                          color:
                                                              Colors.grey[600],
                                                          child: Icon(
                                                            Icons.image,
                                                            color: Colors
                                                                .grey[400],
                                                            size: 16,
                                                          ),
                                                        );
                                                      },
                                                ),
                                              )
                                            : Container(
                                                color: Colors.grey[600],
                                                child: Icon(
                                                  Icons.image,
                                                  color: Colors.grey[400],
                                                  size: 16,
                                                ),
                                              ),
                                      ),
                                    );
                                  }),
                                ),
                        ),

                        /// ================= START HANDLE =================
                        if (_endTime > 0 &&
                            !_endTime.isNaN &&
                            !_startTime.isNaN &&
                            _maxDuration > 0)
                          Positioned(
                            left:
                                _calculateHandlePosition(
                                  _startTime,
                                  _maxDuration,
                                  Get.width - 32,
                                ) -
                                20, // Center the handle on the position
                            top: 0,
                            bottom: 0,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTapDown: (_) {
                                debugPrint("Start handle tapped");
                              },
                              onPanUpdate: (details) {
                                final width = Get.width - 32;
                                if (width <= 0) return;

                                // Use maxDuration for ratio calculation
                                final ratio = _maxDuration / width;
                                final deltaTime = details.delta.dx * ratio;

                                final maxStart = (_endTime - 0.5).clamp(
                                  0.0,
                                  _maxDuration,
                                );
                                final newStart = (_startTime + deltaTime).clamp(
                                  0.0,
                                  maxStart,
                                );

                                if (!newStart.isNaN && newStart < _endTime) {
                                  setState(() => _startTime = newStart);
                                }
                              },
                              child: Container(
                                width: 30, // GOOD touch area
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: whiteColor,
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.drag_handle,
                                  color: blackColor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),

                        /// ================= END HANDLE =================
                        if (_endTime > 0 &&
                            !_endTime.isNaN &&
                            !_startTime.isNaN &&
                            _maxDuration > 0)
                          Positioned(
                            left:
                                _calculateHandlePosition(
                                  _endTime,
                                  _maxDuration,
                                  Get.width - 32,
                                ) -
                                20, // Center the handle on the position
                            top: 0,
                            bottom: 0,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTapDown: (_) {
                                debugPrint("End handle tapped");
                              },
                              onPanUpdate: (details) {
                                final width = Get.width - 32;
                                if (width <= 0) return;

                                // Use maxDuration instead of _endTime for ratio calculation
                                final ratio = _maxDuration / width;
                                final deltaTime = details.delta.dx * ratio;

                                final minEnd = (_startTime + 0.5).clamp(
                                  0.0,
                                  _maxDuration,
                                );
                                final newEnd = (_endTime + deltaTime).clamp(
                                  minEnd,
                                  _maxDuration,
                                );

                                if (!newEnd.isNaN &&
                                    newEnd > _startTime &&
                                    newEnd <= _maxDuration) {
                                  setState(() {
                                    _endTime = newEnd;
                                  });
                                }
                              },
                              child: Container(
                                width: 30, // GOOD touch area
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: whiteColor,
                                ),
                                alignment: Alignment.center,

                                child: const Icon(
                                  Icons.drag_handle,
                                  color: blackColor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),

                        /// ============= SELECTED RANGE OVERLAY ============
                        if (_endTime > 0 &&
                            !_endTime.isNaN &&
                            !_startTime.isNaN &&
                            _maxDuration > 0)
                          Positioned(
                            left: _calculateHandlePosition(
                              _startTime,
                              _maxDuration,
                              Get.width - 32,
                            ),
                            right:
                                (Get.width - 32) -
                                _calculateHandlePosition(
                                  _endTime,
                                  _maxDuration,
                                  Get.width - 32,
                                ),
                            top: 0,
                            bottom: 0,
                            child: SizedBox(),
                            // child:
                            // IgnorePointer(
                            //   ignoring: true,
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //       color: appColor.withValues(alpha:0.3),
                            //       border: Border.symmetric(
                            //         vertical:
                            //         BorderSide(color: appColor, width: 2),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Time labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_startTime),
                        style: const TextStyle(color: whiteColor, fontSize: 10),
                      ),
                      Text(
                        _formatDuration(_endTime),
                        style: const TextStyle(color: whiteColor, fontSize: 10),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Duration text
                  Text(
                    'Duration: ${_formatDuration((_endTime - _startTime).clamp(0.0, _maxDuration))}',
                    style: const TextStyle(
                      color: whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: _isProcessing ? null : () => Get.back(),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: grey27282Color,

                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 16,
                            ),
                            child: Text(
                             'Cancel',
                              style: AppTextStyles.heading2.copyWith(
                                color: whiteColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: _isProcessing ? null : _trimVideo,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: whiteColor,
                          ),
                          child: _isProcessing
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 16,
                                  ),
                                child: const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        appColor,
                                      ),
                                    ),
                                  ),
                              )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    widget.controller.isVideo.value
                                        ? 'Trim'
                                        : 'Create',
                                    style: AppTextStyles.heading2.copyWith(
                                      color: blackColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
