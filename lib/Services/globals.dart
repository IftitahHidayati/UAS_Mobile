import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String baseUrl = "http://10.0.2.2:8000/api/";
// const String baseUrl = "http://127.0.0.1:8000/api/";
// const String baseUrl = "http://v2starter.putraprima.id/api/";
const Map<String, String> headers = {"Content-Type": "application/json"};

errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      content: Text(text),
      duration: const Duration(seconds: 1),
    ),
  );
}
