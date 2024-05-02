import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hmsapp/constants/controllers.dart';
import 'package:hmsapp/constants/style.dart';
import 'package:hmsapp/widgets/custom.dart';

class VerticalMenuItem extends StatelessWidget {
  final String itemName;
  final Function()? onTap;
  const VerticalMenuItem(
      {super.key, required this.itemName, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onHover: (value) {
        value
            ? menuControllers.onHover(itemName)
            : menuControllers.onHover("not hovering");
      },
      child: Obx(() => Container(
            color: menuControllers.isHovering(itemName)
                ? lightGrey.withOpacity(.1)
                : Colors.transparent,
            child: Row(
              children: [
                Visibility(
                  visible: menuControllers.isHovering(itemName) ||
                      menuControllers.isActive(itemName),
                  child: Container(
                    width: 3,
                    height: 72,
                    color: dark,
                  ),
                  maintainSize: true,
                  maintainState: true,
                  maintainAnimation: true,
                ),
                Expanded(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: menuControllers.returnIconFor(itemName),
                    ),
                    if (!menuControllers.isActive(itemName))
                      Flexible(
                          child: CustomText(
                        text: itemName,
                        size: 18,
                        weight: FontWeight.normal,
                        color: menuControllers.isHovering(itemName)
                            ? dark
                            : lightGrey,
                      ))
                    else
                      Flexible(
                          child: CustomText(
                              text: itemName,
                              size: 18,
                              color: dark,
                              weight: FontWeight.bold))
                  ],
                ))
              ],
            ),
          )),
    );
  }
}
