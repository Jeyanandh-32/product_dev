import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';

/// Navigation link button components for the merchant app sidebar drawer.
class DrawerNavButtons {
  const DrawerNavButtons._();

  static Component chevron({required bool isOpen}) {
    const iconClass = 'w-4 h-4 ml-auto mr-3 text-slate-400';
    return isOpen
        ? ChevronDown(classes: iconClass)
        : ChevronRight(classes: iconClass);
  }

  static Component navButton({
    required String name,
    required Component prefixIcon,
    Component? suffixIcon,
    bool isSelected = false,
    bool isExpandable = false,
    VoidCallback? onClick,
  }) {
    final isClickable = !isSelected || isExpandable;
    final isSelectedClasses = isSelected
        ? 'bg-slate-900 text-white shadow-xs font-semibold ${isExpandable ? 'hover:cursor-pointer' : 'cursor-default'}'
        : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100/80 hover:cursor-pointer font-medium';

    return li([
      button(
        onClick: isClickable ? onClick : null,
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
        onClick: onClick,
        classes:
            'text-sm ${isSelected ? 'text-blue-600 bg-blue-50/80 font-semibold' : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100/80 font-medium'} hover:cursor-pointer rounded-lg h-9 w-full flex items-center px-2.5 transition-all',
        [
          Dot(
            classes:
                'w-5 h-5 shrink-0 ${isSelected ? 'text-blue-600' : 'text-slate-400'}',
          ),
          .text(name),
        ],
      ),
    ]);
  }
}
