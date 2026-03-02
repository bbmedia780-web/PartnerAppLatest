import 'package:intl/intl.dart';

class UrlChecker {

  static final urlCheckReg = RegExp(r"((http|https)://)(www.)?" "[a-zA-Z0-9@:%._\\+~#?&//=]" "{2,256}\\.[a-z]" "{2,6}\\b([-a-zA-Z0-9@:%" "._\\+~#?&//=]*)");

  static final checkImageUrlReg = RegExp(r"(https?:\/\/.*\.(?:jpg|jpeg|png|webp|avif|gif|svg))");

  static bool isImageUrl(String url){
    return checkImageUrlReg.hasMatch(url);
  }

  static bool isValid(String url){
    return urlCheckReg.hasMatch(url);
  }
}

class DateFormatter {
  static String getTimeAgo(DateTime dateTime ,{bool numericDates = true}) {
    final date2 = DateTime.now();
    final difference = date2.difference(dateTime);

    if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1w' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays}d';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1d' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours}h';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1h' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes}m';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1m' : 'A min ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds}s';
    } else {
      return 'Just now';
    }
  }
}

class NumbersToShort{
  static String convertNumToShort(int number){
    if(number==0){
      return '0';
    }
    return NumberFormat.compactCurrency(
      decimalDigits: 2,
      symbol: '',
    ).format(number).replaceAll('.00', '');
  }
}