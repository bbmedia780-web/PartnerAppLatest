import 'package:varnika_app/constarits/app_sizes.dart';

import '../../../../../utils/library_utils.dart';

class AppGlobal {
  static Widget commonDivider({
    double indent = 0,
    double endIndent = 0,
    double thickness = 1,
    Color color = Colors.grey,
  }) {
    return Divider(
      color: color,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
    );
  }
}

enum ToastType { success, error, warning, info }

class ShowToast {
  static void show({
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    IconData icon;
    Color color;
    Color backgroundColor;

    switch (type) {
      case ToastType.success:
        icon = Icons.check_circle;
        color = toastSuccessIcon;
        backgroundColor = toastSuccessBg;
        break;
      case ToastType.error:
        icon = Icons.error;
        color = toastErrorIcon;
        backgroundColor = toastErrorBg;
        break;
      case ToastType.warning:
        icon = Icons.warning;
        color = toastWarningIcon;
        backgroundColor = toastWarningBg;
        break;
      case ToastType.info:
        icon = Icons.info;
        color = toastInfoIcon;
        backgroundColor = toastInfoBg;
    }

    final overlay = Overlay.of(Get.overlayContext!);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        // Get keyboard height to position toast above it
        final mediaQuery = MediaQuery.of(context);
        final keyboardHeight = mediaQuery.viewInsets.bottom;
        // Position toast above keyboard if keyboard is open, otherwise use default bottom spacing
        final bottomPosition = keyboardHeight > 0 
            ? keyboardHeight + AppSizes.spacing20 
            : AppSizes.spacing20;
        
        return Positioned(
          bottom: bottomPosition,
          left: AppSizes.spacing20,
          right: AppSizes.spacing20,
          child: Material(
            color: transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacing12, 
                vertical: AppSizes.spacing14,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                border: Border.all(color: color, width: AppSizes.borderWidth1_5), // outline
                boxShadow: [
                  BoxShadow(
                    color: whiteColor,
                    blurRadius: AppSizes.spacing6,
                    offset: const Offset(0, AppSizes.spacing4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(icon, color: color, size: AppSizes.spacing24),
                  const SizedBox(width: AppSizes.spacing12),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: color, 
                        fontSize: AppSizes.caption,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => overlayEntry.remove(),
                    child: Icon(Icons.close, color: color, size: AppSizes.spacing20),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      if (overlayEntry.mounted) overlayEntry.remove();
    });
  }

  static void success(String message) =>
      show(message: message, type: ToastType.success);

  static void error(String message) =>
      show(message: message, type: ToastType.error);

  static void warning(String message) =>
      show(message: message, type: ToastType.warning);

  static void info(String message) =>
      show(message: message, type: ToastType.info);
}






