import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hmsapp/constants/controllers.dart';
import 'package:hmsapp/helpers/responsiveness.dart';
import 'package:hmsapp/pages/dashboard/widgets/available_drivers_table.dart';
import 'package:hmsapp/pages/dashboard/widgets/overview_cards_large.dart';
import 'package:hmsapp/pages/dashboard/widgets/overview_cards_medium.dart';
import 'package:hmsapp/pages/dashboard/widgets/overview_cards_small.dart';
import 'package:hmsapp/pages/dashboard/widgets/revenue_section_large.dart';
import 'package:hmsapp/pages/dashboard/widgets/revenue_section_small.dart';
import 'package:hmsapp/widgets/custom.dart';

class OverViewPage extends StatelessWidget {
  // const OverViewPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Obx(
          () => Row(
            children: [
              Container(
                  margin: EdgeInsets.only(top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6, left: 10),
                  child: CustomText(
                    text: menuControllers.activeItem.value,
                    size: 24,
                    weight: FontWeight.bold,
                  )),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              if (ResponsiveWidget.isLargeScreen(context) || ResponsiveWidget.isMediumScreen(context))
                if (ResponsiveWidget.isCustomSize(context)) const OverviewCardsMediumScreen() else const OverviewCardsLargeScreen()
              else
                const OverviewCardsSmallScreen(),
              if (!ResponsiveWidget.isSmallScreen(context)) const RevenueSectionLarge() else const RevenueSectionSmall(),
               AvailableDriversTable(),
            ],
          ),
        ),
      ],
    );
  }
}