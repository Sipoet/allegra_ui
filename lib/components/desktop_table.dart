import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:allegra_ui/components/action_button.dart';
import 'package:allegra_ui/models/table_definition.dart';

class DesktopTable<T> extends StatefulWidget {
  final List<CustomTableColumn<T>> columns;
  final ValueNotifier<List<T>> rows;
  final RequestData requestData;
  const DesktopTable({
    super.key,
    required this.columns,
    required this.rows,
    required this.requestData,
  });

  @override
  State<DesktopTable<T>> createState() => _DesktopTableState<T>();
}

class SortRule {
  int indexOrder;
  bool isAscending;

  SortRule({required this.indexOrder, required this.isAscending});
}

class _DesktopTableState<T> extends State<DesktopTable<T>> {
  final Map<CustomTableColumn<T>, double> _colsWidth = {};

  final Map<CustomTableColumn<T>, SortRule> _sortMap = {};

  late final List<CustomTableColumn<T>> _columns;

  @override
  void initState() {
    _columns = widget.columns;
    for (var column in _columns) {
      _colsWidth[column] = 200.0;
    }
    widget.rows.addListener(_refreshRow);
    super.initState();
  }

  void _refreshRow() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.rows.removeListener(_refreshRow);
    super.dispose();
  }

  // --- FEATURE: COLUMN REORDERING ---
  void _reorderColumns(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final CustomTableColumn<T> colItem = _columns.removeAt(oldIndex);
      _columns.insert(newIndex, colItem);
    });
  }

  // --- FEATURE: MULTIPLE SORT ---
  void _onHeaderTap(CustomTableColumn<T> column, bool isShiftPressed) {
    int visualColIndex = isShiftPressed ? _sortMap.keys.length : 0;
    setState(() {
      final current = _sortMap[column];
      if (!isShiftPressed) {
        _sortMap.clear();
      }
      if (current == null) {
        _sortMap[column] = SortRule(
          indexOrder: visualColIndex,
          isAscending: true,
        );
      } else if (current.isAscending) {
        _sortMap[column] = SortRule(
          indexOrder: current.indexOrder,
          isAscending: false,
        );
      } else {
        _sortMap.remove(column);
      }
      _applySorting();
    });
  }

  void _applySorting() {
    if (_sortMap.keys.isEmpty) return;
    final sorted = _sortMap.entries.toList()
      ..sort(
        (entryA, entryB) =>
            entryA.value.indexOrder.compareTo(entryB.value.indexOrder),
      );
    widget.requestData.sorts = sorted.mapIndexed<SortData>((index, entry) {
      entry.value.indexOrder = index;
      return SortData(column: entry.key, isAscending: entry.value.isAscending);
    }).toList();
  }

  void _showHideColumnDialog() {
    showDialog<Map<CustomTableColumn<T>, bool?>>(
      context: context,
      builder: (context) {
        final navigator = Navigator.of(context);
        final textTheme = TextTheme.of(context);
        final Map<CustomTableColumn<T>, bool?> checkboxValues = {};
        for (var column in _columns) {
          checkboxValues[column] = true;
        }
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              titlePadding: .symmetric(vertical: 10, horizontal: 20),
              title: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Show/Hide Dialog',
                      style: textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: () => navigator.pop(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              content: SizedBox(
                width: 400,
                child: ListView(
                  scrollDirection: .vertical,
                  children: widget.columns
                      .map<Widget>(
                        (column) => CheckboxListTile(
                          title: Text(column.title),
                          value: checkboxValues[column] == true,
                          onChanged: (value) {
                            setStateDialog(() {
                              checkboxValues[column] = value;
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
              actions: [
                SizedBox(
                  width: 100,
                  height: 30,
                  child: ActionButton(
                    onPressed: () {
                      navigator.pop(checkboxValues);
                    },
                    color: Colors.black,
                    label: 'Submit',
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  height: 30,
                  child: ActionButton(
                    onPressed: () {
                      navigator.pop();
                    },
                    color: Colors.black,
                    label: 'Cancel',
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((showColumnMap) {
      if (showColumnMap == null) {
        return;
      }
      for (var column in _columns) {
        if (showColumnMap[column] != true) {
          _columns.remove(column);
        }
        showColumnMap.remove(column);
      }

      _columns.addAll(
        showColumnMap.entries
            .where((entry) => entry.value == true)
            .map<CustomTableColumn<T>>((entry) => entry.key),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalWidth = _colsWidth.values.reduce(
      (widthA, widthB) => widthA + widthB,
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            height: 40,
            color: Colors.white,
            padding: .symmetric(horizontal: 5),
            child: Row(
              spacing: 15,
              mainAxisAlignment: .end,
              children: [
                Tooltip(
                  message:
                      '• Reorder: Drag any column header horizontally to reorder positions.\n'
                      '• Resize: Drag the right edge of any header to change column width.\n'
                      '• Sort: Click header to sort. Hold SHIFT + Click for multi-column sorting.',
                  textStyle: TextStyle(fontSize: 12, color: Colors.black),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  padding: .all(10),
                  child: Icon(Icons.help),
                ),
                ActionButton(
                  onPressed: _showHideColumnDialog,
                  label: 'Show/Hide Column',
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          // Main Table Container
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: totalWidth,
                    child: Column(
                      children: [
                        // 1. Table HEAD
                        Container(
                          height: 44,
                          color: Colors.grey.shade100,
                          child: Row(
                            children: List.generate(widget.columns.length, (
                              index,
                            ) {
                              final column = widget.columns[index];
                              final sortRuleIndex = widget.requestData.sorts
                                  .indexWhere(
                                    (sortData) => sortData.column == column,
                                  );
                              final isSorted = _sortMap[column] != null;
                              return DragTarget<int>(
                                onAcceptWithDetails: (oldIndex) {
                                  _reorderColumns(oldIndex.data, index);
                                },
                                builder: (context, candidateData, rejectedData) {
                                  return LongPressDraggable<int>(
                                    data: index,
                                    feedback: Material(
                                      elevation: 4,
                                      child: Container(
                                        width: _colsWidth[column],
                                        height: 44,
                                        color: Colors.blue.shade100,
                                        alignment: Alignment.center,
                                        child: Text(
                                          column.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: SizedBox(
                                      width: _colsWidth[column],
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: Material(
                                              color: candidateData.isNotEmpty
                                                  ? Colors.blue.shade50
                                                  : Colors.transparent,
                                              child: InkWell(
                                                onTapDown: (details) {
                                                  final isShift =
                                                      HardwareKeyboard
                                                          .instance
                                                          .isShiftPressed;
                                                  _onHeaderTap(column, isShift);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                      ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        column
                                                            .columnType
                                                            .isNumeric
                                                        ? .end
                                                        : .start,
                                                    children: [
                                                      Icon(
                                                        Icons.drag_indicator,
                                                        size: 14,
                                                        color: Colors
                                                            .grey
                                                            .shade400,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Flexible(
                                                        child: Tooltip(
                                                          message: column.title,
                                                          child: Text(
                                                            column.title,

                                                            style:
                                                                const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 13,
                                                                ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      if (isSorted) ...[
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Icon(
                                                          _sortMap[column]!
                                                                  .isAscending
                                                              ? Icons
                                                                    .arrow_upward
                                                              : Icons
                                                                    .arrow_downward,
                                                          size: 14,
                                                          color: Colors
                                                              .blue
                                                              .shade700,
                                                        ),
                                                        if (_sortMap
                                                                .keys
                                                                .length >
                                                            1)
                                                          Text(
                                                            '${sortRuleIndex + 1}',
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .blue
                                                                  .shade900,
                                                            ),
                                                          ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // --- FEATURE: RESIZABLE COLUMN HANDLE ---
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            bottom: 0,
                                            width: 6,
                                            child: MouseRegion(
                                              cursor: SystemMouseCursors
                                                  .resizeColumn,
                                              child: GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onPanUpdate: (details) {
                                                  setState(() {
                                                    _colsWidth[column] =
                                                        (_colsWidth[column]! +
                                                                details
                                                                    .delta
                                                                    .dx)
                                                            .clamp(50.0, 400.0);
                                                  });
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                          ),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey,
                        ),

                        // 2. BODY ROWS
                        Expanded(
                          child: ListView.builder(
                            itemCount: widget.rows.value.length,
                            itemBuilder: (context, rowIndex) {
                              final row = widget.rows.value[rowIndex];
                              return Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade200,
                                      width: 1,
                                    ),
                                  ),
                                  color: rowIndex.isEven
                                      ? Colors.white
                                      : Colors.grey.shade50.withValues(
                                          alpha: 0.5,
                                        ),
                                ),
                                child: Row(
                                  children: List.generate(_columns.length, (
                                    visualColIndex,
                                  ) {
                                    final col = _columns[visualColIndex];
                                    final cellValue = col.decoratedValue(row);

                                    // --- FEATURE: TEXT ALIGNMENT PER COLUMN ---
                                    return SizedBox(
                                      width: _colsWidth[col],
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Align(
                                          alignment: col.columnType.isNumeric
                                              ? .topRight
                                              : .topLeft,
                                          child: Text(
                                            cellValue.toString(),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black87,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
