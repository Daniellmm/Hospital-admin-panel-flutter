import 'package:flutter/material.dart';
import 'package:hmsapp/pages/dashboard/widgets/info_card.dart';


class OverviewCardsMediumScreen extends StatelessWidget {
  const OverviewCardsMediumScreen({super.key});


  @override
  Widget build(BuildContext context) {
   double width = MediaQuery.of(context).size.width;

    return  Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
                  children: [
                    InfoCard(
                      title: "Appointment",
                      value: "7",
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
                  
                  ],
                ),
            SizedBox(
                      height: width / 64,
                    ),
                  Row(
                  children: [
             
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
                      value: "32",
                      onTap: () {},
                    ),
                
                  ],
                ),
      ],
    );
  }
}