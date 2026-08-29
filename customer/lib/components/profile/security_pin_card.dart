import 'package:customer/components/profile/security_pin_inputs.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router;

/// Customer account security PIN management card.
class SecurityPinCard extends StatelessComponent {
  final bool isEditing;
  final bool isSaving;
  final String? error;
  final VoidCallback onStartEdit;
  final VoidCallback onCancel;
  final ValueChanged<String> onCurrentPinChanged;
  final ValueChanged<String> onNewPinChanged;
  final ValueChanged<String> onConfirmPinChanged;
  final VoidCallback onSave;

  const SecurityPinCard({
    super.key,
    required this.isEditing,
    required this.isSaving,
    required this.error,
    required this.onStartEdit,
    required this.onCancel,
    required this.onCurrentPinChanged,
    required this.onNewPinChanged,
    required this.onConfirmPinChanged,
    required this.onSave,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'bg-white rounded-3xl border border-gray-200/90 p-6 sm:p-8 shadow-xs flex flex-col gap-6',
      [
        div(
          classes:
              'flex items-center justify-between border-b border-gray-100 pb-4',
          [
            div(classes: 'flex items-center gap-2.5', [
              Lock(classes: 'w-5 h-5 text-gray-700'),
              h3(classes: 'text-base font-extrabold text-black', [
                .text('Security PIN'),
              ]),
            ]),
            if (!isEditing)
              button(
                classes: 'flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-gray-100 hover:bg-black hover:text-white text-gray-700 font-bold text-xs transition-all border-0 cursor-pointer active:scale-95',
                onClick: onStartEdit,
                [
                  KeyRound(classes: 'w-3.5 h-3.5'),
                  .text('Change PIN'),
                ],
              ),
          ],
        ),

        if (isEditing)
          div(classes: 'flex flex-col gap-4 animate-in fade-in duration-150', [
            SecurityPinInputs(
              onCurrentPinChanged: onCurrentPinChanged,
              onNewPinChanged: onNewPinChanged,
              onConfirmPinChanged: onConfirmPinChanged,
            ),

            if (error case final msg? when msg.isNotEmpty)
              p(classes: 'text-xs text-red-600 font-semibold mt-0.5', [
                .text(msg),
              ]),

            div(classes: 'flex items-center justify-end gap-2 pt-2', [
              button(
                classes: 'px-4 py-2 rounded-xl bg-gray-100 hover:bg-gray-200 text-gray-700 font-bold text-xs transition-all border-0 cursor-pointer',
                onClick: onCancel,
                [.text('Cancel')],
              ),
              button(
                classes: 'px-5 py-2 rounded-xl bg-black text-white hover:bg-gray-800 font-bold text-xs transition-all border-0 cursor-pointer shadow-2xs flex items-center gap-1.5',
                onClick: isSaving ? null : onSave,
                [
                  if (isSaving)
                    span(
                      classes: 'loading loading-spinner loading-xs text-white',
                      [],
                    )
                  else
                    Lock(classes: 'w-3.5 h-3.5 text-white'),
                  .text(isSaving ? 'Updating...' : 'Update PIN'),
                ],
              ),
            ]),
          ])
        else
          div(classes: 'flex flex-col gap-1', [
            span(
              classes:
                  'text-xs font-bold text-gray-400 uppercase tracking-wider',
              [
                .text('Security PIN Status'),
              ],
            ),
            span(
              classes:
                  'text-sm font-extrabold text-black font-mono tracking-widest',
              [
                .text('••••••'),
              ],
            ),
          ]),
      ],
    );
  }
}
