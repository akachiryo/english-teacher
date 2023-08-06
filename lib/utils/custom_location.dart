import 'package:flutter/material.dart';

class CustomLocation extends FloatingActionButtonLocation {
  const CustomLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final fabX = scaffoldGeometry.scaffoldSize.width -
        scaffoldGeometry.floatingActionButtonSize.width -
        16.0;
    final fabY = scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.floatingActionButtonSize.height -
        60.0; // Change this value to move the FAB up or down.

    return Offset(fabX, fabY);
  }
}
