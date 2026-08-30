import 'dart:js_interop';

@JS('phonePeTransact')
external void _phonePeTransact(
  JSString tokenUrl,
  JSString type,
  JSFunction callback,
);

/// Opens PhonePe checkout sheet in an iframe overlay on Web.
void openPhonePeCheckoutModal({
  required String tokenUrl,
  required void Function(String status) onComplete,
}) {
  try {
    final jsCallback = ((JSString status) {
      onComplete(status.toDart);
    }).toJS;

    _phonePeTransact(tokenUrl.toJS, 'IFRAME'.toJS, jsCallback);
  } catch (_) {
    onComplete('CONCLUDED');
  }
}
