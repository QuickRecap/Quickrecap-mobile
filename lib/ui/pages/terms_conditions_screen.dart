import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Términos y Condiciones',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF7C6AF7), // Color púrpura del encabezado
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Colors.white, // Fondo blanco puro #FFFFFF
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Términos y Condiciones de Uso',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Última actualización: [Fecha]',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Bienvenido a Quick Recap. Al utilizar nuestra aplicación, usted acepta los siguientes términos y condiciones:',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              _buildSection('1. Uso de la Aplicación',
                  'Quick Recap es una herramienta diseñada para [descripción breve]. Usted se compromete a utilizar la aplicación de manera responsable y de acuerdo con todas las leyes aplicables.'),
              _buildSection('2. Registro de Cuenta',
                  'Para utilizar ciertas funciones de la aplicación, puede ser necesario registrarse. Usted es responsable de mantener la confidencialidad de su cuenta y contraseña.'),
              _buildSection('3. Privacidad',
                  'Su privacidad es importante para nosotros. Por favor, consulte nuestra Política de Privacidad para entender cómo recopilamos, usamos y protegemos sus datos personales.'),
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
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Text(
          content,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}