import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onclicked;
  final Color color;

  const ButtonWidget({required this.text, required this.onclicked, required this.color});



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.pink,width: .8),
        borderRadius: BorderRadius.all(Radius.circular(30))
      ),
      child: RaisedButton(
          onPressed: onclicked,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),

        color: color,
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
        textColor: Colors.pink,
      ),
    );
  }
}
