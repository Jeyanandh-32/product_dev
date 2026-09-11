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
    final callback = component.onChange;
    if (callback == null) return;
    try {
      final event = eventOrValue as web.Event;
      final target = event.target as web.HTMLInputElement?;
      if (target != null) {
        callback(target.value);
        return;
      }
    } catch (_) {}
    if (eventOrValue is String) {
      callback(eventOrValue);
      return;
    }
    callback(eventOrValue?.toString() ?? '');
  }

  void _handleKeyDown(dynamic eventOrValue) {
    try {
      final event = eventOrValue as web.KeyboardEvent;
      if (event.key == 'Enter') {
        final target = event.target as web.HTMLInputElement?;
        final form = target?.form;
        if (form != null && target != null) {
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
          final index = list.indexOf(target);
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
    final icon = component.icon;

    return fieldset(classes: 'fieldset w-full mb-4', [
      div(classes: 'flex items-center justify-between mb-1.5', [
        label(
          htmlFor: component.id,
          classes: 'label text-sm font-bold text-slate-700 flex items-center gap-2 p-0',
          [
            ?icon,
            .text(component.labelText),
          ],
        ),
        if (component.enableForgotPassword)
          button(
            type: .button,
            classes: 'text-xs font-semibold text-blue-600 hover:underline hover:cursor-pointer border-0 bg-transparent p-0',
            onClick: () => context.push('/forgotPassword'),
            [.text('Forgot Password?')],
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
            classes: 'input validator h-10.5 border border-border-medium bg-white w-full rounded-[10px] pr-10 text-sm text-slate-900 placeholder:text-slate-400',
            attributes: component.attributes,
          ),
          button(
            type: .button,
            classes: 'absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 hover:cursor-pointer p-1 rounded-md transition-colors border-0 bg-transparent',
            onClick: () => setState(() => _obscureText = !_obscureText),
            [
              if (_obscureText)
                EyeOff(classes: 'w-4.5 h-4.5')
              else
                Eye(classes: 'w-4.5 h-4.5'),
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
          classes: 'input validator h-10.5 border border-border-medium bg-white w-full rounded-[10px] text-sm text-slate-900 placeholder:text-slate-400',
          attributes: component.attributes,
        ),
      if (component.hintText case final hint?)
        p(classes: 'validator-hint hidden', [
          .text(hint),
        ]),
    ]);
  }
}
