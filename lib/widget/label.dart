import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String routeName;
  final String title;
  final String subTitle;
  const Labels(
      {Key? key,
      required this.routeName,
      required this.title,
      required this.subTitle})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              child: Text(subTitle,
                  style: TextStyle(
                      color: Colors.blue[500],
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pushReplacementNamed(context, routeName);
              },
            )
          ],
        ),
      ),
    );
  }
}
