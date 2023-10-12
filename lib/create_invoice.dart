import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swiftinvoice2/pages/create_billable_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class CreateInvoicePage extends StatefulWidget {
  @override
  _CreateInvoicePageState createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  int? selectedItemId;
  List offices = ['Office A', 'Office B', 'Office C', 'Office D'];
  late String selectedOffice = 'Office A';
  List<CardItem> cardItems = [
    CardItem("Item 1", '1'),
    CardItem("Item 2", '1'),
    CardItem("Item 3", '1'),
  ];

  List<Map<String, dynamic>> jsonDataList = [
    {"id": 1, "name": "Item 1"},
    {"id": 2, "name": "Item 2"},
    {"id": 3, "name": "Item 3"},
    // Add more rows of JSON data here
  ];

  String fullName = "..";

  late Box business_profiles_bck;

  late Box billable_items_bck;

  List business_profiles = [];

  List billable_items = [];

  bool isLoading = false;

  late Box user_info;

  String token = "";

  

  Future<dynamic> getBusinessProfiles() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    business_profiles_bck = await Hive.openBox('business_profiles_bck');
    var mymap2 = await business_profiles_bck.toMap().values.toList();

    if (mymap2 == null) {
      business_profiles.add('empty');
    } else {
      business_profiles = await mymap2;
      print('loading profiles');
      print(business_profiles);
      print(jsonDataList);
    }
    // user_info = await Hive.openBox('data');

    // fullName = user_info.get('name');

    setState(() {});

    // print(fullName);
  }

  Future<dynamic> getUserInfo() async {
    user_info = await Hive.openBox('data');

    token = user_info.get('token');

    setState(() {});

    print(token);
  }

  Future<dynamic> getBillableItems() async {
    setState(() {
      isLoading = true;
    });
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    billable_items_bck = await Hive.openBox('billable_items_bck');

    setState(() {});

    String url = "https://invoiceapp.vicsystems.com.ng/api/v1/billable-items";

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // ignore: prefer_interpolation_to_compose_strings
          'Authorization': 'Bearer ' + user_info.get('token')
        },
      );
      print('got billable items');
      var _jsonDecode = await jsonDecode((response.body));

      // print(_jsonDecode);

      await putData(_jsonDecode);
    } catch (SocketException) {
      print(SocketException);
    }

    var mymap2 = billable_items_bck.toMap().values.toList();

    if (mymap2 == null) {
      billable_items.add('empty');
    } else {
      billable_items = mymap2;
      print(billable_items);

      setState(() {
        isLoading = false;
      });
    }

    // return Future.value(true);
  }

  Future putData(data) async {
    await billable_items_bck.clear();
    for (var d in data) {
      billable_items_bck.add(d);
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
    getBusinessProfiles();
    getBillableItems();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Invoice'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 10, vertical: 8), // Customize padding

                  labelText: 'Select Businesses',
                  border: OutlineInputBorder(),
                ),
                value: selectedItemId,
                items: business_profiles.map((item) {
                  return DropdownMenuItem<int>(
                    value: item["id"],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item["b_name"].toString()),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedItemId = newValue;
                  });
                },
              ),
              if (selectedItemId != null)
                Text(
                    'Selected Item: ${business_profiles.firstWhere((item) => item["id"] == selectedItemId)["b_name"]}'),
              SizedBox(height: 30),
              Container(
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Client/Customer Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Client/Customer Phone',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Client/Customer Address',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Billable Item:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Container(
                    height: 30,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateBillableItemPage()),
                        );
                      },
                      child: Text(
                        'Manage',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                height: 150,
                child: Stack(
                  children: <Widget>[
                    // Conditionally show the ListView or the CircularProgressIndicator
                    if (billable_items.length == 0)
                      Column(children: [
                        Text('No billable items yet.'),
                        Container(
                          height: 30,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreateBillableItemPage()),
                              );
                            },
                            child: Text(
                              'Add',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ])
                    else
                      PageView.builder(
                        itemCount: billable_items.length,
                        controller: PageController(viewportFraction: 0.8),
                        itemBuilder: (BuildContext context, int index) {
                          return CardWidget(
                              cardItem: CardItem(
                                  billable_items[index]['description'],
                                  billable_items[index]['price']));
                        },
                      ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    TextInput.finishAutofillContext();

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => DashboardPage()),
                    // );
                  },
                  child: Text(
                    'Create Now',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardItem {
  String name;
  String price;
  int quantity = 0;
  bool selected = false;

  CardItem(this.name, this.price);
}

class CardWidget extends StatefulWidget {
  final CardItem cardItem;

  CardWidget({required this.cardItem});

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 130,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                    child: Text(
                      widget.cardItem.name,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Text(
                      'NGN '+widget.cardItem.price,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 13,)
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Checkbox(
                  value: widget.cardItem.selected,
                  onChanged: (value) {
                    setState(() {
                      widget.cardItem.selected = value!;
                    });
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                Text('Quantity'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.remove_circle_rounded),
                      onPressed: () {
                        setState(() {
                          if (widget.cardItem.quantity > 0) {
                            widget.cardItem.quantity--;
                          }
                        });
                      },
                    ),
                    Text(
                      widget.cardItem.quantity.toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_rounded),
                      onPressed: () {
                        setState(() {
                          widget.cardItem.quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
