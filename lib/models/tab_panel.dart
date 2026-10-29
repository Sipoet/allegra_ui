import 'package:flutter/material.dart';

class TabPanel {
  String title;
  Widget page;
  bool canClose;
  TabPanel({required this.title, this.canClose = true, required this.page});
}
