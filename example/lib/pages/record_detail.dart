import 'package:example/models/sales.dart';
import 'package:flutter/material.dart';
import 'package:allegra_ui/allegra_ui.dart';

class RecordDetail extends StatefulWidget {
  const RecordDetail({super.key});

  @override
  State<RecordDetail> createState() => _RecordDetailState();
}

class _RecordDetailState extends State<RecordDetail> {
  @override
  Widget build(BuildContext context) {
    return RecordDetailLayout<Sales>(
      model: Sales(
        code: '0001/KSR/TOKO/1026',
        transactionDate: DateTime(2026, 10, 1, 8, 1, 0),
        userName: 'Sella',
        total: Money(1_000.0),
        itemCount: 9,
        description: 'dari online',
        isPaid: true,
      ),
    );
  }
}
