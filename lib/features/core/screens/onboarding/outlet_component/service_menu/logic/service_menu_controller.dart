import 'dart:io';

import '../../../../../../../utils/image_helpers.dart';
import '../../../../../../../utils/library_utils.dart';

class ServiceMenuController extends GetxController{
  RxInt totalSelected = 0.obs;
  RxBool isServiceStatus=false.obs;
  TextEditingController searchController= TextEditingController();
  Rx<File> selectedImage=File('').obs;
  RxList<File> selectedImages = <File>[].obs; // For multiple images
  List<String> lstCategories=["Body Care","Facial"];
  RxString selectedCategories="Body Care".obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  var categoryName = "".obs;
  var services = <Map<String, dynamic>>[].obs;
  var selectedIndex = (-1).obs;
  var currentImage = 0.obs;

  void toggleSelect(int index) {
    selectedIndex.value = index;
  }
  // UI Style Selection
  RxInt selectedUIStyle = 0.obs; // 0: Gradient, 1: Glassmorphism, 2: Minimal

  void changeUIStyle(int style) {
    selectedUIStyle.value = style;
  }

  @override
  void onInit() {
    super.onInit();

    categories.value = [
      CategoryModel(
        title: "Body Care",
        services: [
          ServiceModel(name: "Body Massage", description:"This is new for user",status: "Active", isSelected: false.obs, images: [AppImages.img1,AppImages.img2,AppImages.img3],price: '100', category: 'Body Care'),
          ServiceModel(name: "Body Polishing", description:"This is new for user",status: "Inactive", isSelected: false.obs, images: [AppImages.img2,AppImages.img1,AppImages.img3,],price: '250',category: 'Body Care'),
          ServiceModel(name: "Body Scrub", description:"This is new for user",status: "Active", isSelected: false.obs, images: [],price: '150',category: 'Body Care'),
        ],
      ),
      CategoryModel(
        title: "Facial",
        services: [
          ServiceModel(name: "Fruit Facial", status: "Active", isSelected: false.obs, images: [AppImages.img2,AppImages.img1,AppImages.img3,],price: '270',category: 'Facial',description:"This is new for user"),
          ServiceModel(name: "Skin Whitening", status: "Inactive", isSelected: false.obs, images: [AppImages.img1,AppImages.img2,AppImages.img3,],price: '300',category: 'Facial',description:"This is new for user"),
        ],
      ),
    ];
  }
  void addExistingImage(String path) {
    // selectedImages.add(ImageModel.fromNetwork(path));
  }

  void showImagePickerDialog() {
    // same dialog you already wrote
  }

  List<String> getFinalImages() {
    return selectedImages.map((e) => e.path).toList();
  }
  /// HANDLE INDIVIDUAL CHECKBOX
  toggleService(CategoryModel category, ServiceModel service) {
    service.isSelected.value = !service.isSelected.value;
    updateTotalSelected();
  }

  /// SELECT ALL
  selectAll(CategoryModel category) {
    bool newState = !category.isAllSelected.value;

    category.isAllSelected.value = newState;

    for (var service in category.services) {
      service.isSelected.value = newState;
    }

    updateTotalSelected();
  }
  /// UPDATE TOTAL SELECTED COUNT
  updateTotalSelected() {
    int count = 0;
    for (var category in categories) {
      count += category.services.where((s) => s.isSelected.value).length;
    }
    totalSelected.value = count;
  }
  pickServiceImages() async {
    selectedImage.value = await ImagePickerHelper.showPickerDialog(Get.context!) ?? File("");

    if (selectedImage.value.path.isNotEmpty) {
      debugPrint("Image Path: ${selectedImage.value.path}");
    } else {
      debugPrint("No image selected");
    }
  }

  // Pick multiple images
  pickMultipleServiceImages() async {
    try {
      final List<File> pickedImages = await ImagePickerHelper.pickMultipleImages(Get.context!);
      if (pickedImages.isNotEmpty) {
        selectedImages.addAll(pickedImages);
        selectedImages.refresh();
        debugPrint("Added ${pickedImages.length} images. Total: ${selectedImages.length}");
      }
    } catch (e) {
      debugPrint("Error picking multiple images: $e");
    }
  }

  // Pick single image and add to list
  pickSingleServiceImage() async {
    try {
      final File? pickedImage = await ImagePickerHelper.showPickerDialog(Get.context!);
      if (pickedImage != null && pickedImage.path.isNotEmpty) {
        selectedImages.add(pickedImage);
        selectedImages.refresh();
        debugPrint("Added image: ${pickedImage.path}");
        debugPrint("Total images: ${selectedImages.length}");
      }
    } catch (e) {
      debugPrint("Error picking single image: $e");
    }
  }

  // Remove image from list
  removeServiceImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  // Clear all images
  clearAllImages() {
    selectedImages.clear();
  }
  void addService() {
    services.add({
      "name": "",
      "desc": "",
      "images": <File>[].obs,
    });
  }

  void removeService(int index) {
    if (index >= 0 && index < services.length) {
      services.removeAt(index);
    }
  }

  // Pick single image for a specific service
  Future<void> pickServiceImageForIndex(int serviceIndex) async {
    try {
      final File? pickedImage = await ImagePickerHelper.showPickerDialog(Get.context!);
      if (pickedImage != null && pickedImage.path.isNotEmpty) {
        if (serviceIndex >= 0 && serviceIndex < services.length) {
          if (services[serviceIndex]["images"] == null) {
            services[serviceIndex]["images"] = <File>[].obs;
          }
          final images = services[serviceIndex]["images"] as RxList<File>;
          images.add(pickedImage);
          services.refresh();
        }
      }
    } catch (e) {
      debugPrint("Error picking image for service: $e");
    }
  }

  // Pick multiple images for a specific service
  Future<void> pickMultipleServiceImagesForIndex(int serviceIndex) async {
    try {
      final List<File> pickedImages = await ImagePickerHelper.pickMultipleImages(Get.context!);
      if (pickedImages.isNotEmpty) {
        if (serviceIndex >= 0 && serviceIndex < services.length) {
          if (services[serviceIndex]["images"] == null) {
            services[serviceIndex]["images"] = <File>[].obs;
          }
          final images = services[serviceIndex]["images"] as RxList<File>;
          images.addAll(pickedImages);
          services.refresh();
        }
      }
    } catch (e) {
      debugPrint("Error picking multiple images for service: $e");
    }
  }

  // Remove image from a specific service
  void removeServiceImageAtIndex(int serviceIndex, int imageIndex) {
    if (serviceIndex >= 0 && serviceIndex < services.length) {
      final images = services[serviceIndex]["images"] as RxList<File>?;
      if (images != null && imageIndex >= 0 && imageIndex < images.length) {
        images.removeAt(imageIndex);
        services.refresh();
      }
    }
  }

  // Get images for a specific service
  RxList<File> getServiceImages(int serviceIndex) {
    if (serviceIndex >= 0 && serviceIndex < services.length) {
      if (services[serviceIndex]["images"] == null) {
        services[serviceIndex]["images"] = <File>[].obs;
      }
      return services[serviceIndex]["images"] as RxList<File>;
    }
    return <File>[].obs;
  }
}
class CategoryModel {
  String title;
  RxBool isAllSelected = false.obs;
  RxList<ServiceModel> services;

  CategoryModel({
    required this.title,
    required List<ServiceModel> services,
  }) : services = services.obs;
}

class ServiceModel {
  String name;
  String status;
  RxBool isSelected;
  List<String> images;
  String price;
  String description;
  String category;

  ServiceModel({
    required this.name,
    required this.status,
    required this.isSelected,
    required this.images,
    required this.price,
    required this.description,
    required this.category

  });
}
