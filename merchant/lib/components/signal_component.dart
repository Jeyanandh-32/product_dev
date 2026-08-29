import 'package:jaspr/jaspr.dart';
import 'package:signals/signals.dart';

/// Base stateful Jaspr component with automated signal reactivity lifecycle bindings.
abstract class SignalComponent extends StatefulComponent {
  const SignalComponent({super.key});

  @override
  SignalState createState();
}

/// Reactive state container that automatically rebuilds when accessed signals update.
abstract class SignalState<T extends SignalComponent> extends State<T> {
  void Function()? _disposer;
  Component? _cachedBuild;
  bool _isBuilding = false;

  @override
  Component build(BuildContext context) {
    _disposer?.call();
    _disposer = effect(() {
      final prevBuilding = _isBuilding;
      _isBuilding = true;
      _cachedBuild = buildSignal(context);
      _isBuilding = prevBuilding;
      if (!_isBuilding && mounted) {
        setState(() {});
      }
    });
    return _cachedBuild ?? buildSignal(context);
  }

  Component buildSignal(BuildContext context);

  @override
  void dispose() {
    _disposer?.call();
    super.dispose();
  }
}
