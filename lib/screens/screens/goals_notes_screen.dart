// screens/goals_notes_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/goal_provider.dart';

class GoalsNotesScreen extends StatefulWidget {
  const GoalsNotesScreen({super.key});

  @override
  State<GoalsNotesScreen> createState() => _GoalsNotesScreenState();
}

class _GoalsNotesScreenState extends State<GoalsNotesScreen> {
  final TextEditingController _goalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GoalProvider>(context, listen: false).fetchGoals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals & Notes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _goalController,
                    decoration: const InputDecoration(
                      hintText: 'Add a new goal...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_goalController.text.trim().isNotEmpty) {
                      goalProvider.addGoal(_goalController.text.trim());
                      _goalController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: goalProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : goalProvider.goals.isEmpty
                    ? const Center(child: Text('No goals added yet'))
                    : ListView.builder(
                        itemCount: goalProvider.goals.length,
                        itemBuilder: (context, index) {
                          final goal = goalProvider.goals[index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ExpansionTile(
                              leading: Checkbox(
                                value: goal['completed'] == true,
                                onChanged: (value) {
                                  goalProvider.toggleGoalCompletion(
                                      goal['id'], value ?? false);
                                },
                              ),
                              title: Text(
                                goal['text'] ?? 'No text',
                                style: TextStyle(
                                  decoration: goal['completed'] == true
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              children: [
                                if ((goal['suggestions'] as List).isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Suggestions:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        ...(goal['suggestions'] as List)
                                            .map<Widget>((suggestion) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text('- $suggestion'),
                                                ))
                                            .toList(),
                                      ],
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.lightbulb_outline),
                                        onPressed: () {
                                          _generateSuggestion(context, goal['id']);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          goalProvider.deleteGoal(goal['id']);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
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
    ];

    final randomSuggestion =
        suggestions[(DateTime.now().millisecond % suggestions.length)];

    Provider.of<GoalProvider>(context, listen: false)
        .addSuggestion(goalId, randomSuggestion);
  }
}