import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/recipe.dart';
import '../models/recipe_info.dart';

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

  Future<List<RecipeInfo>> getAllRecipeInfo() async {
    try {
      final QuerySnapshot querySnapshot = await _recipeCollection.get();

      final List<RecipeInfo> recipeList =
          querySnapshot.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final name = data['name'] as String? ?? '';
                final uid = doc.id;

                if (name.isNotEmpty) {
                  return RecipeInfo(uid: uid, name: name);
                } else {
                  return null;
                }
              })
              .whereType<RecipeInfo>()
              .toList();

      return recipeList.isEmpty ? [] : recipeList;
    } catch (e) {
      throw Exception("Error fetching recipe data: $e");
    }
  }
}
