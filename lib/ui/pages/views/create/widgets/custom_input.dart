import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isMultiline;
  final String? Function(String?)? validator;
  final int? maxLength;
  final bool isDisabled;
  final bool isLoading; // Add loading state

  const CustomInput({
    Key? key,
    required this.controller,
    required this.label,
    this.isMultiline = false,
    this.validator,
    this.maxLength,
    this.isDisabled = false,
    this.isLoading = false, // Default to false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: Builder(
        builder: (BuildContext context) {
          final bool hasFocus = Focus.of(context).hasFocus;
          final bool finalDisabledState = isDisabled || isLoading; // Combine both states

          return TextFormField(
            controller: controller,
            enabled: !finalDisabledState,
            decoration: InputDecoration(
              hintText: hasFocus ? null : label,
              hintStyle: TextStyle(
                color: finalDisabledState ? Color(0xFFB4ABFF) : Color(0xFFB4ABFF),
                fontSize: 18.0,
                fontFamily: 'Poppins',
              ),
              filled: finalDisabledState,
              fillColor: finalDisabledState ? Color(0xFFF0EFFE) : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: finalDisabledState ? Color(0xFFF0EFFE) : Color(0xFF6D5BFF),
                  width: 1,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Color(0xFFF0EFFE),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Color(0xFF6D5BFF), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
            style: TextStyle(
              color: finalDisabledState ? Color(0xFF6D5BFF) : const Color(0xFF6D5BFF),
            ),
            keyboardType: isMultiline ? TextInputType.multiline : TextInputType.text,
            maxLines: isMultiline ? null : 1,
            minLines: isMultiline ? 5 : 1,
            validator: validator,
          );
        },
      ),
    );
  }
}




