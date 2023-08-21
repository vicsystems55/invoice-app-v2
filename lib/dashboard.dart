import 'package:flutter/material.dart';
import 'package:swiftinvoice2/create_invoice.dart';
import 'package:swiftinvoice2/pages/home_page.dart';
import 'package:swiftinvoice2/pages/invoices_page.dart';
import 'package:swiftinvoice2/pages/settings.dart';
import 'package:swiftinvoice2/pages/user_profile.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateInvoicePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      
      //   actions: [
         
      //   ],
      // ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          HomePage(),
          InvoicesPage(),
          HomePage(),
     
          ProfilePage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
selectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.grey.shade900,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.receipt,
              color: Colors.grey.shade900,
            ),
            label: 'Invoices',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              color: Colors.grey.shade900,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.grey.shade900,
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Colors.grey.shade900,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}