import 'package:allegra_ui/models/layout_manager.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:allegra_ui/allegra_ui.dart';

void main() {
  test('adds one to input values', () {
    final layoutManager = LayoutManager();

    expect(layoutManager.tabs.length, 0);
    layoutManager.addTab(TabPanel(title: 'title', page: Placeholder()));
    // expect(calculator.addOne(-7), -6);
    // expect(calculator.addOne(0), 1);
  });
}
