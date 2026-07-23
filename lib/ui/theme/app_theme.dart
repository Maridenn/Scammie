import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color brandColor = Color.fromARGB(255, 37, 99, 235);
  static const Color errorColor = Color.fromARGB(255, 181, 10, 10);

  static const Color sendBlue = Color.fromARGB(255, 0, 122, 255);
  static const Color receivedGray = Color.fromARGB(255, 233, 233, 235);

  static const Color chipBackground = Color.fromARGB(255, 238, 238, 238);
  static const Color dividerColor = Color.fromARGB(255, 200, 199, 199);

  static const Color sentTextColor = Colors.white;
  static const Color receivedTextColor = Colors.black;
  static const Color chipTextColor = Colors.black87;

  static const TextStyle quickReplyStyle = TextStyle(
    color: chipTextColor,
    fontSize: 14.0,
  );

  static const TextStyle sentMessage = TextStyle(
    fontSize: 16.0,
    color: sentTextColor,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
  );

  static const TextStyle receivedMessage = TextStyle(
    fontSize: 16.0,
    color: receivedTextColor,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
  );

  static final TextStyle heading = GoogleFonts.nunito(
    fontSize: 18.0,
    color: receivedTextColor,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle subheading = GoogleFonts.nunito(
    fontSize: 16.0,
    color: chipTextColor,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle brandName = GoogleFonts.orbitron(
    fontSize: 28,
    color: brandColor,
    fontWeight: FontWeight.w800,
  );

  static final ThemeData theme = ThemeData(
    colorSchemeSeed: brandColor,
    textTheme: GoogleFonts.nunitoTextTheme(),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: subheading,
      floatingLabelStyle: subheading.copyWith(color: brandColor),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: brandColor,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        textStyle: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        side: const BorderSide(color: dividerColor),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
