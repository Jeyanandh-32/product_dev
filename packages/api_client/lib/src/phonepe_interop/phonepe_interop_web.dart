import 'dart:js_interop';

@JS('window.phonePeTransact')
external void _phonePeTransact(
  JSString tokenUrl,
  JSString type,
  JSFunction callback,
);

@JS('window.renderQrCode')
external void _renderQrCode(JSString elementId, JSString text, JSNumber size);

/// Opens PhonePe checkout sheet in an iframe overlay on Web.
void openPhonePeCheckoutModal({
  required String tokenUrl,
  String? merchantOrderId,
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

/// Renders a QR code to a canvas element on Web.
void renderQrCodeCanvas({
  required String elementId,
  required String text,
  int size = 200,
}) {
  try {
    _renderQrCode(elementId.toJS, text.toJS, size.toJS);
  } catch (_) {
    // Ignore canvas render failure in unsupported environments
  }
}
