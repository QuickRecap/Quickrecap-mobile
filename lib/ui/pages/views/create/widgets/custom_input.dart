import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isMultiline;
  final String? Function(String?)? validator;
  final int? maxLength;
  final bool isDisabled;

  const CustomInput({
    Key? key,
    required this.controller,
    required this.label,
    this.isMultiline = false,
    this.validator,
    this.maxLength,  // Añadimos el límite de caracteres al constructor
    this.isDisabled = false,  // Añadimos la opción de deshabilitar
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: Builder(
        builder: (BuildContext context) {
          final bool hasFocus = Focus.of(context).hasFocus;

          return TextFormField(
            controller: controller,
            enabled: !isDisabled,  // Deshabilitar si es necesario
            decoration: InputDecoration(
              hintText: hasFocus ? null : label,
              hintStyle: TextStyle(
                color: isDisabled ? Color(0xFFB4ABFF) : Color(0xFFB4ABFF), // Color de hint deshabilitado y normal
                fontSize: 18.0,
                fontFamily: 'Poppins',
              ),
              filled: isDisabled, // Aplica el color de fondo solo cuando está deshabilitado
              fillColor: isDisabled ? Color(0xFFF0EFFE) : null, // Fondo para deshabilitado
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: isDisabled ? Color(0xFFF0EFFE) : Color(0xFF6D5BFF), // Borde cuando está habilitado o deshabilitado
                  width: 1,
                ),
              ),
              disabledBorder: OutlineInputBorder( // Aseguramos el borde cuando está deshabilitado
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Color(0xFFF0EFFE), // Color específico para el borde deshabilitado
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Color(0xFF6D5BFF), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
            style: TextStyle(
              color: isDisabled ? Color(0xFF6D5BFF) : const Color(0xFF6D5BFF), // Color del texto deshabilitado y habilitado
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




