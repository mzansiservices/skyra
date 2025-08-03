// screens/messages_screen.dart
import 'package:flutter/material.dart';
import '/providers/chat_provider.dart';
import '/providers/user_provider.dart';
import 'chat_screen.dart';
import 'package:provider/provider.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).fetchChats();
      Provider.of<UserProvider>(context, listen: false).getTrustedContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body:
          chatProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : chatProvider.chats.isEmpty
              ? const Center(child: Text('No messages yet'))
              : ListView.builder(
                itemCount: chatProvider.chats.length,
                itemBuilder: (context, index) {
                  final chat = chatProvider.chats[index];
                  // Find the other participant's name
                  final otherParticipantId = (chat['participants'] as List)
                      .firstWhere((id) => id != userProvider.userData?['id']);
                  final contact = userProvider.trustedContacts.firstWhere(
                    (c) => c['id'] == otherParticipantId,
                    orElse: () => {'name': 'Unknown'},
                  );

                  return ListTile(
                    title: Text(contact['name'] ?? 'Unknown'),
                    subtitle: Text(chat['lastMessage'] ?? ''),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ChatScreen(
                                chatId: chat['id'],
                                contactName: contact['name'] ?? 'Unknown',
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showNewChatDialog(context, userProvider.trustedContacts);
        },
      ),
    );
  }

  void _showNewChatDialog(
    BuildContext context,
    List<Map<String, dynamic>> contacts,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Message'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(contacts[index]['name'] ?? 'No name'),
                  onTap: () async {
                    Navigator.pop(context);
                    final chatId = await Provider.of<ChatProvider>(
                      context,
                      listen: false,
                    ).createChat(contacts[index]['id']);
                    if (chatId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ChatScreen(
                                chatId: chatId,
                                contactName:
                                    contacts[index]['name'] ?? 'Unknown',
                              ),
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
}
