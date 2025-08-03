// providers/goal_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class GoalProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _goals = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get goals => _goals;
  bool get isLoading => _isLoading;

  Future<void> fetchGoals() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('goals')
          .orderBy('createdAt', descending: true)
          .get();

      _goals = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching goals: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addGoal(String text) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).collection('goals').add({
        'text': text,
        'completed': false,
        'createdAt': FieldValue.serverTimestamp(),
        'suggestions': [],
      });
      await fetchGoals();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding goal: $e');
      }
      rethrow;
    }
  }

  Future<void> toggleGoalCompletion(String goalId, bool completed) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('goals')
          .doc(goalId)
          .update({'completed': completed});
      await fetchGoals();
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling goal completion: $e');
      }
    }
  }

  Future<void> addSuggestion(String goalId, String suggestion) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('goals')
          .doc(goalId)
          .update({
        'suggestions': FieldValue.arrayUnion([suggestion])
      });
      await fetchGoals();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding suggestion: $e');
      }
    }
  }

  Future<void> deleteGoal(String goalId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('goals')
          .doc(goalId)
          .delete();
      await fetchGoals();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting goal: $e');
      }
    }
  }
}