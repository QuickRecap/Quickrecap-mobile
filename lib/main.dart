import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'application/login_use_case.dart';
import 'data/repositories/user_repository_impl.dart';
import 'ui/pages/login_screen.dart';
import 'ui/providers/login_provider.dart';
import 'data/api/user_api.dart';

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
                )
            )
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Demo',
      debugShowCheckedModeBanner: false, // Desactiva el banner de "Debug"
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}