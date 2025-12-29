
import 'package:auction/core/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomTextFieldPost extends StatelessWidget {
   final TextInputType keyboardType ;
  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final int minLines ;
  final int maxLines ;
  
  const CustomTextFieldPost({
    super.key, required this.controller, required this.label, this.keyboardType=TextInputType.multiline,this.minLines=1, this.maxLines=1, this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: minLines,
      maxLines: maxLines,
      textInputAction: TextInputAction.none,
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) => Utils.validateFormField(value),
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon) : null,
        labelText: label,
        // border: OutlineInputBorder(
        //   // borderSide: BorderSide.none,
        //   // borderSide: BorderSide(color: Colors.),
        //   // borderRadius: BorderRadius.circular(8)
        //   ),
        // filled: true,
        // fillColor: const Color.fromARGB(255, 248, 248, 250),
        // fillColor: Colors.,

        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
