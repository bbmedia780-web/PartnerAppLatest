
import 'package:flutter/material.dart';
import 'package:varnika_app/shared/widgets/txt.dart';

class Widgets {
  Widgets._privateConstructor();
  static final Widgets _instance = Widgets._privateConstructor();
  static Widgets get instance => _instance;

  static String avatar(String phoneNumberOrRemoteKey) {
    String fileName = phoneNumberOrRemoteKey.replaceAll("+", "%2B");
    return "https://firebasestorage.googleapis.com/v0/b/service-ad14a.appspot.com/o/avatars%2F$fileName.jpg?alt=media";
  }

 
  ///This will return the darken color of the given value
  static Color darkenColor(Color color, double value) =>
      HSLColor.fromColor(color).withLightness(value).toColor();

  static Txt subtitle(BuildContext context, String text,
      {TextAlign? textAlign, double? fontSize = 12}) {
    return Txt(
        text: text,
        textAlign: textAlign,
        fontSize: fontSize,
        color: subtitleColor(context));
  }

  static Color subtitleColor(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.5);
  }

  static const Duration duration = Duration(milliseconds: 350);
  static const Duration duration1Sec = Duration(seconds: 1);
  static const Duration duration2Sec = Duration(seconds: 2);
  static const Duration duration3Sec = Duration(seconds: 3);

  static const Curve curve = Curves.easeIn;

  static bool debugging = kDebugMode;
  static bool debugMode = kDebugMode;

  static List<String> generateTags(List sentences) {
    List<String> _tags = [];
    sentences.forEach((sentence) {
      if (sentence != null) {
        List words = '$sentence'.toLowerCase().split(' ');
        words.forEach((word) {
          if (_tags.contains(word) == false) _tags.add(word);
        });
      }
    });
    return _tags
      ..sort((b, a) => a.length.compareTo(b.length))
      ..removeWhere((element) => element.length < 3);
  }

  static Widget boldHeading(String string, {double? left}) {
    return Container(
      padding: EdgeInsets.only(top: 18, bottom: 3, left: left ?? 8),
      alignment: Alignment.centerLeft,
      child: Txt(
        text: string,
        fontWeight: FontWeight.bold,
        textAlign: TextAlign.start,
        fontSize: 16,
      ),
    );
  }


  static Future wait(int milliseconds) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }




  static double mheight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double mwidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

}



