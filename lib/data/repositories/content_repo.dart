import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/content.dart';

class ContentRepo {
  final CollectionReference _contentCollection = FirebaseFirestore.instance
      .collection("Contents");

  Future<List<Content>> fetchContents() async {
    try {
      final QuerySnapshot querySnapshot = await _contentCollection.get();

      final List<Content> contentList =
          querySnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final id = doc.id;
            return Content.fromMap(id, data);
          }).toList();

      return contentList;
    } catch (e) {
      throw Exception("Error fetching contents: $e");
    }
  }
}
