import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/dot.dart';

/// Navigation link button components for the merchant app sidebar drawer.
class DrawerNavButtons {
  const DrawerNavButtons._();

  static Component navButton({
    required String name,
    required Component prefixIcon,
    Component? suffixIcon,
    bool isSelected = false,
    VoidCallback? onClick,
  }) {
    final isSelectedClasses = isSelected
        ? 'bg-primary text-primary-content cursor-default'
        : 'text-gray-500 hover:bg-neutral hover:cursor-pointer';

    return li([
      button(
        onClick: isSelected ? null : onClick,
        classes:
            'flex gap-2 h-10 w-full font-medium items-center rounded-lg pl-4 text-sm transition-all duration-300 $isSelectedClasses',
        [
          prefixIcon,
          .text(name),
          ?suffixIcon,
        ],
      ),
    ]);
  }

  static Component navSubButton({
    required String name,
    bool isSelected = false,
    VoidCallback? onClick,
  }) {
    return li(classes: 'w-full', [
      button(
        onClick: isSelected ? null : onClick,
        classes:
            'text-sm ${isSelected ? 'text-accent' : 'text-gray-500'} font-semibold hover:cursor-pointer hover:bg-neutral rounded-lg h-8 w-full flex items-center',
        [
          Dot(classes: 'w-8 h-8'),
          .text(name),
        ],
      ),
    ]);
  }
}
