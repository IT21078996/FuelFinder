import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class CustomTextFeild extends StatefulWidget {
  const CustomTextFeild(
      {super.key,
        required this.type,
        required this.titile,
        required this.placeholder,
        required this.controller});

  final String type;
  final String titile;
  final String placeholder;

  final TextEditingController? controller;

  @override
  State<CustomTextFeild> createState() => _CustomTextFeildState();
}

class _CustomTextFeildState extends State<CustomTextFeild> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.titile,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(

          controller: widget.controller,
          keyboardType: widget.type == 'number'
              ? TextInputType.number
              : widget.type == 'email'
              ? TextInputType.emailAddress
              : widget.type == 'date'
              ? TextInputType.datetime
              : TextInputType.text,
          obscureText: widget.type == 'password' ? isObscure : false,
          obscuringCharacter: '*',
          style: const TextStyle(
            fontSize: 16,
          ),
          decoration: InputDecoration(
            suffixIcon: widget.type == 'password'
                ? IconButton(
              onPressed: () {
                setState(() {
                  isObscure = !isObscure;
                });
              },
              icon: Icon(isObscure ? LineIcons.eye : LineIcons.eyeSlash),
            )
                : widget.type == 'email'
                ? const Icon(LineIcons.envelope)
                : widget.type == 'user'
                ? const Icon(LineIcons.user)
                : null,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide.none,
            ),

            hintText: widget.placeholder,
            hintStyle: const TextStyle(
                color: Color.fromARGB(93, 46, 46, 46),
                fontSize: 16,
                fontFamily: 'Poppins'),
            contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          ),
        )
      ],
    );
  }
}