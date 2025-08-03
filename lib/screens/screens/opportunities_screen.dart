// screens/opportunities_screen.dart
import 'package:flutter/material.dart';
import '/providers/opportunity_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OpportunitiesScreen extends StatefulWidget {
  const OpportunitiesScreen({super.key});

  @override
  State<OpportunitiesScreen> createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends State<OpportunitiesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OpportunityProvider>(context, listen: false)
          .fetchOpportunities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final opportunityProvider = Provider.of<OpportunityProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunities'),
      ),
      body: opportunityProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : opportunityProvider.opportunities.isEmpty
              ? const Center(child: Text('No opportunities available'))
              : ListView.builder(
                  itemCount: opportunityProvider.opportunities.length,
                  itemBuilder: (context, index) {
                    final opp = opportunityProvider.opportunities[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ExpansionTile(
                        title: Text(opp['title'] ?? 'No title'),
                        subtitle: Text(
                            '${opp['type'] ?? 'Opportunity'} - Deadline: ${opp['deadline'] ?? 'None'}'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(opp['description'] ?? 'No description'),
                                const SizedBox(height: 8),
                                if (opp['url'] != null)
                                  ElevatedButton(
                                    child: const Text('Apply Now'),
                                    onPressed: () =>
                                        _launchURL(opp['url']),
                                  ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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