// screens/safety_screen.dart
import 'package:flutter/material.dart';
import '/providers/location_provider.dart';
import '/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SafetyScreen extends StatefulWidget {
  const SafetyScreen({super.key});

  @override
  State<SafetyScreen> createState() => _SafetyScreenState();
}

class _SafetyScreenState extends State<SafetyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).getTrustedContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Live Location Sharing',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: Text(
                          locationProvider.isSharing ? 'Sharing On' : 'Sharing Off'),
                      value: locationProvider.isSharing,
                      onChanged: locationProvider.isLoading
                          ? null
                          : (value) => locationProvider.toggleLocationSharing(),
                    ),
                    if (locationProvider.currentPosition != null &&
                        locationProvider.isSharing)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Last updated: ${locationProvider.currentPosition!.latitude.toStringAsFixed(4)}, ${locationProvider.currentPosition!.longitude.toStringAsFixed(4)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Trusted Contacts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...userProvider.trustedContacts.map((contact) => Card(
                  child: ListTile(
                    title: Text(contact['name'] ?? 'No name'),
                    subtitle: Text(contact['phone'] ?? 'No phone'),
                    trailing: IconButton(
                      icon: const Icon(Icons.location_on),
                      onPressed: () {
                        // View contact's location if they're sharing
                      },
                    ),
                  ),
                )),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Add Trusted Contact'),
              onPressed: () {
                _showAddContactDialog(context);
              },
            ),
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency Contacts',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Local Police: 911'),
                    Text('Domestic Violence Hotline: 1-800-799-7233'),
                    Text('Suicide Prevention: 1-800-273-8255'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Trusted Contact'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    (phoneController.text.isNotEmpty ||
                        emailController.text.isNotEmpty)) {
                  Provider.of<UserProvider>(context, listen: false).addTrustedContact({
                    'name': nameController.text,
                    'phone': phoneController.text,
                    'email': emailController.text,
                    'addedAt': DateTime.now(),
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}