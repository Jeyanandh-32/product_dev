import 'dart:js_interop';

@JS('window.phonePeTransact')
external void _phonePeTransact(
  String tokenUrl,
  String type,
  JSFunction callback,
);

void openPhonePeCheckoutModal({
  required String tokenUrl,
  required String merchantOrderId,
  required void Function(String status) onComplete,
}) {
  final jsCallback = ((JSString status) {
    onComplete(status.toDart);
  }).toJS;

  _phonePeTransact(tokenUrl, 'IFRAME', jsCallback);
}
