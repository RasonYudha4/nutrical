import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/consumption.dart';

class ConsumptionRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Consumption>> getInitialConsumptions(
    String userId,
    String date,
  ) async {
    try {
      final snapshot =
          await _firestore
              .collection("Consumptions")
              .doc(userId)
              .collection(date)
              .get();

      return snapshot.docs
          .map((doc) => Consumption.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception("Failed to load consumptions: ${e.toString()}");
    }
  }

  Stream<List<Consumption>> getStreamConsumptions(
    String userId,
    String dateKey,
  ) {
    return FirebaseFirestore.instance
        .collection("Consumptions")
        .doc(userId)
        .collection(dateKey)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Consumption.fromMap(doc.id, doc.data()))
                  .toList(),
        );
  }

  Future<void> saveConsumption(
    String userId,
    DateTime currentDate,
    Consumption consumption,
  ) async {
    String date = currentDate.toString().split(" ")[0];

    try {
      await _firestore
          .collection("Consumptions")
          .doc(userId)
          .collection(date)
          .add(consumption.toMap());
    } catch (e) {
      throw Exception("Failed to add consumption: ${e.toString()}");
    }
  }
}
