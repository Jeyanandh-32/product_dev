import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Submit action button matching Finch design system with exact 16px radius and 48px height.
class AuthSubmitButton extends StatelessComponent {
  final String label;
  final String loadingLabel;
  final bool isLoading;

  const AuthSubmitButton({
    super.key,
    required this.label,
    this.loadingLabel = 'Signing In...',
    this.isLoading = false,
  });

  @override
  Component build(BuildContext context) {
    return button(
      type: .submit,
      disabled: isLoading,
      classes: 'w-full h-12 rounded-2xl bg-brand-dark hover:bg-brand-surface hover:shadow-[0_4px_14px_rgba(11,19,43,0.22)] active:scale-[0.98] text-white font-extrabold text-sm transition-all duration-150 flex items-center justify-center cursor-pointer mt-2 border-none outline-none disabled:bg-slate-300 disabled:text-white/60 disabled:cursor-not-allowed disabled:transform-none disabled:shadow-none',
      [
        if (isLoading) ...[
          span(
            classes: 'loading loading-spinner loading-xs text-white mr-2',
            [],
          ),
          span(classes: 'text-sm font-extrabold text-white', [
            .text(loadingLabel),
          ]),
        ] else
          span(classes: 'leading-none', [.text(label)]),
      ],
    );
  }
}
