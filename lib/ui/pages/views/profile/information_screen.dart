import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrecap/ui/widgets/custom_input.dart';
import 'package:quickrecap/ui/widgets/custom_select_input.dart';
import 'package:quickrecap/ui/widgets/custom_date_input.dart';
import 'package:quickrecap/ui/constants/constants.dart';

class ProfileInformationScreen extends StatefulWidget {
  const ProfileInformationScreen({Key? key}) : super(key: key);

  @override
  _ProfileInformationScreenState createState() => _ProfileInformationScreenState();
}

class _ProfileInformationScreenState extends State<ProfileInformationScreen> {
  final TextEditingController nameController = TextEditingController(text: 'Diego');
  final TextEditingController lastNameController = TextEditingController(text: 'Talledo Sanchez');
  final TextEditingController phoneController = TextEditingController(text: '924052944');
  final TextEditingController genderController = TextEditingController(text: 'Masculino');
  final TextEditingController birthDateController = TextEditingController(text: 'dd/mm/aaaa');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Informacion Personal',
              style: TextStyle(
                color: Color(0xff212121), // Cambia el color del texto del título
                fontSize: 20.sp, // Ajusta el tamaño del texto según tu diseño
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/profile_pic.png'),
              ),
              TextButton(
                onPressed: () {
                  // Implementar lógica para cambiar la foto
                },
                child: Text(
                  'Cambiar foto',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(height: 20),
              CustomInput(
                controller: nameController,
                label: 'Nombres',
              ),
              SizedBox(height: 16),
              CustomInput(
                controller: lastNameController,
                label: 'Apellidos',
              ),
              SizedBox(height: 16),
              CustomInput(
                controller: phoneController,
                label: 'Celular',
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              CustomSelectInput(
                label: 'Genero',
                value: genderController.text,
                options: const ['Masculino', 'Femenino', 'Otro'],
                onChanged: (String? newValue) {
                  setState(() {
                    genderController.text = newValue ?? '';
                  });
                },
              ),
              SizedBox(height: 16),
              CustomDateInput(
                controller: birthDateController,
                label: 'Fecha de nacimiento',
                initialDate: DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Implementa la lógica de actualización de contraseña aquí
                  },
                  child: Text(
                    'Guardar',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff6D5BFF),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    genderController.dispose();
    birthDateController.dispose();
    super.dispose();
  }
}