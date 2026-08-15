import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router;
import 'package:web/web.dart' as web;

class EditableInfoCard extends StatelessComponent {
  final String title;
  final String currentValue;
  final String inputLabel;
  final InputType inputType;
  final bool isEditing;
  final bool isSaving;
  final String? error;
  final String? editPin;
  final VoidCallback onStartEdit;
  final VoidCallback onCancel;
  final ValueChanged<String> onValueChanged;
  final ValueChanged<String>? onPinChanged;
  final VoidCallback onSave;

  const EditableInfoCard({
    super.key,
    required this.title,
    required this.currentValue,
    required this.inputLabel,
    this.inputType = InputType.text,
    required this.isEditing,
    required this.isSaving,
    required this.error,
    this.editPin,
    required this.onStartEdit,
    required this.onCancel,
    required this.onValueChanged,
    this.onPinChanged,
    required this.onSave,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'bg-white rounded-3xl border border-gray-200/90 p-6 sm:p-8 shadow-xs flex flex-col gap-6',
      [
        div(
          classes:
              'flex items-center justify-between border-b border-gray-100 pb-4',
          [
            div(classes: 'flex items-center gap-2.5', [
              User(classes: 'w-5 h-5 text-gray-700'),
              h3(classes: 'text-base font-extrabold text-black', [
                .text(title),
              ]),
            ]),
            if (!isEditing)
              button(
                classes:
                    'flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-gray-100 hover:bg-black hover:text-white text-gray-700 font-bold text-xs transition-all border-0 cursor-pointer active:scale-95',
                onClick: onStartEdit,
                [
                  SquarePen(classes: 'w-3.5 h-3.5'),
                  .text('Edit'),
                ],
              ),
          ],
        ),

        if (isEditing)
          div(classes: 'flex flex-col gap-4 animate-in fade-in duration-150', [
            div(classes: 'flex flex-col gap-1.5', [
              label(
                classes:
                    'text-xs font-bold text-gray-700 uppercase tracking-wider',
                [
                  .text(inputLabel),
                ],
              ),
              input(
                type: inputType,
                classes:
                    'w-full px-4 py-3 rounded-2xl border border-gray-300 focus:border-black focus:outline-hidden text-sm font-semibold text-black bg-gray-50/50 transition-all',
                value: currentValue,
                events: {
                  'input': (e) {
                    final input = e.target as web.HTMLInputElement;
                    onValueChanged(input.value);
                  },
                },
              ),
              if (error != null)
                p(classes: 'text-xs text-red-600 font-semibold mt-0.5', [
                  .text(error!),
                ]),
            ]),

            if (onPinChanged != null)
              div(classes: 'flex flex-col gap-1.5', [
                label(
                  classes:
                      'text-xs font-bold text-gray-700 uppercase tracking-wider',
                  [
                    .text('Current Security PIN'),
                  ],
                ),
                input(
                  type: InputType.password,
                  classes:
                      'w-full px-4 py-3 rounded-2xl border border-gray-300 focus:border-black focus:outline-hidden text-sm font-semibold text-black bg-gray-50/50 transition-all font-mono tracking-widest',
                  attributes: {'placeholder': '••••••', 'maxlength': '6'},
                  events: {
                    'input': (e) {
                      final input = e.target as web.HTMLInputElement;
                      onPinChanged!(input.value);
                    },
                  },
                ),
              ]),

            div(classes: 'flex items-center justify-end gap-2 pt-2', [
              button(
                classes:
                    'px-4 py-2 rounded-xl bg-gray-100 hover:bg-gray-200 text-gray-700 font-bold text-xs transition-all border-0 cursor-pointer',
                onClick: onCancel,
                [.text('Cancel')],
              ),
              button(
                classes:
                    'px-5 py-2 rounded-xl bg-black text-white hover:bg-gray-800 font-bold text-xs transition-all border-0 cursor-pointer shadow-2xs flex items-center gap-1.5',
                onClick: isSaving ? null : onSave,
                [
                  if (isSaving)
                    span(
                      classes: 'loading loading-spinner loading-xs text-white',
                      [],
                    )
                  else
                    Check(classes: 'w-3.5 h-3.5 text-white'),
                  .text(isSaving ? 'Saving...' : 'Save Changes'),
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
                .text(inputLabel),
              ],
            ),
            span(classes: 'text-base font-extrabold text-black', [
              .text(currentValue),
            ]),
          ]),
      ],
    );
  }
}
