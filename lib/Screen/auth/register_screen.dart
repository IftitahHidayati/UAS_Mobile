import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

//button
import '../Add/button.dart';

//login
import '../home_screen.dart';
import 'login_screen.dart';

//Services
import '../../Services/auth_services.dart';
import '../../Services/globals.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //name controller
  final TextEditingController _nameController =
      TextEditingController(text: "test");

//email controller
  final TextEditingController _emailController =
      TextEditingController(text: "test@gmail.com");

  String _name = "test";
  String _email = "test@gmail.com";
  String _password = "";
  String _device_name = "android";

  createPressed() async {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email);
    bool passwordValid = RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{5,}$")
        .hasMatch(_password);
    if (emailValid && passwordValid) {
      http.Response response =
          await AuthServices.register(_name, _email, _password, _device_name);
      Map responseMap = jsonDecode(response.body);
      print(response.body);
      if (response.statusCode == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const LoginScreen(),
            ));
      } else {
        errorSnackBar(context, responseMap.values.first[0]);
      }
    } else {
      errorSnackBar(context, 'Enter All Required Fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 249, 248, 248),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            Text(
              "Sign Up",
              style: TextStyle(
                fontSize: 25,
                color: Color.fromARGB(255, 0, 106, 255),
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Full Name',
                labelText: 'Name',
              ),
              onChanged: (value) {
                _name = value;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                labelText: 'Email',
              ),
              onChanged: (value) {
                _email = value;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
              ),
              onChanged: (value) {
                _password = value;
              },
              obscureText: true,
            ),
            Text(
                'Password minimum 1 Upper case, lowercase, and Numeric Number'),
            const SizedBox(
              height: 50,
            ),
            // TextField(
            //   decoration: const InputDecoration(
            //     hintText: 'Confirm Password',
            //   ),
            //   onChanged: (value) {},
            //   obscureText: true, //make hide password key
            // ),
            // const SizedBox(
            //   height: 40,
            // ),
            Button(
                btnText: 'Create',
                onBtnPressed: () {
                  createPressed();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Register success',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              //make a move to home page
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text(
                "already have an account?",
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
