import 'package:flutter/material.dart';
import 'package:allegra_ui/models/custom_type.dart';

class CustomTableColumn<T> {
  String? key;
  String title;
  ColumnType columnType;
  bool canSort;
  final Object? Function(T rowData) getValue;
  CustomTableColumn({
    required this.title,
    required this.columnType,
    this.key,
    this.canSort = true,
    required this.getValue,
  });
  @override
  bool operator ==(other) {
    if (other is CustomTableColumn) {
      return title == other.title;
    }
    return false;
  }

  @override
  int get hashCode => title.hashCode;

  int sorting(bool isAscending, T rowA, T rowB) {
    final cellA = getValue(rowA);
    final cellB = getValue(rowB);
    return isAscending
        ? columnType.sort(cellA, cellB)
        : columnType.sort(cellB, cellA);
  }

  String decoratedValue(T value) {
    final cellValue = getValue(value);
    if (cellValue == null) {
      return '';
    }
    return columnType.displayFormat(cellValue);
  }
}

abstract class ColumnType<T> {
  String displayFormat(T value);
  bool filter(T value, T searchValue) => value == searchValue;
  int sort(T valueA, T valueB);
  bool get isNumeric;
  static ColumnTypeMoney get money => ColumnTypeMoney();
  static ColumnTypeString get string => ColumnTypeString();
  static ColumnTypeNumber get number => ColumnTypeNumber();
  static ColumnTypeDate get date => ColumnTypeDate();
  static ColumnTypeDateTime get datetime => ColumnTypeDateTime();
  static ColumnTypeBoolean get boolean => ColumnTypeBoolean();
}

class ColumnTypeMoney implements ColumnType<Money> {
  @override
  String displayFormat(Money value) => value.format();
  @override
  bool filter(Money value, Money searchValue) =>
      value.value == searchValue.value;
  @override
  int sort(Money valueA, Money valueB) => valueA.value.compareTo(valueB.value);
  @override
  bool get isNumeric => true;
}

class ColumnTypeNumber implements ColumnType<num> {
  @override
  String displayFormat(num value) => value.format();
  @override
  bool filter(num value, num searchValue) => value == searchValue;
  @override
  int sort(num valueA, num valueB) => valueA.compareTo(valueB);
  @override
  bool get isNumeric => true;
}

class ColumnTypeString implements ColumnType<String> {
  @override
  String displayFormat(String value) => value;
  @override
  bool filter(String value, String searchValue) =>
      value.toLowerCase().contains(searchValue.toLowerCase());
  @override
  int sort(String valueA, String valueB) => valueA.compareTo(valueB);
  @override
  bool get isNumeric => false;
}

class ColumnTypeDate implements ColumnType<Date> {
  @override
  String displayFormat(Date value) => value.format();
  @override
  bool filter(Date value, Date searchValue) => value.isSameDay(searchValue);
  @override
  int sort(Date valueA, Date valueB) => valueA.compareTo(valueB);
  @override
  bool get isNumeric => false;
}

class ColumnTypeDateTime implements ColumnType<DateTime> {
  @override
  String displayFormat(DateTime value) => value.format();
  @override
  bool filter(DateTime value, DateTime searchValue) =>
      value.isSameDay(searchValue);
  @override
  int sort(DateTime valueA, DateTime valueB) => valueA.compareTo(valueB);
  @override
  bool get isNumeric => false;
}

class ColumnTypeBoolean implements ColumnType<bool> {
  String trueValLocale;
  String falseValLocale;
  ColumnTypeBoolean({this.falseValLocale = 'Tidak', this.trueValLocale = 'Ya'});
  @override
  String displayFormat(bool value) => value ? trueValLocale : falseValLocale;
  @override
  bool filter(bool value, bool searchValue) => value == searchValue;
  @override
  int sort(bool valueA, bool valueB) {
    int valA = valueA == true ? 1 : 0;
    int valB = valueB == true ? 1 : 0;
    return valA.compareTo(valB);
  }

  @override
  bool get isNumeric => false;
}

class FilterData {
  String key;
  List<FilterDetail> details;
  FilterData({required this.key, this.details = const []});
}

class FilterDetail {
  FilterOperator oper;
  dynamic value;
  FilterDetail({required this.oper, this.value});
}

enum FilterOperator {
  equal,
  compare,
  lessThen,
  greaterThen,
  lessOrEqualThen,
  not,
  greaterOrEqualThen;

  @override
  String toString() {
    switch (this) {
      case equal:
        return 'eq';
      case compare:
        return 'cpr';
      case lessThen:
        return 'lt';
      case greaterThen:
        return 'gt';
      case lessOrEqualThen:
        return 'lteq';
      case greaterOrEqualThen:
        return 'gteq';
      case not:
        return 'not';
    }
  }
}

class SortData {
  CustomTableColumn column;
  bool isAscending;
  SortData({required this.column, this.isAscending = true});
}

class RequestData extends ChangeNotifier {
  int _page;
  int _limit;
  List<SortData> _sorts;
  String? _searchText;
  List<FilterData> _filters;

  RequestData({
    int page = 1,
    int limit = 5,
    String? searchText,
    List<SortData>? sorts,
    List<FilterData>? filters,
  }) : _sorts = sorts ?? [],
       _page = page,
       _limit = limit,
       _filters = filters ?? [],
       _searchText = searchText;

  set sorts(List<SortData> newSorts) {
    _sorts = newSorts;
    notifyListeners();
  }

  set page(int newPage) {
    _page = newPage;
    notifyListeners();
  }

  set limit(int newLimit) {
    _limit = newLimit;
    resetPage();
  }

  set searchText(String? newSearchText) {
    _searchText = newSearchText;
    resetPage();
  }

  set filters(List<FilterData> newFilters) {
    _filters = newFilters;
    resetPage();
  }

  void addFilters(List<FilterData> newFilters) {
    _filters.addAll(newFilters);
    resetPage();
  }

  void addFilter(FilterData newFilter) {
    _filters.add(newFilter);
    resetPage();
  }

  void addSorts(List<SortData> newSorts) {
    _sorts.addAll(newSorts);
    notifyListeners();
  }

  void addSort(SortData newSort) {
    _sorts.add(newSort);
    notifyListeners();
  }

  void resetPage() {
    page = 1;
    notifyListeners();
  }

  List<SortData> get sorts => _sorts;
  int get page => _page;
  int get limit => _limit;
  String? get searchText => _searchText;
  List<FilterData> get filters => _filters;
}

class ResponseData<T> {
  final List<T> data;
  final int currentPage;
  final int? totalPage;
  final int? itemCount;
  const ResponseData({
    required this.data,
    required this.currentPage,
    this.totalPage = 1,
    this.itemCount,
  });
}
