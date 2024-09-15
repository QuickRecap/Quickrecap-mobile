import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;  // Añadimos el parámetro para el tipo de teclado
  final double? width;  // Parámetro para el ancho

  const CustomInput({
    Key? key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.validator,
    this.keyboardType,  // Añadimos el parámetro de tipo de teclado al constructor
    this.width,  // Añadimos el parámetro de ancho
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,  // Utilizamos SizedBox para aplicar el ancho si se proporciona
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        keyboardType: keyboardType,  // Pasamos el tipo de teclado al TextFormField
        cursorColor: Color(0xFF585858),
        style: TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: Color(0xFF585858),
          ),
          floatingLabelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          filled: true,
          fillColor: Color(0xFFF1F1F1),  // Cambiado el color de fondo a #F1F1F1
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}
