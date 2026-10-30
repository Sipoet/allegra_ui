import 'package:allegra_ui/layouts/record/sales_detail_layout.dart';
import 'package:flutter/material.dart';

class CashierDetail extends StatefulWidget {
  const CashierDetail({super.key});

  @override
  State<CashierDetail> createState() => _CashierDetailState();
}

class _CashierDetailState extends State<CashierDetail> {
  @override
  Widget build(BuildContext context) {
    return const SalesDetailLayout();
  }
}
