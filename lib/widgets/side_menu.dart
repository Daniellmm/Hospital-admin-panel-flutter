import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hmsapp/constants/controllers.dart';
import 'package:hmsapp/constants/style.dart';
import 'package:hmsapp/helpers/responsiveness.dart';
import 'package:hmsapp/routing/routes.dart';
import 'package:hmsapp/widgets/custom.dart';
import 'package:hmsapp/widgets/side_menu_items.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
     double width = MediaQuery.of(context).size.width;
    return Container(
      color: light,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
        if(ResponsiveWidget.isSmallScreen(context))
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 40,),
            Row(
              children: [
                SizedBox(width: width / 48,),
                Padding(padding: EdgeInsets.only(right: 12),
                child: Image.asset("assets/icons/logo.png"),
                ),

                Flexible(child: CustomText(
                  text: "H.I.S", 
                  size: 20, 
                  color: active, 
                  weight: FontWeight.bold
                  ),
                  ),
                  SizedBox(width: width / 48,)
              ],
            ), 
          ],
        ),

          Divider(
            color: lightGrey.withOpacity(.1),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: sideMenuItems
                .map(
                  (itemName) => SideMenuItems(
                    itemName: itemName == AuthenticationPageRoute
                        ? "Log Out"
                        : itemName,
                    onTap: () {
                      if (itemName == AuthenticationPageRoute) {
                        // go to auth page
                      }

                      if (!menuControllers.isActive(itemName)) {
                        menuControllers.changeActiveitemTo(itemName);
                        if (ResponsiveWidget.isSmallScreen(context)) 
                        Get.back();
                        navigationController.navigateTo(itemName);
                        
                      }
                    },
                  ),
                )
                .toList(),
          )
      ],),
    );
  }
}