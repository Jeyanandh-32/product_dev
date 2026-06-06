import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';

class Stores extends StatelessComponent {
  const Stores({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'w-full h-full p-4 flex gap-4', [
      div(
        classes:
            'h-full bg-white flex-1 rounded-2xl border border-gray-200 p-6 flex flex-col',
        [
          div(classes: 'flex items-center gap-2', [
            label(
              classes: 'input flex-2 ring ring-inset ring-gray-200 rounded-lg',
              [
                Search(classes: 'h-[1em] opacity-50'),

                input(
                  type: .search,
                  classes: 'grow',
                  attributes: {
                    'required': '',
                    'placeholder': 'Search',
                  },
                ),
              ],
            ),

            button(
              onClick: () {},
              classes:
                  'flex flex-1 hover:cursor-pointer items-center font-semibold justify-center bg-primary text-primary-content text-sm transition-all duration-300 rounded-lg h-10',
              [
                Plus(classes: 'w-4 h-4'),
                .text('Add Store'),
              ],
            ),
          ]),

          div(
            classes:
                'divider before:h-[0.5px] after:h-[0.5px] before:bg-gray-300 after:bg-gray-300',
            [],
          ),

          storeCard(name: 'Canteen', isSelected: true),
          storeCard(name: 'Arcade'),
          storeCard(name: 'Store - 1'),
          storeCard(name: 'Store - 2'),
          storeCard(name: 'Store - 3'),
          storeCard(name: 'Store - 4'),
        ],
      ),
      div(
        classes: 'h-full bg-white flex-2 rounded-2xl border border-gray-200',
        [],
      ),
    ]);
  }

  div storeCard({required String name, bool isSelected = false}) {
    return div(
      classes:
          'p-4 mb-4 border ${isSelected ? ' border-primary' : 'border-gray-200'} rounded-lg flex flex-col gap-4',
      [
        div(classes: 'flex justify-between items-center', [
          h2(classes: 'font-semibold text-primary', [.text(name)]),
          SquarePen(classes: 'w-5 h-5 textborder-gray-500'),
        ]),

        div(classes: 'flex gap-2', [
          div(
            classes:
                'bg-soft-blue grow text-soft-blue-content rounded-lg text-[16px] font-semibold flex justify-center items-center h-10',
            [
              .text('7 Terminals'),
            ],
          ),

          div(
            classes:
                'bg-soft-green grow text-soft-green-content rounded-lg text-[16px] font-semibold flex justify-center items-center h-10',
            [
              .text('ACTIVE'),
            ],
          ),
        ]),
      ],
    );
  }
}
