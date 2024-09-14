import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Importa el paquete flutter_svg
import 'package:provider/provider.dart';
import '../widgets/custom_input.dart'; // Asegúrate de que la ruta es correcta
import '../../ui/providers/login_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/background-authentication.png', // Ruta correcta del PNG
              fit: BoxFit.cover,
            ),
          ),

          // Contenido de la pantalla
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo y nombre de la app
                      Text(
                        "QUICK\nRECAP",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold, // o FontWeight.w700
                          fontSize: 57,
                          height: 0.98,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 4),  // Ajusta los valores según el efecto deseado
                              blurRadius: 30.0,
                              color: Color.fromARGB(70, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),

                      // Campo de correo electrónico utilizando CustomInput
                      CustomInput(
                        controller: emailController,
                        width: 300, // O cualquier otro valor que desees
                        label: 'Correo',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu correo';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Por favor ingresa un correo válido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Campo de contraseña utilizando CustomInput
                      CustomInput(
                        controller: passwordController,
                        width: 300, // O cualquier otro valor que desees
                        label: 'Contraseña',
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu contraseña';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Checkbox de 'Recordarme'
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (bool? value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                          ),
                          Text('Recordarme', style: TextStyle(color: Colors.white)),
                        ],
                      ),

                      SizedBox(height: 16),

                      // Botón de iniciar sesión
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("Iniciar Sesión"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Espacio entre el botón de iniciar sesión y el botón de registrarme
                      SizedBox(height: 16),

                      // Botón de registrarse
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          'Registrarme',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final loginProvider = Provider.of<LoginProvider>(context, listen: false);
        bool success = await loginProvider.login(
          emailController.text,
          passwordController.text,
        );

        if (success) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          _showErrorSnackBar("Login fallido. Por favor verifica tus credenciales.");
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
