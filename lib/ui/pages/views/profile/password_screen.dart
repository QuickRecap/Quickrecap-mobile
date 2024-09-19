import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: Text('Cambiar Contraseña',
              style: TextStyle(
                color: const Color(0xff212121), // Cambia el color del texto del título
                fontSize: 20.sp, // Ajusta el tamaño del texto según tu diseño
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Contraseña actual',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              obscureText: true,
              style: const TextStyle(
                color: Color(0xFF585858), // Color del texto de la contraseña
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
              cursorColor: const Color(0xFF585858),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Contraseña nueva',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              obscureText: true,
              style: const TextStyle(
                color: Color(0xFF585858), // Color del texto de la contraseña
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
              cursorColor: const Color(0xFF585858), // Color de la barra parpadeante
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Repetir contraseña nueva',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              obscureText: true,
              style: const TextStyle(
                color: Color(0xFF585858), // Color del texto de la contraseña
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
              cursorColor: const Color(0xFF585858),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Implement password update logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff6D5BFF),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
              child: const Text('Actualizar contraseña',style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 19,
                color: Colors.white
              )),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Implement cancel logic here
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
              child: const Text('Cancelar',style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 19,
                color: Color(0xff585858),
              )),
            ),
          ],
        ),
      ),
    );
  }
}