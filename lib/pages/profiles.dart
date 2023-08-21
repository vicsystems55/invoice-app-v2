import 'package:flutter/material.dart';


class MyTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Horizontal Tabs Example'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'My Profile'),
              Tab(text: 'Business Profiles'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Content for Tab 1
            Center(child: Text('Tab 1 Content')),
            
            // Content for Tab 2
            Center(child: Text('Tab 2 Content')),
          ],
        ),
        
      ),
    );
  }
}
