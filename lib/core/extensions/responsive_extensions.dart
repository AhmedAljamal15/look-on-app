import 'package:flutter/material.dart';

/// Device size breakpoints for responsive design
class ResponsiveBreakpoints {
  ResponsiveBreakpoints._();

  // Mobile breakpoints
  static const double mobileSmall = 320; // Small phones (iPhone SE)
  static const double mobileMedium = 375; // Standard phones (iPhone)
  static const double mobileLarge = 414; // Large phones (iPhone Plus)

  // Tablet breakpoints
  static const double tabletSmall = 600; // Small tablets
  static const double tabletMedium = 768; // iPad Mini
  static const double tabletLarge = 1024; // iPad Pro

  // Desktop breakpoints
  static const double desktop = 1440; // Desktop/Large screens

  /// Get device type based on width
  static DeviceType getDeviceType(double width) {
    if (width < tabletSmall) return DeviceType.mobile;
    if (width < tabletLarge) return DeviceType.tablet;
    return DeviceType.desktop;
  }
}

/// Device type enum
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

/// Responsive size utilities
extension ResponsiveSizeExtension on BuildContext {
  /// Get media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen width
  double get screenWidth => mediaQuery.size.width;

  /// Get screen height
  double get screenHeight => mediaQuery.size.height;

  /// Get device type
  DeviceType get deviceType => ResponsiveBreakpoints.getDeviceType(screenWidth);

  /// Check if device is mobile
  bool get isMobile => deviceType == DeviceType.mobile;

  /// Check if device is tablet
  bool get isTablet => deviceType == DeviceType.tablet;

  /// Check if device is desktop
  bool get isDesktop => deviceType == DeviceType.desktop;

  /// Check if device is in landscape mode
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  /// Check if device is in portrait mode
  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;

  /// Get device padding (safe area)
  EdgeInsets get devicePadding => mediaQuery.padding;

  /// Get device viewInsets (keyboard height)
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  /// Get keyboard height
  double get keyboardHeight => viewInsets.bottom;

  /// Get text scale factor (for accessibility)
  double get textScaleFactor => mediaQuery.textScaleFactor;

  /// Get pixel ratio (device DPI)
  double get devicePixelRatio => mediaQuery.devicePixelRatio;
}

/// Responsive dimension utilities
extension ResponsiveDimensionExtension on BuildContext {
  /// Get responsive width (percentage of screen width)
  /// Example: context.widthPercent(50) → 50% of screen width
  double widthPercent(double percent) => screenWidth * (percent / 100);

  /// Get responsive height (percentage of screen height)
  /// Example: context.heightPercent(50) → 50% of screen height
  double heightPercent(double percent) => screenHeight * (percent / 100);

  /// Get responsive dimension (mobile, tablet, desktop values)
  double responsiveDimension({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    tablet ??= mobile * 1.25;
    desktop ??= mobile * 1.5;

    return switch (deviceType) {
      DeviceType.mobile => mobile,
      DeviceType.tablet => tablet,
      DeviceType.desktop => desktop,
    };
  }

  /// Get responsive font size
  double responsiveFontSize({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return responsiveDimension(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Get responsive padding
  EdgeInsets responsivePadding({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final value = responsiveDimension(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
    return EdgeInsets.all(value);
  }

  /// Get responsive symmetric padding
  EdgeInsets responsiveSymmetricPadding({
    required double horizontalMobile,
    required double verticalMobile,
    double? horizontalTablet,
    double? verticalTablet,
    double? horizontalDesktop,
    double? verticalDesktop,
  }) {
    final horizontal = responsiveDimension(
      mobile: horizontalMobile,
      tablet: horizontalTablet,
      desktop: horizontalDesktop,
    );
    final vertical = responsiveDimension(
      mobile: verticalMobile,
      tablet: verticalTablet,
      desktop: verticalDesktop,
    );
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  /// Get responsive gap between widgets
  double responsiveGap({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return responsiveDimension(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}

/// Responsive grid utilities
extension ResponsiveGridExtension on BuildContext {
  /// Get number of columns based on device type and screen width
  int getGridColumns({
    int mobileColumns = 2,
    int tabletColumns = 3,
    int desktopColumns = 4,
  }) {
    return switch (deviceType) {
      DeviceType.mobile => mobileColumns,
      DeviceType.tablet => tabletColumns,
      DeviceType.desktop => desktopColumns,
    };
  }

  /// Get responsive aspect ratio
  double getGridAspectRatio({
    required double mobileRatio,
    double? tabletRatio,
    double? desktopRatio,
  }) {
    return responsiveDimension(
      mobile: mobileRatio,
      tablet: tabletRatio,
      desktop: desktopRatio,
    );
  }
}

/// Responsive text utilities
extension ResponsiveTextExtension on BuildContext {
  /// Get responsive heading style
  TextStyle responsiveHeading({
    required double mobileFontSize,
    double? tabletFontSize,
    double? desktopFontSize,
    FontWeight fontWeight = FontWeight.bold,
    Color? color,
  }) {
    final fontSize = responsiveFontSize(
      mobile: mobileFontSize,
      tablet: tabletFontSize,
      desktop: desktopFontSize,
    );
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  /// Get responsive body text style
  TextStyle responsiveBody({
    required double mobileFontSize,
    double? tabletFontSize,
    double? desktopFontSize,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    final fontSize = responsiveFontSize(
      mobile: mobileFontSize,
      tablet: tabletFontSize,
      desktop: desktopFontSize,
    );
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}

/// Responsive builder widget utilities
extension ResponsiveBuilderExtension on BuildContext {
  /// Build widget based on device type
  Widget buildResponsive({
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    return switch (deviceType) {
      DeviceType.mobile => mobile,
      DeviceType.tablet => tablet ?? mobile,
      DeviceType.desktop => desktop ?? tablet ?? mobile,
    };
  }
}
