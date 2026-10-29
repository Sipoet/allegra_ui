import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:allegra_ui/layout/record/record_list_layout.dart';
import 'package:allegra_ui/models/custom_type.dart';
import 'package:allegra_ui/models/layout_manager.dart';

class RecordList extends StatefulWidget {
  const RecordList({super.key});

  @override
  State<RecordList> createState() => _RecordListState();
}

class _RecordListState extends State<RecordList> {
  final _sales = List.generate(
    300,
    (int index) => Sales(
      code: '${(index + 1).toString().padLeft(5, '0')}/KSR/TOKO/1026',
      transactionDate: DateTime(
        2026,
        10,
        Random().nextInt(20) + 1,
        Random().nextInt(14) + 8,
        Random().nextInt(59),
        0,
      ),
      userName: 'Sella',
      total: Money(Random().nextInt(999) * 1_000.0),
      itemCount: Random().nextInt(99) + 9,
      description: [
        'dibeli karyawan',
        'dari online',
        null,
        null,
        null,
      ].sample(1).first,
      isPaid: [false, true, true, true].sample(1).first,
    ),
    growable: true,
  );

  @override
  Widget build(BuildContext context) {
    return RecordListLayout<Sales>(
      columns: <CustomTableColumn<Sales>>[
        CustomTableColumn(
          title: 'No Transaksi',
          columnType: .string,
          getValue: (rowData) => rowData.code,
        ),
        CustomTableColumn(
          title: 'Tanggal',
          columnType: .datetime,
          getValue: (rowData) => rowData.transactionDate,
        ),
        CustomTableColumn(
          title: 'Deskripsi',
          columnType: .string,
          getValue: (rowData) => rowData.description,
        ),
        CustomTableColumn(
          title: 'Total',
          columnType: .money,
          getValue: (rowData) => rowData.total,
        ),
        CustomTableColumn(
          title: 'Jumlah Item',
          columnType: .number,
          getValue: (rowData) => rowData.itemCount,
        ),
        CustomTableColumn(
          title: 'User Buat',
          columnType: .string,
          getValue: (rowData) => rowData.userName,
        ),
        CustomTableColumn(
          title: 'Status Bayar',
          columnType: ColumnTypeBoolean(
            trueValLocale: 'Lunas',
            falseValLocale: 'Belum Lunas',
          ),
          getValue: (rowData) => rowData.isPaid,
        ),
      ],
      getData: RecordListLayout.localQuery(_sales),
      // (RequestData request) {
      //   return Future.value(
      //     ResponseData(
      //       currentPage: request.page,
      //       totalPage: (_sales.length / request.limit).ceil(),
      //       itemCount: _sales.length,
      //       data: _sales.sublist(
      //         (request.page - 1) * request.limit,
      //         [request.page * request.limit, _sales.length].min,
      //       ),
      //     ),
      //   );
      // },
      rowActions: (model) => [
        ActionButton(
          iconData: Icons.edit,
          label: 'Edit',
          color: Colors.orange,
          onPressed: () {},
        ),
        ActionButton(
          iconData: Icons.delete,
          label: 'Hapus',
          color: Colors.red,
          onPressed: () {},
        ),
        ActionButton(
          iconData: Icons.print,
          label: 'Laporan',
          color: const Color.fromARGB(255, 189, 223, 251),
          onPressed: () {},
        ),
      ],
      footerActions: [
        ActionButton(
          iconData: Icons.add,
          label: 'Tambah',
          color: Colors.green,
          onPressed: () {
            final layoutManager = context.read<LayoutManager>();
            int tabIndex = layoutManager.addTab(
              TabPanel(title: 'Tambah Penjualan', page: Placeholder()),
            );
            layoutManager.showTab(tabIndex);
          },
        ),
        ActionButton(
          iconData: Icons.print,
          label: 'Laporan',
          color: Colors.blue,
          onPressed: () {},
        ),
      ],
    );
  }
}

class Sales {
  String code;
  DateTime transactionDate;
  String? description;
  Money total;
  String userName;
  bool isPaid;
  int itemCount;
  Sales({
    required this.transactionDate,
    required this.code,
    this.description,
    this.isPaid = false,
    this.itemCount = 0,
    required this.userName,
    required this.total,
  });
}
