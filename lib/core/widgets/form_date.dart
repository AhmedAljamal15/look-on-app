 import 'package:flutter/material.dart';
import 'package:virtual_tryon_app/core/localization/app_strings.dart';

String formatDate(BuildContext context, DateTime date) {
    final monthKey = 'month_${date.month}';
    return '${context.tr(monthKey)} ${date.year}';
  }