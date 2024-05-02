import 'package:flutter/material.dart';
import 'package:hmsapp/pages/dashboard/widgets/info_card.dart';


class OverviewCardsLargeScreen extends StatelessWidget {
  const OverviewCardsLargeScreen({super.key});


  @override
  Widget build(BuildContext context) {
   double width = MediaQuery.of(context).size.width;

    return  Row(
              children: [
                InfoCard(
                  title: "Appointment",
                  value: "100",
                  onTap: () {},
                  // topColor: Colors.orange,
                ),
                SizedBox(
                  width: width / 64,
                ),
                InfoCard(
                  title: "New Patients",
                  value: "17",
                  // topColor: Colors.lightGreen,
                  onTap: () {},
                ),
                SizedBox(
                  width: width / 64,
                ),
                InfoCard(
                  title: "Operations",
                  value: "3",
                  // topColor: Colors.redAccent,
                  onTap: () {},
                ),
                SizedBox(
                  width: width / 64,
                ),
                InfoCard(
                  title: "Total Patient this week",
                  value: "72",
                  onTap: () {},
                ),
              ],
            );
  }
}