/// Stub implementation for non-web environments (e.g. tests on VM).
void openPhonePeCheckoutModal({
  required String tokenUrl,
  String? merchantOrderId,
  required void Function(String status) onComplete,
}) {
  // No-op on VM/test platforms
}

/// Stub implementation for rendering QR code canvas on non-web environments.
void renderQrCodeCanvas({
  required String elementId,
  required String text,
  int size = 200,
}) {
  // No-op on VM/test platforms
}
