import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swiftinvoice2/pages/success.dart';
import 'package:http/http.dart' as http;

class CreateBusinessProfile extends StatefulWidget {
  @override
  State<CreateBusinessProfile> createState() => _CreateBusinessProfileState();
}

class _CreateBusinessProfileState extends State<CreateBusinessProfile> {
  @override
  Widget build(BuildContext context) {
    return MyFormScreen();
  }
}

class MyFormScreen extends StatefulWidget {
  @override
  _MyFormScreenState createState() => _MyFormScreenState();
}

class _MyFormScreenState extends State<MyFormScreen> {
  TextEditingController _textFieldController = TextEditingController();

  TextEditingController _b_nameController = TextEditingController();
  TextEditingController _b_addressController = TextEditingController();
  TextEditingController _b_phoneController = TextEditingController();
  TextEditingController _b_cac_noController = TextEditingController();
  TextEditingController _b_descriptionController = TextEditingController();

  File? _pickedImage;
  File? _pickedSignature;

  bool isLoading = false;

  late Box user_info;

  String token = "";

//   b_name
// b_address
// b_phone
// b_logo
// b_cac_no
// b_description
// b_sign

  @override
  void initState() {
    // TODO: implement initState

    getUserInfo();
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

  Future<void> _pickSignature() async {
    final pick_er = ImagePicker();
    final pickedSignature =
        await pick_er.pickImage(source: ImageSource.gallery);

    if (pickedSignature != null) {
      setState(() {
        _pickedSignature = File(pickedSignature.path);
      });
    }
  }

// ...

  void _submitForm() async {
    String textValue = _textFieldController.text;
    print('hello wor');

    setState(() {
      isLoading = true;
    });

    if (_pickedImage != null) {
      // Convert the image to bytes
      List<int> imageBytes = await _pickedImage!.readAsBytes();
      List<int> imageBytesSignature = await _pickedSignature!.readAsBytes();

      // Prepare the request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://invoiceapp.vicsystems.com.ng/api/v1/create/business-profile'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Attach form fields
      request.fields['text_field'] = textValue;
      request.fields['b_name'] = _b_nameController.text;
      request.fields['b_address'] = _b_addressController.text;
      request.fields['b_phone'] = _b_phoneController.text;
      request.fields['b_cac_no'] = _b_cac_noController.text;
      request.fields['b_description'] = _b_descriptionController.text;

      // Attach image
      request.files.add(
        http.MultipartFile.fromBytes(
          'b_logo',
          imageBytes,
          filename: 'logo.jpg', // Provide a filename for the image
        ),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'b_signature',
          imageBytesSignature,
          filename: 'signature.jpg', // Provide a filename for the image
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
                      msg: 'Business Profile Creation Successful',
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
        print(error['errors']['b_name'][0]);

        if (error.containsKey('errors')) {
          String b_logo = '';
          String b_signature = '';
          String b_description = '';
          String b_name = '';
          String b_address = '';
          String b_phone = '';

          if (error['errors']['b_logo'] != null) {
            b_logo = error['b_logo'][0];
            Flushbar(
              flushbarStyle: FlushbarStyle.FLOATING,
              icon: const Icon(
                Icons.error,
                color: Colors.red,
              ),
              message: b_logo,
              duration: const Duration(seconds: 5),
            ).show(context);

            Flushbar(
              flushbarStyle: FlushbarStyle.FLOATING,
              icon: const Icon(
                Icons.error,
                color: Colors.red,
              ),
              message: 'b_log',
              duration: const Duration(seconds: 5),
            ).show(context);
          }

          if (error['errors']['b_signature'] != null) {
            b_signature = error['errors']['b_signature'][0];
            Flushbar(
              flushbarStyle: FlushbarStyle.FLOATING,
              icon: const Icon(
                Icons.error,
                color: Colors.red,
              ),
              message: b_signature,
              duration: const Duration(seconds: 5),
            ).show(context);
          }

          if (error['errors']['b_description'] != null) {
            b_description = error['errors']['b_description'][0];
            Flushbar(
              flushbarStyle: FlushbarStyle.FLOATING,
              icon: const Icon(
                Icons.error,
                color: Colors.red,
              ),
              message: b_description,
              duration: const Duration(seconds: 5),
            ).show(context);
          }

          if (error['errors']['b_name'] != null) {
            b_name = error['errors']['b_name'][0];
            Flushbar(
              flushbarStyle: FlushbarStyle.FLOATING,
              icon: const Icon(
                Icons.error,
                color: Colors.red,
              ),
              message: b_name,
              duration: const Duration(seconds: 5),
            ).show(context);
          }

          if (error['errors']['b_address'] != null) {
            b_address = error['errors']['b_address'][0];
            Flushbar(
              flushbarStyle: FlushbarStyle.FLOATING,
              icon: const Icon(
                Icons.error,
                color: Colors.red,
              ),
              message: b_address,
              duration: const Duration(seconds: 5),
            ).show(context);
          }

          if (error['errors']['b_phone'] != null) {
            b_phone = error['errors']['b_phone'][0];
            Flushbar(
              flushbarStyle: FlushbarStyle.FLOATING,
              icon: const Icon(
                Icons.error,
                color: Colors.red,
              ),
              message: b_phone,
              duration: const Duration(seconds: 5),
            ).show(context);
          }

          // return b_logo
          // + '\n' + b_signature
          // + '\n' + b_description
          // + '\n' + b_name
          // + '\n' + b_address
          // + '\n' + b_phone
          // ;
        }

        setState(() {
          isLoading = false;
        });
      }
    } else {
      // Handle the case where no image is picked
      print('Text Value: $textValue');
      print('No image picked');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _textFieldController.dispose();
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
        title: Text('Create A Business Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 50,
                child: TextField(
                  controller: _b_nameController,
                  decoration: InputDecoration(
                    labelText: 'Business Name',
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
                  controller: _b_descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Business Description',
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
                  controller: _b_addressController,
                  decoration: InputDecoration(
                    labelText: 'Business Address',
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
                  controller: _b_phoneController,
                  decoration: InputDecoration(
                    labelText: 'Business Phone Number',
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
                  controller: _b_cac_noController,
                  decoration: InputDecoration(
                    labelText: 'Business CAC No.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
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
              Text('Upload Signature', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _pickSignature,
                child: Container(
                  width: 150,
                  height: 150,
                  color: Colors.grey,
                  child: _pickedSignature != null
                      ? Image.file(_pickedSignature!, fit: BoxFit.cover)
                      : Icon(Icons.add_a_photo, size: 50, color: Colors.white),
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
                          'Submit',
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
