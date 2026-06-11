import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';

class Products extends StatelessComponent {
  const Products({super.key});

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'p-8 text-gray-400 font-medium text-center flex-1 flex items-center justify-center',
      [
        .text(
          'Products content coming soon!',
        ),
      ],
    );
  }
}
