import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrecap/main.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF000000)), // Color negro
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: Text('Configuración'),
        backgroundColor: Colors.white, // Color del AppBar
        elevation: 0, // Sin sombra en el AppBar
        centerTitle: true, // Centra el título
        titleTextStyle: TextStyle(
          color: Color(0xff212121), // Cambia el color del texto del título
          fontSize: 25.sp, // Ajusta el tamaño del texto según tu diseño
          fontWeight: FontWeight.w600,
        ), // Color del ícono
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w), // Margen
        child: Column(
          children: [
            _buildListTile(
              context,
              icon: Icons.person,
              text: 'Información Personal',
              onTap: () {
                //navigateToProfileInformation(context, user);
                //Navigator.pushNamed(context, '/information');
                // Acción al presionar
              },
            ),
            Divider(),
            _buildListTile(
              context,
              icon: Icons.lock,
              text: 'Cambiar Contraseña',
              onTap: () {
                Navigator.pushNamed(context, '/password');
                // Acción al presionar
              },
            ),
            Divider(),
            _buildListTile(
              context,
              icon: Icons.music_note,
              text: 'Música y Efectos',
              onTap: () {
                // Acción al presionar
              },
            ),
            Divider(),
            _buildListTile(
              context,
              icon: Icons.help,
              text: 'Soporte y Ayuda',
              onTap: () {
                Navigator.pushNamed(context, '/support');
                // Acción al presionar
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon, required String text, required Function() onTap}) {
    return ListTile(
      leading: Container(
        height: 40.w, // Ajuste del tamaño del contenedor
        width: 40.w,
        decoration: BoxDecoration(
          color: Color(0xFFEBEAFC), // Color púrpura de fondo
          borderRadius: BorderRadius.circular(12.r), // Forma circular con esquinas redondeadas
        ),
        child: Icon(icon, color: Color(0xFF6D5BFF), size: 24.sp), // Ícono con color púrpura más oscuro
      ),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 16.sp, // Ajuste del tamaño del texto
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 18.sp, color: Color(
          0xff8e9094)), // Flecha
      contentPadding: EdgeInsets.symmetric(vertical: 8.h), // Espaciado vertical
      onTap: onTap,
    );
  }
}
