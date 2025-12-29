// import 'package:eccommerce_new/core/constant/colors.dart';
import 'package:flutter/material.dart';

class customtextfaild extends StatefulWidget {
  final hint;
  final icon;
  final checkpass;
  final errorText;
  final TextInputType typeinput;
  final String? Function(String?) valid ;
  final TextEditingController controller;
  const customtextfaild(
      {super.key,
      this.hint,
      this.icon,
      this.checkpass,
      required this.controller,
      required this.typeinput,
      required this.valid, this.errorText});
  @override
  State<customtextfaild> createState() => _customtextfaildState();
}

class _customtextfaildState extends State<customtextfaild> {
  late bool showpass;
  late final String? Function(String?) v;

  @override
  void initState() {
    showpass = widget.checkpass;
    v = widget.valid;
    // check=widget.chech;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: (value){
        if(value!.isEmpty){
          return  v(value);
        }
      },
      obscureText: showpass,
      keyboardType: widget.typeinput,
      decoration: InputDecoration(
        errorText:widget.errorText,
          // hintText: widget.hint,
          // filled: true,
          // fillColor:Color.fromARGB(255, 242, 242, 242),
          label: Text(widget.hint),
          // contentPadding: const EdgeInsets.all(20),
          prefixIcon: Icon(widget.icon),
          suffixIcon: widget.checkpass == true
              ? showpass == true
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          if (showpass == true) {
                            showpass = false;
                          } else {
                            showpass = true;
                          }
                        });
                      },
                      icon: const Icon(Icons.visibility))
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          if (showpass == true) {
                            showpass = false;
                          } else {
                            showpass = true;
                          }
                        });
                      },
                      icon: const Icon(Icons.visibility_off))
              : const SizedBox(
                  width: 2,
                  height: 2,
                ),
          // border: const OutlineInputBorder(
          //   borderSide: BorderSide.none,
          //   borderRadius: BorderRadius.all(Radius.circular(10)),
          // )
          ),
    );
  }
}
