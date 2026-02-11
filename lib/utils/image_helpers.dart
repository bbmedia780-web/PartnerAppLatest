import 'dart:io';
import '../../../../../utils/library_utils.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> showPickerDialog(BuildContext context) async {
    try {
      return await Get.dialog<File>(
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Select Image"),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox.shrink(),
              InkWell(
                onTap: () async {
                  try {
                    final picked = await _picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 70,
                      maxWidth: 1920,
                      maxHeight: 1920,
                    );
                    if (context.mounted) {
                      Get.back(result: picked != null ? File(picked.path) : null);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      Get.back(result: null);
                    }
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt, color: kColorGray, size: 40),
                    Text('Camera')
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  try {
                    final picked = await _picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 70,
                      maxWidth: 1920,
                      maxHeight: 1920,
                    );
                    if (context.mounted) {
                      Get.back(result: picked != null ? File(picked.path) : null);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      Get.back(result: null);
                    }
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.photo, color: kColorGray, size: 40),
                    Text('Gallery')
                  ],
                ),
              ),
              SizedBox.shrink(),
            ],
          ),
        ),
      );
    } catch (e) {
      return null;
    }
  }

  // Pick multiple images from gallery
  static Future<List<File>> pickMultipleImages(BuildContext context) async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 70,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (pickedFiles.isNotEmpty) {
        return pickedFiles.map((file) => File(file.path)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
