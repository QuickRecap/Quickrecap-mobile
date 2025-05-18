import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrecap/ui/constants/constants.dart';
import 'package:quickrecap/domain/entities/activity.dart';
import 'package:http/http.dart' as http;
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../data/repositories/local_storage_service.dart';
import '../activities/activity_service.dart';
import '../../../../data/api/api_constants.dart';
import 'dart:async';

class AllActivitiesScreen extends StatefulWidget {
  const AllActivitiesScreen({Key? key}) : super(key: key);

  @override
  State<AllActivitiesScreen> createState() => _AllActivitiesScreenState();
}

class _AllActivitiesScreenState extends State<AllActivitiesScreen> {
  String baseUrl = ApiConstants.baseUrl;
  String _currentValue = 'Todos';
  String searchQuery = '';
  List<Activity> activities = [];
  bool isDialogLoading = false;
  bool isLoading = false;
  bool hasError = false;
  LocalStorageService localStorageService = LocalStorageService();


  @override
  void initState() {
    super.initState();
    fetchActivities();
  }


  Future<void> fetchActivities() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    int userId = await localStorageService.getCurrentUserId();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/activity/research?user_id=$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 30), onTimeout: () {
        setState(() {
          isLoading = false;
          hasError = true;
        });
        return http.Response('', 408); // Código 408 indica timeout
      });

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          activities = jsonData.map((data) => Activity.fromJson(data)).toList();
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching activities: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }

  }

  List<Activity> getFilteredActivities() {
    if (searchQuery.isEmpty && _currentValue == 'Todos') {
      return activities;
    }

    return activities.where((activity) {
      bool matchesSearch =
      activity.name.toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesFilter =
          _currentValue == 'Todos' || activity.activityType == _currentValue;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _addFavoriteActivityById(int activityId) {
    setState(() {
      final activity = activities.firstWhere(
            (activity) => activity.id == activityId,
        orElse: () => throw Exception('Activity not found'),
      );

      activity.favorite = true; // Cambiamos favorite porque ya no es final
    });
  }

  // Método para crear actividades falsas para el skeleton
  List<Activity> _createFakeActivities() {
    return List.filled(6, Activity(
        name: 'Actividad de ejemplo',
        timesPlayed: 10,
        id: 0,
        activityType: 'Quiz',
        timePerQuestion: 10,
        numberOfQuestions: 10,
        maxScore: 10,
        favorite: false,
        completed: true,
        private: false,
        rated: false,
        flashcardId: 1,
        userId: 7,
        author: 'Autor de ejemplo'
    ));
  }

  // Método para construir el listado con el Skeletonizer
  Widget _buildActivityList() {
    // Si estamos cargando, mostrar skeletons
    if (isLoading && !hasError) {
      final fakeActivities = _createFakeActivities();

      return Skeletonizer(
        enabled: true,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 1.h),
          itemCount: fakeActivities.length,
          itemBuilder: (context, index) {
            final activity = fakeActivities[index];
            final isLastItem = index == fakeActivities.length - 1;
            return Column(
              children: [
                SizedBox(height: 5.h),
                Container(
                  height: 50.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.play_circle_fill_outlined,
                        color: kPrimaryLight,
                        size: 40.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              activity.name!,
                              style: TextStyle(
                                color: kGrey2,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 15.sp,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Por ${activity.author}',
                              style: TextStyle(
                                color: kGrey,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 11.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.play_arrow_rounded,
                            color: kDark,
                            size: 22.sp,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            activity.timesPlayed.toString(),
                            style: TextStyle(
                              color: kGrey2,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.h),
                if (!isLastItem)
                  Divider(
                    color: Color(0xffD9D9D9),
                    thickness: 1.0,
                    indent: 12.w,
                    endIndent: 12.w,
                  ),
              ],
            );
          },
        ),
      );
    }

    if(hasError && !isLoading){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 64.sp,
              color: Color(0xFFA5A5A5),
            ),
            SizedBox(height: 16.h),
            Text(
              'No pudimos cargar las actividades',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: Color(0xFFA5A5A5),
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 24.h)
          ],
        ),
      );
    }

    // Si no hay actividades, mostrar mensaje
    if (activities.isEmpty) {
      return Center(
        child: Text(
          'No hay actividades que mostrar',
          style: TextStyle(
            color: Color(0xff9A9A9A),
            fontSize: 16.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }

    // Mostrar lista real de actividades
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 1.h),
      itemCount: getFilteredActivities().length,
      itemBuilder: (context, index) {
        final activity = getFilteredActivities()[index];
        final isLastItem = index == getFilteredActivities().length - 1;
        return Column(
          children: [
            SizedBox(height: 5.h),
            GestureDetector(
              onTap: () {
                _showOptionsBottomSheet(context, activity);
              },
              child: Container(
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        playActivity(context, activity.id);
                      },
                      child: Icon(
                        Icons.play_circle_fill_outlined,
                        color: kPrimaryLight,
                        size: 40.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            activity.name!,
                            style: TextStyle(
                              color: kGrey2,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 15.sp,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Por ${activity.author}',
                            style: TextStyle(
                              color: kGrey,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 11.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.play_arrow_rounded,
                          color: kDark,
                          size: 22.sp,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          activity.timesPlayed.toString(),
                          style: TextStyle(
                            color: kGrey2,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5.h),
            if (!isLastItem)
              Divider(
                color: Color(0xffD9D9D9),
                thickness: 1.0,
                indent: 12.w,
                endIndent: 12.w,
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: Stack(
        children: [
          // Fondo superior con imagen
          Container(
            height: 225.h,
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
                // Barra superior con flecha de regreso y título
                Padding(
                  padding:
                  EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: kWhite),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'Todas las actividades',
                        style: TextStyle(
                          color: kWhite,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),

                // Barra de búsqueda
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: TextField(
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                      decoration: InputDecoration(
                        hintText: 'Buscar',
                        border: InputBorder.none,
                        icon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                ),

                SizedBox(height: 5.h),

                // Contenedor blanco con contador, filtro y lista
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: kDark.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Contador y filtro (también con Skeletonizer)
                        Padding(
                          padding: EdgeInsets.only(top: 10.h, bottom: 10, left: 0.w, right: 0.w),
                          child: Skeletonizer(
                            enabled: isLoading,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  '${isLoading ? "0" : getFilteredActivities().length} actividades',
                                  style: TextStyle(
                                    color: kDark,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                DropdownButton<String>(
                                  value: _currentValue,
                                  icon: Icon(Icons.arrow_drop_down, color: kDark),
                                  underline: Container(),
                                  dropdownColor: Colors.white,
                                  style: TextStyle(
                                    color: kDark,
                                    fontFamily: 'Poppins',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  items: [
                                    'Todos',
                                    'Quiz',
                                    'Flashcards',
                                    'Gaps',
                                    'Linkers'
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(color: kDark),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: isLoading ? null : (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        _currentValue = newValue;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Lista de actividades con Skeletonizer
                        Expanded(
                          child: _buildActivityList(),
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
    );
  }

  void _showOptionsBottomSheet(BuildContext context, Activity activity) {
    bool isFavorite = activity.favorite;
    isDialogLoading=false;

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
                                flex: 40, // Ocupa el 45% del ancho
                                child: GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    try {
                                      int userId = await localStorageService.getCurrentUserId();
                                      final response = await http.post(
                                        Uri.parse('$baseUrl/favorite/update/${activity.id}'),
                                        headers: <String, String>{
                                          'Content-Type': 'application/json; charset=UTF-8',
                                        },
                                        body: jsonEncode(<String, dynamic>{
                                          'favorito': !isFavorite,
                                          'user': userId,
                                        }),
                                      ).timeout(
                                        Duration(seconds: 5),
                                        onTimeout: () {
                                          return http.Response('', 408); // Código 408 indica timeout
                                        },
                                      );

                                      if (response.statusCode == 200) {
                                        setState(() {
                                          isFavorite = !isFavorite;
                                          _addFavoriteActivityById(activity.id);
                                          getFilteredActivities();
                                        });
                                      } else {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'No pudimos agregar esta actividad a tus favoritos'),
                                            backgroundColor: Colors.red,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Error de conexión: $e'),
                                          backgroundColor: Color(0xffFFCFD0),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    } finally {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  },
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
                                          size: 30, // Aumentar el tamaño del icono
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          isFavorite ? "Quitar de \nfavoritos" : "Agregar a \nfavoritos",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0XFF212121),
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600, // Aumentar el grosor del texto
                                            fontSize: 14, // Aumentar el tamaño del texto
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20), // Espacio entre los elementos
                              // Segundo item (Ajustes de privacidad)
                              Expanded(
                                flex: 40,
                                child: Container(
                                  height: 67, // Especifica la altura deseada
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
                                        activity.activityType,
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
                            activity.name ?? 'Sin nombre',
                            style: TextStyle(
                                color: kPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
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
                              backgroundColor: Color(0xffefefef), // Fondo del botón
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15), // Bordes redondeados
                              ),
                              minimumSize: Size(100, 60), // Especifica width y height
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Añade padding si es necesario
                            ),
                            child: Text(
                              'Cerrar',
                              style: TextStyle(
                                color: Color(0xff474747), // Color del texto
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () {
                              // Cierra el diálogo actual antes de abrir el BottomSheet
                              Navigator.of(context).pop();
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