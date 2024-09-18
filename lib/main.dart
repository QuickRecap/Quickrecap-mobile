import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickrecap/ui/pages/entrypoint.dart';
import 'application/login_use_case.dart';
import 'application/register_use_case.dart';
import 'data/repositories/user_repository_impl.dart';
import 'ui/pages/login_screen.dart';
import 'ui/pages/register_screen.dart';
import 'ui/pages/terms_conditions_screen.dart';
import 'ui/providers/login_provider.dart';
import 'ui/providers/register_provider.dart';
import 'data/api/user_api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  // Crear una instancia de UserApi
  final userApi = UserApi();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => LoginProvider(
              LoginUseCase(
                  UserRepositoryImpl(userApi)
              ),
            )
        ),
        ChangeNotifierProvider(
            create: (_) => RegisterProvider(
              RegisterUseCase(
                  UserRepositoryImpl(userApi)
              ),
            )
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login', // Establecer la ruta inicial
      routes: {
        '/login': (context) => LoginScreen(),  // Ruta para la pantalla de Login
        '/register': (context) => const RegisterScreen(),  // Ruta para la pantalla de Registro
        '/terms_conditions': (context) => TermsConditionsScreen(),
        '/entrypoint': (context) => MainScreen(),
      },
    );
  }
}
