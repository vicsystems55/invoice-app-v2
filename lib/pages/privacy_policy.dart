import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Terms and Privacy'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms of Service',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Welcome to the Swift Invoice App developed by vicSystems Technologies Ltd. By using this app, you agree to the following terms and conditions:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '1. You must use the app in accordance with the laws and regulations of your country.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '2. The app is provided on an "as is" basis, and vicSystems Technologies Ltd. does not guarantee its accuracy, reliability, or functionality.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '3. vicSystems Technologies Ltd. is not responsible for any loss or damage caused by the use of this app.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'vicSystems Technologies Ltd. is committed to protecting your privacy. We collect and store minimal personal information required for the app\'s functionality. We do not share or sell your information to third parties.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'By using this app, you consent to the collection and use of your personal information as described in this Privacy Policy.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Contact Us',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'If you have any questions or concerns about the Terms and Privacy, please contact us at:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'vicSystems Technologies Ltd.\nEmail: contact@vicsystems.com.ng\nPhone: +234 803 783 5670',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
