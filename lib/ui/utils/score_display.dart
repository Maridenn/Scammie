import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

Color scoreColor(int score) =>
    score >= 80 ? AppTheme.goodResult : (score >= 50 ? AppTheme.midResult : AppTheme.errorColor);

const List<String> _months = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
];

String formatPlayedAt(DateTime d) =>
    "${_months[d.month - 1]} ${d.day}, ${d.year}";

String capitalize(String s) =>
    s.isEmpty ? s : "${s[0].toUpperCase()}${s.substring(1)}";
