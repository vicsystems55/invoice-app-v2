import 'package:flutter/material.dart';
import 'package:swiftinvoice2/components/business_card.dart';
import 'package:swiftinvoice2/pages/business_profiles.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String> notifications =
      List.generate(30, (index) => 'Notification ${index + 1}');

  Future<void> _refreshNotifications() async {
    // Simulate a data refresh, you can fetch new data here if you have an API call.
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      notifications = List.generate(30, (index) => 'Notification ${index + 1}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: TabBar(
            tabs: [
              Tab(text: 'Business Profiles'),
              Tab(text: 'My Profile'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Content for Tab 1

            BusinessProfiles(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Colors.green, // Customize the color as needed
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: const [
                      SizedBox(height: 40),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                            'assets/images/icon2.png'), // Replace with your avatar image path
                      ),
                      SizedBox(height: 16),
                      Text(
                        'John Doe', // Replace with the user's name
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'User', // Replace with the user's job title
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      children: const [
                        ListTile(
                          leading: Icon(Icons.email),
                          title: Text(
                              'john.doe@example.com'), // Replace with the user's email
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.phone),
                          title: Text(
                              '+1 (123) 456-7890'), // Replace with the user's phone number
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.location_on),
                          title: Text(
                              'New York, USA'), // Replace with the user's location
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          

            // Content for Tab 2
          ],
        ),
      ),
    );
  }
}
