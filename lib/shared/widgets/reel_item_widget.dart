import '../../../../../utils/library_utils.dart';

class ReelItemWidget extends StatefulWidget {
  final Map<String, dynamic> reel;
  final int index;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const ReelItemWidget({
    super.key,
    required this.reel,
    required this.index,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  });

  @override
  State<ReelItemWidget> createState() => _ReelItemWidgetState();
}

class _ReelItemWidgetState extends State<ReelItemWidget> with WidgetsBindingObserver {
  late ReelsController controller;
  bool _showLikeAnimation = false;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = Get.find<ReelsController>();
    
    // CRITICAL: Check visibility after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // CRITICAL: Stop video completely when widget is disposed
    if (controller.videoControllers.containsKey(widget.index)) {
      final videoController = controller.videoControllers[widget.index];
      if (videoController != null && videoController.value.isInitialized) {
        // CRITICAL: Stop playback completely
        videoController.pause();
        videoController.setVolume(0.0);
        videoController.seekTo(Duration.zero);
        controller.isPlaying[widget.index] = false;
      }
    }
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // CRITICAL: Pause video when app goes to background
    if (state == AppLifecycleState.paused || 
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      if (controller.videoControllers.containsKey(widget.index)) {
        controller.pauseVideo(widget.index);
      }
    }
  }
  
  // CRITICAL: Check if this reel item is currently visible (Instagram-like behavior)
  void _checkVisibility() {
    if (!mounted) return;
    
    final isCurrentReel = controller.currentIndex.value == widget.index;
    
    if (isCurrentReel && !_isVisible) {
      _isVisible = true;
      // CRITICAL: Play video with audio if it's the current reel and initialized
      if (controller.videoControllers.containsKey(widget.index) &&
          controller.isInitialized[widget.index] == true) {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted && controller.currentIndex.value == widget.index) {
            final videoController = controller.videoControllers[widget.index];
            if (videoController != null && videoController.value.isInitialized) {
              // CRITICAL: Reset to beginning and play
              videoController.seekTo(Duration.zero);
              // CRITICAL: Set volume based on mute state
              videoController.setVolume(controller.globalMuteState.value ? 0.0 : 1.0);
              controller.playVideo(widget.index);
              debugPrint('✅ Playing video ${widget.index} (muted: ${controller.globalMuteState.value})');
            }
          }
        });
      }
    } else if (!isCurrentReel && _isVisible) {
      _isVisible = false;
      // CRITICAL: Stop video completely if it's not the current reel
      if (controller.videoControllers.containsKey(widget.index)) {
        final videoController = controller.videoControllers[widget.index];
        if (videoController != null && videoController.value.isInitialized) {
          // CRITICAL: Pause, mute, and reset to prevent looping
          videoController.pause();
          videoController.setVolume(0.0);
          videoController.seekTo(Duration.zero);
          controller.isPlaying[widget.index] = false;
          debugPrint('✅ Stopped video ${widget.index} (not current reel)');
        }
      }
    }
  }

  void _handleDoubleTap() {
    setState(() {
      _showLikeAnimation = true;
    });
    controller.onDoubleTapLike(widget.index);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showLikeAnimation = false;
        });
      }
    });
  }

  void _handleTap() {
    controller.showVideoControls(widget.index);
    controller.togglePlayPause(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    final hasVideo = controller.videoControllers.containsKey(widget.index);
    final isInitialized = controller.isInitialized[widget.index] ?? false;
    final isCurrentReel = controller.currentIndex.value == widget.index;
    
    // CRITICAL: Check visibility when building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });

    return Stack(
      children: [
        // Video/Image Area
        GestureDetector(
          onTap: _handleTap,
          onDoubleTap: _handleDoubleTap,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: Obx(() {
              // final videoController = controller.videoControllers[widget.index]!;
              // final isPlaying = controller.isPlaying[widget.index] ?? false;
              // final showControls = controller.showControls[widget.index] ?? false;
                    
             return Center(
                child:controller.videoControllers[widget.index]==null?CircularProgressIndicator(): AspectRatio(
                  aspectRatio: controller.videoControllers[widget.index]!.value.aspectRatio,
                  child: VideoPlayer(controller.videoControllers[widget.index]!),
                                ),
                      );
            })
          ),
        ),
        // Gradient overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),
        ),
        // Double tap like animation
        if (_showLikeAnimation)
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 80,
                ),
              ),
            ),
          ),
        // Content overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Left side - Title, Description, Music
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // User/Title
                      Text(
                        widget.reel['title'] as String,
                        style: AppTextStyles.subHeading.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: whiteColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Description
                      Text(
                        widget.reel['description'] as String,
                        style: AppTextStyles.regular.copyWith(
                          fontSize: 14,
                          color: whiteColor.withOpacity(0.9),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Music
                      Row(
                        children: [
                          Image.asset(
                            AppImages.micIcon,
                            width: 16,
                            height: 16,
                            color: whiteColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.reel['audio'] as String,
                            style: AppTextStyles.light.copyWith(
                              fontSize: 12,
                              color: whiteColor.withOpacity(0.8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Right side - Action buttons (Reactive)
                Obx(() {
                  final reel = controller.reels[widget.index];
                  final isLiked = reel['isLiked'] as bool;
                  final likes = reel['likes'] as int;
                  final comments = reel['comments'] as int;
                  final isMuted = controller.globalMuteState.value;
                  
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Mute/Unmute button
                      _buildActionButton(
                        icon: isMuted ? Icons.volume_off : Icons.volume_up,
                        label: isMuted ? 'Muted' : 'Sound',
                        onTap: () => controller.toggleMute(),
                        iconColor: whiteColor,
                      ),
                      const SizedBox(height: 24),
                      // Like button
                      _buildActionButton(
                        icon: isLiked ? Icons.favorite : Icons.favorite_border,
                        label: _formatCount(likes),
                        onTap: widget.onLike,
                        iconColor: isLiked ? Colors.red : whiteColor,
                      ),
                      const SizedBox(height: 24),
                      // Comment button
                      _buildActionButton(
                        icon: Icons.comment_outlined,
                        label: _formatCount(comments),
                        onTap: widget.onComment,
                        iconColor: whiteColor,
                      ),
                      const SizedBox(height: 24),
                      // Share button
                      _buildActionButton(
                        icon: Icons.share_outlined,
                        label: 'Share',
                        onTap: widget.onShare,
                        iconColor: whiteColor,
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
        // Video progress indicator (if video is playing)
        if (hasVideo && isInitialized)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(() {
              final videoController = controller.videoControllers[widget.index];
              final isPlaying = controller.isPlaying[widget.index] ?? false;
              
              if (videoController != null && 
                  videoController.value.isInitialized && 
                  isPlaying) {
                final position = videoController.value.position;
                final duration = videoController.value.duration;
                final progress = duration.inMilliseconds > 0
                    ? position.inMilliseconds / duration.inMilliseconds
                    : 0.0;
                return Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      color: tealColor,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          widget.reel['thumbnail'] as String,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: kColorGray,
              child: const Center(
                child: Icon(Icons.video_library, color: Colors.white54, size: 64),
              ),
            );
          },
        ),
        Container(
          color: Colors.black.withOpacity(0.2),
          child: const Center(
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white70,
              size: 64,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          widget.reel['thumbnail'] as String,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: kColorGray,
            );
          },
        ),
        Container(
          color: Colors.black.withOpacity(0.4),
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.light.copyWith(
              fontSize: 12,
              color: whiteColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
