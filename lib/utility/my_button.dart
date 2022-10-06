import 'package:flutter/material.dart';

class MyRoundButton extends StatelessWidget {
  final String text;

  final Color bgColor;

  MyRoundButton({
    required this.text,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      height:40,
      alignment: Alignment.center,
      padding: EdgeInsets.all(5),
      decoration:  BoxDecoration(
              color: bgColor,
              borderRadius:
                  BorderRadius.all(Radius.circular(10)),

              boxShadow: [
                BoxShadow(
                  color: bgColor.withOpacity(0.2),
                  spreadRadius: 2.0,
                  blurRadius: 2.0,
                  offset: Offset(1.0, 4.0), // changes position of shadow
                ),
              ],
            ),

      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white
        ),
      ),
    );
  }
}
