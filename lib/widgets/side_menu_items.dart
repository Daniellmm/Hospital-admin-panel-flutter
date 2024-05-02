import 'package:flutter/material.dart';
import 'package:hmsapp/helpers/responsiveness.dart';
import 'package:hmsapp/widgets/horizontal_menu_item.dart';
import 'package:hmsapp/widgets/vertical_menu_item.dart';

class SideMenuItems extends StatelessWidget {
  final String itemName;
  final Function() onTap;
  const SideMenuItems({super.key, required this.itemName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (ResponsiveWidget.isCustomSize(context)) {
      return VerticalMenuItem(
        itemName: itemName,
        onTap: onTap,
      );
    } else {
      return HorizontalMenuItem(
        itemName: itemName,
        onTap: onTap,
      );
    }
  }
}
