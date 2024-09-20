import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickrecap/ui/constants/constants.dart';
import '../widgets/custom_input.dart';
import '../../ui/providers/register_provider.dart';
import '../widgets/custom_select_input.dart';  // Importa tu CustomSelectInput

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _acceptTerms = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/background-register.png',
              fit: BoxFit.cover,
            ),
          ),
          // Contenido
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  const Center(
                    child: Text(
                      "QUICK\nRECAP",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 38,
                        height: 1,
                        color: kWhite,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 4),
                            blurRadius: 30.0,
                            color: Color.fromARGB(70, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "Registra una cuenta",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomInput(
                            controller: nameController,
                            label: 'Nombre',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su nombre';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomInput(
                            controller: lastNameController,
                            label: 'Apellidos',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese sus apellidos';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CustomSelectInput(
                                  label: 'Género',
                                  value: genderController.text.isEmpty ? null : genderController.text,
                                  options: const ['Masculino', 'Femenino', 'Otro'],
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      genderController.text = newValue ?? '';
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor selecciona un género';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),Expanded(
                                flex: 1,
                                child: CustomInput(
                                  controller: phoneController,
                                  label: 'Celular',
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingrese su número de celular';
                                    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                                      return 'El número de celular solo debe contener dígitos';
                                    } else if (value.length < 9) {
                                      return 'El número de celular debe tener al menos 9 dígitos';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          CustomInput(
                            controller: emailController,
                            label: 'Correo',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su correo electrónico';
                              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Ingrese un correo electrónico válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomInput(
                            controller: passwordController,
                            label: 'Contraseña',
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su contraseña';
                              } else if (value.length < 6) {
                                return 'La contraseña debe tener al menos 6 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomInput(
                            controller: repeatPasswordController,
                            label: 'Repetir Contraseña',
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor repita su contraseña';
                              } else if (value != passwordController.text) {
                                return 'Las contraseñas no coinciden';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Checkbox(
                                value: _acceptTerms,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _acceptTerms = value ?? false;
                                  });
                                },
                                activeColor: kSecondary,
                                checkColor: kWhite,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/terms_conditions');
                                  },
                                  child: const Text.rich(
                                    TextSpan(
                                      text: 'Acepto los ',
                                      style: TextStyle(
                                        color: kGrey,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Términos y Condiciones y Políticas de privacidad',
                                          style: TextStyle(
                                            color: kGrey,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleRegister,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor: kSecondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                minimumSize: const Size(200, 50),
                                textStyle: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kWhite
                                ),
                                foregroundColor: kWhite, // Aquí se establece el color del texto
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: kWhite,
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Text("Registrarme"),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Ya tienes una cuenta?',
                                style: TextStyle(
                                  color:kGrey,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: const Text(
                                  'Inicia sesión',
                                  style: TextStyle(
                                    color: kPrimary,
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        _showErrorSnackBar("Debes aceptar los Términos y Condiciones.");
        return;
      }

      setState(() => _isLoading = true);

      try {
        final registerProvider = Provider.of<RegisterProvider>(context, listen: false);
        bool success = await registerProvider.register(
          nameController.text,
          lastNameController.text,
          genderController.text,
          phoneController.text,
          emailController.text,
          passwordController.text,
        ).timeout(Duration(seconds: 15)); // Añadimos un timeout de 15 segundos

        if (success) {
          Navigator.pushNamed(context, '/login');
        } else {
          _showErrorSnackBar("Registro fallido. Por favor verifica tus datos.");
        }
      } on TimeoutException {
        _showErrorSnackBar("El registro está tardando demasiado. Por favor, verifica tu conexión a internet e inténtalo de nuevo.");
      } catch (e) {
        _showErrorSnackBar("Ocurrió un error durante el registro. Inténtalo de nuevo.");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    genderController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }
}
