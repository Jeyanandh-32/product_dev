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

  /// Whether the current screen is compact / mobile (< sm breakpoint).
  bool get isMobile => screenWidth < breakpoints.sm;

  /// Whether the current screen is tablet (< lg breakpoint).
  bool get isTablet =>
      screenWidth >= breakpoints.sm && screenWidth < breakpoints.lg;

  /// Whether the current screen is desktop (>= lg breakpoint).
  bool get isDesktop => screenWidth >= breakpoints.lg;

  /// Dynamic product catalog column count based on current breakpoint.
  int get productGridColumns => switch (screenWidth) {
        _ when screenWidth < breakpoints.sm => 2,
        _ when screenWidth < breakpoints.lg => 3,
        _ when screenWidth < breakpoints.xl => 3,
        _ => 4,
      };
}
