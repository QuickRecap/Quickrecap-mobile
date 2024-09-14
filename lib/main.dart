import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quickrecap/ui/pages/entrypoint.dart';

// void main() {
//   // Crear una instancia de UserApi
//   final userApi = UserApi();

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//             create: (_) => LoginProvider(
//                 LoginUseCase(
//                     UserRepositoryImpl(userApi)
//                 )
//             )
//         ),
//       ],
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Login Demo',
//       debugShowCheckedModeBanner: false, // Desactiva el banner de "Debug"
//       theme: ThemeData(
//         fontFamily: 'Poppins',
//         primarySwatch: Colors.blue,
//       ),
//       home: LoginScreen(),
//     );
//   }
// }

Widget defaultHome = MainScreen();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 825),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Foodly',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            primarySwatch: Colors.grey
          ),
          home: defaultHome,
        );
      },
    );
  }
}