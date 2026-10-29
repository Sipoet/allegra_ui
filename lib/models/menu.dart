import 'package:flutter/material.dart';

class Menu {
  Widget? page;
  IconData? iconData;
  List<Menu> submenus = [];
  String title;
  String? description;
  Menu({
    required this.title,
    this.description,
    this.page,
    this.iconData,
    this.submenus = const [],
  });
}
