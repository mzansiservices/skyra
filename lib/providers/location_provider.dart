// providers/location_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isSharing = false;
  Position? _currentPosition;
  bool _isLoading = false;

  bool get isSharing => _isSharing;
  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;

  Future<void> toggleLocationSharing() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      if (_isSharing) {
        // Stop sharing
        await _firestore.collection('user_locations').doc(user.uid).delete();
        _isSharing = false;
      } else {
        // Start sharing
        final status = await Permission.location.request();
        if (status.isGranted) {
          final position = await Geolocator.getCurrentPosition();
          _currentPosition = position;
          await _firestore.collection('user_locations').doc(user.uid).set({
            'userId': user.uid,
            'latitude': position.latitude,
            'longitude': position.longitude,
            'timestamp': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          _isSharing = true;

          // Start periodic updates
          Geolocator.getPositionStream().listen((position) async {
            _currentPosition = position;
            await _firestore.collection('user_locations').doc(user.uid).set({
              'latitude': position.latitude,
              'longitude': position.longitude,
              'timestamp': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
            notifyListeners();
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling location sharing: $e');
      }
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> getContactLocation(String contactId) async {
    try {
      final doc =
          await _firestore.collection('user_locations').doc(contactId).get();
      return doc.data();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting contact location: $e');
      }
      return null;
    }
  }
}