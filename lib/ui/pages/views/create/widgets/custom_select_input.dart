import 'package:flutter/material.dart';

class CustomSelectInput extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;
  final bool isLoading;
  final bool isActivity;
  final String suffix;

  const CustomSelectInput({
    Key? key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.validator,
    this.isLoading = false,
    this.isActivity = false,
    this.suffix = '',
  }) : super(key: key);

  String _formatTimeDisplay(String value) {
    if (isActivity) {
      return '$value $suffix';
    }

    final int seconds = int.tryParse(value) ?? 0;

    if (seconds <= 60) {
      return '$seconds segundos';
    } else {
      final int minutes = seconds ~/ 60;
      final int remainingSeconds = seconds % 60;

      if (remainingSeconds == 0) {
        return '$minutes ${minutes == 1 ? 'minuto' : 'minutos'}';
      } else {
        return '$minutes ${minutes == 1 ? 'min' : 'min'} $remainingSeconds seg';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              filled: isLoading,
              fillColor: isLoading ? const Color(0xFFF0EFFE) : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: isLoading ? const Color(0xFFF0EFFE) : const Color(0xFF6D5BFF),
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
              color: isLoading ? const Color(0xFFB4ABFF) : const Color(0xFF585858),
              fontFamily: 'Poppins',
              fontSize: 18.0,
            ),
            dropdownColor: Colors.white,
            isExpanded: true,
            icon: Icon(
              Icons.arrow_drop_down,
              color: isLoading ? const Color(0xFFB4ABFF) : const Color(0xFF6D5BFF),
            ),
            onChanged: isLoading ? null : onChanged,
            validator: validator,
            items: options.map<DropdownMenuItem<String>>((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(
                  _formatTimeDisplay(option),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: isLoading ? const Color(0xFFB4ABFF) : const Color(0xFF6D5BFF),
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