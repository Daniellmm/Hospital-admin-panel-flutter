import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hmsapp/constants/style.dart';
import 'package:hmsapp/routing/routes.dart';

class MenuControllers extends GetxController{
 static MenuControllers instance = Get.find();
 var activeItem = OverViewPageRoute.obs;
 var hoverItem = "".obs;

 changeActiveitemTo(String itemName){
  activeItem.value = itemName;
 }

 onHover(String itemName){
  if(!isActive(itemName)) hoverItem.value = itemName;
 }


 isActive(String itemName) =>activeItem.value == itemName;
 isHovering(String itemName) => hoverItem.value == itemName;

 Widget returnIconFor(String itemName){
  switch (itemName) {
    case OverViewPageRoute:
      return _customIcon(Icons.home, itemName);
      case PatientsPageRoute:
        return _customIcon(Icons.people, itemName);
      case ConsultPageRoute:
        return _customIcon(Icons.medical_services, itemName);
      case PharmacyPageRoute:
        return _customIcon(Icons.local_hospital, itemName);
      // case PaymentPageRoute:
      //   return _customIcon(Icons.payment, itemName);
      case AuthenticationPageRoute:
        return _customIcon(Icons.exit_to_app, itemName);
      
    default:
      return _customIcon(Icons.exit_to_app, itemName);

  }
 }

 Widget _customIcon(IconData icon, String itemName){
  if(isActive(itemName)) return Icon(icon, size: 22, color: dark,);

  return Icon(icon, color: isHovering(itemName) ? dark : lightGrey,);
 }
}