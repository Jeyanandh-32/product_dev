/// Stub implementation for non-web environments (e.g. tests on VM).
void openPhonePeCheckoutModal({
  required String tokenUrl,
  required void Function(String status) onComplete,
}) {
  // No-op on VM/test platforms
}
