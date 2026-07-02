import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:jaspr_lucide/generated_icons/square_pen.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/components/buttons/add_button.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/modals/add_edit_counter_modal.dart';
import 'package:merchant/providers/counters_provider.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:models/models.dart';
import 'package:web/web.dart';

class Counters extends StatefulComponent {
  const Counters({super.key});

  @override
  State<Counters> createState() => _CountersState();
}

class _CountersState extends State<Counters> {
  int _currentPage = 1;
  int _entries = 10;
  String _searchQuery = '';

  void _changeEntry(int entry) {
    setState(() {
      _entries = entry;
      _currentPage = 1;
    });

    final activeElement = document.activeElement;
    if (activeElement != null) {
      (activeElement as HTMLElement).blur();
    }
  }

  int _getAssociatedCount(Counter counter) {
    return (counter.name.hashCode.abs() % 900) + 100;
  }

  @override
  Component build(BuildContext context) {
    final store = context.watch(storeProvider);
    final counters = context.watch(countersProvider);
    final activeModal = context.watch(activeModalProvider);
    final editingCounter = context.watch(editingCounterProvider);

    final countersList = counters.value ?? [];
    final filtered = countersList.where((cnt) {
      if (_searchQuery.isEmpty) return true;
      return cnt.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (cnt.description ?? '').toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
    }).toList();

    final totalPages = (filtered.length / _entries).ceil();
    if (_currentPage > totalPages && totalPages > 0) {
      _currentPage = totalPages;
    }

    final startIndex = (_currentPage - 1) * _entries;
    final endIndex = (startIndex + _entries) > filtered.length
        ? filtered.length
        : (startIndex + _entries);
    final paginated = filtered.isEmpty
        ? <Counter>[]
        : filtered.sublist(startIndex, endIndex);

    return div(
      classes:
          'flex flex-col flex-1 min-h-0 m-4 bg-white rounded-2xl border border-border-medium shadow-xs overflow-hidden',
      [
        if (activeModal == ActiveModal.addCounter) const AddEditCounterModal(),
        if (activeModal == ActiveModal.editCounter)
          AddEditCounterModal(counter: editingCounter),

        div(
          classes:
              'flex flex-col md:items-center md:flex-row md:justify-between w-full border-b border-border-medium p-4 gap-4',
          [
            span(classes: 'flex gap-2 items-center text-sm font-medium', [
              .text('Show'),
              div(classes: 'dropdown dropdown-bottom dropdown-center', [
                div(
                  classes:
                      'btn rounded-full border border-border-medium bg-white hover:bg-base-200 text-sm h-8 min-h-0',
                  attributes: {
                    'tabindex': '0',
                    'role': 'button',
                  },
                  [
                    .text('$_entries'),
                    ChevronDown(classes: 'w-4 h-4'),
                  ],
                ),
                ul(
                  attributes: {'tabindex': '-1'},
                  classes:
                      'dropdown-content menu bg-base-100 rounded-box z-10 mt-2.5 p-2 shadow-sm border border-border-light',
                  [
                    dropdownButton(
                      name: '10',
                      onClick: () => _changeEntry(10),
                    ),
                    dropdownButton(
                      name: '25',
                      onClick: () => _changeEntry(25),
                    ),
                    dropdownButton(
                      name: '50',
                      onClick: () => _changeEntry(50),
                    ),
                    dropdownButton(
                      name: '100',
                      onClick: () => _changeEntry(100),
                    ),
                  ],
                ),
              ]),
              .text('entries'),
            ]),
            div(classes: 'flex justify-between gap-2 items-center w-full', [
              Searchbar(
                placeholder: 'Search Counters...',
                classes: 'flex-1 sm:flex-none sm:w-64',
                onInput: (val) {
                  setState(() {
                    _searchQuery = val;
                    _currentPage = 1;
                  });
                },
              ),
              AddButton(
                name: 'Add Counter',
                onClick: () {
                  context.read(editingCounterProvider.notifier).state = null;
                  context.read(activeModalProvider.notifier).state =
                      ActiveModal.addCounter;
                },
              ),
            ]),
          ],
        ),

        if (counters.isLoading)
          Loading(text: 'Loading counters...', fullScreen: false)
        else if (store == null)
          CenteredMessage(message: 'Create Store to add counters.')
        else if (countersList.isEmpty)
          CenteredMessage(message: 'No Counters were added.')
        else if (filtered.isEmpty)
          CenteredMessage(message: 'No matching counters found.')
        else
          div(classes: 'h-full overflow-x-auto', [
            table(classes: 'table table-zebra table-pin-rows table-pin-cols', [
              tableHead(),
              tbody([
                for (final counter in paginated)
                  tableRow(
                    name: counter.name,
                    image: counter.imageUrl,
                    isActive: counter.isActive,
                    productsCount: _getAssociatedCount(counter),
                    description: counter.description ?? 'N/A',
                    onEdit: () {
                      context.read(editingCounterProvider.notifier).state =
                          counter;
                      context.read(activeModalProvider.notifier).state =
                          ActiveModal.editCounter;
                    },
                  ),
              ]),
            ]),
          ]),

        if (totalPages > 1)
          div(
            classes:
                'border-t border-border-medium flex justify-center items-center gap-2 font-medium text-gray-500 p-4',
            [
              button(
                classes:
                    'btn border-none bg-white shadow-none hover:bg-neutral h-8 hover:text-black ${_currentPage == 1 ? 'btn-disabled opacity-50' : ''}',
                onClick: _currentPage > 1
                    ? () => setState(() => _currentPage--)
                    : null,
                [
                  .text('Previous'),
                ],
              ),
              for (int i = 1; i <= totalPages; i++)
                button(
                  classes:
                      'btn w-8 h-8 rounded-lg ${i == _currentPage ? 'bg-accent text-white hover:bg-accent' : 'bg-neutral hover:bg-base-300'}',
                  onClick: i == _currentPage
                      ? null
                      : () => setState(() => _currentPage = i),
                  [
                    .text('$i'),
                  ],
                ),
              button(
                classes:
                    'btn border-none bg-white shadow-none hover:bg-neutral h-8 hover:text-black ${_currentPage == totalPages ? 'btn-disabled opacity-50' : ''}',
                onClick: _currentPage < totalPages
                    ? () => setState(() => _currentPage++)
                    : null,
                [
                  .text('Next'),
                ],
              ),
            ],
          ),
      ],
    );
  }

  thead tableHead() {
    return thead([
      tr([
        th([]),
        td([.text('Action')]),
        td([.text('Image')]),
        th([.text('Counter Name')]),
        td([.text('Status')]),
        td([.text('Products Associated')]),
        td([.text('Description')]),
        th([]),
      ]),
    ]);
  }

  tr tableRow({
    required String name,
    String? image,
    required bool isActive,
    required int productsCount,
    required String description,
    VoidCallback? onEdit,
  }) {
    return tr([
      th([]),
      td([
        div(classes: 'flex items-center gap-4', [
          button(
            classes:
                'hover:cursor-pointer btn btn-ghost btn-xs h-8 w-8 p-0 rounded-full',
            events: {
              'click': (e) {
                e.stopPropagation();
                onEdit?.call();
              },
            },
            [
              SquarePen(classes: 'w-5 h-5 text-gray-500 hover:text-accent'),
            ],
          ),
        ]),
      ]),
      td([
        if (image != null && image.isNotEmpty)
          div(
            classes:
                'h-12 w-12 overflow-hidden rounded-2xl bg-gray-100 shrink-0',
            [
              img(
                src: image,
                alt: name,
                classes: 'block h-full w-full object-cover',
              ),
            ],
          )
        else
          .text('-'),
      ]),
      th(classes: 'whitespace-nowrap font-semibold text-gray-900', [
        .text(name),
      ]),
      td([
        div(
          classes:
              '${isActive ? 'bg-soft-green text-soft-green-content' : 'bg-soft-red text-soft-red-content'} rounded-full px-3 py-1 text-center text-xs font-semibold inline-block',
          [
            .text(isActive ? 'ACTIVE' : 'INACTIVE'),
          ],
        ),
      ]),
      td([.text('$productsCount')]),
      td([.text(description)]),
      th([]),
    ]);
  }

  li dropdownButton({
    required String name,
    VoidCallback? onClick,
  }) {
    return li([
      a(
        href: '#',
        classes: 'rounded-md hover:bg-neutral',
        onClick: onClick,
        [
          .text(name),
        ],
      ),
    ]);
  }
}
