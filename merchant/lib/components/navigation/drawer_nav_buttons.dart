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
        ? 'bg-slate-900 text-white shadow-xs font-semibold cursor-default'
        : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100/80 hover:cursor-pointer font-medium';

    return li([
      button(
        onClick: isSelected ? null : onClick,
        classes:
            'flex gap-2.5 h-10 w-full items-center rounded-xl px-3.5 text-sm transition-all duration-150 $isSelectedClasses',
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
            'text-xs ${isSelected ? 'text-blue-600 bg-blue-50/80 font-bold' : 'text-slate-500 hover:text-slate-900 hover:bg-slate-100/80 font-medium'} hover:cursor-pointer rounded-lg h-8 w-full flex items-center px-2 transition-all',
        [
          Dot(
            classes:
                'w-5 h-5 ${isSelected ? 'text-blue-600' : 'text-slate-400'}',
          ),
          .text(name),
        ],
      ),
    ]);
  }
}
