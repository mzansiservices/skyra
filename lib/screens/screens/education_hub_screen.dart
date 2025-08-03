// screens/education_hub_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class EducationHubScreen extends StatefulWidget {
  const EducationHubScreen({super.key});

  @override
  State<EducationHubScreen> createState() => _EducationHubScreenState();
}

class _EducationHubScreenState extends State<EducationHubScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userData = userProvider.userData;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Complete Your Education',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Education Level',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userData?['educationLevel'] ?? 'Not specified',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _showEducationLevelDialog(context, userProvider);
                      },
                      child: const Text('Update Education Level'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Available Programs',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildEducationProgram(
              'GED Program',
              'General Educational Development (GED) tests are a group of four subject tests which, when passed, provide certification that the test taker has United States or Canadian high school-level academic skills.',
              '6-12 months',
            ),
            _buildEducationProgram(
              'Adult High School Diploma',
              'Complete your high school education through flexible programs designed for adults.',
              '1-2 years',
            ),
            _buildEducationProgram(
              'Online High School',
              'Complete your high school education entirely online at your own pace.',
              'Flexible',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationProgram(String title, String description, String duration) {
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
            Text(
              'Duration: $duration',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Implement program enrollment
              },
              child: const Text('Learn More'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEducationLevelDialog(BuildContext context, UserProvider userProvider) {
    final levels = [
      'Less than High School',
      'High School Incomplete',
      'GED',
      'High School Diploma',
      'Some College',
      'Associate Degree',
      'Bachelor\'s Degree',
      'Graduate Degree',
    ];

    String? selectedLevel = userProvider.userData?['educationLevel'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Education Level'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: levels.length,
              itemBuilder: (context, index) {
                return RadioListTile<String>(
                  title: Text(levels[index]),
                  value: levels[index],
                  groupValue: selectedLevel,
                  onChanged: (value) {
                    setState(() {
                      selectedLevel = value;
                    });
                    Navigator.pop(context);
                    if (selectedLevel != null) {
                      userProvider.updateUserData({
                        'educationLevel': selectedLevel,
                      });
                    }
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}