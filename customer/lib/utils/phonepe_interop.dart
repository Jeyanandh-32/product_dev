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

@JS('window.renderQrCode')
external void _renderQrCode(String elementId, String text, int size);

void renderQrCodeCanvas({
  required String elementId,
  required String text,
  int size = 200,
}) {
  _renderQrCode(elementId, text, size);
}
