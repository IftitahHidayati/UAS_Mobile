import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api_login/Screen/auth/register_screen.dart';
import 'package:flutter_api_login/Services/globals.dart';
import '../Add/button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../Services/auth_services.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

//email controller
final TextEditingController _emailController =
    TextEditingController(text: "superadmin@gmail.com");

//password controller
final TextEditingController _passwordController =
    TextEditingController(text: "password");

//device_name controller
final TextEditingController _device_name =
    TextEditingController(text: "android");

class _LoginScreenState extends State<LoginScreen> {
  @override
  String _email = "superadmin@gmail.com";
  String _password = "password";
  String _device_name = "android";
  var Token = '';
  bool _autoValidate = false;

  final Pattern _emailPattern =
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";

  Future loginPressed() async {
    if (_email.isNotEmpty && _password.isNotEmpty) {
      http.Response response =
          await AuthServices.login(_email, _password, _device_name);
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        onPressed:
        () => sweatAlert;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen(),
          ),
        );
      } else {
        errorSnackBar(context, responseMap.values.first);
      }
    } else {
      errorSnackBar(context, 'enter all required fields');
    }
  }

  void sweatAlert(BuildContext context) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Alert!",
      desc: "Ingin Melanjutkan Login?",
      buttons: [
        DialogButton(
            child: Text(
              "Iya",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            onPressed: () {
              loginPressed();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Login success',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            })
      ],
    ).show();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white24,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 120,
            ),
            Text(
              "Sign In",
              style: TextStyle(
                fontSize: 25,
                color: Color.fromARGB(255, 49, 79, 231),
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: 'Email',
              ),
              onChanged: (value) {
                _email = value;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
                hintText: 'Password',
              ),
              onChanged: (value) {
                _password = value;
              },
              obscureText: true, //make hide input password key
            ),
            const SizedBox(
              height: 50,
            ),
            Button(
              btnText: 'Login',
              onBtnPressed: () => sweatAlert(context),
              // onBtnPressed: () => loginPressed(),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              //make a move to login page
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text(
                "Don't have any account?",
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
