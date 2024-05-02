import 'package:flutter/material.dart';

const int LargeScreenSize = 1366;
const int mediumScreenSize = 768;
const int smallScreenSize = 360;
const int customScreenSize = 1100;

class ResponsiveWidget extends StatelessWidget {
  final Widget LargeScreen;
  final Widget? mediumScreen;
  final Widget? smallScreen;
  final Widget? CustomScreen;
  

  const ResponsiveWidget(
      {super.key,
      required this.LargeScreen,
      this.mediumScreen,
      this.smallScreen, 
      this.CustomScreen,
      });

static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < mediumScreenSize;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= mediumScreenSize &&
        MediaQuery.of(context).size.width < LargeScreenSize;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > LargeScreenSize;
  }

  static bool isCustomSize(BuildContext context) {
    return MediaQuery.of(context).size.width <= customScreenSize &&
        MediaQuery.of(context).size.width >= mediumScreenSize;
  }
    

  @override
Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= LargeScreenSize) {
          return LargeScreen;
        } else if (constraints.maxWidth < LargeScreenSize &&
            constraints.maxWidth >= mediumScreenSize) {
          return mediumScreen ?? LargeScreen;
        } else {
          return smallScreen ?? LargeScreen;
        }
      },
    );
  }
}
