import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String btnText;
  final Function onBtnPressed;

  const Button({
    Key? key,
    required this.btnText,
    required this.onBtnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: Color.fromARGB(255, 130, 148, 238),
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        onPressed: () {
          onBtnPressed();
        },
        minWidth: 300,
        height: 60,
        child: Text(
          btnText,
          style: const TextStyle(
            color: Color.fromARGB(255, 247, 247, 247),
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
