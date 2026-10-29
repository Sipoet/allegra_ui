import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:allegra_ui/allegra_ui.dart';

void main() {
  test('adds tab and remove tab', () {
    final layoutManager = LayoutManager();

    expect(layoutManager.tabPanels.length, 0);
    final tabPanel = TabPanel(title: 'title', page: Placeholder());
    layoutManager.addTab(tabPanel);
    expect(layoutManager.tabPanels.length, 1);
    layoutManager.removeTab(tabPanel);
    expect(layoutManager.tabPanels.length, 0);
  });
}
