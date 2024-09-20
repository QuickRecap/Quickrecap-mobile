import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrecap/ui/widgets/custom_input.dart';
import 'package:quickrecap/ui/widgets/custom_select_input.dart';
import 'package:quickrecap/ui/widgets/custom_date_input.dart';
import 'package:quickrecap/ui/constants/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../providers/edit_profile_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../data/repositories/local_storage_service.dart';
import '../../../../domain/entities/user.dart';
import 'package:path/path.dart' as path;

class ProfileInformationScreen extends StatefulWidget {
  ProfileInformationScreen({Key? key}) : super(key: key);

  @override
  _ProfileInformationScreenState createState() =>
      _ProfileInformationScreenState();
}

class _ProfileInformationScreenState extends State<ProfileInformationScreen> {
  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController genderController;
  late TextEditingController birthDateController;

  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  String? _downloadURL;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    nameController = TextEditingController();
    lastNameController = TextEditingController();
    phoneController = TextEditingController();
    genderController = TextEditingController();
    birthDateController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadUserProfile();
    });
  }

  Future<void> loadUserProfile() async {
    try {
      LocalStorageService localStorageService = LocalStorageService();
      User? user = await localStorageService.getCurrentUser();

      if (user != null) {
        setState(() {
          idController.text = user.id;
          nameController.text = user.firstName;
          lastNameController.text = user.lastName;
          phoneController.text = user.phone;
          genderController.text = user.gender;

          // Convertir la fecha de cumpleaños al formato dd/MM/yyyy
          if (user.birthday.isNotEmpty) {
            try {
              final DateTime birthDate = DateTime.parse(user.birthday);
              birthDateController.text = DateFormat('dd/MM/yyyy').format(birthDate);
            } catch (e) {
              print("Error al parsear la fecha de nacimiento: $e");
              birthDateController.text = "";
            }
          } else {
            birthDateController.text = "";
          }

          // Actualizar la imagen de perfil si está disponible
          if (user.profileImg.isNotEmpty) {
            _downloadURL = user.profileImg;
          }
        });
      } else {
        print("No se encontró información del usuario.");
      }
    } catch (e) {
      print("Error al cargar el perfil: $e");
    }
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
              'Información Personal',
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
          child: Form( // Añadir el formulario aquí
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null
                      ? FileImage(File(_image!.path)) as ImageProvider
                      : (_downloadURL != null && _downloadURL!.isNotEmpty
                      ? NetworkImage(_downloadURL!)
                      : AssetImage('assets/images/profile_pic.png')) as ImageProvider,
                ),
                TextButton(
                  onPressed: _pickImage,
                  child: Text(
                    'Cambiar foto',
                    style: TextStyle(color: Color(0xff6D5BFF)),
                  ),
                ),
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
                  validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
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
                  validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
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
                  label: 'Ingrese su número celular',
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Género',
                    style: TextStyle(
                      color: Color(0xff585858),
                      fontSize: 15.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                CustomSelectInput(
                  label: 'Seleccione un género',
                  value: genderController.text,
                  options: const ['Masculino', 'Femenino', 'Otro'],
                  onChanged: (String? newValue) {
                    setState(() {
                      genderController.text = newValue ?? '';
                    });
                  },
                  validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
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
                  label: 'Selecciona una fecha',
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Si hay una imagen seleccionada, intenta subirla primero
                      if (_image != null) {
                        await _uploadImage(); // Espera a que se suba la imagen
                      }

                      // Verifica si el formulario es válido antes de proceder
                      if (_formKey.currentState?.validate() == true) {
                        final editProfileProvider = Provider.of<EditProfileProvider>(context, listen: false);

                        // Formato de la fecha
                        String formattedBirthDate = "";
                        if (birthDateController.text.isNotEmpty) {
                          try {
                            final inputFormat = DateFormat('dd/MM/yyyy'); // Formato de entrada
                            final outputFormat = DateFormat('yyyy-MM-dd'); // Formato de salida
                            final dateTime = inputFormat.parse(birthDateController.text);
                            formattedBirthDate = outputFormat.format(dateTime);
                          } catch (e) {
                            print("Error al formatear la fecha: $e");
                          }
                        }

                        // Utiliza el enlace de la imagen subido, si está disponible
                        String imageUrl = _downloadURL ?? "";

                        // Llama a la función para editar el perfil
                        bool success = await editProfileProvider.editProfile(
                          idController.text,
                          nameController.text,
                          lastNameController.text,
                          phoneController.text,
                          genderController.text,
                          formattedBirthDate,
                          imageUrl,
                        );

                        // Muestra un mensaje según el resultado
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Perfil actualizado exitosamente.'),
                            ),
                          );
                          // También actualiza los datos en la base de datos local
                          LocalStorageService localStorageService = LocalStorageService();
                          await localStorageService.updateUser(User(
                            id: idController.text,
                            firstName: nameController.text,
                            lastName: lastNameController.text,
                            phone: phoneController.text,
                            gender: genderController.text,
                            birthday: formattedBirthDate,
                            profileImg: imageUrl,
                            email: "", // Asigna el email del usuario si es necesario
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No se pudo actualizar el perfil.'),
                            ),
                          );
                        }
                      }
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
