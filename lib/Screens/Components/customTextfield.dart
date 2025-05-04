import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String lable;
final TextEditingController? controller;
  const CustomTextfield({super.key,required this.lable, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
       label: Text(lable)
      ),
    );
  }
}