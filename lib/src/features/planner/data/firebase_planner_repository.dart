import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/planned_item.dart';
import '../domain/planner_repository.dart';
import 'planned_item_dto.dart';

/// Firebase implementation of PlannerRepository.
class FirebasePlannerRepository implements PlannerRepository {
  final FirebaseFirestore _firestore;
  final String _userId;

  FirebasePlannerRepository({
    required String userId,
    FirebaseFirestore? firestore,
  })  : _userId = userId,
        _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _plansCollection =>
      _firestore.collection('users').doc(_userId).collection('plans');

  @override
  Stream<List<PlannedItem>> getPlans() {
    return _plansCollection
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PlannedItemDto.fromFirestore(doc).toEntity())
            .toList());
  }

  @override
  Future<PlannedItem?> getPlan(String id) async {
    final doc = await _plansCollection.doc(id).get();
    if (!doc.exists) return null;
    return PlannedItemDto.fromFirestore(doc).toEntity();
  }

  @override
  Future<void> upsertPlan(PlannedItem plan) async {
    final dto = PlannedItemDto.fromEntity(plan);
    if (plan.id.isEmpty) {
      await _plansCollection.add(dto.toFirestore());
    } else {
      await _plansCollection.doc(plan.id).set(dto.toFirestore());
    }
  }

  @override
  Future<void> deletePlan(String id) async {
    await _plansCollection.doc(id).delete();
  }

  @override
  Future<void> toggleCompletion(String id, bool isCompleted) async {
    await _plansCollection.doc(id).update({'isCompleted': isCompleted});
  }

  @override
  Future<void> toggleInstanceCompletion(
      String id, DateTime date, bool isCompleted) async {
    final doc = await _plansCollection.doc(id).get();
    if (!doc.exists) return;

    final plan = PlannedItemDto.fromFirestore(doc).toEntity();
    final normalizedDate = DateTime(date.year, date.month, date.day);

    List<DateTime> updatedDates = List.from(plan.completedDates);
    if (isCompleted) {
      if (!updatedDates.any((d) =>
          DateTime(d.year, d.month, d.day).isAtSameMomentAs(normalizedDate))) {
        updatedDates.add(normalizedDate);
      }
    } else {
      updatedDates.removeWhere((d) =>
          DateTime(d.year, d.month, d.day).isAtSameMomentAs(normalizedDate));
    }

    await _plansCollection.doc(id).update({
      'completedDates': updatedDates.map((d) => Timestamp.fromDate(d)).toList(),
    });
  }
}
