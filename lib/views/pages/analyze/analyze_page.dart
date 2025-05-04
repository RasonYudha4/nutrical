import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:image_picker/image_picker.dart';
import "package:flutter_gemini/flutter_gemini.dart";

class AnalyzePage extends StatefulWidget {
  const AnalyzePage({super.key});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? _geminiResponse;

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        var geminiResponse = await _analyzeImage(File(photo.path));
        setState(() {
          _image = File(photo.path);
          _geminiResponse = geminiResponse;
        });
      }
    } catch (e) {
      print('Error taking photo: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var geminiResponse = await _analyzeImage(File(image.path));
        log("Gemini response : $geminiResponse");
        setState(() {
          _image = File(image.path);
          _geminiResponse = geminiResponse;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<String> _analyzeImage(File image) async {
    try {
      final gemini = Gemini.instance;
      final bytes = await image.readAsBytes();
      var result = await gemini.prompt(
        parts: [
          Part.bytes(bytes),
          Part.text(
            """Analyze the nutritional value of the food! Response it with this format:
          \n**Food Name**\n\nMain Ingredients : {Ingredients}\n
          Carbohydrates :{Carbohydrates in integer}g\n
          Proteins : {Proteins in integer}g\nFats : {Fats in integer}g\n
          Minerals : Minerals contained\n\n
          Note: Do not add any other texts\n{} is a placeholder, you can delete the {}\nIf the image is not food, response with "It is not food"
          """,
          ),
        ],
        model: "gemini-2.0-flash-exp-image-generation",
      );
      log("Result: ${result.toString()}");
      return result?.output ?? "Error occurred";
    } catch (e) {
      return "Gemini error: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 90),
            Container(
              decoration: BoxDecoration(color: Color(0xFF89AC46)),
              height: 250,
              child:
                  _image == null
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_rounded, size: 80),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Select an Image of Food",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      : Image.file(
                        _image!,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
            ),
            _geminiResponse == null
                ? Padding(
                  padding: EdgeInsets.only(top: 100, left: 30, right: 30),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _takePhoto,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF89AC46),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 90,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.camera_alt_rounded, size: 40),
                                    SizedBox(width: 20),
                                    Text(
                                      "Take an Image",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios_rounded),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      GestureDetector(
                        onTap: _pickImageFromGallery,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF89AC46),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 90,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.image_outlined, size: 40),
                                    SizedBox(width: 20),
                                    Text(
                                      "Upload from Gallery",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios_rounded),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF89AC46),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GptMarkdown(
                        _geminiResponse!,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
