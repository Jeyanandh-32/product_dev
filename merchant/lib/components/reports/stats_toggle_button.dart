import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';

class StatsToggleButton extends StatelessComponent {
  final bool showStats;
  final VoidCallback onToggle;

  const StatsToggleButton({
    super.key,
    required this.showStats,
    required this.onToggle,
  });

  @override
  Component build(BuildContext context) {
    final activeClass = showStats
        ? 'border-primary bg-primary text-primary-content'
        : 'border-border-medium bg-white hover:bg-neutral text-gray-700';

    return button(
      type: .button,
      classes:
          'btn btn-sm rounded-full border text-xs font-semibold px-3 h-8 flex items-center gap-1.5 shadow-2xs cursor-pointer transition-all $activeClass',
      events: {
        'click': (e) => onToggle(),
      },
      [
        if (showStats)
          EyeOff(classes: 'w-3.5 h-3.5')
        else
          ChartColumn(classes: 'w-3.5 h-3.5'),
        .text(showStats ? 'Hide Stats' : 'View Stats'),
      ],
    );
  }
}
