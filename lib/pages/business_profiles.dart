import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swiftinvoice2/components/business_card.dart';
import 'package:swiftinvoice2/pages/create_business_profiles.dart';
import 'package:http/http.dart' as http;

class BusinessProfiles extends StatefulWidget {
  const BusinessProfiles({super.key});

  @override
  State<BusinessProfiles> createState() => _BusinessProfilesState();
}

class _BusinessProfilesState extends State<BusinessProfiles> {
  late Box business_profiles_bck;
  late Box user_data;

  List business_profiles = [];

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBusinessProfiles();
  }

  Future<dynamic> getBusinessProfiles() async {
    setState(() {
      isLoading = true;
    });
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    user_data = await Hive.openBox('data');
    business_profiles_bck = await Hive.openBox('business_profiles_bck');

    setState(() {});

    String url =
        "https://invoiceapp.vicsystems.com.ng/api/v1/business-profiles";

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // ignore: prefer_interpolation_to_compose_strings
          'Authorization': 'Bearer ' + user_data.get('token')
        },
      );
      print('got products');
      var _jsonDecode = await jsonDecode((response.body));

      print(_jsonDecode);

      await putData(_jsonDecode);
    } catch (SocketException) {
      print(SocketException);
    }

    var mymap2 = business_profiles_bck.toMap().values.toList();

    if (mymap2 == null) {
      business_profiles.add('empty');
    } else {
      business_profiles = mymap2;
      print(business_profiles);

      setState(() {
        isLoading = false;
      });
    }

    // return Future.value(true);
  }

  Future putData(data) async {
    await business_profiles_bck.clear();
    for (var d in data) {
      business_profiles_bck.add(d);
    }
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Stack(children: [
      Stack(
        children: <Widget>[
          // Conditionally show the ListView or the CircularProgressIndicator
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              itemCount: business_profiles.length,
              itemBuilder: (context, index) {
                return BusinessCard(
                    b_logo: business_profiles[index]['b_logo'],
                    b_name: business_profiles[index]['b_name'],
                    b_phone: business_profiles[index]['b_phone']);
              },
            ),
        ],
      ),
      Positioned(
        bottom: 16.0, // Adjust the values to position the FAB
        right: 16.0,
        child: Container(
          height: 50,
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateBusinessProfile()),
              );
            },
            child: Text(
              'Add Business',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    ]);
  }
}
