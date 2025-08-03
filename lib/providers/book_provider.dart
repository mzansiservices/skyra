// providers/book_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class BookProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _books = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get books => _books;
  bool get isLoading => _isLoading;

  Future<void> fetchBooks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('books')
          .get();

      _books = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching books: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBook(Map<String, dynamic> bookData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('books')
          .add(bookData);
      await fetchBooks();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding book: $e');
      }
      rethrow;
    }
  }

  Future<void> updateBookProgress(String bookId, double progress) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('books')
          .doc(bookId)
          .update({
        'progress': progress,
        'lastRead': FieldValue.serverTimestamp(),
      });
      await fetchBooks();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating book progress: $e');
      }
    }
  }

  Future<void> toggleFavorite(String bookId, bool isFavorite) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('books')
          .doc(bookId)
          .update({'favorite': isFavorite});
      await fetchBooks();
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling favorite: $e');
      }
    }
  }

  Future<void> deleteBook(String bookId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('books')
          .doc(bookId)
          .delete();
      await fetchBooks();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting book: $e');
      }
    }
  }
}