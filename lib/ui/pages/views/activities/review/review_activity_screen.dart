import 'package:flutter/material.dart';
import 'widget/info_container.dart';

class ReviewActivityScreen extends StatefulWidget {
  const ReviewActivityScreen({super.key});

  @override
  State<ReviewActivityScreen> createState() => _ReviewActivityScreenState();
}

class _ReviewActivityScreenState extends State<ReviewActivityScreen> {
  int _rating = 0; // Variable para almacenar el rating seleccionado
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con imagen
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background-authentication.png'), // Tu imagen de fondo
                fit: BoxFit.cover, // Ajuste de la imagen
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Quiz \n completado',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 47,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white.withOpacity(1),
                        width: 4, // Ajusta este valor según el grosor deseado
                      ),
                    ),
                    child: Text(
                      '+900 puntos',
                      style: TextStyle(
                        fontSize: 36,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff7768fc), // Fondo transparente
                      foregroundColor: Colors.white, // Letra blanca
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white), // Borde blanco
                        borderRadius: BorderRadius.circular(17), // Bordes redondeados
                      ),
                    ),
                    onPressed: () => _showRatingBottomSheet(context),
                    child: Text(
                      'Calificar juego',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Colors.white, // Asegurarse de que el texto sea blanco
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InfoContainer(
                        title: 'Tiempo',
                        value: '05:15',
                        icon: Icons.timer,
                      ),
                      InfoContainer(
                        title: 'Puntuacion',
                        value: '9/10',
                        icon: Icons.adjust,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Botón 'Continuar'
                  SizedBox(
                    width: 300, // Aquí puedes ajustar el ancho para todos los botones
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF6803), // Color #FF6803
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        // Acción del botón
                      },
                      child: Text(
                        'Continuar',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Botón 'Ver respuestas' (Fondo transparente con borde blanco)
                  SizedBox(
                    width: 300,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white), // Borde blanco
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        // Acción del botón
                      },
                      child: Text(
                        'Ver respuestas',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Botón 'Volver a intentar' (Fondo transparente con borde blanco)
                  SizedBox(
                    width: 300,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white), // Borde blanco
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        // Acción del botón
                      },
                      child: Text(
                        'Volver a intentar',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRatingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // Importante para que el modal pueda expandirse con el teclado
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                          onPressed: () {
                            // Acción al presionar enviar
                            Navigator.pop(context); // Cierra el modal
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
          },
        );
      },
    );
  }
}
