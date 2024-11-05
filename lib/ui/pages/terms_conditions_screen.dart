import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Términos y Condiciones',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF7C6AF7), // Color púrpura del encabezado
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Colors.white, // Fondo blanco puro #FFFFFF
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Términos y Condiciones de Uso',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Última actualización: 5/11/2024',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Bienvenido a Quick Recap. Al utilizar nuestra aplicación, usted acepta los siguientes términos y condiciones:',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              _buildSection('1. Uso de la Aplicación',
                  'Quick Recap es una herramienta diseñada para facilitar y reforzar el aprendizaje mediante actividades generadas apartir de archivos de formato PDF. Usted se compromete a utilizar la aplicación de manera responsable y de acuerdo con todas las leyes aplicables.'),
              _buildSection('2. Registro de Cuenta',
                  'Para utilizar ciertas funciones de la aplicación, puede ser necesario registrarse. Usted es responsable de mantener la confidencialidad de su cuenta y contraseña.'),
              _buildSection(
                  '3. Privacidad',
                  'Valoramos y respetamos su privacidad. Nos comprometemos a proteger la información personal de nuestros usuarios. Esta aplicación móvil es parte de un proyecto de tesis y no tiene fines comerciales. Está destinada exclusivamente a usuarios seleccionados para la fase de prueba y validación de nuestra investigación.'
              ),
              _buildSection('4. Propiedad Intelectual',
                  'Todo el contenido presente en Quick Recap, incluyendo pero no limitado a textos, gráficos, logotipos, iconos, imágenes, clips de audio, descargas digitales y compilaciones de datos, es propiedad de Quick Recap o de sus proveedores de contenido y está protegido por las leyes de propiedad intelectual.'),
              // ... (otros sections)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}