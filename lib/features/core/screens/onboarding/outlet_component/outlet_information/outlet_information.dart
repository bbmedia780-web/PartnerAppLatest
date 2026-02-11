import '../../../../../../utils/library_utils.dart';

class OutletInformationView extends GetView<OnBoardingController> {
  const OutletInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    OnBoardingController controller = Get.put(OnBoardingController());
    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar(title: "Outlet Information"),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: controller.formKey,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What's your outlet type?",
                      style: AppTextStyles.heading1.copyWith(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    10.height,
                    Obx(
                      () => InkWell(
                        onTap: () async {
                          final result = await Get.toNamed(
                            AppRoutes.outletTypeSelection,
                          );
                          if (result != null) {
                            controller.selectedOutletType.value = result;
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: dividerColor.withValues(alpha: 0.5), width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// Show selected value OR hint text
                              Text(
                                controller.selectedOutletType.value == null
                                    ? "Choose your outlet type"
                                    : controller.selectedOutletType.value ?? '',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      controller.selectedOutletType.value ==
                                          null
                                      ? kColorGray
                                      : Colors.black,
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios_outlined,color: appColor,size: 18,)
                            ],
                          ),
                        ),
                      ),
                    ),
                    10.height,
                    Text(
                      "Basic Details",
                      style: AppTextStyles.subHeading.copyWith(fontSize: 16),
                    ),
                    8.height,
                    CustomContainer(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            textInputType: TextInputType.name,
                            hintText: 'Zuniun yark',
                            labelName: 'Owner full name',
                            controller: controller.ownerNameController,
                            validator: (value) =>
                                Validators().requiredField(value),
                          ),
                          8.height,
                          CustomTextField(
                            textInputType: TextInputType.name,
                            hintText: 'Black Boutique',
                            labelName: 'Parlor / Boutique name',
                            controller: controller.parlorNameController,
                            validator: (value) =>
                                Validators().requiredField(value),
                          ),
                          8.height,
                          CustomTextField(
                            onlyRead: true,
                            onTap: () async {
                              await Get.to(() => const SelectLocationScreen());
                            },
                            minLine: 1,
                            maxLine: 2,
                            suffixWidget: Text(
                              'Edit',
                              style: AppTextStyles.subHeading.copyWith(
                                color: kColorPink,
                                fontSize: 14,
                              ),
                            ),
                            textInputType: TextInputType.name,
                            hintText: '209, Mauntain Diver , Mumbai',
                            labelName: 'Address',
                            controller: controller.addressController,
                            validator: (value) =>
                                Validators().requiredField(value),
                          ),
                        ],
                      ),
                    ),
                    10.height,
                    Text(
                      "Owner Contact Details",
                      style: AppTextStyles.subHeading.copyWith(fontSize: 16),
                    ),
                    8.height,
                    CustomContainer(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            textInputType: TextInputType.emailAddress,
                            hintText: 'zuniunyark@gmail.com',
                            labelName: 'Email',
                            controller: controller.emailController,
                            validator: (value) =>
                                Validators().validateEmail(value),
                          ),
                          8.height,
                          CustomTextField(
                            textInputType: TextInputType.number,
                            hintText: '+91 8765768765',
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            labelName: 'Mobile No',
                            controller: controller.mobileNoController,
                            validator: (value) =>
                                Validators().validateMobile(value),
                          ),
                          8.height,
                        ],
                      ),
                    ),
                    10.height,
                    Text(
                      "Working Days",
                      style: AppTextStyles.subHeading.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    10.height,
                    CustomContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(() {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 10,
                                runSpacing: 5,
                                children: controller.weekDays.map((day) {
                                  final isSelected = controller
                                      .selectedWorkingDays
                                      .contains(day);

                                  return SizedBox(
                                    width: Get.width * 0.27,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () =>
                                              controller.toggleWorkingDay(day),
                                          child: Icon(
                                            isSelected
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: isSelected
                                                ? appColor
                                                : dividerColor,
                                          ),
                                        ),
                                        10.width,
                                        GestureDetector(
                                          onTap: () =>
                                              controller.toggleWorkingDay(day),
                                          child: Text(
                                            day,
                                            style: AppTextStyles.regular
                                                .copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                    10.height,
                    Text(
                      "Opening & Closing time",
                      style: AppTextStyles.subHeading.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    10.height,
                    CustomContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => SizedBox(
                              height: 35,
                              child: RadioListTile<bool>(
                                title: Text(
                                  "I open and close my restaurant at the same time on all working days",
                                  style: AppTextStyles.regular.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                value: true,
                                groupValue:
                                    controller.isSameTimingForAllDays.value,
                                onChanged: (value) =>
                                    controller.isSameTimingForAllDays.value =
                                        value!,
                                activeColor: appColor,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          Obx(
                            () => SizedBox(
                              height: 35,
                              child: RadioListTile<bool>(
                                title: Text(
                                  "I've separate daywise timings",
                                  style: AppTextStyles.regular.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                value: false,
                                groupValue:
                                    controller.isSameTimingForAllDays.value,
                                onChanged: (value) =>
                                    controller.isSameTimingForAllDays.value =
                                        value!,
                                activeColor: appColor,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          16.height,
                          // Time Input Fields
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    final TimeOfDay? picked =
                                        await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme: ColorScheme.light(
                                                  primary: appColor,
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                    if (picked != null) {
                                      final hour12 = picked.hour > 12
                                          ? picked.hour - 12
                                          : (picked.hour == 0
                                                ? 12
                                                : picked.hour);
                                      controller.openingTime.value =
                                          "${hour12.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')} ${picked.period == DayPeriod.am ? 'Am' : 'Pm'}";
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: borderGreyColor,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Obx(
                                          () => Text(
                                            controller.openingTime.value,
                                            style: AppTextStyles.regular
                                                .copyWith(
                                                  fontSize: 14,
                                                  color: blackColor,
                                                ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.access_time,
                                          color: kColorGray,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    final TimeOfDay? picked =
                                        await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme: ColorScheme.light(
                                                  primary: appColor,
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                    if (picked != null) {
                                      final hour12 = picked.hour > 12
                                          ? picked.hour - 12
                                          : (picked.hour == 0
                                                ? 12
                                                : picked.hour);
                                      controller.closingTime.value =
                                          "${hour12.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')} ${picked.period == DayPeriod.am ? 'Am' : 'Pm'}";
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: borderGreyColor,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Obx(
                                          () => Text(
                                            controller.closingTime.value,
                                            style: AppTextStyles.regular
                                                .copyWith(
                                                  fontSize: 14,
                                                  color: blackColor,
                                                ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.access_time,
                                          color: kColorGray,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          12.height,
                          // Add Slot Button
                          GestureDetector(
                            onTap: () {
                              controller.addTimeSlot();
                            },
                            child: Row(
                              children: [
                                Icon(Icons.add, color: appColor, size: 18),
                                SizedBox(width: 6),
                                Text(
                                  "Add another slot",
                                  style: AppTextStyles.regular.copyWith(
                                    fontSize: 14,
                                    color: appColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Display Time Slots
                          Obx(
                            () => controller.timeSlots.isEmpty
                                ? SizedBox.shrink()
                                : Column(
                                    children: controller.timeSlots
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                          int index = entry.key;
                                          return Padding(
                                            padding: EdgeInsets.only(top: 8),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.all(12),
                                                    decoration: BoxDecoration(
                                                      color: appColor
                                                          .withValues(alpha:0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      border: Border.all(
                                                        color: appColor,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "${entry.value['open']} - ${entry.value['close']}",
                                                      style: AppTextStyles
                                                          .regular
                                                          .copyWith(
                                                            fontSize: 13,
                                                            color: appColor,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                GestureDetector(
                                                  onTap: () => controller
                                                      .removeTimeSlot(index),
                                                  child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: errorColor
                                                          .withValues(alpha:0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      Icons.close,
                                                      color: errorColor,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        })
                                        .toList(),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    20.height,
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.yellow.shade200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.orange.shade700,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Longer operational timings ensures you get 1.5X more orders and helps you avoid cancellations.",
                              style: AppTextStyles.regular.copyWith(
                                fontSize: 13,
                                color: Colors.orange.shade900,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    110.height,
                  ],
                ),
              ),
              Positioned(
                left: 5,
                right: 5,
                bottom: 10,
                child: SafeArea(
                  child: CustomButton(
                    height: 50,
                    title: 'Save',
                    onTap: () {
                      if (controller.formKey.currentState!.validate()) {
                        controller.step1.value = true;
                        Get.back();
                      }
                    },
                    isDisable: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
