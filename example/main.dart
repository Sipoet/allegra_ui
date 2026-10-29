import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:allegra_ui/components/daterangetimepicker.dart';
import 'package:allegra_ui/layout/main/desktop_main_layout.dart';
import 'package:allegra_ui/layout/main/mobile_main_layout.dart';
import 'package:allegra_ui/models/layout_manager.dart';
import 'package:allegra_ui/models/menu.dart';
import 'cashier_detail.dart';
import 'record_detail.dart';
import 'record_list.dart';
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
        Menu(
          iconData: Icons.history,
          title: 'History Harga Jual',
          page: Placeholder(child: Text('History Harga Jual')),
        ),
        Menu(
          iconData: Icons.swap_horiz,
          title: 'Tukar Tambah',
          page: Placeholder(child: Text('Tukar Tambah')),
        ),
        Menu(
          iconData: Icons.payment,
          title: 'Daftar Pembayaran',
          page: Placeholder(child: Text('Daftar Pembayaran')),
        ),
      ],
    ),
    Menu(title: 'Perakitan'),
    Menu(title: 'Persediaan'),
    Menu(title: 'Akuntansi'),
    Menu(title: 'Laporan'),
    Menu(title: 'Pengaturan'),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LayoutManager>(
      create: (context) => LayoutManager(
        tabs: [
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
            return DesktopMainLayout(menus: mainMenus);
          } else {
            return MobileMainLayout(menus: mainMenus);
          }
        },
      ),
    );
  }
}
