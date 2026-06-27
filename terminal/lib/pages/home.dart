import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mix/mix.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:terminal/pages/loading.dart';
import 'package:terminal/providers/categories_provider.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final categories = ref.watch(categoriesProvider);
    if (categories.isLoading) return Scaffold(body: Loading());
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: StyledText(
          'Branding',
          style: TextStyler()
              .fontSize(40)
              .fontFamily(GoogleFonts.arizonia().fontFamily!)
              .color(theme.colorScheme.primary),
        ),
      ),
      body: RowBox(
        children: [
          ColumnBox(),
          ColumnBox(style: FlexBoxStyler().color(Colors.white)),
        ],
      ),
    );
  }
}
