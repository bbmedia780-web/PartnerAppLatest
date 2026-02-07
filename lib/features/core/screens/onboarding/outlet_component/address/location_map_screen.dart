import '../../../../../../utils/library_utils.dart';

class MapLocationScreen extends GetView<OnBoardingController> {
  const MapLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Your Location'),
      body: Stack(
        children: [
          Obx(() {
            if (controller.latitude.value == 0 && controller.longitude.value == 0) {
              return Center(child: Text("Tap button to get current location"));
            }
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(controller.latitude.value, controller.longitude.value),
                zoom: 16,
              ),
              onTap: (latLng) async {
                controller.latitude.value = latLng.latitude;
                controller.longitude.value = latLng.longitude;
                await controller.updateAddressFromLatLng(latLng.latitude, latLng.longitude);
              },
              markers: {
                Marker(
                  markerId: MarkerId('selected'),
                  position: LatLng(controller.latitude.value, controller.longitude.value),
                ),
              },
            );
          }),

          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "loc",
                  child: Icon(Icons.my_location),
                  onPressed: () async {
                    await controller.fetchCurrentLocation();
                  },
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  child: Text("Confirm / Edit Address"),
                  onPressed: () {
                    _showAddressDialog(context);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showAddressDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final houseNoController = TextEditingController(text: controller.houseNo.value);
    final streetAreaController = TextEditingController(text: controller.streetArea.value);
    final landmarkController = TextEditingController(text: controller.landmark.value);
    final cityController = TextEditingController(text: controller.city.value);
    
    Get.defaultDialog(
      title: "Confirm Address",
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Obx(() => Text("Raw address: ${controller.rawAddress.value}")),
                SizedBox(height: 8),
                CustomTextField(
                  labelName: "House No.",
                  controller: houseNoController,
                  onChange: (v) => controller.houseNo.value = v,
                  validator: (value) => Validators().requiredField(value),
                ),
                CustomTextField(
                  labelName: "Street / Area",
                  controller: streetAreaController,
                  onChange: (v) => controller.streetArea.value = v,
                  validator: (value) => Validators().requiredField(value),
                ),
                CustomTextField(
                  labelName: "Landmark",
                  controller: landmarkController,
                  onChange: (v) => controller.landmark.value = v,
                ),
                CustomTextField(
                  labelName: "City",
                  controller: cityController,
                  onChange: (v) => controller.city.value = v,
                  validator: (value) => Validators().requiredField(value),
                ),
              ],
            ),
          ),
        ),
      ),
      textConfirm: "Save",
      textCancel: "Cancel",
      onConfirm: () {
        if (formKey.currentState!.validate()) {
          controller.houseNo.value = houseNoController.text;
          controller.streetArea.value = streetAreaController.text;
          controller.landmark.value = landmarkController.text;
          controller.city.value = cityController.text;
          controller.confirmAddress();
        }
      },
      onCancel: () => Get.back(),
    );
  }
}