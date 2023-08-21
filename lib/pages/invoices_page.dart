import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../components/invoice_card.dart';

class InvoicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 80,),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'My Invoices',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                           labelText: 'Search',
                        hintText: 'Search',
                        suffixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),
            
               
              ],
            ),
       
        ),
      
        SizedBox(height:6.0),
        Expanded(
          child: ListView.builder(
            itemCount: 10, // Replace with the actual number of invoices
            itemBuilder: (context, index) {
              return InvoiceCard();
            },
          ),
        ),
      ],
    );
  }
}