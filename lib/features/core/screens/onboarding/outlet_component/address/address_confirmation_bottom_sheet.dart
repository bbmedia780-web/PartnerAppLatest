import '../../../../../../utils/library_utils.dart';
class AddressConfirmationBottomSheet extends StatefulWidget {
  final String address;
  final VoidCallback onSave;

  const AddressConfirmationBottomSheet({
    super.key,
    required this.address,
    required this.onSave,
  });

  @override
  State<AddressConfirmationBottomSheet> createState() =>
      _AddressConfirmationBottomSheetState();
}

class _AddressConfirmationBottomSheetState
    extends State<AddressConfirmationBottomSheet> {
  late final OnBoardingController controller;
  late final TextEditingController addressLine1Controller;
  late final TextEditingController addressLine2Controller;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    controller = Get.find<OnBoardingController>();
    addressLine1Controller = TextEditingController();
    addressLine2Controller = TextEditingController();
    _initializeControllers();
  }

  void _initializeControllers() {
    String addressLine1 = _buildAddressLine1();
    addressLine1Controller.text = addressLine1;
    String addressLine2 = _buildAddressLine2();
    addressLine2Controller.text = addressLine2;
    _isInitialized = true;
  }

  String _buildAddressLine1() {
    List<String> parts = [];

    // Add house number if it exists
    if (controller.houseNo.value.trim().isNotEmpty) {
      parts.add(controller.houseNo.value.trim());
    }

    // Add street area if it exists and doesn't already contain the house number
    if (controller.streetArea.value.trim().isNotEmpty) {
      final houseNo = controller.houseNo.value.trim();
      final streetArea = controller.streetArea.value.trim();

      // Only add street area if it's different from house number
      if (houseNo.isEmpty || !streetArea.contains(houseNo)) {
        parts.add(streetArea);
      }
    }

    // If still empty, parse from rawAddress
    if (parts.isEmpty && controller.rawAddress.value.trim().isNotEmpty) {
      final rawAddr = controller.rawAddress.value.trim();
      final addrParts = rawAddr
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      if (addrParts.isNotEmpty) {
        // Use first part for Address Line 1 (usually contains street/house number)
        parts.add(addrParts[0]);
      }
    }

    // Join with comma only if we have parts, otherwise return empty string (but we ensure it's not empty above)
    return parts.join(', ');
  }

  String _buildAddressLine2() {
    // First try to use landmark
    if (controller.landmark.value.trim().isNotEmpty) {
      return controller.landmark.value.trim();
    }

    // If landmark is empty, try to parse from rawAddress
    if (controller.rawAddress.value.trim().isNotEmpty) {
      final rawAddr = controller.rawAddress.value.trim();
      final addrParts = rawAddr
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      // Use second and third parts if available (subLocality, locality)
      if (addrParts.length > 1) {
        // Combine second and third parts for Address Line 2 (limit to 2 parts)
        final line2Parts = addrParts.length > 2
            ? addrParts
                  .sublist(1, addrParts.length > 3 ? 3 : addrParts.length)
                  .join(', ')
            : addrParts[1];
        return line2Parts;
      } else if (addrParts.isNotEmpty && addrParts.length == 1) {
        // If only one part exists and it's already used in line 1, use city as fallback
        if (controller.city.value.trim().isNotEmpty) {
          return controller.city.value.trim();
        }
        // Last resort: use the single part (shouldn't happen but ensures non-empty)
        return addrParts[0];
      }
    }

    // Fallback: try to use city or street from address model
    if (controller.city.value.trim().isNotEmpty) {
      return controller.city.value.trim();
    }

    if (controller.addressModel != null) {
      if (controller.addressModel!.city.isNotEmpty) {
        return controller.addressModel!.city;
      }
      if (controller.addressModel!.street.isNotEmpty) {
        return controller.addressModel!.street;
      }
    }

    // Last fallback: return a default value to ensure it's never empty
    return controller.rawAddress.value.trim().isNotEmpty
        ? controller.rawAddress.value.trim()
        : '';
  }

  @override
  void dispose() {
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
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
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: borderGreyColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Complete Your Address',
                  style: AppTextStyles.heading2.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: blackColor),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
          // Pre-filled Address
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderGreyColor),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: appColor, size: 20),
                  8.width,
                  Expanded(
                    child: Text(
                      widget.address,
                      style: AppTextStyles.regular.copyWith(
                        fontSize: 13,
                        color: blackColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          16.height,
          // Form Fields
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Address Line 1
                    Text(
                      'Address Line 1',
                      style: AppTextStyles.subHeading.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: blackColor,
                      ),
                    ),
                    8.height,
                    Obx(() {
                      // Update controller text only if values changed externally (e.g., from map selection)
                      if (_isInitialized) {
                        final newValue = _buildAddressLine1();
                        // Only update if values changed externally and user isn't actively editing
                        final currentText = addressLine1Controller.text.trim();
                        final newText = newValue.trim();

                        // Check if the underlying data changed but text field hasn't been updated
                        if (currentText != newText && newText.isNotEmpty) {
                          // Only update if user isn't actively editing (cursor at end or no selection)
                          final selection = addressLine1Controller.selection;
                          final isUserEditing =
                              selection.isValid &&
                              selection.baseOffset <
                                  addressLine1Controller.text.length;

                          if (!isUserEditing) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted &&
                                  addressLine1Controller.text != newValue) {
                                addressLine1Controller.text = newValue;
                              }
                            });
                          }
                        }
                      }
                      return CustomTextField(
                        textInputType: TextInputType.streetAddress,
                        hintText: 'House/Flat No., Building Name',
                        labelName: '',
                        controller: addressLine1Controller,
                        prefixIcon: Icon(Icons.home, color: txtdarkgrayColor),
                        onChange: (value) {
                          // When user types, update the controller values
                          // Split by comma: first part = house no, rest = street area
                          if (value.trim().isEmpty) {
                            controller.houseNo.value = '';
                            controller.streetArea.value = '';
                          } else {
                            // Split by comma and filter out empty parts
                            final parts = value
                                .split(',')
                                .map((e) => e.trim())
                                .where((e) => e.isNotEmpty)
                                .toList();

                            if (parts.isNotEmpty) {
                              // First part is house number
                              controller.houseNo.value = parts[0];

                              // Remaining parts are street area
                              if (parts.length > 1) {
                                controller.streetArea.value = parts
                                    .sublist(1)
                                    .join(', ')
                                    .trim();
                              } else {
                                // If only one part, check if it looks like a house number
                                if (RegExp(r'^\d+').hasMatch(parts[0])) {
                                  // It's a house number
                                  controller.houseNo.value = parts[0];
                                  controller.streetArea.value = '';
                                } else {
                                  // It's a street name
                                  controller.houseNo.value = '';
                                  controller.streetArea.value = parts[0];
                                }
                              }
                            } else {
                              controller.houseNo.value = '';
                              controller.streetArea.value = '';
                            }
                          }
                        },
                        validator: (value) => Validators().requiredField(value),
                      );
                    }),
                    16.height,
                    // Address Line 2
                    Text(
                      'Address Line 2',
                      style: AppTextStyles.subHeading.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: blackColor,
                      ),
                    ),
                    8.height,
                    Obx(() {
                      // Update controller text only if landmark or rawAddress changed externally
                      if (_isInitialized) {
                        final newValue = _buildAddressLine2();
                        final currentText = addressLine2Controller.text.trim();

                        if (currentText != newValue.trim() &&
                            newValue.trim().isNotEmpty) {
                          // Only update if user isn't actively editing
                          final selection = addressLine2Controller.selection;
                          final isUserEditing =
                              selection.isValid &&
                              selection.baseOffset <
                                  addressLine2Controller.text.length;

                          if (!isUserEditing) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted &&
                                  addressLine2Controller.text != newValue) {
                                addressLine2Controller.text = newValue;
                              }
                            });
                          }
                        }
                      }
                      return CustomTextField(
                        textInputType: TextInputType.streetAddress,
                        hintText: 'Street, Area, Landmark (Optional)',
                        labelName: '',
                        controller: addressLine2Controller,
                        prefixIcon: Icon(
                          Icons.business,
                          color: txtdarkgrayColor,
                        ),
                        onChange: (value) {
                          // Update landmark when user edits
                          controller.landmark.value = value.trim();
                        },
                      );
                    }),

                    12.height,
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => CustomTextField(
                              textInputType: TextInputType.text,
                              hintText: controller.city.value.isEmpty
                                  ? 'City'
                                  : controller.city.value,
                              labelName: 'City',
                              controller: TextEditingController(
                                text: controller.city.value,
                              ),
                              prefixIcon: Icon(
                                Icons.location_city,
                                color: txtdarkgrayColor,
                              ),
                              onChange: (value) =>
                                  controller.city.value = value,
                              validator: (value) =>
                                  Validators().requiredField(value),
                            ),
                          ),
                        ),
                        8.width,
                        Expanded(
                          child: CustomTextField(
                            textInputType: TextInputType.text,
                            hintText: 'State',
                            labelName: 'State',
                            controller: TextEditingController(
                              text: controller.addressModel?.state ?? '',
                            ),
                            prefixIcon: Icon(
                              Icons.public,
                              color: txtdarkgrayColor,
                            ),
                            onlyRead: true,
                          ),
                        ),
                      ],
                    ),

                    12.height,
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            textInputType: TextInputType.number,
                            hintText: 'Postal Code',
                            labelName: 'Postal Code',
                            controller: TextEditingController(
                              text: controller.addressModel?.postalCode ?? '',
                            ),
                            prefixIcon: Icon(
                              Icons.tag,
                              color: txtdarkgrayColor,
                            ),
                            onlyRead: true,
                          ),
                        ),
                        8.width,
                        Expanded(
                          child: CustomTextField(
                            textInputType: TextInputType.text,
                            hintText: 'Country',
                            labelName: 'Country',
                            controller: TextEditingController(
                              text: controller.addressModel?.country ?? 'India',
                            ),
                            prefixIcon: Icon(
                              Icons.public,
                              color: txtdarkgrayColor,
                            ),
                            onlyRead: true,
                          ),
                        ),
                      ],
                    ),
                    20.height,
                  ],
                ),
              ),
            ),
          ),
          // Save Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: CustomButton(
                title: 'Save Address',
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    // Ensure final values are synced from text fields before saving
                    final line1Text = addressLine1Controller.text
                        .replaceFirst(RegExp(r'^[,\s]+'), '')
                        .trim();
                    if (line1Text.isNotEmpty) {
                      final line1Parts = line1Text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList();

                      if (line1Parts.isNotEmpty) {
                        if (RegExp(r'^\d').hasMatch(line1Parts[0])) {
                          controller.houseNo.value = line1Parts[0];
                          controller.streetArea.value = line1Parts.length > 1
                              ? line1Parts.sublist(1).join(', ')
                              : '';
                        } else {
                          controller.houseNo.value = '';
                          controller.streetArea.value = line1Parts.join(', ');
                        }
                      }
                    } else {
                      controller.houseNo.value = '';
                      controller.streetArea.value = '';
                    }

                    controller.landmark.value = addressLine2Controller.text
                        .trim();

                    controller.confirmAddress();
                    widget.onSave();
                  }
                },
                isDisable: false,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
