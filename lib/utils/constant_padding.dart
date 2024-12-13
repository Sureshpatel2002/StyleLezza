import 'package:flutter/material.dart';

class ResponsivePadding {
  static double getPagePadding(BuildContext context) {
    // Get the width of the screen using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;

    // Define padding based on screen width
    if (screenWidth < 600) {
      // Mobile devices
      return 16.0;
    } else if (screenWidth < 1200) {
      // Tablets or small screens
      return 24.0;
    } else {
      // Large screens
      return 32.0;
    }
  }

  static double getWidgetPadding(BuildContext context) {
    // Get the width of the screen using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;

    // Define padding based on screen width
    if (screenWidth < 600) {
      // Mobile devices
      return 12.0;
    } else if (screenWidth < 1200) {
      // Tablets or small screens
      return 16.0;
    } else {
      // Large screens
      return 20.0;
    }
  }
}
