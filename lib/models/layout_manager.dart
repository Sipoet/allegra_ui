import 'package:flutter/foundation.dart';
import 'package:allegra_ui/models/tab_panel.dart';
export 'package:allegra_ui/models/tab_panel.dart';

class LayoutManager extends ChangeNotifier {
  List<TabPanel> _tabs = [];

  int _selectedTabIndex = 0;
  LayoutManager({List<TabPanel>? tabs}) : _tabs = tabs ?? [];

  void showTab(int index) {
    if (_selectedTabIndex != index) {
      _selectedTabIndex = index;
      notifyListeners();
    }
  }

  int get selectedTabIndex => _selectedTabIndex;

  List<TabPanel> get tabs => _tabs;
  int addTab(TabPanel tab) {
    int tabIndex = findTabIndex(tab);
    if (tabIndex >= 0) {
      return tabIndex;
    }
    tabs.add(tab);
    notifyListeners();
    return tabs.length - 1;
  }

  int findTabIndex(TabPanel tab) =>
      _tabs.indexWhere((tabPanel) => tabPanel.title == tab.title);

  void removeTab(TabPanel tab) {
    tabs.remove(tab);
    notifyListeners();
  }
}
