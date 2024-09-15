import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_input.dart';
import '../../ui/providers/register_provider.dart';

class RegisterScreen extends StatefulWidget {
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
                  SizedBox(height: 60),
                  Center(
                    child: Text(
                      "QUICK\nRECAP",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 42,
                        height: 1,
                        color: Colors.white,
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
                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Registra una cuenta",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          CustomInput(
                            controller: nameController,
                            label: 'Nombre',
                          ),
                          SizedBox(height: 16),
                          CustomInput(
                            controller: lastNameController,
                            label: 'Apellidos',
                          ),
                          SizedBox(height: 16),
                          CustomInput(
                            controller: genderController,
                            label: 'Género',
                          ),
                          SizedBox(height: 16),
                          CustomInput(
                            controller: phoneController,
                            label: 'Celular',
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 16),
                          CustomInput(
                            controller: emailController,
                            label: 'Correo',
                          ),
                          SizedBox(height: 16),
                          CustomInput(
                            controller: passwordController,
                            label: 'Contraseña',
                            obscureText: true,
                          ),
                          SizedBox(height: 16),
                          CustomInput(
                            controller: repeatPasswordController,
                            label: 'Repetir Contraseña',
                            obscureText: true,
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Checkbox(
                                value: _acceptTerms,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _acceptTerms = value ?? false;
                                  });
                                },
                                activeColor: Color(0xFFFF6803),
                                checkColor: Colors.white,
                              ),
                              Expanded(
                                child: Text(
                                  'Acepto los Términos y Condiciones y Políticas de privacidad',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _handleRegister,
                            child: _isLoading
                                ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : Text("Registrarme"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Color(0xFFFF6803),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              minimumSize: Size(double.infinity, 50),
                              textStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Ya tienes una cuenta?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: Text(
                                  'Inicia sesión',
                                  style: TextStyle(
                                    color: Color(0xFF7566FC),
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
        );

        if (success) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          _showErrorSnackBar("Registro fallido. Por favor verifica tus datos.");
        }
      } catch (e) {
        _showErrorSnackBar("Ocurrió un error. Inténtalo de nuevo.");
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
