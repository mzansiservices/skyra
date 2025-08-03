// screens/education_hub_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/animated_sky_background.dart';
import '../../widgets/animated_card.dart';

class EducationHubScreen extends StatefulWidget {
  const EducationHubScreen({super.key});

  @override
  State<EducationHubScreen> createState() => _EducationHubScreenState();
}

class _EducationHubScreenState extends State<EducationHubScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUserData();
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
    final userProvider = Provider.of<UserProvider>(context);
    final userData = userProvider.userData;

    return AnimatedSkyBackground(
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Complete Your Education',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Take the next step in your educational journey',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 24),

              AnimatedCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.school, color: Colors.purple, size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'Current Education Level',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.purple.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.purple,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              userData?['educationLevel'] ?? 'Not specified',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showEducationLevelDialog(context, userProvider);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Update Education Level'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Available Programs',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              _buildEducationProgram(
                'GED Program',
                'General Educational Development (GED) tests are a group of four subject tests which, when passed, provide certification that the test taker has United States or Canadian high school-level academic skills.',
                '6-12 months',
                Icons.school,
              ),
              _buildEducationProgram(
                'Adult High School Diploma',
                'Complete your high school education through flexible programs designed for adults.',
                '1-2 years',
                Icons.graduation_cap,
              ),
              _buildEducationProgram(
                'Online High School',
                'Complete your high school education entirely online at your own pace.',
                'Flexible',
                Icons.computer,
              ),
              _buildEducationProgram(
                'Vocational Training',
                'Learn practical skills for specific careers through hands-on training programs.',
                '3-18 months',
                Icons.build,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEducationProgram(
    String title,
    String description,
    String duration,
    IconData icon,
  ) {
    return AnimatedCard(
      margin: const EdgeInsets.only(bottom: 16.0),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        duration,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showProgramDetails(title);
                  },
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Learn More'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.withOpacity(0.2),
                    foregroundColor: Colors.purple,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _enrollInProgram(title);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Enroll'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEducationLevelDialog(
    BuildContext context,
    UserProvider userProvider,
  ) {
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
          backgroundColor: Colors.black.withOpacity(0.9),
          title: const Text(
            'Select Education Level',
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: levels.length,
              itemBuilder: (context, index) {
                return RadioListTile<String>(
                  title: Text(
                    levels[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                  value: levels[index],
                  groupValue: selectedLevel,
                  activeColor: Colors.purple,
                  onChanged: (value) {
                    setState(() {
                      selectedLevel = value;
                    });
                    Navigator.pop(context);
                    if (selectedLevel != null) {
                      userProvider.updateUserData({
                        'educationLevel': selectedLevel,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Education level updated to: $selectedLevel',
                          ),
                          backgroundColor: Colors.purple,
                        ),
                      );
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

  void _showProgramDetails(String programName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          title: Text(programName, style: const TextStyle(color: Colors.white)),
          content: Text(
            'Detailed information about $programName will be displayed here. This includes curriculum, requirements, costs, and application process.',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.purple),
              ),
            ),
          ],
        );
      },
    );
  }

  void _enrollInProgram(String programName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Enrollment request sent for $programName'),
        backgroundColor: Colors.purple,
        action: SnackBarAction(
          label: 'View Status',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to enrollment status page
          },
        ),
      ),
    );
  }
}
