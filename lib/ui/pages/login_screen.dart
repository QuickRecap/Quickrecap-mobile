import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/user.dart';
import '../../ui/providers/login_provider.dart';
import '../widgets/custom_input.dart';
import '../../data/repositories/local_storage_service.dart';

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
  final LocalStorageService _storageService = LocalStorageService();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    final credentials = await _storageService.getCredentials();
    if (credentials != null) {
      setState(() {
        emailController.text = credentials['email'];
        passwordController.text = credentials['password'];
        _rememberMe = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/background-authentication.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 62.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Text(
                          "QUICK\nRECAP",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 57,
                            height: 0.98,
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
                      const SizedBox(height: 40),
                      CustomInput(
                        controller: emailController,
                        label: 'Correo',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu correo';
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
                            return 'Por favor ingresa tu contraseña';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (bool? value) {
                              setState(() {
                                _rememberMe = value ?? false;
                                if (_rememberMe == false) {
                                  _storageService.clearCredentials();
                                }
                              });
                            },
                            activeColor: Colors
                                .white, // El color del fondo cuando está activo
                            checkColor: const Color(
                                0xFF7566FC), // Color del check dentro del checkbox
                            side: const BorderSide(
                                color: Colors.white, width: 2), // Borde blanco
                          ),
                          const Text(
                            'Recordar credenciales',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(
                        color: Colors.white
                            .withOpacity(0.5), // Blanco al 50% de opacidad
                        thickness: 2, // 2 píxeles de alto
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: SizedBox(
                          width:
                              200, // Ajusta este valor para cambiar el ancho del botón
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: const Color(0xFFFF6803),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Aumentado el radio del borde
                              ),
                              textStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              foregroundColor: Colors.white,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text("Iniciar Sesion"),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text(
                          'Registrarme',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
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
        final loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
        User? user = await loginProvider.login(
          emailController.text,
          passwordController.text,
        );

        if (user != null) {
          // Guardar credenciales
          if (_rememberMe) {
            await _storageService.saveCredentials(
              emailController.text,
              passwordController.text,
              true,
            );
          } else {
            await _storageService.clearCredentials();
          }

          // Guardar usuario actual
          await _storageService.saveUser(user);

          Navigator.pushNamed(context, '/entrypoint');
          //navigateToProfileInformation(context, user);
        } else {
          _showErrorSnackBar(
              "Login fallido. Por favor verifica tus credenciales.");
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
