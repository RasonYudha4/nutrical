import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import "package:flutter_gemini/flutter_gemini.dart";
import 'dart:convert';
import 'analysis_result.dart';

class AnalyzePage extends StatefulWidget {
  const AnalyzePage({super.key});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String foodName = "";
  Map<String, dynamic> _geminiResponse = {};

  bool containsError(Map<String, dynamic> geminiResponse) {
    return geminiResponse.containsKey("error");
  }

  void notifyError(String error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $error"), duration: Duration(seconds: 2)),
    );
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        var geminiResponse = await _analyzeImage(File(photo.path));
        if (containsError(geminiResponse)) {
          notifyError(geminiResponse["error"]);
          return;
        }
        setState(() {
          _image = File(photo.path);
          _geminiResponse =
              geminiResponse.containsKey("error") ? {} : geminiResponse;
        });
      }
    } catch (e) {
      print('Error taking photo: $e');
    }
  }

  void resetState() {
    setState(() {
      _image = null;
      _geminiResponse = {};
    });
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var geminiResponse = await _analyzeImage(File(image.path));
        if (containsError(geminiResponse)) {
          notifyError(geminiResponse["error"]);
          return;
        }
        setState(() {
          _image = File(image.path);
          _geminiResponse = geminiResponse;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  bool isJSON(String geminiOutput) {
    try {
      jsonDecode(geminiOutput);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> _analyzeImage(File image) async {
    try {
      final gemini = Gemini.instance;
      final bytes = await image.readAsBytes();
      Candidates? result;
      do {
        result = await gemini.prompt(
          parts: [
            Part.bytes(bytes),
            Part.text(
              '''Analyze the nutritional value of the food! Respond ONLY with a raw JSON object in this format:
            {
            "food_name": "Name of the food" (String),
            "main_ingredients": ["Main ingredients of the food"] (Array of string),
            "calories": Amount of calories in kcal (int),
            "carbohydrates": Amount of carbohydrates in grams (int),
            "proteins": Amount of proteins in grams (int),
            "fats": Amount of fats in grams (int),
            "minerals": ["Minerals contained in the food"] (Array of strings)
            "additional_info": Additional information about the food (e.g: Overall this is a healthy food)
            }
            Do not include any explanations, markdown formatting, or code block indicators (e.g., no ```json or backticks). Only respond with the raw JSON.
            You can add bold and italics markdown formatting to the "additional_info" field.
            If it is not a food response with {"error": "Not a food"}
          ''',
            ),
          ],
          generationConfig: GenerationConfig(temperature: 0),
          model: "gemini-2.0-flash-exp-image-generation",
        );
      } while (!isJSON(result?.output ?? '{"error": "Not a food"}'));
      return jsonDecode(result?.output ?? "");
    } catch (e) {
      log("Gemini error: $e");
      return {"error": "Error occurred! Please try again"};
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
            _geminiResponse.isEmpty
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
                : AnalysisResult(
                  geminiResponse: _geminiResponse,
                  onPressedNo: resetState,
                ),
          ],
        ),
      ),
    );
  }
}
