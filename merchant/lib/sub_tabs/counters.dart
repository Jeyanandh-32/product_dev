import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:jaspr_lucide/generated_icons/square_pen.dart';
import 'package:merchant/components/buttons/add_button.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/modals/add_edit_counter_modal.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/components/table_pagination.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/counters_signal.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';
import 'package:web/web.dart';

class Counters extends SignalComponent {
  const Counters({super.key});

  @override
  SignalState<Counters> createState() => _CountersState();
}

class _CountersState extends SignalState<Counters> {
  @override
  void initState() {
    super.initState();
    refreshCountersSignal();
  }

  void _changeEntry(int entry) {
    entriesSignal.value = entry;
    countersPageSignal.value = 1;
    refreshCountersSignal();

    final activeElement = document.activeElement;
    if (activeElement != null) {
      (activeElement as HTMLElement).blur();
    }
  }

  int _getAssociatedCount(Counter counter) {
    return (counter.name.hashCode.abs() % 900) + 100;
  }

  @override
  Component buildSignal(BuildContext context) {
    final entries = entriesSignal.value;
    final counters = countersSignal.value;
    final currentPage = countersPageSignal.value;
    final totalPages = countersTotalPagesSignal.value;
    final activeModal = activeModalSignal.value;
    final editingCounter = editingCounterSignal.value;
    final store = storeSignal.value;

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
            span(
              classes:
                  'flex gap-2 items-center text-sm font-medium whitespace-nowrap',
              [
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
                      .text('$entries'),
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
                .text(
                  countersTotalSignal.value <= 0
                      ? '0 of 0'
                      : 'Showing ${((currentPage - 1) * entries) + 1}–${(currentPage * entries).clamp(0, countersTotalSignal.value)} of ${countersTotalSignal.value}',
                ),
              ],
            ),
            div(classes: 'flex justify-between gap-2 items-center w-full', [
              Searchbar(
                placeholder: 'Search Counters...',
                classes: 'flex-1 sm:flex-none sm:w-64',
                onInput: (val) {
                  counterSearchSignal.value = val;
                  countersPageSignal.value = 1;
                  refreshCountersSignal();
                },
              ),

              AddButton(
                name: 'Add Counter',
                onClick: () {
                  editingCounterSignal.value = null;
                  activeModalSignal.value = ActiveModal.addCounter;
                },
              ),
            ]),
          ],
        ),

        if (storesSignal.value.isLoading || counters.isLoading)
          Loading(text: 'Loading counters...', fullScreen: false)
        else if (store == null)
          CenteredMessage(message: 'Create Store to add counters.')
        else if (counters.hasError)
          CenteredMessage(
            message: counters.error is ApiException
                ? (counters.error as ApiException).message
                : 'Failed to load counters. Please try again.',
          )
        else if (counters.hasValue && counters.value!.isEmpty)
          CenteredMessage(message: 'No Counters were added.')
        else
          div(classes: 'flex-1 min-h-0 overflow-auto', [
            table(
              classes: 'table table-zebra table-pin-rows table-pin-cols',
              [
                tableHead(),
                tbody([
                  for (final counter in counters.value!)
                    tableRow(
                      name: counter.name,
                      image: counter.imageUrl,
                      isActive: counter.isActive,
                      productsCount: _getAssociatedCount(counter),
                      description: counter.description ?? 'N/A',
                      onEdit: () {
                        editingCounterSignal.value = counter;
                        activeModalSignal.value = ActiveModal.editCounter;
                      },
                    ),
                ]),
              ],
            ),
          ]),

        TablePagination(
          currentPage: currentPage,
          totalPages: totalPages,
          onPageChanged: (page) {
            countersPageSignal.value = page;
            refreshCountersSignal();
          },
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
      th(classes: 'whitespace-nowrap', [
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
