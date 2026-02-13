

import '../../../../../../utils/library_utils.dart';

class MusicSelectionBottomSheet extends StatelessWidget {
  final CreateReelsController controller;

  const MusicSelectionBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: true,
      child: Container(
        height: ((MediaQuery.of(context).size.height)) * 0.5,
        decoration: BoxDecoration(
          color: bottomsheetbgcolor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: searchBgColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextField(
                      style: AppTextStyles.regular.copyWith(
                        color: whiteColor,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search..',
                        hintStyle: AppTextStyles.regular.copyWith(
                          color: greytextcolor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        prefixIcon: Icon(Icons.search, color: greytextcolor),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Obx(
                    () => Row(
                      children: [
                        _buildCategoryTab(
                          'For you',
                          controller.selectedMusicTab.value == 0,
                          () => controller.changeMusicTab(0),
                        ),
                        8.width,
                        _buildCategoryTab(
                          'Trending',
                          controller.selectedMusicTab.value == 1,
                          () => controller.changeMusicTab(1),
                        ),
                        8.width,
                        _buildCategoryTab(
                          'Saved',
                          controller.selectedMusicTab.value == 2,
                          () => controller.changeMusicTab(2),
                        ),
                        8.width,
                        // _buildCategoryTab('Original audio', controller.selectedMusicTab.value == 3, () => controller.changeMusicTab(3)),
                      ],
                    ),
                  ),
                ),

                10.height,
                // Obx(() => controller.selectedMusic.value.isNotEmpty
                //     ? Container(
                //         margin: EdgeInsets.symmetric(horizontal: 16),
                //         padding: EdgeInsets.all(12),
                //         decoration: BoxDecoration(
                //           color: Colors.grey[800],
                //           borderRadius: BorderRadius.circular(8),
                //         ),
                //         child: Row(
                //           children: [
                //             Container(
                //               width: 60,
                //               height: 60,
                //               decoration: BoxDecoration(
                //                 color: Colors.grey[700],
                //                 borderRadius: BorderRadius.circular(8),
                //               ),
                //               child: Icon(Icons.music_note, color: whiteColor),
                //             ),
                //             12.width,
                //             Expanded(
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text(
                //                     controller.selectedMusic.value,
                //                     style: AppTextStyles.regular.copyWith(
                //                       color: whiteColor,
                //                       fontSize: 14,
                //                       fontWeight: FontWeight.bold,
                //                     ),
                //                   ),
                //                   4.height,
                //                   Text(
                //                     controller.selectedMusicArtist.value,
                //                     style: AppTextStyles.regular.copyWith(
                //                       color: Colors.grey,
                //                       fontSize: 12,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //             GestureDetector(
                //               onTap: () => controller.toggleMusicPlayPause(),
                //               child: Icon(
                //                 controller.isMusicPlaying.value
                //                     ? Icons.pause_circle_outline
                //                     : Icons.play_circle_outline,
                //                 color: whiteColor,
                //                 size: 28,
                //               ),
                //             ),
                //           ],
                //         ),
                //       )
                //     : SizedBox.shrink()),

                // Music list
                Expanded(
                  child: Obx(() {
                    final filteredMusicList = controller.getFilteredMusicList();

                    if (filteredMusicList.isEmpty) {
                      return Center(
                        child: Text(
                          'No music available',
                          style: AppTextStyles.regular.copyWith(
                            color: greytextcolor,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: controller.selectedMusic.value.isNotEmpty
                            ? 80
                            : 00,
                      ),
                      child: ListView.builder(
                        itemCount: filteredMusicList.length,
                        itemBuilder: (context, index) {
                          final music = filteredMusicList[index];
                          final musicName = music['name'] as String;
                          final originalIndex = controller.musicList.indexWhere(
                            (m) => m['name'] == musicName,
                          );

                          return Obx(() {
                            return GestureDetector(
                              onTap: () async {
                                await controller.selectMusic(
                                  music,
                                  originalIndex >= 0 ? originalIndex : index,
                                );
                              },
                              child: Container(
                                // margin: EdgeInsets.only(bottom: 12),
                                // padding: EdgeInsets.only(bottom: 4),
                                decoration: BoxDecoration(
                                  color:
                                      controller.selectedMusicIndex.value ==
                                          originalIndex
                                      ? Color(0xff2b3036)
                                      : Colors.transparent,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    top: 8,
                                    bottom: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[700],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          image: DecorationImage(
                                            image: AssetImage(
                                              music['image'] ?? AppImages.img3,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      12.width,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              musicName,
                                              style: AppTextStyles.regular
                                                  .copyWith(
                                                    color: whiteColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            2.height,
                                            Text(
                                              '${music['artist'] ?? ''}',
                                              style: AppTextStyles.regular
                                                  .copyWith(
                                                    color: greytextcolor,
                                                    fontSize: 12,
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Save/Unsave button
                                      Obx(() {
                                        final isSavedNow = controller
                                            .isMusicSaved(musicName);
                                        return IconButton(
                                          icon: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Image.asset(
                                              isSavedNow
                                                  ? AppImages.bookmarkFillIcon
                                                  : AppImages
                                                        .bookmarkOutlineIcon,
                                              color: whiteColor,
                                            ),
                                          ),
                                          onPressed: () {
                                            controller.toggleSaveMusic(
                                              musicName,
                                            );
                                          },
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    );
                  }),
                ),

                // Bottom audio player bar
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Obx(() {
                if (controller.selectedMusic.value.isEmpty) {
                  return SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xff1b4249),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage(
                                controller.selectedMusicImgPath.value,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        12.width,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                controller.selectedMusic.value,
                                style: AppTextStyles.regular.copyWith(
                                  color: whiteColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              2.height,
                              Text(
                                controller.selectedMusicArtist.value,
                                style: AppTextStyles.regular.copyWith(
                                  color: greytextcolor,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        12.width,
                        Obx(() {
                          // CRITICAL: Check actual player state, not just isMusicPlaying
                          final isActuallyPlaying =
                              controller.isMusicPlaying.value;

                          return IconButton(
                            icon: SizedBox(
                              height: 20,
                              width: 20,
                              child: Image.asset(
                                isActuallyPlaying
                                    ? AppImages.pauseIcon
                                    : AppImages.playIcon,
                                color: whiteColor,
                              ),
                            ),
                            onPressed: () async {
                              // If playing, pause. If paused/stopped, play selected music
                              if (isActuallyPlaying) {
                                await controller.toggleMusicPlayPause();
                              } else {
                                // Play the selected music
                                await controller.playSelectedMusic();
                              }
                            },
                          );
                        }),
                        // Step 3: Right arrow button to open trimming sheet
                        IconButton(
                          icon: CircleAvatar(
                            radius: 15,
                            backgroundColor: whiteColor,
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Image.asset(AppImages.arrowRightIcon),
                            ),
                          ),
                          onPressed: () async {
                            // Pause current music before opening trimming sheet
                            if (controller.isMusicPlaying.value) {
                              controller.toggleMusicPlayPause();
                            }

                            // CRITICAL: Ensure video is paused and muted when opening trimming sheet
                            if (controller.isVideo.value &&
                                controller.videoController.value != null &&
                                controller
                                    .videoController
                                    .value!
                                    .value
                                    .isInitialized) {
                              try {
                                // Pause video first to stop playback
                                await controller.videoController.value!.pause();
                                // Then mute to release audio focus
                                await controller.videoController.value!
                                    .setVolume(0.0);
                                debugPrint(
                                  '✅ Video paused and muted for music trimming',
                                );
                              } catch (e) {
                                debugPrint('Error pausing video: $e');
                              }
                            }
                            controller.isNextForTrim.value = true;
                            Get.back();
                            // Close music selection sheet
                            showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                isDismissible: true,
                                enableDrag: true,
                                context: context, builder: (context){
                              return MusicTrimmingBottomSheet(
                                controller: controller,
                              );
                            }).then((_) async {
                                  // CRITICAL: Add small delay to ensure bottom sheet is fully closed
                                  await Future.delayed(
                                    Duration(milliseconds: 100),
                                  );

                                  // CRITICAL: Ensure music selection state is preserved and UI updates
                                  if (controller
                                      .selectedMusicPath
                                      .value
                                      .isNotEmpty) {
                                    controller.selectedMusic.refresh();
                                    controller.selectedMusicArtist.refresh();
                                    controller.selectedMusicImgPath.refresh();
                                    controller.isMusicAppliedToVideo.refresh();
                                    controller.update();
                                  }
                                  Map<String, dynamic>? data =
                                      await TrimmedMusicDB.getStoredTrimmedMusic();

                                  if (data != null) {
                                    controller.selectedMusic.value =
                                        data['musicName'].toString();
                                    controller.selectedMusicArtist.value =
                                        data['musicArtist'].toString();
                                    controller.selectedMusicImgPath.value =
                                        data['musicImagePath'].toString();
                                    controller.selectedMusicPath.value =
                                        data['musicPath'].toString();
                                    controller.musicStartTime.value =
                                        double.tryParse(
                                          data['startTime'].toString(),
                                        ) ??
                                        0.0;
                                    controller.musicEndTime.value =
                                        double.tryParse(
                                          data['endTime'].toString(),
                                        ) ??
                                        0.0;
                                  }
                                  // When trimming sheet closes, resume video if music is not applied
                                  if (controller.isVideo.value &&
                                      controller.videoController.value !=
                                          null &&
                                      controller
                                          .videoController
                                          .value!
                                          .value
                                          .isInitialized &&
                                      !controller.isMusicAppliedToVideo.value) {
                                    try {
                                      // Restore video volume and resume playback
                                      controller.videoController.value!
                                          .setVolume(1.0);
                                      controller.videoController.value!.play();
                                      debugPrint(
                                        '✅ Video resumed after closing music trimming',
                                      );
                                    } catch (e) {
                                      debugPrint('Error resuming video: $e');
                                    }
                                  }
                                })
                                .catchError((error) {
                                  debugPrint(
                                    'Error in trimming bottom sheet callback: $error',
                                  );
                                  // CRITICAL: Ensure music state is preserved even on error
                                  if (controller
                                      .selectedMusicPath
                                      .value
                                      .isNotEmpty) {
                                    controller.selectedMusic.refresh();
                                    controller.selectedMusicArtist.refresh();
                                    controller.selectedMusicImgPath.refresh();
                                    controller.isMusicAppliedToVideo.refresh();
                                    controller.update();
                                  }
                                  // Still try to resume video
                                  if (controller.isVideo.value &&
                                      controller.videoController.value !=
                                          null &&
                                      controller
                                          .videoController
                                          .value!
                                          .value
                                          .isInitialized &&
                                      !controller.isMusicAppliedToVideo.value) {
                                    try {
                                      controller.videoController.value!
                                          .setVolume(1.0);
                                      controller.videoController.value!.play();
                                    } catch (e) {
                                      debugPrint(
                                        'Error resuming video in error handler: $e',
                                      );
                                    }
                                  }
                                });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? whiteColor : Color(0xff27282d),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.regular.copyWith(
              color: isSelected ? Colors.black : whiteColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
