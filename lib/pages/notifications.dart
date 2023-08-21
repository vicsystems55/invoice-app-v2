import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<String> notifications = List.generate(30, (index) => 'Notification ${index + 1}');

  Future<void> _refreshNotifications() async {
    // Simulate a data refresh, you can fetch new data here if you have an API call.
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      notifications = List.generate(30, (index) => 'Notification ${index + 1}');
    });
  }

  Future<void> _loadMoreNotifications() async {
    // Simulate loading more data, you can fetch more data here if you have an API call.
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      final int currentLength = notifications.length;
      final int maxLength = currentLength + 30;
      for (int i = currentLength + 1; i <= maxLength; i++) {
        notifications.add('Notification $i');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return Column(
              children: [

                ListTile(
                  title: Text(notifications[index]),
                  subtitle: Text('Notification details here...'),
                  // Add more notification details as needed
                ),
                  Divider(),
              ],
            );
          },
        ),
      ),

    );
  }
}
