import 'package:allegra_ui/models/tab_panel.dart';
import 'package:flutter/material.dart';
export 'package:allegra_ui/models/tab_panel.dart';

class LayoutManager extends ChangeNotifier {
  late final List<TabPanel> _tabs;
  Widget? floatingActionButton;

  int _selectedTabIndex = 0;
  LayoutManager({List<TabPanel>? tabPanels, this.floatingActionButton})
    : _tabs = tabPanels ?? <TabPanel>[];

  void showTab(int index) {
    if (_selectedTabIndex != index) {
      _selectedTabIndex = index;
      notifyListeners();
    }
  }

  int get selectedTabIndex => _selectedTabIndex;

  TabPanel? get selectedTab => _tabs.elementAtOrNull(_selectedTabIndex);

  List<TabPanel> get tabPanels => _tabs;
  int addTab(TabPanel tab) {
    int tabIndex = findTabIndex(tab);
    if (tabIndex >= 0) {
      return tabIndex;
    }
    _tabs.add(tab);
    notifyListeners();
    return _tabs.length - 1;
  }

  int findTabIndex(TabPanel tab) =>
      _tabs.indexWhere((tabPanel) => tabPanel.title == tab.title);

  void removeTab(TabPanel tab) {
    _tabs.remove(tab);
    notifyListeners();
  }
}
