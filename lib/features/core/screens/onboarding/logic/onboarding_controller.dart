import 'package:geolocator/geolocator.dart';
import '../outlet_component/address/address_model.dart';
import '../../../../../../utils/library_utils.dart';

class OnBoardingController extends GetxController{
  TextEditingController ownerNameController=TextEditingController();
  TextEditingController parlorNameController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController mobileNoController=TextEditingController();
  TextEditingController aadhaarController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController accNameController = TextEditingController();
  TextEditingController accNumberController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController gstNumController = TextEditingController();

  GlobalKey<FormState> formKey=GlobalKey<FormState>();
  GlobalKey<FormState> documentFormKey=GlobalKey<FormState>();
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString rawAddress = ''.obs;
  RxString houseNo      = ''.obs;
  RxString streetArea   = ''.obs;
  RxString landmark     = ''.obs;
  RxString city         = ''.obs;

  AddressModel? addressModel;

  /// Fetch device current location
  Future<void> fetchCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        ShowToast.error('Location permission is required');
        return;
      }
    }

    Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    latitude.value = pos.latitude;
    longitude.value = pos.longitude;

    await   updateAddressFromLatLng(pos.latitude, pos.longitude);
  }

  /// Reverse-geocode lat/lng to address
  Future<void> updateAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        rawAddress.value = "${p.street ?? ''}, ${p.subLocality ?? ''}, ${p.locality ?? ''}, ${p.postalCode ?? ''}, ${p.country ?? ''}";

        // Extract house number from Placemark
        // subThoroughfare usually contains house/building number
        // If not available, try to parse from street or thoroughfare
        String extractedHouseNo = '';
        if (p.subThoroughfare != null && p.subThoroughfare!.isNotEmpty) {
          extractedHouseNo = p.subThoroughfare!;
        } else if (p.street != null && p.street!.isNotEmpty) {
          // Try to extract house number from street address (e.g., "123 Main St" -> "123")
          final streetParts = p.street!.split(' ');
          if (streetParts.isNotEmpty && RegExp(r'^\d+').hasMatch(streetParts.first)) {
            extractedHouseNo = streetParts.first;
          }
        } else if (p.thoroughfare != null && p.thoroughfare!.isNotEmpty) {
          // Try to extract from thoroughfare
          final thoroughfareParts = p.thoroughfare!.split(' ');
          if (thoroughfareParts.isNotEmpty && RegExp(r'^\d+').hasMatch(thoroughfareParts.first)) {
            extractedHouseNo = thoroughfareParts.first;
          }
        }

        // Initialize editable fields from geocoded data
        houseNo.value    = extractedHouseNo;
        // Use thoroughfare (street name) for streetArea if available, otherwise subLocality, otherwise street
        streetArea.value = (p.thoroughfare?.trim() ?? p.subLocality?.trim() ?? p.street?.trim() ?? '').trim();
        // Use subLocality for landmark if available, otherwise use locality
        landmark.value   = (p.subLocality?.trim() ?? p.locality?.trim() ?? '').trim();
        city.value       = (p.locality?.trim() ?? '').trim();

        addressModel = AddressModel(
          latitude: lat,
          longitude: lng,
          houseNo: extractedHouseNo,
          street: streetArea.value,
          city: city.value,
          state: p.administrativeArea ?? '',
          postalCode: p.postalCode ?? '',
          country: p.country ?? 'India',
        );
      }
    } catch (e) {
      // print("Error in reverse geocoding: $e");
      ShowToast.error('Could not get address from location');
    }
  }

  /// Called when user confirms the address form

  var currentStep = 0.obs;
  RxBool step1 = false.obs;
  RxBool step2 = false.obs;
  RxBool step3 = false.obs;
  RxBool step4 = false.obs;
  RxnString selectedOutletType=RxnString();

  List<String> categories = [
    "Salon",
    "Spa",
    "Makeup Artist",
    "Nail Studio",
  ];

  // Working Days and Timing
  RxSet<String> selectedWorkingDays = <String>{}.obs;
  RxBool isSameTimingForAllDays = true.obs;
  RxString openingTime = "09:00 AM".obs;
  RxString closingTime = "10:00 PM".obs;
  RxList<Map<String, String>> timeSlots = <Map<String, String>>[].obs;

  List<String> weekDays = [
    "All",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];


  void toggleWorkingDay(String day) {
    if (day == "All") {
      if (selectedWorkingDays.contains("All")) {
        selectedWorkingDays.clear();
      } else {
        selectedWorkingDays
          ..clear()
          ..addAll(weekDays.where((d) => d != "All"));
        selectedWorkingDays.add("All");
      }
      return;
    }

    if (selectedWorkingDays.contains(day)) {
      selectedWorkingDays.remove(day);
    } else {
      selectedWorkingDays.add(day);
    }
    final allDays = weekDays.where((d) => d != "All").toList();
    final isAllSelected = allDays.every((day) => selectedWorkingDays.contains(day));

    if (isAllSelected) {
      selectedWorkingDays.add("All");
    } else {
      selectedWorkingDays.remove("All");
    }
  }

  bool isSelected(String type) {
    return selectedOutletType.value == type;
  }
  void addTimeSlot() {
    timeSlots.add({
      "open": openingTime.value,
      "close": closingTime.value,
    });
  }

  void removeTimeSlot(int index) {
    if (index >= 0 && index < timeSlots.length) {
      timeSlots.removeAt(index);
    }
  }
  void nextStep() {
    if (currentStep < 3) currentStep++;
  }
  void confirmAddress() {
    if (addressModel == null) return;
    addressModel = AddressModel(
      latitude: latitude.value,
      longitude: longitude.value,
      houseNo: houseNo.value.trim(),
      street: streetArea.value.trim(),
      landmark: landmark.value.trim(),
      city: city.value.trim(),
      state: addressModel?.state ?? '',
      postalCode: addressModel?.postalCode ?? '',
      country: addressModel?.country ?? 'India',
    );
    
    // Build address string properly without unnecessary commas
    List<String> addressParts = [];
    
    if (addressModel!.houseNo.isNotEmpty) {
      addressParts.add(addressModel!.houseNo);
    }
    if (addressModel!.street.isNotEmpty) {
      addressParts.add(addressModel!.street);
    }
    if (addressModel!.landmark.isNotEmpty) {
      addressParts.add(addressModel!.landmark);
    }
    if (addressModel!.city.isNotEmpty) {
      addressParts.add(addressModel!.city);
    }
    
    // Join all parts with comma and space, removing any empty parts
    addressController.text = addressParts.join(', ');
  }
  void selectOutlet(String type) {
    selectedOutletType.value = type;
  }
}