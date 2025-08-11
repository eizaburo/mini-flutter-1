import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  ContactState createState() => ContactState();
}

class ContactState extends State<Contact> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  bool isSubmitting = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // hero
          Container(
            width: double.infinity,
            height: 120,
            color: Color(0xFFAAAAAA),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text(
                  "お問合せフォーム",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("お気軽にお問合せ下さい。", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(30.0),
              //form
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    //email
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Emailは必須です。";
                        }
                        final emailRegExp = RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        );
                        if (!emailRegExp.hasMatch(value)) {
                          return "Emailを正しく入力して下さい。";
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    //button
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF333333),
                          foregroundColor: Color(0xFFFFFFFF),
                        ),
                        onPressed: isSubmitting
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  sendFormData(context);
                                }
                              },
                        child: Text("送信"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //sendFormData
  void sendFormData(BuildContext context) async {
    setState(() {
      isSubmitting = true;
    });
    final client = http.Client();
    var url = Uri.parse(
      dotenv.env['GAS_API_URL'] ?? '',
    );

    try {
      var response = await http.post(
        url,
        headers: {"Content-type": "application/x-www-form-urlencoded"},
        body: {"email": emailController.text},
      );

      if (response.statusCode == 302) {
        String? location = response.headers['location'];
        if (location != null) {
          var redirectUrl = Uri.parse(location);
          var redirectResponse = await client.get(redirectUrl);
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(redirectResponse.body)));
          }
        }
      }
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
      emailController.clear();
      formKey.currentState!.reset();
    }
  }
}
