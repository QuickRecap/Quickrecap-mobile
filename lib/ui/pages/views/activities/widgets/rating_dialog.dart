import 'package:flutter/material.dart';
import '../../../../providers/rate_activity_provider.dart';
import 'package:provider/provider.dart';

class RatingDialog extends StatefulWidget {
  final int activityId;
  final String activityType;

  RatingDialog({
    required this.activityId,
    required this.activityType
  });

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _rating = 0;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    // Limpia el controlador cuando se destruya el widget
    _commentController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Detecta el teclado
      ),
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width, // Ocupar todo el ancho
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Barra superior con el botón de cerrar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Califica este juego',
                    style: TextStyle(
                      fontSize: 23,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 48), // Espacio para alinear el texto
                ],
              ),
              const SizedBox(height: 16),

              // Texto adicional
              Text(
                'Tu opinión es muy importante',
                style: TextStyle(color: Colors.grey, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),

              // Fila de estrellas interactivas
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: IconButton(
                      icon: Icon(
                        index < _rating ? Icons.star : Icons.star_border, // Cambia el icono de estrella según el rating
                        size: 36,
                        color: index < _rating ? Colors.orange : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _rating = index + 1; // Actualiza el rating
                        });
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              // Campo de texto para el comentario
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Déjanos un comentario',
                  hintStyle: TextStyle(color: Color(0xff585858)), // Color de las letras del contenido
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xffF1F1F1)), // Color del borde
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xffF1F1F1)), // Color del borde cuando está habilitado
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xffF1F1F1)), // Color del borde cuando está enfocado
                  ),
                  filled: true,
                  fillColor: Color(0xffF1F1F1), // Color de fondo
                ),
                style: TextStyle(color: Color(0xff585858), fontFamily: "Poppins"), // Color del texto ingresado
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              // Botón de enviar
              FractionallySizedBox(
                widthFactor: 0.7, // Ajusta el ancho relativo del botón
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;  // Activa el loading
                      });

                      final rateActivityProvider = Provider.of<RateActivityProvider>(context, listen: false);

                      try {
                        bool success = await rateActivityProvider.rateActivity(widget.activityId, widget.activityType, _rating,_commentController.text);

                        if (success) {
                          Navigator.of(context).pop(); // Cierra el diálogo si la respuesta es exitosa
                          _showSuccessSnackBar('Error reportado exitosamente.');
                        } else {
                          Navigator.of(context).pop();
                          _showErrorSnackBar('No se pudo calificar la actividad.');
                        }
                      } catch (e) {
                        Navigator.of(context).pop();
                        _showErrorSnackBar('Ocurrió un error inesperado. Por favor, inténtalo de nuevo.');
                      } finally {
                        _rating=0;
                        _commentController.clear();

                        setState(() {
                          _isLoading = false;  // Desactiva el loading
                        });
                      }
                    }
                  },
                  child: Text(
                    'Enviar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
