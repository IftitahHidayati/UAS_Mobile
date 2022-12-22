import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final String btnText;
  final Function onBtnPressed;

  const LogoutButton({
    Key? key,
    required this.btnText,
    required this.onBtnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: Color.fromARGB(255, 255, 0, 0),
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
