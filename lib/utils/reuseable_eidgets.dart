import 'package:flutter/material.dart';


class MenuCard extends StatelessWidget {
  MenuCard({@required this.title, @required this.backgroundColor, @required this.onTap});

  final Color backgroundColor;
  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: backgroundColor,
        elevation: 6,
        child: Container(
          child: Text(
            '$title',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
      ),
    );
  }
}
