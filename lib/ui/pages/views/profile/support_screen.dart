import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrecap/ui/constants/constants.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                'Soporte y Ayuda',
                style: TextStyle(
                  color: Color(0xff212121), // Cambia el color del texto del título
                  fontSize: 20.sp, // Ajusta el tamaño del texto según tu diseño
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
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
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
              content:
              'Solo tienes que subir el PDF de tu resumen o clase, seleccionar el tipo de juego que quieres, el número de preguntas que quieres responder, el tiempo que quieres para cada pregunta, y ¡voilá! ¡Tu actividad está lista para poner a prueba tus habilidades!',
            ),
            const SizedBox(height: 10),
            _buildExpansionTile(
              title: '¿Cómo juego el quiz?',
              content:
              'Puedes jugar el quiz accediendo a la sección de juegos, seleccionando el quiz que generaste, y respondiendo a las preguntas dentro del tiempo establecido.',
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity, // Ocupa todo el ancho disponible
              child: ElevatedButton.icon(
                onPressed: () {
                  _showReportDialog(context);
                },
                icon: const Icon(Icons.report, color: Colors.white),
                label: const Text(
                  'Reportar un error',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6D5BFF), // Color de fondo
                  padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5, // Añade sombra para un efecto elevado
                ),
              ),
            )
          ],
        ),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que el diálogo se ajuste cuando aparece el teclado
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom, // Ajusta la posición según el teclado
            top: 16.0,
          ),
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
                        color: Color(0xff424242)
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: TextStyle(
                    color: Color(0xFF676767),
                  ),
                  floatingLabelStyle: TextStyle(
                    color: kPrimary,
                  ),
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
                ),
                style: TextStyle(
                  color: Color(0xFF585858),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  labelStyle: TextStyle(
                    color: Color(0xFF676767),
                  ),
                  floatingLabelStyle: TextStyle(
                    color: kPrimary,
                  ),
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
                  alignLabelWithHint: true,
                ),
                style: TextStyle(
                  color: Color(0xFF585858),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 5,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6D5BFF),
                    padding: const EdgeInsets.symmetric(vertical: 19),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
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
        );
      },
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
          color: _isExpanded ? Color(0xFF6D5BFF) : Color(0xFFC6C6C6), // Cambia el color según el estado
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text(
                widget.content,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
          ],
          textColor: Color(0xFF6D5BFF),
          iconColor: Color(0xFF6D5BFF),
          collapsedTextColor: Colors.black,
          collapsedIconColor: Colors.black,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: const EdgeInsets.only(bottom: 16.0),
          onExpansionChanged: (bool expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
        ),
      ),
    );
  }
}
