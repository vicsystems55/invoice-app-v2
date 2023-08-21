import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:swiftinvoice2/pages/invoice_details.dart';
import 'package:swiftinvoice2/pages/notifications.dart';
import 'package:hive/hive.dart';

import '../components/invoice_card.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String fullName = "..";

  late Box user_info;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  Future<dynamic> getUserInfo() async {
    user_info = await Hive.openBox('data');

    fullName = user_info.get('name');

    setState(() {});

    print(fullName);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text('Hi, $fullName',
                    style:
                        TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationsScreen()),
                  )
                },
                color: Colors.green,
                iconSize: 24,
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            height: 148.0,
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$0.00', // Replace with the actual value
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange),
                        ),
                        Text(
                          '\$0.00', // Replace with the actual value
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Invoices Raised', // Replace with the actual value
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Invoices Paid', // Replace with the actual value
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Latest Updates: 9 September, 2023',
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Replace with the actual number of invoices
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InvoiceDetails()),
                          )
                        },
                    child: InvoiceCard());
              },
            ),
          ),
        ],
      ),
    );
  }
}
