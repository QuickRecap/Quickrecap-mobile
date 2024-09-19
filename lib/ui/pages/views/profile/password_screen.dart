import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Cambiar Contraseña',
              style: TextStyle(
                color: Color(0xff212121), // Cambia el color del texto del título
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
              style: TextStyle(
                color: Color(0xFF585858), // Color del texto de la contraseña
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
              cursorColor: Color(0xFF585858),
            ),
            SizedBox(height: 16),
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
              style: TextStyle(
                color: Color(0xFF585858), // Color del texto de la contraseña
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
              cursorColor: Color(0xFF585858), // Color de la barra parpadeante
            ),
            SizedBox(height: 16),
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
              style: TextStyle(
                color: Color(0xFF585858), // Color del texto de la contraseña
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
              cursorColor: Color(0xFF585858),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Implement password update logic here
              },
              child: Text('Actualizar contraseña',style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 19,
                color: Colors.white
              )),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff6D5BFF),
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Implement cancel logic here
              },
              child: Text('Cancelar',style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 19,
                color: Color(0xff585858),
              )),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}