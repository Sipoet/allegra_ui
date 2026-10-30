import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:allegra_ui/models/layout_manager.dart';
import 'package:allegra_ui/models/menu.dart';

class DesktopBaseLayout extends StatefulWidget {
  final List<Menu> menus;
  const DesktopBaseLayout({super.key, required this.menus});

  @override
  State<DesktopBaseLayout> createState() => _DesktopBaseLayoutState();
}

class _DesktopBaseLayoutState extends State<DesktopBaseLayout> {
  int _selectedMainMenuIndex = -1;
  String _activeSubMenu = 'Menu Utama';

  // final List<TabPanel> _tabs = [
  //   TabPanel(
  //     title: 'Menu Utama',
  //     canClose: false,
  //     page: Placeholder(child: Text('Menu Utama')),
  //   ),
  // ];

  // Dummy row model for data table

  // Sorting function logic

  @override
  Widget build(BuildContext context) {
    final layoutManager = context.watch<LayoutManager>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35),
        child: AppBar(
          backgroundColor: const Color(0xFFE1E6EB),
          elevation: 0,
          title: Text(
            '$_activeSubMenu - iPos Ultimate 5.0.9.3, [PUSAT] User : ADMIN, Lokasi : GDG, Host : 192.168.11.11',
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ),
      ),
      body: Column(
        children: [
          // 1. MAIN MENU BAR
          Container(
            height: 40,
            color: const Color(0xFFF8F9FA),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.menus.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedMainMenuIndex == index;
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedMainMenuIndex = -1;
                      } else {
                        _selectedMainMenuIndex = index;
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? Colors.green : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Text(
                      widget.menus[index].title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? Colors.green.shade800
                            : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1, color: Colors.grey),

          // 2. SUB MENU TOOLBAR (Clickable)
          if (_selectedMainMenuIndex != -1)
            Container(
              height: 75,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.menus[_selectedMainMenuIndex].submenus.length,
                itemBuilder: (context, index) {
                  final subMenus =
                      widget.menus[_selectedMainMenuIndex].submenus;
                  final subMenu = subMenus[index];
                  final isSubMenuSelected = _activeSubMenu == subMenu.title;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _activeSubMenu = subMenu.title;
                          int tabIndex = layoutManager.addTab(
                            TabPanel(title: subMenu.title, page: subMenu.page!),
                          );
                          layoutManager.showTab(tabIndex);
                        });
                      },
                      child: Container(
                        width: 75,
                        decoration: BoxDecoration(
                          color: isSubMenuSelected
                              ? Colors.green.shade50
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isSubMenuSelected
                                ? Colors.green.shade200
                                : Colors.transparent,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              subMenu.iconData,
                              size: 24,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subMenu.title,
                              style: const TextStyle(fontSize: 10),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          const Divider(height: 1, color: Colors.grey),

          // 3. TAB NAVIGATION BAR (Clickable Tabs)
          Container(
            height: 32,
            color: const Color(0xFFECEFF1),
            child: Row(
              children: List.generate(layoutManager.tabPanels.length, (index) {
                final isActive = layoutManager.selectedTabIndex == index;
                return InkWell(
                  onTap: () {
                    setState(() {
                      layoutManager.showTab(index);
                    });
                  },
                  child: _buildTabItem(
                    layoutManager.tabPanels[index],
                    isActive,
                  ),
                );
              }),
            ),
          ),
          Expanded(child: layoutManager.selectedTab?.page ?? const SizedBox()),
        ],
      ),
    );
  }

  Widget _buildTabItem(TabPanel tabPanel, bool isActive) {
    final LayoutManager layoutManager = context.read<LayoutManager>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : const Color(0xFFECEFF1),
        border: Border(
          top: BorderSide(
            color: isActive ? Colors.green : Colors.transparent,
            width: 2,
          ),
          right: const BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tabPanel.title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.black : Colors.black54,
            ),
          ),
          if (tabPanel.canClose)
            IconButton(
              onPressed: () {
                setState(() {
                  layoutManager.removeTab(tabPanel);
                  if (layoutManager.selectedTabIndex >=
                      layoutManager.tabPanels.length) {
                    layoutManager.showTab(layoutManager.tabPanels.length - 1);
                  }
                });
              },
              iconSize: 15,
              icon: Icon(Icons.close),
            ),
        ],
      ),
    );
  }
}
