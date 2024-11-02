import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickrecap/ui/constants/constants.dart';
import '../../../../../domain/entities/activity.dart';
import '../../../../../data/repositories/local_storage_service.dart';

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
  bool isLoading = false;
  late bool isFavorite;
  final LocalStorageService localStorageService = LocalStorageService();

  @override
  void initState() {
    super.initState();
    isFavorite = widget.activity.favorite;
  }

  Future<void> _updateFavoriteStatus() async {
    setState(() {
      isLoading = true;
    });

    try {
      int userId = await localStorageService.getCurrentUserId();
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/quickrecap/favorite/update/${widget.activity.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'favorito': !isFavorite,
          'user': userId,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isFavorite = !isFavorite;
          widget.onFavoriteUpdated(widget.activity.id);
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No pudimos agregar esta actividad a tus favoritos'),
              backgroundColor: Color(0xffFFCFD0),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error de conexión: $e'),
            backgroundColor: Color(0xffFFCFD0),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
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
                          onTap: _updateFavoriteStatus,
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
