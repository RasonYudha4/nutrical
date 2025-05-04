import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
  int carbs = 200;
  int proteins = 18;
  int fats = 180;
  int calories = 300;
  int caloriesLimit = 380;
  TextEditingController carbsController = TextEditingController();
  TextEditingController proteinsController = TextEditingController();
  TextEditingController fatsController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();
  TextEditingController caloriesLimitController = TextEditingController();
  TextStyle nutrtitionsTextStyle = const TextStyle(
    fontSize: 15,
    letterSpacing: 0.2,
  );
  TextStyle nutrtitionsValueStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  final backgroundColor = const Color(0xffD3E671);
  final primaryColor = const Color(0xff89AC46);
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
                      IconButton(
                        onPressed: () {
                          log("Read more");
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.all(5),
                        ),
                        icon: Text(
                          "Read more",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
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

  Widget editButtonClicked(BuildContext context) {
    carbsController.text = carbs.toString();
    proteinsController.text = proteins.toString();
    fatsController.text = fats.toString();
    caloriesController.text = calories.toString();
    caloriesLimitController.text = caloriesLimit.toString();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.transparent,
      child: Container(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    "Today's Nutrition Summarization",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
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
                          Row(
                            children: [
                              SizedBox(width: 12),
                              Container(
                                width: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xffd3e671),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: TextField(
                                  controller: carbsController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ), // Same as your Text style
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                  ),
                                ),
                              ),
                              Text(" g", style: nutrtitionsValueStyle),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text("Proteins :", style: nutrtitionsTextStyle),
                          Row(
                            children: [
                              SizedBox(width: 12),
                              Container(
                                width: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xffd3e671),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: TextField(
                                  controller: proteinsController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ), // Same as your Text style
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                  ),
                                ),
                              ),
                              Text(" g", style: nutrtitionsValueStyle),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text("Fats :", style: nutrtitionsTextStyle),
                          Row(
                            children: [
                              SizedBox(width: 12),
                              Container(
                                width: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xffd3e671),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: TextField(
                                  controller: fatsController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ), // Same as your Text style
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                  ),
                                ),
                              ),
                              Text(" g", style: nutrtitionsValueStyle),
                            ],
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total Calories :", style: nutrtitionsTextStyle),
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
                              percent: math.min(1, (calories / caloriesLimit)),
                              startAngle: 270,
                              circularStrokeCap: CircularStrokeCap.round,
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 50,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Color(0xffd3e671),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: caloriesController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ), // Same as your Text style
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 2,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        " Cal",
                                        style: nutrtitionsValueStyle,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("/", style: nutrtitionsTextStyle),
                                      Container(
                                        width: 50,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Color(0xffd3e671),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: caloriesLimitController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ), // Same as your Text style
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 2,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Text(" Cal", style: nutrtitionsTextStyle),
                                    ],
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    log(carbsController.text);
                    log(proteinsController.text);
                    log(fatsController.text);
                    log(caloriesController.text);
                    log(caloriesLimitController.text);
                    setState(() {
                      carbs = int.parse(carbsController.text);
                      proteins = int.parse(proteinsController.text);
                      fats = int.parse(fatsController.text);
                      calories = int.parse(caloriesController.text);
                      caloriesLimit = int.parse(caloriesLimitController.text);
                    });
                    Navigator.pop(context);
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: backgroundColor,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.redAccent, // Button background color
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => editButtonClicked(context),
                                );
                              },
                              icon: Container(
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
                                Row(
                                  children: [
                                    SizedBox(width: 12),
                                    Text(
                                      carbs.toString(),
                                      style: nutrtitionsValueStyle,
                                    ),
                                    Text(" g", style: nutrtitionsValueStyle),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text("Proteins :", style: nutrtitionsTextStyle),
                                Row(
                                  children: [
                                    SizedBox(width: 12),
                                    Text(
                                      proteins.toString(),
                                      style: nutrtitionsValueStyle,
                                    ),
                                    Text(" g", style: nutrtitionsValueStyle),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text("Fats :", style: nutrtitionsTextStyle),
                                Row(
                                  children: [
                                    SizedBox(width: 12),
                                    Text(
                                      fats.toString(),
                                      style: nutrtitionsValueStyle,
                                    ),
                                    Text(" g", style: nutrtitionsValueStyle),
                                  ],
                                ),
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
                                    percent: math.min(
                                      1,
                                      calories / caloriesLimit,
                                    ),
                                    startAngle: 270,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    center: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              calories.toString(),
                                              style: nutrtitionsValueStyle,
                                            ),
                                            Text(
                                              " Cal",
                                              style: nutrtitionsValueStyle,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "/",
                                              style: nutrtitionsTextStyle,
                                            ),
                                            Text(
                                              caloriesLimit.toString(),
                                              style: nutrtitionsTextStyle,
                                            ),
                                            Text(
                                              " Cal",
                                              style: nutrtitionsTextStyle,
                                            ),
                                          ],
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
