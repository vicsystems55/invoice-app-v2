import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatelessWidget {
  // Support information
  final String supportEmail = 'support@example.com';
  final String supportPhoneNumber = '+1 (123) 456-7890';
  final String supportAddress = '123 Main Street, City, Country';
  final String supportWebsite = 'www.example.com';

  // WhatsApp number
  final String whatsappNumber = '+2348037835670';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Contact Us'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.email),
            title: Text('Email'),
            subtitle: Text(supportEmail),
            onTap: () => _sendEmail(),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Phone'),
            subtitle: Text(supportPhoneNumber),
            onTap: () => _callPhoneNumber(),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Address'),
            subtitle: Text(supportAddress),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Website'),
            subtitle: Text(supportWebsite),
            onTap: () => _launchWebsite(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _chatOnWhatsApp(),
        child: Icon(Icons.chat),
      ),
    );
  }

  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      print('Error launching email');
    }
  }

  void _callPhoneNumber() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: supportPhoneNumber.replaceAll(' ', ''),
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print('Error calling phone number');
    }
  }

  void _launchWebsite() async {
    final Uri websiteUri = Uri(
      scheme: 'https',
      host: supportWebsite,
    );
    if (await canLaunchUrl(websiteUri)) {
      await launchUrl(websiteUri);
    } else {
      print('Error launching website');
    }
  }

  void _chatOnWhatsApp() async {
    final Uri whatsappUri =Uri.parse('https://wa.me/2348037835670');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication,);
    } else {
      print('Error launching WhatsApp');
    }
  }
}

