import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pnlclone/constants/colorconstant.dart';

class CustomAppbar extends StatelessWidget {
  final String title;
  final String subtitle;
  const CustomAppbar({super.key, required this.title, this.subtitle = ""});

 @override
Widget build(BuildContext context) {

  return Container(
    decoration: const BoxDecoration(
      color: Colors.transparent,
    ),
    child: Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(
                color: Colors.black,
                fontSize: ColorConstant.appbartitle,
                fontWeight: FontWeight.w500),
          ),
          subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: ColorConstant.appbarsubtitle),),
        )
      ],
    ),
  );
}
}