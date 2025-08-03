// screens/library_screen.dart
import 'package:flutter/material.dart';
import '../../providers/book_provider.dart';
import '../../widgets/animated_sky_background.dart';
import '../../widgets/animated_card.dart';
import 'book_detail_screen.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookProvider>(context, listen: false).fetchBooks();
    });

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);

    return AnimatedSkyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Library'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _showSearchDialog();
              },
            ),
          ],
        ),
        body: SlideTransition(
          position: _slideAnimation,
          child: bookProvider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.purple),
                )
              : bookProvider.books.isEmpty
              ? _buildEmptyState()
              : _buildBooksGrid(bookProvider),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
          onPressed: () {
            _showAddBookDialog(context);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.library_books,
              size: 64,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your Library is Empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start building your personal library by adding books',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _showAddBookDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Your First Book'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBooksGrid(BookProvider bookProvider) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: bookProvider.books.length,
      itemBuilder: (context, index) {
        final book = bookProvider.books[index];
        return _buildBookCard(book);
      },
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    return AnimatedCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookDetailScreen(book: book)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.purple.withOpacity(0.1),
                border: Border.all(color: Colors.purple.withOpacity(0.3)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: book['coverUrl'] != null && book['coverUrl'].isNotEmpty
                    ? Image.network(
                        book['coverUrl'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildDefaultBookCover(),
                      )
                    : _buildDefaultBookCover(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            book['title'] ?? 'No title',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            book['author'] ?? 'Unknown author',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${((book['progress'] ?? 0.0) * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.purple,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (book['favorite'] == true)
                    const Icon(Icons.favorite, color: Colors.purple, size: 16),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: (book['progress'] ?? 0.0).toDouble(),
                backgroundColor: Colors.grey.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
                borderRadius: BorderRadius.circular(2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultBookCover() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book, size: 48, color: Colors.purple),
          SizedBox(height: 8),
          Text(
            'No Cover',
            style: TextStyle(color: Colors.purple, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    final searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          title: const Text(
            'Search Books',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: searchController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Search by title or author',
              labelStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.purple),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement search functionality
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Searching for: ${searchController.text}'),
                    backgroundColor: Colors.purple,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void _showAddBookDialog(BuildContext context) {
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    final urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          title: const Text(
            'Add New Book',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: authorController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Author',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: urlController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Cover Image URL (Optional)',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.purple),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  Provider.of<BookProvider>(context, listen: false).addBook({
                    'title': titleController.text,
                    'author': authorController.text,
                    'coverUrl': urlController.text,
                    'progress': 0.0,
                    'favorite': false,
                    'addedAt': DateTime.now(),
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added: ${titleController.text}'),
                      backgroundColor: Colors.purple,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
