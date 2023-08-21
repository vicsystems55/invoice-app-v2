import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swiftinvoice2/pages/success.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


class CreateBillableItemPage extends StatefulWidget {
  @override
  _CreateBillableItemPageState createState() => _CreateBillableItemPageState();
}

class _CreateBillableItemPageState extends State<CreateBillableItemPage> {
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

// user_id
// business_profile_id
// image
// price
// description

  int? selectedItemId;

  File? _pickedImage;

  bool isLoading = false;

  late Box user_info;

  String token = "";

  late Box business_profiles_bck;

  List business_profiles = [];

  @override
  void initState() {
    // TODO: implement initState

    getUserInfo();
    getBusinessProfiles();
  }

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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
    }
  }

// ...

  void _submitForm() async {
    final List<String> allErrors = [];
    print('hello wor');

    setState(() {
      isLoading = true;
    });

    if (_pickedImage != null) {
      // Convert the image to bytes
      List<int> imageBytes = await _pickedImage!.readAsBytes();

      // Prepare the request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://invoiceapp.vicsystems.com.ng/api/v1/create-billable-item'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      request.fields['price'] = _priceController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['business_profile_id'] = selectedItemId.toString();

      // Attach form fields

      // Attach image
      request.files.add(
        http.MultipartFile.fromBytes(
          'billable_item_image',
          imageBytes,
          filename: 'logo.jpg', // Provide a filename for the image
        ),
      );

      // Send the request
      var response = await request.send();

      if (response.statusCode == 201) {
        // Request was successful, handle response
        print('Request successful');
        print(await response.stream.bytesToString());

        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SuccessScreen(
                      msg: 'Billable Item Created!!',
                      icon: 'assets/images/success.json',
                    )));

        setState(() {
          isLoading = false;
        });
      } else {
        // Request failed, handle error
        print('Request failed');
        print(response.statusCode);
        var errorContent = await response.stream.bytesToString();
        final error = json.decode(errorContent) as Map<String, dynamic>;
        // var errorContentMsg = jsonDecode(errorContent.error);
        if (error.containsKey('errors')) {
          // String errorMessage = errorJson['error'] as String;
          // print('Error message: $errorMessage');

          print(error['errors']);

          String b_logo = '';
          String b_signature = '';
          String b_description = '';
          String b_name = '';
          String b_address = '';
          String b_phone = '';

          if (error['errors']['b_logo'] != null) {
            b_logo = error['errors']['b_logo'][0];
            allErrors.add(b_logo);
          }

          if (error['errors']['b_signature'] != null) {
            b_signature = error['errors']['b_signature'][0];
            allErrors.add(b_signature);
          }

          if (error['errors']['b_description'] != null) {
            b_description = error['errors']['b_description'][0];
            allErrors.add(b_description);
          }

          if (error['errors']['b_name'] != null) {
            b_name = error['errors']['b_name'][0];
            allErrors.add(b_name);
          }

          if (error['errors']['b_address'] != null) {
            b_address = error['errors']['b_address'][0];
            allErrors.add(b_address);
          }

          if (error['errors']['b_phone'] != null) {
            b_phone = error['errors']['b_phone'][0];
            allErrors.add(b_phone);
          }

          // return b_logo +
          //     '\n' +
          //     b_signature +
          //     '\n' +
          //     b_description +
          //     '\n' +
          //     b_name +
          //     '\n' +
          //     b_address +
          //     '\n' +
          //     b_phone;

          // ignore: use_build_context_synchronously

          // ignore: use_build_context_synchronously
          Flushbar(
            icon: const Icon(
              Icons.error,
              color: Colors.red,
            ),
            title: "An error occured",
            messageText: Text(
              allErrors.join('\n'),
              style: TextStyle(color: Colors.white),
            ),
            duration: const Duration(seconds: 5),
          ).show(context);
        }

        setState(() {
          isLoading = false;
        });
      }
    } else {
      // Handle the case where no image is picked

      print('No image picked');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blueGrey, // Change this color
    ));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Create A Billable Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20),
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
                onChanged: (int? newValue) {
                  setState(() {
                    selectedItemId = newValue;
                  });
                },
              ),
              if (selectedItemId != null)
                Text(
                    'Selected Item: ${business_profiles.firstWhere((item) => item["id"] == selectedItemId)["b_name"]}'),
              SizedBox(height: 20),
              Text('Upload Logo', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 150,
                  height: 150,
                  color: Colors.grey,
                  child: _pickedImage != null
                      ? Image.file(_pickedImage!, fit: BoxFit.cover)
                      : Icon(Icons.add_a_photo, size: 50, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                child: TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(
                        r'^\d+\.?\d{0,2}$')), // Allow up to 2 decimal places
                  ],
                  decoration: InputDecoration(
                    labelText: 'Price',
                    hintText: 'Enter price',
                    prefixText: 'NGN  ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    _submitForm();

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => SuccessScreen()),
                    // );
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        )
                      : const Text(
                          'Create Item',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
