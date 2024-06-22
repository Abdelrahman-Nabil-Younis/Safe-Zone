import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminReceivedNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Notifications',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFF76B1C), // Light orange color
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('adminNotifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!.docs;

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text('No Notifications Found.'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index];
              return FutureBuilder<String>(
                future: _getFullName(notification['userId']),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return _buildLoadingCard();
                  }
                  return _buildNotificationCard(
                      context, notification, userSnapshot.data!);
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<String> _getFullName(String userId) async {
    var userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    var userData = userSnapshot.data();
    return '${userData?['firstName']} ${userData?['secondName']}';
  }

  Widget _buildLoadingCard() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Text(
          'New Notification',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Loading...'),
      ),
    );
  }

  Widget _buildNotificationCard(
      BuildContext context, DocumentSnapshot notification, String fullName) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Text(
          'New Notification',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('User: $fullName'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  NotificationDetail(notification: notification),
            ),
          );
        },
      ),
    );
  }
}

class NotificationDetail extends StatelessWidget {
  final DocumentSnapshot notification;

  const NotificationDetail({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFF76B1C), // Light orange color
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getDetails(notification),
        builder: (context, detailSnapshot) {
          if (detailSnapshot.hasError) {
            return Center(child: Text('Error: ${detailSnapshot.error}'));
          }

          if (!detailSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var details = detailSnapshot.data!;
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User: ${details['fullName']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '${details['idFieldName']}: ${details['serviceName'] ?? details['packageName'] ?? details['vehicleBrand']}',
                  style: TextStyle(fontSize: 16),
                ),
                if (details.containsKey('appointmentDateTime')) ...[
                  SizedBox(height: 10),
                  Text(
                    'Appointment Date & Time: ${details['appointmentDateTime']}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
                SizedBox(height: 10),
                Text(
                  'Timestamp: ${notification['timestamp'].toDate()}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _getDetails(
      DocumentSnapshot notification) async {
    var userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(notification['userId'])
        .get();
    var userData = userSnapshot.data();

    String? idFieldName;
    String? idValue;
    String collectionName;
    String displayNameField;

    // Check if the notification contains 'packageId' or 'serviceId' field
    if ((notification.data() as Map<String, dynamic>)
        .containsKey('packageId')) {
      idFieldName = 'Package Name';
      idValue = notification['packageId'];
      collectionName = 'packages';
      displayNameField = 'package_name'; // Correct field for package name
    } else if ((notification.data() as Map<String, dynamic>)
        .containsKey('serviceId')) {
      idFieldName = 'Service Name';
      idValue = notification['serviceId'];
      collectionName = 'services';
      displayNameField = 'service_name'; // Correct field for service name
    } else {
      throw Exception(
          'Notification does not contain valid packageId or serviceId');
    }

    var documentSnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(idValue)
        .get();

    var documentData = documentSnapshot.data();

    return {
      'fullName': '${userData?['firstName']} ${userData?['secondName']}',
      'idFieldName': capitalize(idFieldName ?? ''),
      'packageName': documentData?['package_name'],
      'serviceName': documentData?['service_name'],
      'vehicleBrand': documentData?['brand'],
      if (documentData?.containsKey('appointmentDateTime') ?? false)
        'appointmentDateTime': documentData?['appointmentDateTime'],
    };
  }

  String capitalize(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }
}
