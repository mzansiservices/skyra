// screens/career_path_screen.dart
import 'package:flutter/material.dart';
import '../../providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CareerPathScreen extends StatefulWidget {
  const CareerPathScreen({super.key});

  @override
  State<CareerPathScreen> createState() => _CareerPathScreenState();
}

class _CareerPathScreenState extends State<CareerPathScreen> {
  final List<Map<String, dynamic>> _courses = [
    {
      'title': 'Introduction to Programming',
      'platform': 'Coursera',
      'free': true,
      'certificate': true,
      'url': 'https://www.coursera.org/learn/intro-programming',
      'image': 'assets/images/programming.jpg',
    },
    {
      'title': 'Digital Marketing Fundamentals',
      'platform': 'Google Digital Garage',
      'free': true,
      'certificate': true,
      'url': 'https://learndigital.withgoogle.com/digitalgarage',
      'image': 'assets/images/marketing.jpg',
    },
    {
      'title': 'Business Foundations',
      'platform': 'edX',
      'free': true,
      'certificate': true,
      'url': 'https://www.edx.org/course/business-foundations',
      'image': 'assets/images/business.jpg',
    },
    {
      'title': 'Graphic Design Basics',
      'platform': 'Udemy',
      'free': false,
      'certificate': true,
      'url': 'https://www.udemy.com/course/graphic-design-fundamentals/',
      'image': 'assets/images/design.jpg',
    },
  ];

  final List<Map<String, dynamic>> _careerPaths = [
    {
      'title': 'Information Technology',
      'description':
          'Careers in software development, cybersecurity, network administration, and more.',
      'skills': ['Programming', 'Problem Solving', 'Technical Knowledge'],
    },
    {
      'title': 'Healthcare',
      'description':
          'Careers in nursing, medical assisting, pharmacy tech, and other health services.',
      'skills': ['Compassion', 'Attention to Detail', 'Communication'],
    },
    {
      'title': 'Skilled Trades',
      'description':
          'Careers in electrician, plumbing, HVAC, welding, and other hands-on fields.',
      'skills': ['Manual Dexterity', 'Problem Solving', 'Physical Stamina'],
    },
    {
      'title': 'Business Administration',
      'description':
          'Careers in office management, customer service, bookkeeping, and more.',
      'skills': ['Organization', 'Communication', 'Computer Skills'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final educationLevel = userProvider.userData?['educationLevel'] ?? 'Not specified';

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Career Path'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Courses'),
              Tab(text: 'Careers'),
              Tab(text: 'Resources'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCoursesTab(),
            _buildCareersTab(educationLevel),
            _buildResourcesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _courses.length,
      itemBuilder: (context, index) {
        final course = _courses[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Image.asset(
              course['image'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.school, size: 50),
            ),
            title: Text(course['title']),
            subtitle: Text(
                '${course['platform']} - ${course['free'] ? 'Free' : 'Paid'}'),
            trailing: const Icon(Icons.launch),
            onTap: () => _launchURL(course['url']),
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
          Text(
            'Based on your education level: $educationLevel',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ..._careerPaths.map((career) => Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        career['title'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(career['description']),
                      const SizedBox(height: 8),
                      const Text(
                        'Key Skills:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...career['skills']
                          .map<Widget>((skill) => Text('- $skill'))
                          .toList(),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Show career details
                        },
                        child: const Text('Explore This Path'),
                      ),
                    ],
                  ),
                ),
              )),
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
          'https://www.mynextmove.org/explore/ip',
        ),
        _buildResourceCard(
          'Resume Builder',
          'Create a professional resume for free with easy-to-use templates.',
          'https://www.resume.com/',
        ),
        _buildResourceCard(
          'Job Search',
          'Search for local job openings and apply online.',
          'https://www.indeed.com/',
        ),
        _buildResourceCard(
          'Interview Tips',
          'Learn how to prepare for job interviews and answer common questions.',
          'https://www.thebalancecareers.com/job-interview-questions-and-answers-2061204',
        ),
      ],
    );
  }

  Widget _buildResourceCard(String title, String description, String url) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _launchURL(url),
              child: const Text('Visit Resource'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
}