import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hmsapp/constants/controllers.dart';
import 'package:hmsapp/constants/style.dart';
import 'package:hmsapp/widgets/custom.dart';

class HorizontalMenuItem extends StatelessWidget {
   final String itemName;
  final Function()? onTap;
  const HorizontalMenuItem(
      {super.key, required this.itemName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      onHover: (value) {
        value
            ? menuControllers.onHover(itemName)
            : menuControllers.onHover("not hovering");
      },
      child: Obx(() => Container(
                    color: menuControllers.isHovering(itemName) ? lightGrey.withOpacity(.1) : Colors.transparent,
                    child: Row(
                      children: [
                        Visibility(
                          visible: menuControllers.isHovering(itemName) || menuControllers.isActive(itemName),
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: Container(
                            width: 6,
                            height: 40,
                            color: dark,
                          ),
                        ),
                       SizedBox(width:width / 88),

                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: menuControllers.returnIconFor(itemName),
                        ),
                        if(!menuControllers.isActive(itemName))
                        Flexible(child: CustomText(text: itemName , color: menuControllers.isHovering(itemName) ? dark : lightGrey,))
                        else
                        Flexible(child: CustomText(text: itemName , color:  dark , size: 18, weight: FontWeight.bold,))

                      ],
                    ),
                  ))
    );
  }
}
