// screens/goals_notes_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/goal_provider.dart';
import '../../widgets/animated_sky_background.dart';
import '../../widgets/animated_card.dart';

class GoalsNotesScreen extends StatefulWidget {
  const GoalsNotesScreen({super.key});

  @override
  State<GoalsNotesScreen> createState() => _GoalsNotesScreenState();
}

class _GoalsNotesScreenState extends State<GoalsNotesScreen>
    with TickerProviderStateMixin {
  final TextEditingController _goalController = TextEditingController();
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GoalProvider>(context, listen: false).fetchGoals();
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
    final goalProvider = Provider.of<GoalProvider>(context);

    return AnimatedSkyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Goals & Notes')),
        body: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              _buildAddGoalSection(goalProvider),
              Expanded(
                child: goalProvider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.purple),
                      )
                    : goalProvider.goals.isEmpty
                    ? _buildEmptyState()
                    : _buildGoalsList(goalProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddGoalSection(GoalProvider goalProvider) {
    return AnimatedCard(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.add_task, color: Colors.purple, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Add New Goal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _goalController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'What do you want to achieve?',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.purple.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.purple),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.purple.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    if (_goalController.text.trim().isNotEmpty) {
                      goalProvider.addGoal(_goalController.text.trim());
                      _goalController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Goal added successfully!'),
                          backgroundColor: Colors.purple,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
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
            child: const Icon(Icons.flag, size: 64, color: Colors.purple),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Goals Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start by adding your first goal to track your progress',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsList(GoalProvider goalProvider) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: goalProvider.goals.length,
      itemBuilder: (context, index) {
        final goal = goalProvider.goals[index];
        return _buildGoalCard(goal, goalProvider);
      },
    );
  }

  Widget _buildGoalCard(Map<String, dynamic> goal, GoalProvider goalProvider) {
    return AnimatedCard(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ExpansionTile(
        leading: Container(
          decoration: BoxDecoration(
            color: goal['completed'] == true
                ? Colors.green.withOpacity(0.2)
                : Colors.purple.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Checkbox(
            value: goal['completed'] == true,
            activeColor: goal['completed'] == true
                ? Colors.green
                : Colors.purple,
            onChanged: (value) {
              goalProvider.toggleGoalCompletion(goal['id'], value ?? false);
            },
          ),
        ),
        title: Text(
          goal['text'] ?? 'No text',
          style: TextStyle(
            color: Colors.white,
            decoration: goal['completed'] == true
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            decorationColor: Colors.green,
          ),
        ),
        iconColor: Colors.purple,
        collapsedIconColor: Colors.purple,
        children: [
          if ((goal['suggestions'] as List).isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.purple,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Suggestions:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...(goal['suggestions'] as List)
                      .map<Widget>(
                        (suggestion) => Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            bottom: 4.0,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_right,
                                color: Colors.purple,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  suggestion,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _generateSuggestion(context, goal['id']),
                    icon: const Icon(Icons.lightbulb_outline),
                    label: const Text('Get Suggestion'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.withOpacity(0.2),
                      foregroundColor: Colors.purple,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _showDeleteConfirmation(context, goal, goalProvider),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.2),
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Map<String, dynamic> goal,
    GoalProvider goalProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          title: const Text(
            'Delete Goal',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete "${goal['text']}"?',
            style: const TextStyle(color: Colors.white),
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
                goalProvider.deleteGoal(goal['id']);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Goal deleted'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _generateSuggestion(BuildContext context, String goalId) {
    // In a real app, you would call an AI API here
    // For demo purposes, we'll use a simple list of suggestions
    final suggestions = [
      'Break this goal into smaller steps',
      'Set a specific deadline',
      'Research resources to help achieve this',
      'Find an accountability partner',
      'Track your progress daily',
      'Create a detailed action plan',
      'Set up reminders and notifications',
      'Celebrate small wins along the way',
    ];

    final randomSuggestion =
        suggestions[(DateTime.now().millisecond % suggestions.length)];

    Provider.of<GoalProvider>(
      context,
      listen: false,
    ).addSuggestion(goalId, randomSuggestion);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Suggestion added: $randomSuggestion'),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
