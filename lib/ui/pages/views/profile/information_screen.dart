import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrecap/domain/entities/user.dart';
import 'package:quickrecap/ui/widgets/custom_input.dart';
import 'package:quickrecap/ui/widgets/custom_select_input.dart';
import 'package:quickrecap/ui/widgets/custom_date_input.dart';
import 'package:quickrecap/ui/constants/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage
import 'dart:io';
import 'package:path/path.dart' as path; // Manejo de nombres de archivos

class ProfileInformationScreen extends StatefulWidget {
  ProfileInformationScreen({Key? key}) : super(key: key);

  @override
  _ProfileInformationScreenState createState() =>
      _ProfileInformationScreenState();
}

class _ProfileInformationScreenState extends State<ProfileInformationScreen> {
  late TextEditingController nameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController genderController;
  late TextEditingController birthDateController;

  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  String? _downloadURL;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: "Diego");
    lastNameController = TextEditingController(text: "Talledo Sanchez");
    phoneController = TextEditingController(text: "924052944");
    genderController = TextEditingController(text: "Masculino");
    birthDateController = TextEditingController(text: "19/09/2024");
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() {
      _isUploading = true;
    });

    FirebaseStorage storage = FirebaseStorage.instance;
    String fileName = path.basename(_image!.path);
    Reference storageRef = storage.ref().child('profile_pics/$fileName');

    try {
      await storageRef.putFile(File(_image!.path));
      String downloadURL = await storageRef.getDownloadURL();

      setState(() {
        _downloadURL = downloadURL;
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Imagen subida exitosamente'),
      ));
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al subir la imagen'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Informacion Personal',
              style: TextStyle(
                color: Color(0xff212121),
                fontSize: 20.sp,
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
                backgroundImage: _image != null
                    ? FileImage(File(_image!.path)) as ImageProvider
                    : AssetImage('assets/images/profile_pic.png'),
              ),
              TextButton(
                onPressed: _pickImage,
                child: Text(
                  'Cambiar foto',
                  style: TextStyle(color: Color(0xff6D5BFF)),
                ),
              ),
              if (_isUploading) CircularProgressIndicator(),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nombres',
                  style: TextStyle(
                    color: Color(0xff585858),
                    fontSize: 15.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CustomInput(
                controller: nameController,
                label: 'Ingrese su nombre',
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Apellidos',
                  style: TextStyle(
                    color: Color(0xff585858),
                    fontSize: 15.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CustomInput(
                controller: lastNameController,
                label: 'Ingrese sus apellidos',
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Celular',
                  style: TextStyle(
                    color: Color(0xff585858),
                    fontSize: 15.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CustomInput(
                controller: phoneController,
                label: 'Ingrese su numero celular',
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Genero',
                  style: TextStyle(
                    color: Color(0xff585858),
                    fontSize: 15.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CustomSelectInput(
                label: 'Seleccione un genero',
                value: genderController.text,
                options: const ['Masculino', 'Femenino', 'Otro'],
                onChanged: (String? newValue) {
                  setState(() {
                    genderController.text = newValue ?? '';
                  });
                },
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Fecha de nacimiento',
                  style: TextStyle(
                    color: Color(0xff585858),
                    fontSize: 15.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CustomDateInput(
                controller: birthDateController,
                label: 'Ingrese una fecha de nacimiento',
                initialDate: DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await _uploadImage();
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
                    backgroundColor: kPrimary,
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
