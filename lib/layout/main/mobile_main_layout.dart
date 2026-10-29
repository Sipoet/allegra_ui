import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:allegra_ui/models/layout_manager.dart';
import 'package:allegra_ui/models/menu.dart';

class MobileMainLayout extends StatefulWidget {
  final List<Menu> menus;
  const MobileMainLayout({super.key, required this.menus});

  @override
  State<MobileMainLayout> createState() => _MobileMainLayoutState();
}

class _MobileMainLayoutState extends State<MobileMainLayout>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final layoutManager = context.watch<LayoutManager>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'iPos Ultimate Mobile',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),

      // EXPANDABLE DRAWER CONTAINING MAIN MENUS & SUBMENUS
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.green.shade800),
                accountName: const Text(
                  'iPos Ultimate Mobile',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: const Text('User: ADMIN | Lokasi: GDG'),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.green, size: 36),
                ),
              ),

              // Menu & Submenu Expandable List
              Expanded(
                child: ListView.builder(
                  itemCount: widget.menus.length,
                  itemBuilder: (context, index) {
                    final menu = widget.menus[index];
                    final List<Menu> subMenus = menu.submenus;

                    return ExpansionTile(
                      leading: Icon(
                        menu.iconData,
                        color: Colors.green.shade700,
                      ),
                      title: Text(
                        menu.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      children: subMenus.map<Widget>((subMenu) {
                        return ListTile(
                          contentPadding: const EdgeInsets.only(
                            left: 48,
                            right: 16,
                          ),
                          leading: Icon(
                            subMenu.iconData,
                            size: 18,
                            color: Colors.grey.shade700,
                          ),
                          title: Text(
                            subMenu.title,
                            style: const TextStyle(fontSize: 13),
                          ),
                          onTap: () {
                            Navigator.pop(context); // Close Drawer
                            final layoutManager = context.read<LayoutManager>();
                            int tabIndex = layoutManager.addTab(
                              TabPanel(
                                title: subMenu.title,
                                page: subMenu.page!,
                              ),
                            );
                            layoutManager.showTab(tabIndex);
                            // _openSubMenuAsTab(subMenu.title); // Open in Tab
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // MAIN PANEL WITH GROWABLE TABS
      body: Column(
        children: [
          // Dynamic Tab Header Strip
          Container(
            height: 42,
            color: Colors.grey.shade200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: layoutManager.tabs.length,
              itemBuilder: (context, index) {
                final tab = layoutManager.tabs[index];
                bool isSelected = layoutManager.selectedTabIndex == index;

                return InkWell(
                  onTap: () => setState(() => layoutManager.showTab(index)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.grey.shade200,
                      border: Border(
                        top: BorderSide(
                          color: isSelected ? Colors.green : Colors.transparent,
                          width: 3,
                        ),
                        right: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tab.title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.green.shade900
                                : Colors.black87,
                          ),
                        ),
                        if (tab.canClose) ...[
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: () => layoutManager.removeTab(tab),
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          // 2. Dynamic Active Tab Content Panel
          Expanded(
            child:
                layoutManager.tabs
                    .elementAtOrNull(layoutManager.selectedTabIndex)
                    ?.page ??
                const SizedBox(),
          ),
        ],
      ),
    );
  }
}
