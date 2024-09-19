import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final double? width;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomDateInput({
    Key? key,
    required this.controller,
    required this.label,
    this.validator,
    this.width,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        readOnly: true,
        validator: validator,
        onTap: () => _selectDate(context),
        cursorColor: const Color(0xFF585858),
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: Color(0xFF454545),
          ),
          floatingLabelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          filled: true,
          fillColor: const Color(0xFFF1F1F1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          alignLabelWithHint: true,
          suffixIcon: Icon(Icons.calendar_today, color: Color(0xff6D5BFF)),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    DateTime initialDate;

    // Verifica si el controlador tiene un valor válido
    if (controller.text.isNotEmpty) {
      try {
        initialDate = DateFormat('dd/MM/yyyy').parse(controller.text);
      } catch (e) {
        initialDate = now;
      }
    } else {
      initialDate = now;
    }

    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Color(0xff6D5BFF), // Color del calendario
                onPrimary: Colors.white, // Color del texto en el calendario
                onSurface: Colors.black, // Color del texto en los días
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: Builder(
              builder: (context) => CalendarDatePicker(
                initialDate: initialDate,
                firstDate: firstDate ?? DateTime(1900),
                lastDate: lastDate ?? now,
                onDateChanged: (DateTime date) {
                  Navigator.pop(context, date);
                },
              ),
            ),
          ),
        );
      },
    );
    if (picked != null && picked != now) {
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }
}
