import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ogechukwu Collins', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.0),
                      Text('INVS0239'),
                      SizedBox(height: 8.0),
                      Text('Date: 2-23-2002'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('N 35,000,000.00'),
                      SizedBox(height: 8.0),
                      Text('unpaid'),
                      SizedBox(height: 8.0),
                      Text('Due: 2-23-2002'),
                    ],
                  ),
                ],

                // onTap: () {
                //   // Handle invoice item tap
                // },
              ),
            ),
            Divider(),
          ],
        ),
        
      ),
    );
  }
}
