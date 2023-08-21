import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cached_network_image/cached_network_image.dart';


class BusinessCard extends StatefulWidget {
  final String b_logo;
  final String b_name;
  final String b_phone;

  BusinessCard(
      {required this.b_logo, required this.b_name, required this.b_phone});

  @override
  State<BusinessCard> createState() => _BusinessCardState();
}

class _BusinessCardState extends State<BusinessCard> {
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.transparent, // No color change on the image
                        BlendMode.srcATop, // Apply the background color on top
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: 'https://invoiceapp.vicsystems.com.ng/business_logos/${widget.b_logo}',
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.b_name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.0),
                      Text(widget.b_phone),
                      SizedBox(height: 8.0),
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
