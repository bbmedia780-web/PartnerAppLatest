import 'package:card_swiper/card_swiper.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../../constarits/colors.dart';
import 'components/like_icon.dart';
import 'components/screen_options.dart';
import 'components/url_checker.dart';
import 'models/reels_model.dart';

class ReelsPage extends StatefulWidget {
  final ReelModel item;
  final bool showVerifiedTick;
  final Function(String)? onShare;
  final Function(String)? onLike;
  final Function(String)? onComment;
  final Function()? onClickMoreBtn;
  final Function()? onFollow;
  final SwiperController swiperController;
  final bool showProgressIndicator;
  const ReelsPage({
    Key? key,
    required this.item,
    this.showVerifiedTick = true,
    this.onClickMoreBtn,
    this.onComment,
    this.onFollow,
    this.onLike,
    this.onShare,
    this.showProgressIndicator = true,
    required this.swiperController,
  }) : super(key: key);

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> with RouteAware  {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _liked = false;
  @override
  void initState() {
    super.initState();
    if (!UrlChecker.isImageUrl(widget.item.url) &&
        UrlChecker.isValid(widget.item.url)) {
      _initializePlayer();
    }
  }
  @override
  void didPushNext() {
    _stopVideo(); // pause when another screen opens
  }

  @override
  void didPop() {
    _stopVideo();
  }

  @override
  void didPopNext() {
    _initializePlayer(); // resume if needed
  }
  Future<void> _stopVideo() async {
    try {
      await _chewieController?.pause();
      await _videoPlayerController?.pause();

      await _videoPlayerController?.dispose();

      _chewieController = null;
      _videoPlayerController?.dispose();
    } catch (e) {
      debugPrint("Video dispose error: $e");
    }
  }
  // ✅ Initialize Video
  Future<void> _initializePlayer() async {
    await _stopVideo();

    _videoPlayerController = VideoPlayerController.network(widget.item.url);
    await _videoPlayerController!.initialize();


    if(_videoPlayerController!=null){
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: true,
      );
    }
    setState(() {});

    _videoPlayerController!.addListener(() {
      final controller = _videoPlayerController!;
      if (controller.value.position >= controller.value.duration &&
          controller.value.isInitialized) {
        widget.swiperController.next();
      }
    });
  }
  @override
  void dispose() {
    debugPrint('Dispose controller =========>>> ');
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (_videoPlayerController?.value.isPlaying ?? false) {
          _videoPlayerController?.pause();
        }
      },
      child: _buildVideoView(),
    );
  }

  Widget _buildVideoView() {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (_chewieController != null &&
            _videoPlayerController?.value.isInitialized == true)
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: GestureDetector(
                onDoubleTap: () {
                  if (!widget.item.isLiked) {
                    _liked = true;
                    widget.onLike?.call(widget.item.url);
                    setState(() {});
                  }
                },
                onTap: () {
                  if (_videoPlayerController?.value.isPlaying ?? false) {
                    _videoPlayerController?.pause();
                  } else {
                    _videoPlayerController?.play();
                  }
                },
                child: Chewie(
                  controller: _chewieController!,
                ),
              ),
            ),
          )
        else
           Center(
            child: CircularProgressIndicator(color: whiteColor,),
          ),

        if (_liked) const Center(child: LikeIcon()),

        if (widget.showProgressIndicator &&
            _videoPlayerController != null)
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: VideoProgressIndicator(
              _videoPlayerController!,
              allowScrubbing: false,
              colors:  VideoProgressColors(
                backgroundColor: Colors.white,
                bufferedColor: Colors.grey,
                playedColor: Color(0xFFD74C7C),
              ),
            ),
          ),

        ScreenOptions(
          onClickMoreBtn: widget.onClickMoreBtn,
          onComment: widget.onComment,
          onFollow: widget.onFollow,
          onLike: widget.onLike,
          showVerifiedTick: widget.showVerifiedTick,
          item: widget.item,
        )
      ],
    );
  }
}