import 'package:allegra_ui/models/custom_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaginationPanel extends StatelessWidget {
  final int currentPage;
  final int totalPage;
  final int? itemCount;
  final int limit;
  final List<int> limitOptions;
  final void Function(int page)? onPageChanged;
  final void Function(int limit)? onLimitChanged;
  final _pageInputController = TextEditingController();
  PaginationPanel({
    super.key,
    required this.currentPage,
    required this.totalPage,
    required this.limit,
    this.itemCount,
    this.onLimitChanged,
    this.onPageChanged,
    this.limitOptions = const [5, 10, 20, 50, 100],
  });

  int get _startShowItems => (currentPage - 1) * limit + 1;
  int get _endShowItems => currentPage * limit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    _pageInputController.text = currentPage.format();
    return LayoutBuilder(
      builder: (content, constraint) {
        if (constraint.maxWidth < 1024) {
          final double iconSize = 30;
          return Container(
            // height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    // First Page Button
                    IconButton(
                      iconSize: iconSize,
                      icon: const Icon(Icons.first_page),
                      onPressed: currentPage == 1
                          ? null
                          : () => onPageChanged?.call(1),
                      tooltip: 'First Page',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                    ),
                    // Previous Page Button
                    IconButton(
                      iconSize: iconSize,
                      icon: const Icon(Icons.chevron_left),
                      onPressed: currentPage == 1
                          ? null
                          : () => onPageChanged?.call(currentPage - 1),
                      tooltip: 'Previous Page',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                    ),

                    Text(
                      'Page of ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),

                    SizedBox(
                      width: 42,
                      height: 28,
                      child: TextField(
                        controller: _pageInputController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onSubmitted: (value) {
                          final page = (int.tryParse(value) ?? 1).clamp(
                            1,
                            totalPage,
                          );
                          _pageInputController.text = page.format();
                          onPageChanged?.call(page);
                        },
                      ),
                    ),
                    Text(
                      'of $totalPage',
                      textAlign: .right,
                      overflow: .clip,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),

                    // Next Page Button
                    IconButton(
                      iconSize: iconSize,
                      icon: const Icon(Icons.chevron_right),
                      onPressed: currentPage == totalPage
                          ? null
                          : () => onPageChanged?.call(currentPage + 1),
                      tooltip: 'Next Page',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                    ),
                    // Last Page Button
                    IconButton(
                      iconSize: iconSize,
                      icon: const Icon(Icons.last_page),
                      onPressed: currentPage == totalPage
                          ? null
                          : () => onPageChanged?.call(totalPage),
                      tooltip: 'Last Page',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Showing $_startShowItems–$_endShowItems ${itemCount != null ? 'of $itemCount records' : ''}',
                        style: TextStyle(
                          fontSize: 10,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: .clip,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Row(
                      children: [
                        Text(
                          'Rows per page:',
                          style: TextStyle(
                            fontSize: 10,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const .only(bottom: 20.0),
                          child: SizedBox(
                            height: 30,
                            child: DropdownMenu<int>(
                              width: 80,
                              initialSelection: limit,
                              dropdownMenuEntries: limitOptions.map((limit) {
                                return DropdownMenuEntry<int>(
                                  value: limit,
                                  label: '$limit',
                                );
                              }).toList(),
                              onSelected: (newLimit) {
                                onLimitChanged?.call(newLimit ?? 5);
                              },
                              inputDecorationTheme: InputDecorationTheme(
                                labelStyle: TextStyle(fontSize: 10),
                                isDense: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              crossAxisAlignment: .center,
              children: [
                // Total Record Info
                Text(
                  'Showing $_startShowItems–$_endShowItems ${itemCount != null ? 'of $itemCount records' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),

                // Rows per page selector (Limit)
                Text(
                  'Rows per page:',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const .only(bottom: 20.0),
                  child: SizedBox(
                    height: 30,
                    child: DropdownMenu<int>(
                      width: 80,
                      initialSelection: limit,
                      dropdownMenuEntries: limitOptions.map((limit) {
                        return DropdownMenuEntry<int>(
                          value: limit,
                          label: '$limit',
                        );
                      }).toList(),
                      onSelected: (newLimit) {
                        onLimitChanged?.call(newLimit ?? 5);
                      },
                      inputDecorationTheme: InputDecorationTheme(
                        labelStyle: TextStyle(fontSize: 12),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 30),

                // Pagination Action Buttons & Input
                Row(
                  children: [
                    // First Page Button
                    IconButton(
                      icon: const Icon(Icons.first_page, size: 18),
                      onPressed: currentPage == 1
                          ? null
                          : () => onPageChanged?.call(1),
                      tooltip: 'First Page',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                    ),
                    // Previous Page Button
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 18),
                      onPressed: currentPage == 1
                          ? null
                          : () => onPageChanged?.call(currentPage - 1),
                      tooltip: 'Previous Page',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                    ),
                    const SizedBox(width: 6),

                    Text(
                      'Page of ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(width: 6),
                    SizedBox(
                      width: 42,
                      height: 28,
                      child: TextField(
                        controller: _pageInputController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onSubmitted: (value) {
                          final page = (int.tryParse(value) ?? 1).clamp(
                            1,
                            totalPage,
                          );
                          _pageInputController.text = page.format();
                          onPageChanged?.call(page);
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 70,
                      child: Text(
                        'of $totalPage',
                        textAlign: .right,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Next Page Button
                    IconButton(
                      icon: const Icon(Icons.chevron_right, size: 18),
                      onPressed: currentPage == totalPage
                          ? null
                          : () => onPageChanged?.call(currentPage + 1),
                      tooltip: 'Next Page',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                    ),
                    // Last Page Button
                    IconButton(
                      icon: const Icon(Icons.last_page, size: 18),
                      onPressed: currentPage == totalPage
                          ? null
                          : () => onPageChanged?.call(totalPage),
                      tooltip: 'Last Page',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
