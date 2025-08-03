// screens/book_detail_screen.dart
import 'package:flutter/material.dart';
import '../../providers/book_provider.dart';
import 'package:provider/provider.dart';

class BookDetailScreen extends StatefulWidget {
  final Map<String, dynamic> book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late double _progressValue;

  @override
  void initState() {
    super.initState();
    _progressValue = (widget.book['progress'] ?? 0.0).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book['title'] ?? 'Book Details'),
        actions: [
          IconButton(
            icon: Icon(
              widget.book['favorite'] == true
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: widget.book['favorite'] == true ? Colors.red : null,
            ),
            onPressed: () {
              bookProvider.toggleFavorite(
                widget.book['id'],
                !(widget.book['favorite'] == true),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.book['coverUrl'] ?? '',
                height: 200,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.book, size: 200),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.book['title'] ?? 'No title',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'by ${widget.book['author'] ?? 'Unknown author'}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              'Reading Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _progressValue,
              onChanged: (value) {
                setState(() {
                  _progressValue = value;
                });
              },
              onChangeEnd: (value) {
                bookProvider.updateBookProgress(widget.book['id'], value);
              },
            ),
            Center(
              child: Text(
                '${(_progressValue * 100).toStringAsFixed(0)}% complete',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implement reading functionality
                },
                child: const Text('Continue Reading'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Notes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Add your notes about this book...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}