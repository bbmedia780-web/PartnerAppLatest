
import '../../../../../utils/library_utils.dart';

class AppTextStyles {
  // Title / Heading - Large (for main titles)
  static TextStyle heading1 = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Colors.black,
    letterSpacing: -0.3,
  );

  // Heading - Medium (for section titles)
  static TextStyle heading2 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black,
    letterSpacing: -0.2,
  );

  // Sub-heading - Medium (for descriptions)
  static TextStyle subHeading = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
    height: 1.3,
  );

  // Normal text - Regular (for body text)
  static TextStyle regular = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
    height: 1.4,
  );

  // Light text - Small (for hints, captions)
  static TextStyle light = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: kColorGray,
    height: 1.3,
  );

  // Button Text
  static TextStyle button = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  // Small text - Extra small (for fine print)
  static TextStyle small = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: kColorGray,
    height: 1.3,
  );
}
