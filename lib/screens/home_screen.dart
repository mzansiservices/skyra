// screens/home_screen.dart
import 'package:flutter/material.dart';
import '../widgets/animated_sky_background.dart';
import '../widgets/animated_card.dart';
import 'screens/career_path_screen.dart';
import 'screens/education_hub_screen.dart';
import 'screens/goals_notes_screen.dart';
import 'screens/library_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/opportunities_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/safety_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const EducationHubScreen(),
    const CareerPathScreen(),
    const LibraryScreen(),
    const GoalsNotesScreen(),
    const SafetyScreen(),
    const OpportunitiesScreen(),
    const MessagesScreen(),
  ];

  final List<String> _screenTitles = [
    'Dashboard',
    'Education Hub',
    'Career Path',
    'Library',
    'Goals & Notes',
    'Safety Resources',
    'Opportunities',
    'Messages',
  ];

  final List<IconData> _screenIcons = [
    Icons.home,
    Icons.school,
    Icons.work,
    Icons.book,
    Icons.note,
    Icons.security,
    Icons.money,
    Icons.message,
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _navigateToScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
    _fadeController.reset();
    _fadeController.forward();
    Navigator.pop(context); // Close drawer
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSkyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(_screenTitles[_currentIndex]),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        drawer: _buildDrawer(),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: _screens[_currentIndex],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.black.withOpacity(0.9),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purple.withOpacity(0.8),
                  Colors.purple.withOpacity(0.4),
                ],
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Life Improvement App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Transform Your Life',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _screens.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    _screenIcons[index],
                    color: _currentIndex == index ? Colors.purple : Colors.white,
                  ),
                  title: Text(
                    _screenTitles[index],
                    style: TextStyle(
                      color: _currentIndex == index ? Colors.purple : Colors.white,
                      fontWeight: _currentIndex == index ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: _currentIndex == index,
                  selectedTileColor: Colors.purple.withOpacity(0.1),
                  onTap: () => _navigateToScreen(index),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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
    return SlideTransition(
      position: _slideAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to Your Journey',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Transform your life with our comprehensive tools and resources',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 32),

            // Quick Actions Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildQuickActionCard(
                  'Education Hub',
                  Icons.school,
                  Colors.purple,
                  () => _navigateToScreen(context, 1),
                ),
                _buildQuickActionCard(
                  'Career Path',
                  Icons.work,
                  Colors.purple,
                  () => _navigateToScreen(context, 2),
                ),
                _buildQuickActionCard(
                  'Library',
                  Icons.book,
                  Colors.purple,
                  () => _navigateToScreen(context, 3),
                ),
                _buildQuickActionCard(
                  'Goals & Notes',
                  Icons.note,
                  Colors.purple,
                  () => _navigateToScreen(context, 4),
                ),
                _buildQuickActionCard(
                  'Safety Resources',
                  Icons.security,
                  Colors.purple,
                  () => _navigateToScreen(context, 5),
                ),
                _buildQuickActionCard(
                  'Opportunities',
                  Icons.money,
                  Colors.purple,
                  () => _navigateToScreen(context, 6),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Recent Activity Section
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            AnimatedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.trending_up, color: Colors.purple, size: 24),
                      const SizedBox(width: 8),
                      const Text(
                        'Your Progress',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildProgressItem('Education Goals', 0.7),
                  _buildProgressItem('Career Development', 0.5),
                  _buildProgressItem('Safety Knowledge', 0.8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return AnimatedCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String title, double progress) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  void _navigateToScreen(BuildContext context, int index) {
    // Find the HomeScreen and update its current index
    final homeScreenState = context.findAncestorStateOfType<_HomeScreenState>();
    if (homeScreenState != null) {
      homeScreenState._navigateToScreen(index);
    }
  }
}
