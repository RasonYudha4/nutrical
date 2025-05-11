import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color(0xffD3E671),
              padding: const EdgeInsets.all(30),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "About",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Text.rich(
                    TextSpan(
                      text: "\"Healthy Lifestyle Isn't Optional—",
                      style: const TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: "It's Foundational\"",
                          style: const TextStyle(color: Color(0xff89AC46)),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "What you eat affects more than just your weight. Healthy food fuels your body, supports your immune system, and keeps your energy levels steady throughout the day. Choosing fresh, whole foods over processed ones helps your body work the way it’s supposed to—from your heart to your brain, and even your mood.",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Nutrical is present to help people on maintaining their healthy lifestyle. Intergrated with Google's Gemini AI technology, Nutrical helps user on tracking the nutritions of what they consume. With a friendly and easy to use interface, user can interact with the provided features easily and maintain their health better.",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Meet Our Team",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff89AC46),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(radius: 80),
                        SizedBox(height: 20),
                        Text(
                          "Rason Yudha Pati N.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(radius: 80),
                        SizedBox(height: 20),
                        Text(
                          "Christian",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(radius: 80),
                        SizedBox(height: 20),
                        Text(
                          "Kevin Juan Carlos",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(radius: 80),
                        SizedBox(height: 20),
                        Text(
                          "Veronica Irene Tanumihadja",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
