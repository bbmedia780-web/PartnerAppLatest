import '../../../../../../utils/library_utils.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> with WidgetsBindingObserver {
  GoogleMapController? mapController;
  final OnBoardingController controller = Get.find<OnBoardingController>();
  final RxBool isMapInitialized = false.obs;
  final RxBool hasLocationPermission = false.obs;
  String selectedAddress = '';
  final TextEditingController searchController = TextEditingController();
  final RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;
  final RxBool isSearching = false.obs;
  final FocusNode searchFocusNode = FocusNode();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissionAndInitialize();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    // Cancel previous debounce timer
    _searchDebounce?.cancel();
    
    final query = searchController.text.trim();
    if (query.isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    // Debounce search to avoid too many API calls
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      _searchPlaces(query);
    });
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;
    try {
      List<Location> locations = await locationFromAddress(query);
      
      if (locations.isEmpty) {
        searchResults.clear();
        isSearching.value = false;
        return;
      }

      // Get placemarks for all locations and store with coordinates
      List<Map<String, dynamic>> results = [];
      for (var location in locations.take(5)) { // Limit to 5 results
        try {
          List<Placemark> marks = await placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          );
          if (marks.isNotEmpty) {
            results.add({
              'placemark': marks.first,
              'latitude': location.latitude,
              'longitude': location.longitude,
            });
          }
        } catch (e) {
          // Skip if placemark fetch fails for this location
          continue;
        }
      }

      searchResults.value = results;
    } catch (e) {
      // If locationFromAddress fails, clear results
      searchResults.clear();
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> _onPlaceSelected(Map<String, dynamic> result) async {
    final latitude = result['latitude'] as double;
    final longitude = result['longitude'] as double;

    try {
      controller.latitude.value = latitude;
      controller.longitude.value = longitude;
      await controller.updateAddressFromLatLng(latitude, longitude);

      // Move map camera to selected location
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(latitude, longitude),
            16,
          ),
        );
      }

      setState(() {
        selectedAddress = controller.rawAddress.value;
        searchController.text = '';
        searchResults.clear();
      });

      // Unfocus search field
      searchFocusNode.unfocus();
    } catch (e) {
      ShowToast.error('Could not update location');
    }
  }

  Future<void> _checkPermissionAndInitialize() async {
    try {
      // Check permission status first
      PermissionStatus status = await Permission.location.status;
      
      if (status.isGranted) {
        hasLocationPermission.value = true;
        await _initializeMap();
      } else {
        hasLocationPermission.value = false;
        // Initialize map with default location even without permission
        await _initializeMapWithDefaultLocation();
      }
    } catch (e) {
      // If permission check fails, initialize with default location
      hasLocationPermission.value = false;
      await _initializeMapWithDefaultLocation();
    }
  }

  Future<void> _initializeMapWithDefaultLocation() async {
    // Set default location (Surat, Gujarat)
    if (controller.latitude.value == 0 && controller.longitude.value == 0) {
      controller.latitude.value = 21.1702;
      controller.longitude.value = 72.8311;
    }
    
    // Fetch address for the initial location (default or existing)
    try {
      await controller.updateAddressFromLatLng(
        controller.latitude.value,
        controller.longitude.value,
      );
      if (mounted) {
        setState(() {
          selectedAddress = controller.rawAddress.value;
          // Don't manually override the values - updateAddressFromLatLng already sets them correctly
        });
      }
    } catch (e) {
      // If address fetch fails, still initialize map
      // print("Error fetching address for initial location: $e");
    }
    
    isMapInitialized.value = true;
  }

  Future<void> _initializeMap() async {
    // Get current location if permission is granted
    if (hasLocationPermission.value) {
      try {
        await controller.fetchCurrentLocation();
      } catch (e) {
        // If fetching current location fails, use default location
        // print("Error fetching current location: $e");
        await _initializeMapWithDefaultLocation();
        return;
      }
    }

    // Ensure address is fetched for the location
    if (controller.latitude.value != 0 && controller.longitude.value != 0) {
      // If address is not already fetched, fetch it now
      if (controller.rawAddress.value.isEmpty) {
        try {
          await controller.updateAddressFromLatLng(
            controller.latitude.value,
            controller.longitude.value,
          );
        } catch (e) {
          debugPrint("Error fetching address: $e");
        }
      }
      
      isMapInitialized.value = true;
      if (mounted) {
        setState(() {
          selectedAddress = controller.rawAddress.value;
          // Don't manually override the values - updateAddressFromLatLng already sets them correctly
        });
      }
    } else {
      // Set default location if current location fails
      await _initializeMapWithDefaultLocation();
    }
  }

  Future<void> _requestLocationPermission() async {
    try {
      // Check current permission status
      PermissionStatus status = await Permission.location.status;

      if (status.isGranted) {
        // Permission already granted
        hasLocationPermission.value = true;
        await _initializeMap();
        return;
      }

      if (status.isPermanentlyDenied) {
        // Permission permanently denied, need to open settings
        final shouldOpen = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Location Permission Required'),
            content: const Text(
              'Location permission is permanently denied. Please enable it from device settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );

        if (shouldOpen == true) {
          await openAppSettings();
        }
        return;
      }

      // Request permission
      status = await Permission.location.request();
      
      if (status.isGranted) {
        hasLocationPermission.value = true;
        await _initializeMap();
        
        // Fetch current location after permission granted
        try {
          await controller.fetchCurrentLocation();
          if (controller.latitude.value != 0 && controller.longitude.value != 0 && mapController != null) {
            await mapController!.animateCamera(
              CameraUpdate.newLatLngZoom(
                LatLng(controller.latitude.value, controller.longitude.value),
                16,
              ),
            );
            if (mounted) {
              setState(() {
                selectedAddress = controller.rawAddress.value;
              });
            }
          }
        } catch (e) {
          // Location fetch failed, but permission is granted
        }
      } else if (status.isDenied) {
        ShowToast.error('Location permission is required to get your current location');
      } else if (status.isPermanentlyDenied) {
        final shouldOpen = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Location Permission Required'),
            content: const Text(
              'Location permission is permanently denied. Please enable it from device settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );

        if (shouldOpen == true) {
          await openAppSettings();
        }
      }
    } catch (e) {
      ShowToast.error('Failed to request location permission: ${e.toString()}');
    }
  }

  Future<void> _getCurrentLocation() async {
    // Re-check permission status
    PermissionStatus status = await Permission.location.status;
    
    if (!status.isGranted) {
      await _requestLocationPermission();
      // Re-check after requesting
      status = await Permission.location.status;
      if (!status.isGranted) {
        return;
      }
      hasLocationPermission.value = true;
    }
    
    // Show loading indicator
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    
    try {
      await controller.fetchCurrentLocation();
      
      // Close loading indicator
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      
      if (controller.latitude.value != 0 && controller.longitude.value != 0) {
        // Update map camera to current location
        if (mapController != null) {
          await mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(controller.latitude.value, controller.longitude.value),
              16,
            ),
          );
        }
        
        if (mounted) {
          setState(() {
            selectedAddress = controller.rawAddress.value;
          });
        }
      } else {
        ShowToast.error('Could not get current location');
      }
    } catch (e) {
      // Close loading indicator if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      
      ShowToast.error('Failed to get current location: ${e.toString()}');
    }
  }

  void _onMapTap(LatLng latLng) async {
    // Allow map tap even without permission - user can manually select location
    controller.latitude.value = latLng.latitude;
    controller.longitude.value = latLng.longitude;
    await controller.updateAddressFromLatLng(latLng.latitude, latLng.longitude);
    setState(() {
      selectedAddress = controller.rawAddress.value;
      // Don't manually override the values - updateAddressFromLatLng already sets them correctly
    });
  }

  void _onSelectLocationTap() {
    // Allow selecting location even without permission (user can tap on map)
    if (controller.latitude.value == 0 || controller.longitude.value == 0) {
      ShowToast.error('Please select a location on the map');
      return;
    }
    
    // If address is empty, try to get it from coordinates
    if (controller.rawAddress.value.isEmpty) {
      controller.updateAddressFromLatLng(
        controller.latitude.value,
        controller.longitude.value,
      ).then((_) {
        // Show bottom sheet after address is updated
        if (mounted) {
          _showAddressBottomSheet();
        }
      }).catchError((e) {
        // Show bottom sheet even if address update fails
        if (mounted) {
          _showAddressBottomSheet();
        }
      });
    } else {
      _showAddressBottomSheet();
    }
  }

  void _showAddressBottomSheet() {
    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddressConfirmationBottomSheet(
        address: controller.rawAddress.value.isNotEmpty 
            ? controller.rawAddress.value 
            : selectedAddress,
        onSave: () {
          Get.back(); // Close bottom sheet
          Get.back(); // Close map screen
        },
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Check permission again when app resumes (e.g., after returning from settings)
      _checkPermissionAndInitialize().then((_) {
        // If permission was granted while in settings, get current location
        if (hasLocationPermission.value) {
          _getCurrentLocation();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: CustomAppBar(title: "Select Location",children: [
        TextButton(
           onPressed: () => Get.back(),
              child: Text(
                'Done',
                style: AppTextStyles.subHeading.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: appColor,
                ),
              ),
            ),
      ],),
      // appBar: AppBar(
      //   backgroundColor: appColor,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios_new, color: whiteColor, size: 20),
      //     onPressed: () => Get.back(),
      //   ),
      //   title: Text(
      //     'Select Location',
      //     style: AppTextStyles.subHeading.copyWith(
      //       fontSize: 18,
      //       fontWeight: FontWeight.w600,
      //       color: whiteColor,
      //     ),
      //   ),
      //   centerTitle: true,
      //   actions: [
      //     TextButton(
      //       onPressed: () => Get.back(),
      //       child: Text(
      //         'Done',
      //         style: AppTextStyles.subHeading.copyWith(
      //           fontSize: 16,
      //           fontWeight: FontWeight.w600,
      //           color: whiteColor,
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          // Search Bar
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [

                    Expanded(
                      child: CustomTextField(
                        prefixIcon: Icon(Icons.search, color: txtdarkgrayColor, size: 20),
                        labelName: '',
                        controller: searchController,
                        focusNode: searchFocusNode,
                        hintText: 'Search for places...',
                        filled: false,
                        textStyle: AppTextStyles.regular.copyWith(
                          fontSize: 14,
                          color: blackColor,
                        ),
                        hintTextStyle: AppTextStyles.light.copyWith(
                          fontSize: 14,
                          color: txtdarkgrayColor,
                        ),
                        contentPadding: EdgeInsets.zero,
                        onChange: (value) {
                          if (value.trim().isNotEmpty) {
                            _onSearchChanged();
                          }
                        },
                      ),
                    ),
                    Obx(() => isSearching.value
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: appColor,
                              ),
                            ),
                          )
                        : searchController.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  searchController.clear();
                                  searchResults.clear();
                                },
                                child: Icon(
                                  Icons.close,
                                  color: txtdarkgrayColor,
                                  size: 20,
                                ),
                              )
                            : const SizedBox.shrink()),
                  ],
                ),
              ),
              // Search Results
              Obx(() => searchResults.isNotEmpty
                  ? Container(
                      margin: const EdgeInsets.only(top: 8),
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderGreyColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final result = searchResults[index];
                          final placemark = result['placemark'] as Placemark;
                          final address = _buildAddressFromPlacemark(placemark);
                          return InkWell(
                            onTap: () => _onPlaceSelected(result),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: appColor,
                                    size: 20,
                                  ),
                                  12.width,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _getPlaceName(placemark),
                                          style: AppTextStyles.subHeading.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: blackColor,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        4.height,
                                        Text(
                                          address,
                                          style: AppTextStyles.regular.copyWith(
                                            fontSize: 12,
                                            color: txtdarkgrayColor,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const SizedBox.shrink()),
            ],
          ),
          // Selected Location Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: whiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Location:',
                  style: AppTextStyles.subHeading.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: blackColor,
                  ),
                ),
                4.height,
                Obx(() => Text(
                      controller.rawAddress.value.isEmpty
                          ? 'Tap on map to select location'
                          : controller.rawAddress.value,
                      style: AppTextStyles.regular.copyWith(
                        fontSize: 13,
                        color: txtdarkgrayColor,
                      ),
                    )),
              ],
            ),
          ),
          // Map View - Always show map
          Expanded(
            child: Obx(() {
              // Show loading if map not initialized
              if (!isMapInitialized.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: appColor),
                      16.height,
                      Text(
                        'Loading map...',
                        style: AppTextStyles.regular.copyWith(
                          fontSize: 14,
                          color: txtdarkgrayColor,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Always show map
              return Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        controller.latitude.value,
                        controller.longitude.value,
                      ),
                      zoom: 16,
                    ),
                    onMapCreated: (GoogleMapController googleMapController) {
                      mapController = googleMapController;
                    },
                    onTap: _onMapTap,
                    markers: {
                      Marker(
                        markerId: const MarkerId('selected'),
                        position: LatLng(
                          controller.latitude.value,
                          controller.longitude.value,
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed,
                        ),
                      ),
                    },
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                  ),
                  // Current Location Button - Only show if permission granted
                  Obx(() => hasLocationPermission.value
                      ? Positioned(
                          bottom: 100,
                          right: 16,
                          child: FloatingActionButton(
                            heroTag: 'current_location',
                            backgroundColor: whiteColor,
                            onPressed: _getCurrentLocation,
                            child: Icon(Icons.my_location, color: appColor),
                          ),
                        )
                      : const SizedBox.shrink()),
                  // Permission Button Overlay at Bottom - Only show if permission not granted
                  Obx(() => !hasLocationPermission.value
                      ? Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, -2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Allow Location Permission',
                                        style: AppTextStyles.subHeading.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: blackColor,
                                        ),
                                      ),
                                      4.height,
                                      Text(
                                        'We need your location to help you get your current location accurately',
                                        textAlign: TextAlign.start,
                                        style: AppTextStyles.light.copyWith(
                                          fontSize: 12,
                                          color: txtdarkgrayColor,
                                        ),
                                      ),
                                      12.height,

                                    ],
                                  ),
                                ),
                                CustomButton(
                                  onTap: _requestLocationPermission,
                                  title: "Allow", isDisable: false,
                                ),
                              ],

                            ),
                          ),
                        )
                      : const SizedBox.shrink()),
                ],
              );
            }),
          ),
          // Select Location Button - Only show if permission granted
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
                title: 'Select Location',
                onTap: _onSelectLocationTap,
                isDisable: false,
              ),
            ),
          )
        ],
      ),
    );
  }

  String _getPlaceName(Placemark placemark) {
    if (placemark.name != null && placemark.name!.isNotEmpty) {
      return placemark.name!;
    } else if (placemark.street != null && placemark.street!.isNotEmpty) {
      return placemark.street!;
    } else if (placemark.subLocality != null &&
        placemark.subLocality!.isNotEmpty) {
      return placemark.subLocality!;
    } else if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      return placemark.locality!;
    }
    return 'Unknown Location';
  }

  String _buildAddressFromPlacemark(Placemark placemark) {
    List<String> parts = [];
    if (placemark.street != null && placemark.street!.isNotEmpty) {
      parts.add(placemark.street!);
    }
    if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
      parts.add(placemark.subLocality!);
    }
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      parts.add(placemark.locality!);
    }
    if (placemark.administrativeArea != null &&
        placemark.administrativeArea!.isNotEmpty) {
      parts.add(placemark.administrativeArea!);
    }
    if (placemark.postalCode != null && placemark.postalCode!.isNotEmpty) {
      parts.add(placemark.postalCode!);
    }
    return parts.join(', ');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    mapController?.dispose();
    _searchDebounce?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }
}

