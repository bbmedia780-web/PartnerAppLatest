import '../../../../../../utils/library_utils.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {
        "date": "Today, May 21",
        "items": [
          {
            "title": "Special offer: Double data on weekly plans!",
            "subtitle": "Check out the latest deals on our app.",
            "time": "8:28 am"
          },
          {
            "title": "Enjoy unlimited data with our new daily pack!",
            "subtitle": "Recharge to get 10% extra",
            "time": "6:36 am"
          },
        ]
      },
      {
        "date": "Yesterday, May 20",
        "items": [
          {
            "title": "Exclusive: Free streaming on Banglaflix",
            "subtitle": "with our new plan.",
            "time": "11:15 am",
            "isDeletable": true
          }
        ]
      },
      {
        "date": "May 19",
        "items": [
          {
            "title": "Your subscription to the Music Station is now active.",
            "subtitle": "",
            "time": "9:00 pm"
          },
          {
            "title": "New games available in the app!",
            "subtitle": "Experience seamless broadband gaming.",
            "time": "7:15 pm"
          },
          {
            "title": "Reminder: Pay your bill to avoid service interruption.",
            "subtitle": "Your balance is low.",
            "time": "12:17 pm"
          }
        ]
      }
    ];

    if (!Get.isRegistered<NotificationController>()) {
      NotificationBinding().dependencies();
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar:CustomAppBar(title: "Notifications"),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: notifications.map((group) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// DATE HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      group["date"],
                      style: AppTextStyles.heading2.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  /// LIST OF NOTIFICATIONS FOR DATE
                  ...List.generate(
                    group["items"].length,
                        (index) => _notificationTile(
                      group["items"][index],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// ------------------------------------------
  /// Single Notification Tile Widget
  /// ------------------------------------------
  Widget _notificationTile(Map<String, dynamic> data) {
    bool isDeletable = data["isDeletable"] == true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Stack(
        children: [
          /// Delete button (slide effect illusion)
          if (isDeletable)
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.delete, color: Colors.red),
                ),
              ),
            ),

          /// MAIN NOTIFICATION CARD
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.05),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ICON
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: appColor.withValues(alpha:0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.notifications_active, color: appColor),
                ),
                12.width,

                /// TEXT DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data["title"],
                        style: AppTextStyles.subHeading.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.3),
                      ),
                      if (data["subtitle"] != "")
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            data["subtitle"],
                            style: AppTextStyles.regular.copyWith(
                                color: Colors.black54,
                                fontSize: 11,
                                height: 1.3),
                          ),
                        ),
                      6.height,
                      /// TIME
                      Text(
                        data["time"],
                        style: TextStyle(
                            color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                /// Slide Spacing
                if (isDeletable) 40.width,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

