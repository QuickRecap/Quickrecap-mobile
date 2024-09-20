import 'package:flutter/material.dart';

class CustomSelectInput extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> options;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;

  const CustomSelectInput({super.key, 
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
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          color: Color(0xFF737373),  // Color del label
          fontSize: 16,  // Tamaño del label
        ),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffF1F1F1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFF1F1F1), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      dropdownColor: const Color(0xffffffff), // Color de fondo del dropdown
      isExpanded: true,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        color: Color(0xFF343434),  // Color del texto seleccionado
        fontSize: 16,  // Tamaño del texto seleccionado
      ),
      items: options.map<DropdownMenuItem<String>>((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(
            option,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Color(0xFF484848),  // Color del texto en las opciones
              fontSize: 16,  // Tamaño del texto en las opciones
            ),
          ),
        );
      }).toList(),
    );
  }
}
