//- notification-Screen
import '../utils/library_utils.dart';

// final height = ((MediaQuery.of(context).size.height));
// final width = (MediaQuery.of(context).size.width);
String addAttr(String svg) {
  // Add stroke and fill attributes to the <svg> tag
  if (!svg.contains('stroke=')) {
    svg = svg.replaceFirst('<svg', '<svg stroke="#777e90"');
  }
  if (!svg.contains('fill=')) {
    svg = svg.replaceFirst('<svg', '<svg fill="none"');
  }
  return svg;
}
bool isTablet(BuildContext context) {
  return MediaQuery.of(context).size.width >= 600;
}