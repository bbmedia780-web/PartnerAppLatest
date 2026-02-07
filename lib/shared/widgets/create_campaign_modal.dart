
import '../../../../../utils/library_utils.dart';

class CreateCampaignModal extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController campaignNameController;
  final TextEditingController dailyBudgetController;
  final String selectedCampaignType;
  final String selectedDuration;
  final List<String> campaignTypes;
  final List<String> durationOptions;
  final Function(String) onCampaignTypeSelected;
  final Function(String) onDurationSelected;
  final VoidCallback onCreate;
  final VoidCallback onCancel;

   CreateCampaignModal({
    super.key,
    required this.campaignNameController,
    required this.dailyBudgetController,
    required this.selectedCampaignType,
    required this.selectedDuration,
    required this.campaignTypes,
    required this.durationOptions,
    required this.onCampaignTypeSelected,
    required this.onDurationSelected,
    required this.onCreate,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Create campaign',
                  style: AppTextStyles.subHeading.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                ),
                GestureDetector(
                  onTap: onCancel,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: whiteColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Campaign name field
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Campaign name',
                    style: AppTextStyles.subHeading.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: blackColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    labelName: '',
                    controller: campaignNameController,
                    hintText: 'Diwali mega sale',
                    borderRadius: 12,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderGreyColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: tealColor),
                    ),
                    validator: (value) => Validators().requiredField(value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Campaign type field
            Text(
              'Campaign type',
              style: AppTextStyles.subHeading.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: blackColor,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showCampaignTypePicker(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: borderGreyColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedCampaignType.isEmpty
                          ? 'Select a type'
                          : selectedCampaignType,
                      style: AppTextStyles.regular.copyWith(
                        fontSize: 14,
                        color: selectedCampaignType.isEmpty
                            ? txtdarkgrayColor
                            : blackColor,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: txtdarkgrayColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Daily budget field
            Text(
              'Daily budget',
              style: AppTextStyles.subHeading.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: blackColor,
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              labelName: '',
              controller: dailyBudgetController,
              textInputType: TextInputType.number,
              hintText: '₹500 per day',
              borderRadius: 12,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderGreyColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: tealColor),
              ),
              validator: (value) => Validators().requiredField(value),
            ),
            const SizedBox(height: 20),
            // Duration field
            Text(
              'Duration',
              style: AppTextStyles.subHeading.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: blackColor,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showDurationPicker(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: borderGreyColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time, color: txtdarkgrayColor, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          selectedDuration.isEmpty
                              ? 'Select duration'
                              : selectedDuration,
                          style: AppTextStyles.regular.copyWith(
                            fontSize: 14,
                            color: selectedDuration.isEmpty
                                ? txtdarkgrayColor
                                : blackColor,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_drop_down, color: txtdarkgrayColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Create button
            SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      onCreate();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tealColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Create campaign',
                    style: AppTextStyles.button.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCampaignTypePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Campaign Type',
              style: AppTextStyles.subHeading.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ),
            const SizedBox(height: 16),
            ...campaignTypes.map((type) => ListTile(
                  title: Text(
                    type,
                    style: AppTextStyles.regular.copyWith(
                      fontSize: 14,
                      color: blackColor,
                    ),
                  ),
                  onTap: () {
                    onCampaignTypeSelected(type);
                    Get.back();
                  },
                  trailing: selectedCampaignType == type
                      ? Icon(Icons.check, color: tealColor)
                      : null,
                )),
          ],
        ),
      ),
    );
  }

  void _showDurationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Duration',
              style: AppTextStyles.subHeading.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ),
            const SizedBox(height: 16),
            ...durationOptions.map((duration) => ListTile(
                  leading: Icon(Icons.access_time, color: txtdarkgrayColor, size: 20),
                  title: Text(
                    duration,
                    style: AppTextStyles.regular.copyWith(
                      fontSize: 14,
                      color: blackColor,
                    ),
                  ),
                  onTap: () {
                    onDurationSelected(duration);
                    Get.back();
                  },
                  trailing: selectedDuration == duration
                      ? Icon(Icons.check, color: tealColor)
                      : null,
                )),
          ],
        ),
      ),
    );
  }
}

