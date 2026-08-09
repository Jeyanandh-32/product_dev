import 'dart:js_interop';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide Map;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:web/web.dart' as web;

class FormField extends StatefulComponent {
  final String id;
  final String labelText;
  final Component? icon;
  final InputType type;
  final Map<String, String>? attributes;
  final String? hintText;
  final void Function(dynamic)? onChange;
  final bool enableForgotPassword;

  const FormField({
    super.key,
    required this.id,
    required this.labelText,
    required this.type,
    required this.attributes,
    this.hintText,
    this.icon,
    this.onChange,
    this.enableForgotPassword = false,
  });

  @override
  State<FormField> createState() => _FormFieldState();
}

class _FormFieldState extends State<FormField> {
  bool _obscureText = true;

  void _handleInput(dynamic eventOrValue) {
    if (component.onChange == null) return;
    try {
      final event = eventOrValue as web.Event;
      final target = event.target as web.HTMLInputElement?;
      if (target != null) {
        component.onChange!(target.value);
        return;
      }
    } catch (_) {}
    if (eventOrValue is String) {
      component.onChange!(eventOrValue);
      return;
    }
    component.onChange!(eventOrValue?.toString());
  }

  void _handleKeyDown(dynamic eventOrValue) {
    try {
      final event = eventOrValue as web.KeyboardEvent;
      if (event.key == 'Enter') {
        final currentTarget = event.target as web.HTMLInputElement?;
        final form = currentTarget?.form;
        if (form != null) {
          final elements = form.querySelectorAll(
            'input:not([type="hidden"]):not([disabled])',
          );
          final list = <web.HTMLInputElement>[];
          for (var i = 0; i < elements.length; i++) {
            final item = elements.item(i);
            if (item.isA<web.HTMLInputElement>()) {
              list.add(item as web.HTMLInputElement);
            }
          }
          final index = list.indexOf(currentTarget!);
          if (index != -1 && index < list.length - 1) {
            event.preventDefault();
            list[index + 1].focus();
          }
        }
      }
    } catch (_) {}
  }

  @override
  Component build(BuildContext context) {
    final isPassword = component.type == InputType.password;

    return fieldset(classes: 'fieldset w-full mb-4', [
      div(classes: 'flex items-center justify-between', [
        label(
          htmlFor: component.id,
          classes: 'label text-[14px] font-semibold text-gray-500',
          [?component.icon, .text(component.labelText)],
        ),
        if (component.enableForgotPassword)
          button(
            type: .button,
            classes: 'text-sm font-semibold text-accent hover:cursor-pointer',
            onClick: () => context.push('/forgotPassword'),
            [
              .text('Forgot Password?'),
            ],
          ),
      ]),
      if (isPassword)
        div(classes: 'relative w-full', [
          input(
            id: component.id,
            name: component.id,
            type: _obscureText ? InputType.password : InputType.text,
            onInput: _handleInput,
            onChange: _handleInput,
            events: {'keydown': _handleKeyDown},
            classes:
                'input validator h-11 border border-border-medium w-full rounded-lg pr-10',
            attributes: component.attributes,
          ),
          button(
            type: .button,
            classes:
                'absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600 hover:cursor-pointer p-1 rounded-md transition-colors',
            events: {
              'click': (e) {
                e.preventDefault();
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            },
            [
              if (_obscureText)
                Eye(classes: 'w-4.5 h-4.5')
              else
                EyeOff(classes: 'w-4.5 h-4.5'),
            ],
          ),
        ])
      else
        input(
          id: component.id,
          name: component.id,
          type: component.type,
          onInput: _handleInput,
          onChange: _handleInput,
          events: {'keydown': _handleKeyDown},
          classes:
              'input validator h-11 border border-border-medium w-full rounded-lg',
          attributes: component.attributes,
        ),
      p(classes: 'validator-hint hidden', [
        if (component.hintText != null) .text(component.hintText!),
      ]),
    ]);
  }
}
