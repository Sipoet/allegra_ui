import 'package:flutter/material.dart';
import 'package:allegra_ui/components/action_button.dart';
import 'package:allegra_ui/models/table_definition.dart';

class MobileTable<T> extends StatelessWidget {
  final List<CustomTableColumn<T>> columns;
  final List<T> rows;
  final CustomTableColumn? firstColumn;
  final List<ActionButton> Function(T)? rowActions;
  const MobileTable({
    super.key,
    required this.columns,
    this.rowActions,
    this.firstColumn,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: rows.length,
      itemBuilder: (context, index) {
        final headerColumn = firstColumn ?? columns.first;
        final bodyColumns = columns
            .skipWhile((column) => column.title == headerColumn.title)
            .toList();
        return ModelCard<T>(
          model: rows[index],
          headerColumn: headerColumn,
          bodyColumns: bodyColumns,
          rowActions: rowActions,
        );
      },
    );
  }
}

class ModelCard<T> extends StatefulWidget {
  final List<CustomTableColumn<T>> bodyColumns;
  final T model;
  final CustomTableColumn headerColumn;
  final List<ActionButton> Function(T)? rowActions;
  const ModelCard({
    super.key,
    required this.model,
    this.rowActions,
    required this.headerColumn,
    required this.bodyColumns,
  });

  @override
  State<ModelCard<T>> createState() => _ModelCardState<T>();
}

class _ModelCardState<T> extends State<ModelCard<T>> {
  bool isExpanded = false;
  final MenuController _menuController = MenuController();

  Widget _buildInfoRow(CustomTableColumn column) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF2F2F2), width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              column.title,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              valueOf(column),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String valueOf(CustomTableColumn column) =>
      column.decoratedValue(widget.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. CARD HEADER (Unit Name & Action Icons)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 6, 12),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: Text(
                    valueOf(widget.headerColumn),
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(0, 0, 0, 0.867),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Align(
                    alignment: .topRight,
                    child: LayoutBuilder(
                      builder: (context, constraint) {
                        final rowActions =
                            widget.rowActions?.call(widget.model) ?? [];
                        double minWidth = (rowActions.length * 50 + 5)
                            .toDouble();
                        if (constraint.maxWidth >= minWidth) {
                          return SizedBox(
                            width: minWidth,
                            child: Row(
                              spacing: 10,
                              mainAxisAlignment: .end,
                              children: rowActions
                                  .map(
                                    (actionButton) => SizedBox(
                                      width: 45,
                                      child: actionButton,
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        } else {
                          return SizedBox(
                            width: 45,
                            child: MenuAnchor(
                              controller: _menuController,
                              menuChildren: rowActions
                                  .map<MenuItemButton>(
                                    (actionButton) => MenuItemButton(
                                      onPressed: () {
                                        actionButton.onPressed?.call();
                                        _menuController.close();
                                      },
                                      leadingIcon: Icon(
                                        actionButton.iconData,
                                        color: actionButton.color,
                                      ),
                                      child: Text(actionButton.label),
                                    ),
                                  )
                                  .toList(),
                              child: IconButton(
                                icon: Icon(Icons.more_vert),
                                onPressed: () => _menuController.open(),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          ...widget.bodyColumns
              .take(isExpanded ? 99999 : 1)
              .map<Widget>(_buildInfoRow),
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isExpanded ? 'View Less' : 'View More',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5C527F), // Muted Purple shade
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18,
                    color: const Color(0xFF5C527F),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
