import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color brandColor = Color(0xFF2563EB);
  
  static const Color sendBlue = Color(0xFF007AFF);
  static const Color receivedGray = Color(0xFFE9E9EB);

  static const Color chipBackground = Color(0xFFEEEEEE);
  static const Color dividerColor = Color(0xFFE0E0E0);

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
}
