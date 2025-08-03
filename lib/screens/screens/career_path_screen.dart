// screens/career_path_screen.dart
import 'package:flutter/material.dart';
import '../../providers/user_provider.dart';
import '../../widgets/animated_sky_background.dart';
import '../../widgets/animated_card.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CareerPathScreen extends StatefulWidget {
  const CareerPathScreen({super.key});

  @override
  State<CareerPathScreen> createState() => _CareerPathScreenState();
}

class _CareerPathScreenState extends State<CareerPathScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _courses = [
    {
      'title': 'Introduction to Programming',
      'platform': 'Coursera',
      'free': true,
      'certificate': true,
      'url': 'https://www.coursera.org/learn/intro-programming',
      'image': 'assets/images/programming.jpg',
      'icon': Icons.code,
    },
    {
      'title': 'Digital Marketing Fundamentals',
      'platform': 'Google Digital Garage',
      'free': true,
      'certificate': true,
      'url': 'https://learndigital.withgoogle.com/digitalgarage',
      'image': 'assets/images/marketing.jpg',
      'icon': Icons.trending_up,
    },
    {
      'title': 'Business Foundations',
      'platform': 'edX',
      'free': true,
      'certificate': true,
      'url': 'https://www.edx.org/course/business-foundations',
      'image': 'assets/images/business.jpg',
      'icon': Icons.business,
    },
    {
      'title': 'Graphic Design Basics',
      'platform': 'Udemy',
      'free': false,
      'certificate': true,
      'url': 'https://www.udemy.com/course/graphic-design-fundamentals/',
      'image': 'assets/images/design.jpg',
      'icon': Icons.palette,
    },
  ];

  final List<Map<String, dynamic>> _careerPaths = [
    {
      'title': 'Information Technology',
      'description':
          'Careers in software development, cybersecurity, network administration, and more.',
      'skills': ['Programming', 'Problem Solving', 'Technical Knowledge'],
      'icon': Icons.computer,
      'color': Colors.blue,
    },
    {
      'title': 'Healthcare',
      'description':
          'Careers in nursing, medical assisting, pharmacy tech, and other health services.',
      'skills': ['Compassion', 'Attention to Detail', 'Communication'],
      'icon': Icons.medical_services,
      'color': Colors.red,
    },
    {
      'title': 'Skilled Trades',
      'description':
          'Careers in electrician, plumbing, HVAC, welding, and other hands-on fields.',
      'skills': ['Manual Dexterity', 'Problem Solving', 'Physical Stamina'],
      'icon': Icons.build,
      'color': Colors.orange,
    },
    {
      'title': 'Business Administration',
      'description':
          'Careers in office management, customer service, bookkeeping, and more.',
      'skills': ['Organization', 'Communication', 'Computer Skills'],
      'icon': Icons.business_center,
      'color': Colors.green,
    },
  ];

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
    final userProvider = Provider.of<UserProvider>(context);
    final educationLevel =
        userProvider.userData?['educationLevel'] ?? 'Not specified';

    return AnimatedSkyBackground(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Career Path'),
            bottom: TabBar(
              tabs: const [
                Tab(text: 'Courses'),
                Tab(text: 'Careers'),
                Tab(text: 'Resources'),
              ],
              indicatorColor: Colors.purple,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
            ),
          ),
          body: SlideTransition(
            position: _slideAnimation,
            child: TabBarView(
              children: [
                _buildCoursesTab(),
                _buildCareersTab(educationLevel),
                _buildResourcesTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoursesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _courses.length,
      itemBuilder: (context, index) {
        final course = _courses[index];
        return AnimatedCard(
          margin: const EdgeInsets.only(bottom: 16.0),
          onTap: () => _launchURL(course['url']),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(course['icon'], color: Colors.purple, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course['platform'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (course['free'])
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Free',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (course['certificate']) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Certificate',
                              style: TextStyle(
                                color: Colors.purple,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.launch, color: Colors.purple, size: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCareersTab(String educationLevel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.purple, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Your Education Level',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.purple.withOpacity(0.3)),
                  ),
                  child: Text(
                    educationLevel,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Recommended Career Paths',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ..._careerPaths.map((career) => _buildCareerCard(career)),
        ],
      ),
    );
  }

  Widget _buildCareerCard(Map<String, dynamic> career) {
    return AnimatedCard(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: career['color'].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(career['icon'], color: career['color'], size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  career['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            career['description'],
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Key Skills:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: career['skills'].map<Widget>((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.purple.withOpacity(0.3)),
                ),
                child: Text(
                  skill,
                  style: const TextStyle(
                    color: Colors.purple,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showCareerDetails(career),
              icon: const Icon(Icons.explore),
              label: const Text('Explore This Path'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildResourceCard(
          'Career Assessment',
          'Take a free career assessment to discover careers that match your interests and skills.',
          Icons.psychology,
          'https://www.mynextmove.org/explore/ip',
        ),
        _buildResourceCard(
          'Resume Builder',
          'Create a professional resume for free with easy-to-use templates.',
          Icons.description,
          'https://www.resume.com/',
        ),
        _buildResourceCard(
          'Job Search',
          'Search for local job openings and apply online.',
          Icons.search,
          'https://www.indeed.com/',
        ),
        _buildResourceCard(
          'Interview Tips',
          'Learn how to prepare for job interviews and answer common questions.',
          Icons.question_answer,
          'https://www.thebalancecareers.com/job-interview-questions-and-answers-2061204',
        ),
      ],
    );
  }

  Widget _buildResourceCard(
    String title,
    String description,
    IconData icon,
    String url,
  ) {
    return AnimatedCard(
      margin: const EdgeInsets.only(bottom: 16.0),
      onTap: () => _launchURL(url),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.purple, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Icon(Icons.launch, color: Colors.purple, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showCareerDetails(Map<String, dynamic> career) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          title: Text(
            career['title'],
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                career['description'],
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Required Skills:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...career['skills'].map<Widget>(
                (skill) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.purple, size: 16),
                      const SizedBox(width: 8),
                      Text(skill, style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.purple),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _launchURL('https://www.indeed.com/jobs?q=${career['title']}');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Search Jobs'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $url'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
