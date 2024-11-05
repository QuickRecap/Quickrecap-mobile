import 'dart:async';

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

  bool _isLoading = false;

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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
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
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85, // Puedes ajustar la calidad de la imagen
    );

    if (image != null) {
      // Filtrar por formato válido
      final validFormats = ['jpg', 'jpeg', 'png'];
      final String fileExtension = path.extension(image.path).toLowerCase().replaceAll('.', '');

      if (!validFormats.contains(fileExtension)) {
        // Mostrar SnackBar si el formato no es válido
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Formato de imagen no válido. Seleccione una imagen JPG o PNG.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red, // Snack rojo para error
          ),
        );
      } else {
        // Si la imagen tiene un formato válido
        setState(() {
          _image = image;
        });
      }
    }
  }


  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() {
      _isUploading = true;
    });

    FirebaseStorage storage = FirebaseStorage.instance;
    // Obtener el nombre base del archivo primero
    String baseFileName = path.basename(_image!.path);

    // Componer el nombre del archivo usando idController.text + '_' + baseFileName
    String fileName = '${idController.text}';

    // Usar el nombre compuesto en la referencia de almacenamiento
    Reference storageRef = storage.ref().child('profile_pics/$fileName');

    try {
      await storageRef.putFile(File(_image!.path));
      String downloadURL = await storageRef.getDownloadURL();

      setState(() {
        _downloadURL = downloadURL;
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Imagen subida exitosamente',
            style: TextStyle(color: Colors.white), // Texto blanco
          ),
          backgroundColor: const Color(0xff6d5bff), // Color de fondo #6D5BFF
          duration: const Duration(seconds: 1),
        ),
      );
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
      backgroundColor: Colors.white,
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
                  backgroundColor: kWhite, // Color de fondo cuando se muestra el ícono
                  backgroundImage: _image != null
                      ? FileImage(File(_image!.path)) as ImageProvider
                      : (_downloadURL != null && _downloadURL!.isNotEmpty
                      ? NetworkImage(_downloadURL!)
                      : null), // No se establece una imagen si no hay URL o imagen seleccionada
                  child: (_image == null && (_downloadURL == null || _downloadURL!.isEmpty))
                      ? Icon(
                    Icons.person,
                    size: 30.sp,
                    color: kPrimary, // Ajusta este color según tu preferencia
                  )
                      : null, // El ícono solo aparece si no hay imagen o URL
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obligatorio';
                    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return 'El número de celular solo debe contener dígitos';
                    } else if (value.length < 9) {
                      return 'El número de celular debe tener al menos 9 dígitos';
                    }
                    return null;
                  },
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
                    onPressed: _isLoading
                        ? null
                        : () async {
                      try {
                        // Si hay una imagen seleccionada, intenta subirla primero
                        if (_image != null) {
                          setState(() => _isLoading = true);
                          await _uploadImage(); // Espera a que se suba la imagen
                        }

                        // Verifica si el formulario es válido antes de proceder
                        if (_formKey.currentState?.validate() == true) {
                          setState(() => _isLoading = true);

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
                          ).timeout(Duration(seconds: 10));

                          // Muestra un mensaje según el resultado
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Perfil actualizado exitosamente.',
                                  style: TextStyle(color: Colors.white), // Texto blanco
                                ),
                                backgroundColor: Colors.green, // Color verde para éxito
                              ),
                            );

                            // Actualiza los datos en la base de datos local
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
                              SnackBar(
                                content: const Text(
                                  'No se pudo actualizar el perfil.',
                                  style: TextStyle(color: Colors.white), // Texto blanco
                                ),
                                backgroundColor: Colors.red, // Color rojo para error
                              ),
                            );
                          }
                        }

                      } on TimeoutException {
                        _showErrorSnackBar("El registro está tardando demasiado. Por favor, verifica tu conexión a internet e inténtalo de nuevo.");
                      } catch (e) {
                        _showErrorSnackBar("Ocurrió un error durante el registro. Inténtalo de nuevo.");
                      } finally {
                        setState(() => _isLoading = false);
                      }
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                        : const Text(
                      'Enviar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
