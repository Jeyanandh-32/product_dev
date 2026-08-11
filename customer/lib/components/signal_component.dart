import 'package:jaspr/jaspr.dart';

abstract class SignalComponent extends StatefulComponent {
  const SignalComponent({super.key});
}

abstract class SignalState<T extends SignalComponent> extends State<T> {
  Component buildSignal(BuildContext context);

  @override
  Component build(BuildContext context) {
    return buildSignal(context);
  }
}
