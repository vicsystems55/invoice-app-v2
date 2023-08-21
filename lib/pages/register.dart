import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:swiftinvoice2/dashboard.dart';
import 'package:swiftinvoice2/pages/login.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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

  TextEditingController nameController = TextEditingController();

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

  Future<dynamic> register() async {
    setState(() {
      isLoading = true;
    });

    String url = "https://invoiceapp.vicsystems.com.ng/api/v1/register";

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'name': nameController.text,
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
      } else {
        // Backend returned an error

        var errorMessage = jsonDecode(response.body)[
            'errors']; // Modify this based on the actual error field in the response
        print(errorMessage['name']);

        resolveError(error) {
          String name_error = '';
          String email_error = '';
          String password_error = '';

          if (error['name'] != null) {
            name_error = error['name'][0];
          }
          if (error['email'] != null) {
            email_error = error['email'][0];
          }
          if (error['password'] != null) {
            password_error = error['password'][0];
          }

          return name_error + '\n' + email_error + '\n' + password_error;
        }

        Flushbar(
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
          title: "An error occured",
          message: resolveError(errorMessage),
          duration: const Duration(seconds: 3),
        ).show(context);

        setState(() {
          isLoading = false;
        });

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
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Fullname',
                  ),
                ),
              ),
              SizedBox(height: 20),
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
                    print(nameController.text);

                    register();

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
                          'Sign up',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              SizedBox(height: 10),
              // Text for already having an account
              TextButton(
                  child: Text('Already have an account?'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
