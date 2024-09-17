import 'package:flutter/material.dart';

class CustomSelectInput extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> options;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;

  CustomSelectInput({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value?.isEmpty ?? true ? null : value,
      hint: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          color: Color(0xFF454545),  // Color del label
          fontSize: 16,  // Tamaño del label
        ),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xffF1F1F1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFF1F1F1), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      dropdownColor: Color(0xffffffff), // Color de fondo del dropdown
      isExpanded: true,
      onChanged: onChanged,
      validator: validator,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        color: Color(0xFF454545),  // Color del texto seleccionado
        fontSize: 16,  // Tamaño del texto seleccionado
      ),
      items: options.map<DropdownMenuItem<String>>((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(
            option,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Color(0xFF454545),  // Color del texto en las opciones
              fontSize: 16,  // Tamaño del texto en las opciones
            ),
          ),
        );
      }).toList(),
    );
  }
}
