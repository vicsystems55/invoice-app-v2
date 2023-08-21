import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swiftinvoice2/pages/Contact.dart';
import 'package:swiftinvoice2/pages/login.dart';
import 'package:swiftinvoice2/pages/privacy_policy.dart';

class SettingsPage extends StatefulWidget {

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
   late Box box;
    void logout() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('data');


    await box.clear();
  

    print('log out');

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.green, // Customize the color as needed
              padding: EdgeInsets.all(16),
              child: Column(
                children: const [
                  SizedBox(height: 80),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        'assets/images/icon2.png'), // Replace with your avatar image path
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Swift Invoice', // Replace with the user's name
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  // Text(
                  //   'User', // Replace with the user's job title
                  //   style: TextStyle(fontSize: 16, color: Colors.white),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Card(
            //     child: Column(
            //       children: const [
            //         ListTile(
            //           leading: Icon(Icons.email),
            //           title: Text(
            //               'john.doe@example.com'), // Replace with the user's email
            //         ),
            //         Divider(),
            //         ListTile(
            //           leading: Icon(Icons.phone),
            //           title: Text(
            //               '+1 (123) 456-7890'), // Replace with the user's phone number
            //         ),
            //         Divider(),
            //         ListTile(
            //           leading: Icon(Icons.location_on),
            //           title: Text(
            //               'New York, USA'), // Replace with the user's location
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrivacyPolicy()),
                        )
                      },
                      child: ListTile(
                        leading: Icon(Icons.security),
                        title: Text(
                            'Privacy Policy'), // Replace with the user's email
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text(
                          'Security Settings'), // Replace with the user's phone number
                    ),
                    Divider(),
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Contact()),
                        )
                      },
                      child: ListTile(
                        leading: Icon(Icons.headset),
                        title:
                            Text('Contact'), // Replace with the user's location
                      ),
                    ),
                    Divider(),
                    GestureDetector(
                      onTap: () => {
                        logout()
                      },
                      child: ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Logout'), // Replace with the user's location
                      ),
                    ),
                  ],
                ),
              ),
            )

            // Add more essential links or information as needed
          ],
        ),
      ),
     
    );
  }
}
