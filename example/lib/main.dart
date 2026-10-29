import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:allegra_ui/allegra_ui.dart';
import 'package:example/pages/cashier_detail.dart';
import 'package:example/pages/record_detail.dart';
import 'package:example/pages/record_list.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('ID');
  runApp(const AllegraUI());
}

class AllegraUI extends StatelessWidget {
  const AllegraUI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iPos Ultimate Clone',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color.fromARGB(255, 240, 245, 243),
        fontFamily: 'Roboto',
      ),
      home: MainLayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainLayout extends StatelessWidget {
  MainLayout({super.key});
  final List<Menu> mainMenus = [
    Menu(title: 'Master Data'),
    Menu(
      title: 'Komponen',
      submenus: [
        Menu(
          title: 'date time range picker',
          iconData: Icons.calendar_month,
          page: SizedBox(child: DateTimeRangeScreen()),
        ),
      ],
    ),
    Menu(
      title: 'Layout',
      submenus: [
        Menu(
          iconData: Icons.receipt_long,
          title: 'Record list',
          page: RecordList(),
        ),

        Menu(
          iconData: Icons.receipt_long,
          title: 'Record Detail',
          page: RecordDetail(),
        ),
        Menu(
          iconData: Icons.receipt_long,
          title: 'Cashier',
          page: CashierDetail(),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LayoutManager>(
      create: (context) => LayoutManager(
        tabPanels: [
          TabPanel(
            title: 'Menu Utama',
            canClose: false,
            page: Placeholder(child: Text('Menu Utama')),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraint) {
          if (constraint.maxWidth >= 1024) {
            return DesktopBaseLayout(menus: mainMenus);
          } else {
            return MobileBaseLayout(menus: mainMenus);
          }
        },
      ),
    );
  }
}
