import 'package:flutter/material.dart';
import 'package:quickrecap/ui/constants/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Container
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            color: kPrimary, // Cambia esto por el color que prefieras
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image icon
                CircleAvatar(
                  radius: 25,
                  backgroundImage:
                      AssetImage('assets/avatar.png'), // Coloca tu imagen aquí
                ),
                SizedBox(width: 10),
                // Text
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hola, Diego!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '¿Listo para aprender?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // White container with shadow
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3), // Shadow position
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First row with icons and counts
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Activities
                    Column(
                      children: [
                        Text(
                          'Actividades',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Icon(Icons.videogame_asset, color: kPrimary),
                        Text(
                          '125',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: kDark,
                          ),
                        ),
                      ],
                    ),
                    // PDFs
                    Column(
                      children: [
                        Icon(Icons.picture_as_pdf, color: kPrimary),
                        SizedBox(height: 5),
                        Text(
                          'PDFs',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '72',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Players
                    Column(
                      children: [
                        Icon(Icons.people, color: kPrimary),
                        SizedBox(height: 5),
                        Text(
                          'Jugadores',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '100',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Second row with text and button
                const Text(
                  '¡Empieza a crear tus propios desafíos!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción del botón
                    },
                    style: ElevatedButton.styleFrom(
                      iconColor: kPrimary, // Color del botón
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Crear Actividad',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
