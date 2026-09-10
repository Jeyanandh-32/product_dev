import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Top branding header for the merchant sidebar drawer.
class DrawerBrandHeader extends StatelessComponent {
  const DrawerBrandHeader({super.key});

  @override
  Component build(BuildContext context) {
    return a(
      href: '/',
      classes: 'w-full h-15 min-h-15 px-5 flex items-center gap-3 group border-b border-border-medium no-underline shrink-0',
      [
        div(
          classes: 'w-9 h-9 rounded-xl overflow-hidden shadow-2xs border border-border-medium group-hover:scale-105 transition-transform duration-200 shrink-0',
          [
            img(
              src: 'images/finch_app_icon_square.png',
              width: 36,
              height: 36,
              classes: 'w-full h-full object-cover',
            ),
          ],
        ),
        div(
          classes: 'flex items-center gap-1.5',
          [
            span(
              classes: 'font-script text-[30px] font-bold text-slate-900 leading-none select-none',
              [.text('Finch')],
            ),
            span(
              classes: 'text-[10px] font-black tracking-widest text-slate-700 bg-slate-100 border border-slate-200 px-1.5 py-0.5 rounded-md uppercase leading-none shadow-2xs select-none',
              [.text('POS')],
            ),
          ],
        ),
      ],
    );
  }
}
