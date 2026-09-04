import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

/// Clean extension on [BuildContext] for responsive layout helpers and screen sizes.
extension ResponsiveContextX on BuildContext {
  /// The current screen width.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// The current screen height.
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// The Forui theme breakpoints.
  FBreakpoints get breakpoints => theme.breakpoints;

  /// Whether the current screen is compact / mobile (<= md breakpoint / 768px).
  /// For 768px tablet portrait screens, mobile flow is used because there is
  /// not enough room for the cart sidebar alongside the catalog.
  bool get isMobile => screenWidth <= breakpoints.md;

  /// Whether the current screen is tablet (> md breakpoint and < lg breakpoint).
  bool get isTablet =>
      screenWidth > breakpoints.md && screenWidth < breakpoints.lg;

  /// Whether the current screen is desktop (>= lg breakpoint).
  bool get isDesktop => screenWidth >= breakpoints.lg;

  /// Dynamic product catalog column count based on current breakpoint.
  int get productGridColumns => switch (screenWidth) {
    _ when screenWidth < breakpoints.sm => 2,
    _ when screenWidth <= breakpoints.md => 3,
    _ when screenWidth < breakpoints.lg => 2,
    _ when screenWidth < breakpoints.xl => 3,
    _ => 4,
  };
}
