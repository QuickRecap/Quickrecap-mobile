import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../ui/constants/constants.dart';
import '../../../../ui/providers/support_provider.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Soporte y Ayuda',
              style: TextStyle(
                color: Color(0xff212121),
                fontSize: 20.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildExpansionTile(
              title: '¿Qué es QuickRecap?',
              content: 'QuickRecap es una plataforma que te permite generar cuestionarios a partir de tus archivos de resumen o clases.',
            ),
            const SizedBox(height: 10),
            _buildExpansionTile(
              title: '¿Cómo puedo generar un quiz?',
              content: 'Solo tienes que subir el PDF de tu resumen o clase...',
            ),
            const SizedBox(height: 10),
            _buildExpansionTile(
              title: '¿Cómo juego el quiz?',
              content: 'Puedes jugar el quiz accediendo a la sección de juegos...',
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showReportDialog(context),
                icon: const Icon(Icons.report, color: Colors.white),
                label: const Text(
                  'Reportar un error',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6D5BFF),
                  padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _handleSendError() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;  // Activa el loading
      });

      final supportProvider = Provider.of<SupportProvider>(context, listen: false);

      try {
        bool success = await supportProvider.reportError(
          nameController.text,
          descriptionController.text,
        ).timeout(Duration(seconds: 10));

        if (success) {
          Navigator.of(context).pop(); // Cierra el diálogo si la respuesta es exitosa
          _showSuccessSnackBar('Error reportado exitosamente.');
        } else {
          _showErrorSnackBar('No se pudo reportar el error.');
        }

      } on TimeoutException {
        _showErrorSnackBar('La operación está tardando demasiado. Por favor, verifica tu conexión e inténtalo de nuevo.');
      } catch (e) {
        _showErrorSnackBar('Ocurrió un error inesperado. Por favor, inténtalo de nuevo.');
      } finally {
        setState(() {
          _isLoading = false;  // Desactiva el loading
        });
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildExpansionTile({required String title, required String content}) {
    return _CustomExpansionTile(
      title: title,
      content: content,
    );
  }

  void _showReportDialog(BuildContext context) {
    bool _isLoading = false; // Mueve el estado aquí

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 16.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Text(
                          'Reportar un error',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff424242),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      nameController,
                      'Nombre',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese su nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      descriptionController,
                      'Descripción',
                      isMultiline: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese una descripción';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {  // Cambia a async para poder usar await
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;  // Activa el loading
                            });

                            final supportProvider = Provider.of<SupportProvider>(context, listen: false);

                            try {
                              bool success = await supportProvider.reportError(
                                nameController.text,
                                descriptionController.text,
                              ).timeout(Duration(seconds: 10));

                              if (success) {
                                Navigator.of(context).pop(); // Cierra el diálogo si la respuesta es exitosa
                                _showSuccessSnackBar('Error reportado exitosamente.');
                              } else {
                                Navigator.of(context).pop();
                                _showErrorSnackBar('No se pudo reportar el error.');
                              }
                            } on TimeoutException {
                              Navigator.of(context).pop();
                              _showErrorSnackBar('La operación está tardando demasiado. Por favor, verifica tu conexión e inténtalo de nuevo.');
                            } catch (e) {
                              Navigator.of(context).pop();
                              _showErrorSnackBar('Ocurrió un error inesperado. Por favor, inténtalo de nuevo.');
                            } finally {
                              nameController.clear();
                              descriptionController.clear();

                              setState(() {
                                _isLoading = false;  // Desactiva el loading
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6D5BFF),
                          padding: const EdgeInsets.symmetric(vertical: 19),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                            : const Text(
                          'Enviar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildTextField(
      TextEditingController controller,
      String labelText,
      {bool isMultiline = false, String? Function(String?)? validator}
      ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Color(0xFF676767)),
        floatingLabelStyle: TextStyle(color: kPrimary),
        contentPadding: const EdgeInsets.all(10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF676767), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: kPrimary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF676767), width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        alignLabelWithHint: isMultiline, // Alinea el label con la parte superior en campos multilinea
      ),
      style: TextStyle(color: Color(0xFF585858)),
      keyboardType: isMultiline ? TextInputType.multiline : TextInputType.text,
      maxLines: isMultiline ? null : 1,
      minLines: isMultiline ? 5 : 1,
      validator: validator, // Validador añadido
    );
  }


}

class _CustomExpansionTile extends StatefulWidget {
  final String title;
  final String content;

  const _CustomExpansionTile({required this.title, required this.content});

  @override
  State<_CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<_CustomExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _isExpanded ? Color(0xFF6D5BFF) : Color(0xFFC6C6C6),
          width: 1.0,
        ),
      ),
      child: Theme(
        data: ThemeData().copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Text(
            widget.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff212121),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
              child: Text(
                widget.content,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ],
          onExpansionChanged: (isExpanded) {
            setState(() {
              _isExpanded = isExpanded;
            });
          },
        ),
      ),
    );
  }
}
