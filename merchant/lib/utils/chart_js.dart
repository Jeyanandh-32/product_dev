import 'dart:js_interop';
import 'package:jaspr/jaspr.dart';

@JS('renderChart')
external JSObject? _renderChart(
  JSString canvasId,
  JSString type,
  JSAny data,
  JSAny? options,
);

void drawChart({
  required String canvasId,
  required String type,
  required Map<String, dynamic> data,
  Map<String, dynamic>? options,
}) {
  if (kIsWeb) {
    try {
      _renderChart(
        canvasId.toJS,
        type.toJS,
        data.jsify()!,
        options?.jsify(),
      );
    } catch (_) {}
  }
}
