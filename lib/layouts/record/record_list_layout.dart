import 'package:allegra_ui/components/pagination_panel.dart';
import 'package:flutter/material.dart';
import 'package:allegra_ui/components/action_button.dart';
import 'package:allegra_ui/components/desktop_table.dart';
import 'package:allegra_ui/components/mobile_table.dart';
import 'package:allegra_ui/models/custom_type.dart';
import 'package:allegra_ui/models/table_definition.dart';

export 'package:allegra_ui/models/table_definition.dart';
export 'package:allegra_ui/components/action_button.dart';

typedef FetchModelForTable<T> = Future<ResponseData<T>> Function(RequestData);

class RecordListLayout<T> extends StatefulWidget {
  final List<CustomTableColumn<T>> columns;
  final FetchModelForTable<T> getData;

  final bool showSearchText;
  final List<Widget>? filterForm;
  final List<ActionButton>? footerActions;
  final List<ActionButton> Function(T model)? rowActions;
  final void Function(FormState formState)? onFilterSubmit;
  const RecordListLayout({
    super.key,
    required this.columns,
    required this.getData,
    this.filterForm,
    this.rowActions,
    this.footerActions,
    this.onFilterSubmit,
    this.showSearchText = true,
  });

  static FetchModelForTable<T> localQuery<T>(List<T> rows) {
    return (RequestData requestData) {
      int itemCount = rows.length;
      int totalPage = (itemCount / requestData.limit).ceil();
      int startIndex = (requestData.page - 1) * requestData.limit;
      int endIndex = requestData.page * requestData.limit;
      //   final values = _rows.value.toList();
      rows.sort((rowA, rowB) {
        for (final sortData in requestData.sorts) {
          int compared = sortData.column.sorting(
            sortData.isAscending,
            rowA,
            rowB,
          );
          if (compared != 0) {
            return compared;
          }
        }
        return 0;
      });

      return Future.value(
        ResponseData<T>(
          data: rows.sublist(startIndex, endIndex),
          currentPage: requestData.page,
          totalPage: totalPage,
          itemCount: itemCount,
        ),
      );
    };
  }

  @override
  State<RecordListLayout<T>> createState() => _RecordListLayoutState<T>();
}

class _RecordListLayoutState<T> extends State<RecordListLayout<T>> {
  final ValueNotifier<List<T>> _rows = ValueNotifier([]);
  CustomTableColumn? _firstColumn;
  final _pageInputController = TextEditingController(text: '1');
  int? itemCount;
  final requestData = RequestData(page: 1, limit: 5, filters: [], sorts: []);
  int totalPage = 1;
  int currentPage = 1;

  @override
  void initState() {
    requestData.addListener(_fetchData);
    _fetchData();
    super.initState();
  }

  void _fetchData() {
    widget
        .getData(requestData)
        .then(
          (responseData) => setState(() {
            _rows.value = responseData.data;
            totalPage = responseData.totalPage ?? 1;
            currentPage = responseData.currentPage;
            _pageInputController.text = currentPage.format();
            itemCount = responseData.itemCount;
          }),
        );
  }

  @override
  void dispose() {
    requestData.removeListener(_fetchData);
    requestData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        if (constraint.maxWidth >= 1024) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white,
                child: Column(
                  children: [
                    if (widget.showSearchText)
                      Row(
                        children: [
                          const SizedBox(
                            width: 80,
                            child: Text(
                              'Kata Kunci :',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 28,
                              child: TextField(
                                maxLines: 1,
                                onChanged: (newValue) {
                                  newValue = newValue.trim();
                                  setState(() {
                                    requestData.searchText = newValue.isEmpty
                                        ? null
                                        : newValue;
                                  });
                                },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  suffixIcon: const Icon(
                                    Icons.search,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.refresh, size: 18),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 15,
                      runSpacing: 10,
                      children: widget.filterForm ?? [],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.grey),
              Expanded(
                child: DesktopTable(
                  columns: widget.columns,
                  rows: _rows,
                  requestData: requestData,
                  rowActions: widget.rowActions,
                ),
              ),
              PaginationPanel(
                currentPage: currentPage,
                totalPage: totalPage,
                limit: requestData.limit,
                itemCount: itemCount,
                onPageChanged: (page) {
                  setState(() {
                    requestData.page = page;
                  });
                },
                onLimitChanged: (limit) {
                  setState(() {
                    requestData.limit = limit;
                  });
                },
              ),
              if (widget.footerActions != null)
                Container(
                  height: 40,
                  color: const Color(0xFFECEFF1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  child: ListView.separated(
                    scrollDirection: .horizontal,
                    itemCount: widget.footerActions!.length,
                    itemBuilder: (context, index) =>
                        widget.footerActions!.elementAt(index),
                    separatorBuilder: (context, index) => SizedBox(width: 5),
                  ),
                ),
            ],
          );
        } else {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  spacing: 5,
                  children: [
                    SizedBox(
                      height: 45,
                      child: Row(
                        spacing: 10,
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          if (widget.showSearchText)
                            Expanded(
                              child: TextField(
                                maxLines: 1,
                                onChanged: (newValue) {
                                  newValue = newValue.trim();
                                  setState(() {
                                    requestData.searchText = newValue.isEmpty
                                        ? null
                                        : newValue;
                                  });
                                },
                                style: TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  suffixIcon: Icon(
                                    Icons.search,
                                    color: Colors.grey.shade600,
                                  ),

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  hint: Text(
                                    'Kata Kunci',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          SizedBox(
                            width: 45,
                            child: ActionButton(
                              onPressed: _showBottomFilterPanel,
                              badgeText: requestData.filters.isNotEmpty
                                  ? requestData.filters.length.format()
                                  : null,
                              iconData: Icons.filter_list_alt,
                              label: 'Filter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      child: Row(
                        spacing: 10,
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Expanded(
                            child: DropdownMenu(
                              width: 350,
                              decorationBuilder: (context, controller) =>
                                  InputDecoration(
                                    isDense: true,
                                    fillColor: Colors.white,
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    hint: Text(
                                      'First Column:',
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                              textStyle: TextStyle(fontSize: 14),
                              dropdownMenuEntries: widget.columns
                                  .map<DropdownMenuEntry>(
                                    (column) => DropdownMenuEntry(
                                      value: column,
                                      label: column.title,
                                    ),
                                  )
                                  .toList(),
                              onSelected: (value) => setState(() {
                                _firstColumn = value;
                              }),
                            ),
                          ),
                          SizedBox(
                            width: 45,
                            child: ActionButton(
                              onPressed: _showBottomSortPanel,
                              badgeText: requestData.sorts.isNotEmpty
                                  ? requestData.sorts.length.toString()
                                  : null,
                              iconData: Icons.sort,
                              // color: Colors.grey.shade700,
                              label: 'Sort Order',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: MobileTable<T>(
                  columns: widget.columns,
                  firstColumn: _firstColumn,
                  rowActions: widget.rowActions,
                  rows: _rows.value,
                ),
              ),
              PaginationPanel(
                currentPage: currentPage,
                totalPage: totalPage,
                limit: requestData.limit,
                itemCount: itemCount,
                onLimitChanged: (limit) => requestData.limit = limit,
                onPageChanged: (page) => requestData.page = page,
              ),
              if (widget.footerActions != null)
                Container(
                  height: 46,
                  color: const Color(0xFFECEFF1),
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    bottom: 5,
                  ),
                  child: ListView.separated(
                    scrollDirection: .horizontal,
                    itemCount: widget.footerActions!.length,
                    itemBuilder: (context, index) =>
                        widget.footerActions!.elementAt(index),
                    separatorBuilder: (context, index) => SizedBox(width: 5),
                  ),
                ),
            ],
          );
        }
      },
    );
  }

  void _showBottomFilterPanel() {
    showModalBottomSheet(
      elevation: 2,
      context: context,
      builder: (context) {
        final formKey = GlobalKey<FormState>();
        final navigator = Navigator.of(context);
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final textTheme = TextTheme.of(context);
            return Container(
              padding: .symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text('Filter:', style: textTheme.titleMedium),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Divider(height: 2, color: Colors.grey.shade600),
                  ),
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: Column(children: widget.filterForm ?? []),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Divider(height: 2, color: Colors.grey.shade600),
                  ),
                  Row(
                    mainAxisAlignment: .spaceAround,
                    children: [
                      ActionButton(
                        onPressed: () {
                          widget.onFilterSubmit?.call(formKey.currentState!);
                        },
                        color: Colors.green,
                        label: 'Filter',
                      ),
                      ActionButton(
                        onPressed: () {
                          setStateDialog(() {});
                        },
                        label: 'Reset',
                      ),
                      ActionButton(
                        onPressed: () {
                          navigator.pop();
                        },
                        color: Colors.black,
                        label: 'Batalkan',
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showBottomSortPanel() {
    final Map<CustomTableColumn<T>, List> sortMap = {};
    for (final (int index, SortData sort) in requestData.sorts.indexed) {
      sortMap[sort.column as CustomTableColumn<T>] = [index, sort.isAscending];
    }
    showModalBottomSheet<List<SortData>>(
      elevation: 2,
      context: context,
      builder: (context) {
        final navigator = Navigator.of(context);
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final textTheme = TextTheme.of(context);
            return Container(
              padding: .symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text('Diurutkan Berdasarkan:', style: textTheme.titleMedium),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Divider(height: 2, color: Colors.grey.shade600),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: widget.columns
                            .map(
                              (column) => Badge(
                                backgroundColor: Colors.blue.shade300,
                                label: Text(
                                  sortMap[column] == null
                                      ? ''
                                      : (sortMap[column]?[0] + 1).toString(),
                                ),
                                isLabelVisible: sortMap[column] != null,
                                child: SortButton(
                                  column: column,
                                  sortValue: sortMap[column]?[1],
                                  onChanged: (isAscending) {
                                    if (isAscending != null) {
                                      if (sortMap[column] == null) {
                                        setStateDialog(() {
                                          sortMap[column] = [
                                            sortMap.keys.length,
                                            isAscending,
                                          ];
                                        });
                                      } else {
                                        setStateDialog(() {
                                          sortMap[column]![1] = isAscending;
                                        });
                                      }
                                    } else {
                                      setStateDialog(() {
                                        sortMap.remove(column);
                                      });
                                    }
                                  },
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Divider(height: 2, color: Colors.grey.shade600),
                  ),
                  Row(
                    mainAxisAlignment: .spaceAround,
                    children: [
                      ActionButton(
                        onPressed: () {
                          final sortEntries = sortMap.entries.toList()
                            ..sort(
                              (entryA, entryB) =>
                                  entryA.value[0].compareTo(entryB.value[0]),
                            );
                          final List<SortData> sorts = sortEntries
                              .map<SortData>(
                                (entry) => SortData(
                                  column: entry.key,
                                  isAscending: entry.value[1],
                                ),
                              )
                              .toList();
                          navigator.pop(sorts);
                        },
                        color: Colors.green,
                        label: 'Urutkan',
                      ),
                      ActionButton(
                        onPressed: () {
                          setStateDialog(() {
                            sortMap.clear();
                          });
                        },
                        label: 'Reset',
                      ),
                      ActionButton(
                        onPressed: () {
                          navigator.pop();
                        },
                        color: Colors.black,
                        label: 'Batalkan',
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((List<SortData>? sorts) {
      if (sorts != null) {
        setState(() {
          requestData.sorts = sorts;
        });
      }
    });
  }
}

class SortButton extends StatelessWidget {
  final bool? sortValue;
  final CustomTableColumn column;
  final Function(bool?) onChanged;
  const SortButton({
    super.key,
    required this.column,
    this.sortValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        if (sortValue == true) {
          onChanged.call(false);
        } else if (sortValue == false) {
          onChanged.call(null);
        } else {
          onChanged.call(true);
        }
      },
      icon: sortValue == null
          ? SizedBox(width: 18)
          : Icon(sortValue == true ? Icons.arrow_upward : Icons.arrow_downward),
      label: Text(column.title, style: TextStyle(color: Colors.grey.shade600)),
    );
  }
}
