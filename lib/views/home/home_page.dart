import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomePage extends StatelessWidget {
  Stack createCard(String title, String desc, String imageURL) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image(
            image: NetworkImage(imageURL),
            fit: BoxFit.cover,
            height: 200,
            width: 350,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            width: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(desc, style: TextStyle(fontSize: 15)),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          log("Read more");
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 5,
                            right: 5,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Read more",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  const HomePage({super.key});
  final backgroundColor = const Color(0xffD3E671);
  final primaryColor = const Color(0xff89AC46);
  @override
  Widget build(BuildContext context) {
    TextStyle nutrtitionsTextStyle = const TextStyle(
      fontSize: 15,
      letterSpacing: 0.2,
    );
    TextStyle nutrtitionsValueStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    return SingleChildScrollView(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Container(
              width: double.infinity,
              height: 240,
              color: backgroundColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(100, 0, 0, 0),
                            spreadRadius: 1,
                            offset: Offset(2, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(Icons.home, size: 30, color: Colors.white),
                    ),
                    SizedBox(width: 15),
                    Text(
                      'NutriCal',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 70),
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(100, 0, 0, 0),
                        spreadRadius: 1,
                        offset: Offset(2, 2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Today's Nutrition Summarization",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                log("Edit pressed");
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(100, 0, 0, 0),
                                      spreadRadius: 1,
                                      offset: Offset(2, 2),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 5,
                                    bottom: 5,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Edit",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(Icons.edit, size: 15),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Carbs :", style: nutrtitionsTextStyle),
                                Text("\t\t200 g", style: nutrtitionsValueStyle),
                                SizedBox(height: 5),
                                Text("Proteins :", style: nutrtitionsTextStyle),
                                Text("\t\t18 g", style: nutrtitionsValueStyle),
                                SizedBox(height: 5),
                                Text("Fats :", style: nutrtitionsTextStyle),
                                Text("\t\t180 g", style: nutrtitionsValueStyle),
                                SizedBox(height: 5),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Calories :",
                                  style: nutrtitionsTextStyle,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10, right: 15),
                                  child: CircularPercentIndicator(
                                    radius: 70,
                                    lineWidth: 15,
                                    backgroundColor: Color.fromARGB(
                                      255,
                                      238,
                                      252,
                                      185,
                                    ),
                                    progressColor: backgroundColor,
                                    percent: (300 / 380),
                                    startAngle: 270,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    center: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "300 Cal",
                                          style: nutrtitionsValueStyle,
                                        ),
                                        Text(
                                          "/380 Cal",
                                          style: nutrtitionsTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    "Daily Consumptions",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                ...["Breakfast", "Lunch", "Dinner"].map((e) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios_sharp),
                        ],
                      ),
                    ),
                  );
                }),
                Text(
                  "Contents",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      createCard(
                        "Healthy Eating",
                        "Making smart food choices doesn’t mean sacrificing flavor.",
                        "https://imgsrv2.voi.id/4UB_YXWr4rIKQoUdb4PugkW-e3ZDEX5cS2rDM4NQjco/auto/336/188/sm/1/bG9jYWw6Ly8vcHVibGlzaGVycy8yNTM3MzEvMjAyMzAyMTMxMzAzLW1haW4uanBn.jpg",
                      ),
                      SizedBox(width: 10),
                      createCard(
                        "Healthy Eating",
                        "Making smart food choices doesn’t mean sacrificing flavor.",
                        "https://imgsrv2.voi.id/4UB_YXWr4rIKQoUdb4PugkW-e3ZDEX5cS2rDM4NQjco/auto/336/188/sm/1/bG9jYWw6Ly8vcHVibGlzaGVycy8yNTM3MzEvMjAyMzAyMTMxMzAzLW1haW4uanBn.jpg",
                      ),
                      SizedBox(width: 10),
                      createCard(
                        "Healthy Eating",
                        "Making smart food choices doesn’t mean sacrificing flavor.",
                        "https://imgsrv2.voi.id/4UB_YXWr4rIKQoUdb4PugkW-e3ZDEX5cS2rDM4NQjco/auto/336/188/sm/1/bG9jYWw6Ly8vcHVibGlzaGVycy8yNTM3MzEvMjAyMzAyMTMxMzAzLW1haW4uanBn.jpg",
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
