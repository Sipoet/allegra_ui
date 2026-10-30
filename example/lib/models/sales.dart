import 'package:allegra_ui/models/main.dart';

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
