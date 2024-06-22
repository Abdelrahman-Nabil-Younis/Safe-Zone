import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminNotificationPage extends StatefulWidget {
  @override
  _AdminNotificationPageState createState() => _AdminNotificationPageState();
}

class _AdminNotificationPageState extends State<AdminNotificationPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String? _selectedUserId;
  String? _selectedUserName;

  void _sendNotification(String userId, String title, String message) async {
    await _firestore.collection('notifications').add({
      'userId': userId,
      'title': title,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification sent to $_selectedUserName')),
    );

    // Clear the text fields and selected user
    setState(() {
      _selectedUserId = null;
      _selectedUserName = null;
      _titleController.clear();
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Notifications'),
        backgroundColor: Color(0xFFF86C1D),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('users').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final users = snapshot.data!.docs;

                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select User',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedUserId,
                      items: users.map((user) {
                        return DropdownMenuItem<String>(
                          value: user.id,
                          child: Text(
                              '${user['firstName']} ${user['secondName']}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedUserId = value;
                          _selectedUserName = users.firstWhere(
                                  (user) => user.id == value)['firstName'] +
                              ' ' +
                              users.firstWhere(
                                  (user) => user.id == value)['secondName'];
                        });
                      },
                    );
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: 'Message',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedUserId != null &&
                          _titleController.text.isNotEmpty &&
                          _messageController.text.isNotEmpty) {
                        _sendNotification(
                          _selectedUserId!,
                          _titleController.text,
                          _messageController.text,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all fields')),
                        );
                      }
                    },
                    child: Text('Send Notification'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFFF86C1D),
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 30.0),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
