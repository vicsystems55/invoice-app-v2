import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:swiftinvoice2/dashboard.dart';
import 'package:swiftinvoice2/pages/register.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Box box;

  List data = [];

  bool _isObscure = true;

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState

    openBox();
  }

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  void _toggle() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  Future openBox() async {
    try {
      box = await Hive.openBox('data');
    } catch (e) {}
  }

  Future<dynamic> login() async {
    setState(() {
      isLoading = true;
    });

    String url = "https://invoiceapp.vicsystems.com.ng/api/v1/login";

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': emailController.text,
          'password': passwordController.text
        }),
      );
      if (response.statusCode == 200) {
        // Successful response
        var _jsonDecode = jsonDecode(response.body);
        print(_jsonDecode);
        await putData(_jsonDecode);

        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );

        // ignore: use_build_context_synchronously
        await Flushbar(
          icon: const Icon(
            Icons.check,
            color: Colors.green,
          ),
          title: "Login Successful",
          message: "Welcome on board",
          duration: const Duration(seconds: 3),
        ).show(context);
      } else {
        // Backend returned an error

        var errorMessage = jsonDecode(response.body)[
            'message']; // Modify this based on the actual error field in the response
        print('Error: $errorMessage');

        Flushbar(
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
          title: "An error occured",
          message: "$errorMessage",
          duration: const Duration(seconds: 3),
        ).show(context);

        // TODO: Handle the error, e.g., show a snackbar or an error dialog.
      }
    } catch (SocketException) {
      setState(() {
        isLoading = false;
      });

      print(SocketException);
    }

    return Future.value(true);
  }

  Future putData(data) async {
    try {
      await box.clear();

      final String token = data['access_token'];
      final String name = data['user_data']['name'];
      final String email = data['user_data']['email'];

      box.put('token', token);
      box.put('name', name);
      box.put('email', email);

      print(box.get('token'));

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error while putting data: $e');
      // Handle the error gracefully, e.g., show a snackbar, or navigate to an error page.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image asset widget for the logo
              SizedBox(height: 50),
              Image.asset(
                'assets/images/launcher.png',
                height: 100,
              ),
              SizedBox(height: 20),
              // Text beneath logo
              Text(
                '',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // Email input field
              Container(
                height: 50,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Email',
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Password field with toggle visibility icon
              Container(
                height: 50,
                child: TextField(
                  obscureText: _isObscure,
                  textInputAction: TextInputAction.done,
                  autofillHints: [AutofillHints.password],
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        print('t');
                        _toggle();
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Sign in button
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
                    TextInput.finishAutofillContext();
                    print(emailController.text);
                    print(passwordController.text);

                    login();

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => DashboardPage()),
                    // );
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Sign in',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              SizedBox(height: 10),
              // Text for already having an account
              TextButton(
                  child: Text('Don\'t have an account?'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
