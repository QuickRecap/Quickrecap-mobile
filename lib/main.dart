import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickrecap/ui/pages/entrypoint.dart';
import 'application/login_use_case.dart';
import 'application/register_use_case.dart';
import 'data/repositories/user_repository_impl.dart';
import 'ui/pages/login_screen.dart';
import 'ui/pages/register_screen.dart';
import 'ui/pages/terms_conditions_screen.dart';
import 'ui/pages/views/profile/configuration_screen.dart';
import 'ui/pages/views/profile/support_screen.dart';
import 'ui/providers/login_provider.dart';
import 'ui/providers/register_provider.dart';
import 'data/api/user_api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Importar flutter_screenutil

void main() {
  // Crear una instancia de UserApi
  final userApi = UserApi();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => LoginProvider(
              LoginUseCase(UserRepositoryImpl(userApi)),
            )),
        ChangeNotifierProvider(
            create: (_) => RegisterProvider(
              RegisterUseCase(UserRepositoryImpl(userApi)),
            )),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inicializar ScreenUtil con un tamaño de diseño
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Ajusta según el diseño de tu app
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Login Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Poppins',
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(
              fontSizeFactor: 1.sp, // Ajustar el tamaño del texto
            ),
          ),
          initialRoute: '/login', // Establecer la ruta inicial
          routes: {
            '/login': (context) => LoginScreen(), // Ruta para la pantalla de Login
            '/register': (context) => const RegisterScreen(), // Ruta para la pantalla de Registro
            '/terms_conditions': (context) => TermsConditionsScreen(),
            '/entrypoint': (context) => MainScreen(),
            '/configuration': (context) => ConfigurationScreen(),
            '/support': (context) => SupportScreen(),
          },
        );
      },
      child: const HomePage(title: 'First Method'), // Widget principal de la app
    );
  }
}

class HomePage extends StatelessWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          'Bienvenido a la App',
          style: TextStyle(fontSize: 24.sp), // Ejemplo de uso de ScreenUtil
        ),
      ),
    );
  }
}
