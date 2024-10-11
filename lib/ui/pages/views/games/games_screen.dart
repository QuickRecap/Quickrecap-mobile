import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrecap/ui/constants/constants.dart';
import '../../../../data/repositories/local_storage_service.dart';
import '../../../../domain/entities/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  _GamesScreenState createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  String? userId;
  String? userFirstName;
  String? userLastName;
  String? userProfileImg;
  List<dynamic> activities = [];
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchUserId().then((_) {
      _fetchActivities(0);
    });
  }

  Future<void> _fetchUserId() async {
    LocalStorageService localStorageService = LocalStorageService();
    User? user = await localStorageService.getCurrentUser();

    if (user != null) {
      setState(() {
        userId = user.id;
        userFirstName = user.firstName;
        userLastName = user.lastName;
        userProfileImg = user.profileImg;
      });
    } else {
      print('No se encontró el usuario.');
    }
  }

  Future<void> _fetchActivities(int tabIndex) async {
    if (userId == null) return;

    setState(() {
      isLoading = true;
      error = null;
      activities = []; // Clear previous activities
    });

    String url = 'http://10.0.2.2:8000/quickrecap/activity/search/$userId';
    if (tabIndex == 1) {
      url += '?favorito=true';
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        setState(() {
          activities = decodedData is List ? decodedData : [];
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Error al cargar las actividades';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error de conexión: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FC),
        body: Stack(
          children: [
            // Fondo
            Container(
              height: 230.h,
              decoration: BoxDecoration(
                color: kPrimary,
                image: DecorationImage(
                  image: AssetImage('assets/images/background-top.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Contenido principal
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 20.w, right: 20.w, top: 15.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Mis actividades",
                              style: TextStyle(
                                color: kWhite,
                                fontSize: 26.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.logout,
                                color: kWhite,
                                size: 30.sp,
                              ),
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/login', (route) => false);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Buscar',
                              border: InputBorder.none,
                              icon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: kDark.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.symmetric(vertical: 3.w)),
                          TabBar(
                            labelColor: kPrimary,
                            unselectedLabelColor: kGrey,
                            onTap: (index) {
                              _fetchActivities(index);
                            },
                            tabs: [
                              Tab(text: 'Creados'),
                              Tab(text: 'Favoritos'),
                              Tab(text: 'Historial'),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                              horizontal: 10.w,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  '${activities.length} actividades',
                                  style: TextStyle(
                                    color: kDark,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                DropdownButton<String>(
                                  value: 'Todos',
                                  icon:
                                      Icon(Icons.arrow_drop_down, color: kDark),
                                  underline:
                                      Container(), // Elimina la línea inferior
                                  dropdownColor: Colors
                                      .white, // Fondo blanco del menú desplegable
                                  style: TextStyle(
                                      color: kDark, // Texto negro
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500),
                                  items: <String>[
                                    'Todos',
                                    'Quiz',
                                    'Flashcards',
                                    'Gap',
                                    'Linkers'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            color:
                                                kDark), // Asegura que el texto de las opciones también sea negro
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    // Aquí puedes manejar el cambio de selección
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: activities.isEmpty
                                ? Center(
                                    child:
                                        CircularProgressIndicator()) //No borrar, sale error si no tiene el spinner
                                : TabBarView(
                                    children: [
                                      _buildActivityList(0, context),
                                      _buildActivityList(1, context),
                                      _buildActivityList(2, context),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityList(int currentTabIndex, BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text(error!, style: TextStyle(color: Colors.red)));
    }

    if (activities.isEmpty) {
      return Center(
        child: Text(
          'No hay actividades disponibles',
          style: TextStyle(
            color: kGrey2,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Container(
          height: 65,
          child: Row(
            children: [
              Icon(
                Icons.play_circle_fill_outlined,
                color: kPrimaryLight,
                size: 40,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  activity['nombre'] ?? 'Sin nombre',
                  style: TextStyle(
                    color: kGrey2,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () => _showOptionsBottomSheet(context, activity),
                child: _getIconForTab(currentTabIndex, activity),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getIconForTab(int currentTabIndex, dynamic activity) {
    switch (currentTabIndex) {
      case 0: // Creados
        return Icon(
          Icons.settings,
          color: kGrey,
          size: 25,
        );
      case 1: // Favoritos
        return Icon(
          Icons.bookmark,
          color: kYellow,
          size: 25,
        );
      case 2: // Historial
        return Container(
          width: 60,
          height: 40,
          decoration: BoxDecoration(
            color: kPrimaryLight.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${activity['puntuacion_maxima'] ?? '0'}/${activity['numero_preguntas'] ?? '0'}',
                style: TextStyle(
                  color: kPrimaryLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      default:
        return Icon(
          Icons.help_outline,
          color: kPrimaryLight,
          size: 25,
        );
    }
  }

  void _showOptionsBottomSheet(BuildContext context, dynamic activity) {
    String currentState = activity['estado'] ?? 'Público';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                          'Opciones de la actividad',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
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
                          child: Text('Nombre:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15)),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: kPrimaryLight.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            activity['nombre'] ?? 'Sin nombre',
                            style: TextStyle(
                                color: kPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsets.only(left: 6, bottom: 7),
                          child: Text('Estado:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: kWhite,
                            border: Border.all(color: kPrimary, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value:
                                  activity['privado'] ? 'Privado' : 'Público',
                              isExpanded: true,
                              items: <String>['Público', 'Privado']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: TextStyle(
                                          color: kPrimary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14)),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    activity['privado'] = newValue == 'Privado';
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                              shadowColor: kDark,
                            ),
                            child: Text('Eliminar',
                                style: TextStyle(color: kWhite)),
                            onPressed: () async {
                              try {
                                final response = await http.delete(
                                  Uri.parse(
                                      'http://10.0.2.2:8000/quickrecap/activity/delete/${activity['id']}'),
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                  },
                                );

                                if (response.statusCode == 204) {
                                  // Actualización exitosa
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Actividad borrada con éxito')),
                                  );
                                  Navigator.pop(context); // Cierra el pop-up
                                  _fetchActivities(
                                      0); // Refresca la lista de actividades
                                } else {
                                  print(response);
                                }
                              } catch (e) {
                                // Error de conexión
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Error de conexión: $e')),
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryLight,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                              shadowColor: kDark,
                            ),
                            child: Text('Guardar',
                                style: TextStyle(color: kWhite)),
                            onPressed: () async {
                              bool isPrivate = currentState == 'Privado';
                              // Crear el cuerpo de la solicitud
                              final requestBody = jsonEncode(<String, dynamic>{
                                'privado': isPrivate,
                              });

                              try {
                                final response = await http.put(
                                  Uri.parse(
                                      'http://10.0.2.2:8000/quickrecap/activity/update/${activity['id']}'),
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                  },
                                  body: jsonEncode(<String, dynamic>{
                                    'privado': isPrivate,
                                  }),
                                );

                                if (response.statusCode == 200) {
                                  // Actualización exitosa
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Actividad actualizada con éxito')),
                                  );
                                  Navigator.pop(context); // Cierra el pop-up
                                  _fetchActivities(
                                      0); // Refresca la lista de actividades
                                } else {
                                  print(response);
                                }
                              } catch (e) {
                                // Error de conexión
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Error de conexión: $e')),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
