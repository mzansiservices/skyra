// providers/opportunity_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class OpportunityProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _opportunities = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get opportunities => _opportunities;
  bool get isLoading => _isLoading;

  Future<void> fetchOpportunities() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('opportunities')
          .orderBy('deadline')
          .get();

      _opportunities = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching opportunities: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addOpportunity(Map<String, dynamic> data) async {
    try {
      await _firestore.collection('opportunities').add(data);
      await fetchOpportunities();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding opportunity: $e');
      }
      rethrow;
    }
  }
}