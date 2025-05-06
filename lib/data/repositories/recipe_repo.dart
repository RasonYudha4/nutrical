import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/recipe.dart';

class RecipeRepo {
  final CollectionReference _recipeCollection = FirebaseFirestore.instance
      .collection("Recipes");

  Future<Recipe> getRecipeById(String id) async {
    try {
      DocumentSnapshot<Object?> snapshot =
          await _recipeCollection.doc(id).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return Recipe.fromMap(id, data);
      } else {
        throw Exception("Group not found");
      }
    } catch (e) {
      throw Exception("Error fetching group: $e");
    }
  }
}
