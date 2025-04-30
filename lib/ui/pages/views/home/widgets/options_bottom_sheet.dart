import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickrecap/ui/constants/constants.dart';
import '../../../../../domain/entities/activity.dart';
import '../../../../../data/repositories/local_storage_service.dart';
import '../../../../../data/api/api_constants.dart';

class OptionsBottomSheet extends StatefulWidget {
  final Activity activity;
  final Function(int) onFavoriteUpdated;

  const OptionsBottomSheet({
    Key? key,
    required this.activity,
    required this.onFavoriteUpdated,
  }) : super(key: key);

  static void show(BuildContext context, Activity activity, Function(int) onFavoriteUpdated) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return OptionsBottomSheet(
          activity: activity,
          onFavoriteUpdated: onFavoriteUpdated,
        );
      },
    );
  }

  @override
  State<OptionsBottomSheet> createState() => _OptionsBottomSheetState();
}

class _OptionsBottomSheetState extends State<OptionsBottomSheet> {
  String baseUrl = ApiConstants.baseUrl;
  bool isLoading = false;
  late bool isFavorite;
  final LocalStorageService localStorageService = LocalStorageService();
  Timer? timeoutTimer;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.activity.favorite;
  }

  @override
  void dispose() {
    timeoutTimer?.cancel();
    super.dispose();
  }

  Future<void> _updateFavoriteStatus() async {
    // Mostrar el indicador de carga
    setState(() {
      isLoading = true;
    });

    // Crear un temporizador de 30 segundos
    bool requestCompleted = false;

    // Iniciar el temporizador
    timeoutTimer = Timer(Duration(seconds: 30), () {
      if (!requestCompleted && mounted) {
        // Si no se completó la solicitud en 30 segundos:
        // 1. Cerrar el diálogo
        Navigator.of(context).pop();

        // 2. Mostrar el mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No pudimos conectar con el servidor. Inténtalo más tarde.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    try {
      int userId = await localStorageService.getCurrentUserId();
      final response = await http.post(
        Uri.parse('$baseUrl/favorite/update/${widget.activity.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'favorito': !isFavorite,
          'user': userId,
        }),
      );

      // Marcar la solicitud como completada
      requestCompleted = true;

      // Cancelar el temporizador si se completó la solicitud
      timeoutTimer?.cancel();

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            isFavorite = !isFavorite;
            isLoading = false;
          });
          widget.onFavoriteUpdated(widget.activity.id);
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No pudimos actualizar esta actividad en tus favoritos'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      // Marcar la solicitud como completada (aunque sea con error)
      requestCompleted = true;

      // Cancelar el temporizador
      timeoutTimer?.cancel();

      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error de conexión: $e'),
            backgroundColor: Color(0xffFFCFD0),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.close, size: 30, weight: 700),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'Informacion de la actividad',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    fontSize: 20,
                  ),
                ),
                SizedBox(width: 48),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 6, bottom: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 40,
                        child: GestureDetector(
                          onTap: isLoading ? null : _updateFavoriteStatus,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                isLoading
                                    ? SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFB3B3B3),
                                    strokeWidth: 2,
                                  ),
                                )
                                    : Icon(
                                  Icons.bookmark,
                                  color: isFavorite ? Color(0xffffd100) : Color(0xff4d4a4b),
                                  size: 30,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  isFavorite ? "Quitar de \nfavoritos" : "Agregar a \nfavoritos",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0XFF212121),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        flex: 40,
                        child: Container(
                          height: 67,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.category,
                                color: Color(0xff4d4a4b),
                                size: 30,
                              ),
                              SizedBox(width: 10),
                              Text(
                                widget.activity.activityType,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0XFF212121),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.only(left: 6, bottom: 7),
                  child: Text(
                    'Nombre:',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: kPrimaryLight.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    widget.activity.name ?? 'Sin nombre',
                    style: TextStyle(
                      color: kPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xffefefef),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: Size(100, 60),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text(
                      'Cerrar',
                      style: TextStyle(
                        color: Color(0xff474747),
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}