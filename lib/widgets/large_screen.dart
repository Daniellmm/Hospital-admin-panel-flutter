import 'package:flutter/material.dart';
import 'package:hmsapp/helpers/local_navigator.dart';
import 'package:hmsapp/widgets/side_menu.dart';

class LargeScreen extends StatelessWidget {
  const LargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Expanded(child: SideMenu()),
          Expanded(
            flex: 5,
            child: localNavigator())
        ],
      );
  }
}