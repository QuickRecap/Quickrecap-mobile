import 'package:flutter/material.dart';

class CustomSelectInput extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> options;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;
  final String suffix;

  const CustomSelectInput({
    Key? key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.validator,
    this.suffix = ' segundos',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inicializar con el primer elemento si no hay valor seleccionado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (value == null || value!.isEmpty) {
        onChanged(options.first);
      }
    });

    return Focus(
      child: Builder(
        builder: (BuildContext context) {
          final bool hasFocus = Focus.of(context).hasFocus;

          return DropdownButtonFormField<String>(
            value: value?.isEmpty ?? true ? options.first : value,
            decoration: InputDecoration(
              hintText: hasFocus ? null : label,
              hintStyle: const TextStyle(
                color: Color(0xFF6D5BFF),
                fontSize: 18.0,
                fontFamily: 'Poppins',
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Color(0xFF6D5BFF),
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
            style: const TextStyle(
              color: Color(0xFF585858),
              fontFamily: 'Poppins',
              fontSize: 18.0,
            ),
            dropdownColor: Colors.white,
            isExpanded: true,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF6D5BFF),
            ),
            onChanged: onChanged,
            validator: validator,
            items: options.map<DropdownMenuItem<String>>((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(
                  option + suffix,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6D5BFF),
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}