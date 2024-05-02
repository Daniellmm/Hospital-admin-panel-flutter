import 'package:flutter/material.dart';
import 'package:hmsapp/pages/Booking/Booking.dart';
import 'package:hmsapp/pages/consultation/consultation.dart';
import 'package:hmsapp/pages/dashboard/dashboard.dart';
import 'package:hmsapp/pages/patient/patient.dart';
import 'package:hmsapp/pages/payment/payment.dart';
import 'package:hmsapp/pages/pharmacy/pharmacy.dart';
import 'package:hmsapp/routing/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case OverViewPageRoute:
      return _getPageRoute( OverViewPage());
    case PatientsPageRoute:
      return _getPageRoute( PatientPage());
    case BookingPageRoute:
      return _getPageRoute( BookingPage());
    case ConsultPageRoute:
      return _getPageRoute( ConsultPage());
    case PharmacyPageRoute:
      return _getPageRoute( PharmacyPage());
    case PaymentPageRoute:
      return _getPageRoute( PaymentPage());
    default:
      return _getPageRoute( OverViewPage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
