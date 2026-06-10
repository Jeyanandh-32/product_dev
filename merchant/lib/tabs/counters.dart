import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:merchant/components/buttons/add_button.dart';
import 'package:merchant/components/cards/counter_card.dart';
import 'package:merchant/components/fields/searchbar.dart';

class Counters extends StatelessComponent {
  const Counters({super.key});

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'flex flex-col flex-1 min-h-0 m-4 bg-white rounded-2xl border border-border-medium shadow-xs',
      [
        div(
          classes:
              'w-full border-b border-border-medium flex items-center justify-between p-4 gap-2',
          [
            Searchbar(
              placeholder: 'Search Counters...',
              classes: 'flex-1 sm:flex-none sm:w-64',
            ),
            AddButton(name: 'Add Counter'),
          ],
        ),
        div(
          classes:
              'flex-1 min-h-0 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 m-4 pr-2 gap-4 overflow-y-auto auto-rows-max',
          [
            CounterCard(name: 'Biscuit'),
            CounterCard(name: 'Biscuit'),
            CounterCard(name: 'Biscuit'),
            CounterCard(name: 'Biscuit'),
            CounterCard(name: 'Biscuit'),
            CounterCard(name: 'Biscuit'),
            CounterCard(name: 'Biscuit'),
          ],
        ),
      ],
    );
  }
}
