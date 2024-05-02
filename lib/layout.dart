import 'package:flutter/material.dart';
import 'package:hmsapp/helpers/responsiveness.dart';
import 'package:hmsapp/widgets/large_screen.dart';
import 'package:hmsapp/widgets/side_menu.dart';
import 'package:hmsapp/widgets/small_screen.dart';
import 'package:hmsapp/widgets/top_nav_bar.dart';

class SiteLayout extends StatefulWidget {

   SiteLayout({super.key});

  @override
  State<SiteLayout> createState() => _SiteLayoutState();
}

class _SiteLayoutState extends State<SiteLayout> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar:topNavigationBar(context, scaffoldKey) ,
      drawer: Drawer(child: SideMenu(),),
      body: ResponsiveWidget(LargeScreen: LargeScreen(),  smallScreen: SmallScreen(),),
    );
  }
}