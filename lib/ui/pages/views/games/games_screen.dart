import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrecap/data/repositories/local_storage_service.dart';
import '../../../../domain/entities/history_activity.dart';
import 'package:quickrecap/ui/constants/constants.dart';
import '../../../../domain/entities/activity.dart';
import '../../../../domain/entities/history_activity.dart';
import '../../../providers/get_activities_for_user_provider.dart';
import '../../../providers/get_history_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../activities/activity_service.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  GamesScreenState createState() => GamesScreenState();
}

class GamesScreenState extends State<GamesScreen> {
  //String? userId;
  List<Activity> activities = [];
  bool isLoading = false;
  bool isDialogLoading = false;
  String? error;
  String _currentValue = 'Todos';
  int displayableActivityQuantity = 0;
  String searchQuery = '';
  List<Activity> allActivities = [];
  List<HistoryActivity> historyActivities = [];
  String? isChangingPrivacyFor;
  bool isHistoryDisplayed = false;
  int currentTabIndex=0;

  LocalStorageService localStorageService = LocalStorageService();

  @override
  void initState() {
    super.initState();
    _fetchActivities(0);
  }

  Future<void> refresh() async {
    _fetchActivities(currentTabIndex);
  }

  Future<void> _fetchActivities(int tabIndex) async {
    setState(() {
      isLoading = true;
      error = null;
      currentTabIndex = tabIndex;
    });
    if(tabIndex!=2){
      isHistoryDisplayed=false;
      try {
        // Llamada a la función de la API
        final getActivitiesForUserProvider = Provider.of<GetActivitiesForUserProvider>(context, listen: false);
        List<Activity>? activityList = await getActivitiesForUserProvider.getActivityListByUserId(tabIndex);
        if (activityList != null) {
          setState(() {
            allActivities = activityList;
            activities = List<Activity>.from(allActivities); // Aseguramos la seguridad del tipo
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          error = e.toString();
          isLoading = false;
        });
      }
    }else{
      isHistoryDisplayed=true;
      final getHistoryForUserProvider = Provider.of<GetHistoryProvider>(context, listen: false);
      List<HistoryActivity>? historyList = await getHistoryForUserProvider.getHistoryByUserId();
      if(historyList != null){
        setState(() {
          historyActivities = historyList;
          isLoading = false;
        });
      }

    }
  }

  Future<void> _updateActivityPrivacy(Activity activity, bool privateValue) async {
    try {
      final response = await http
          .put(
        Uri.parse('https://quickrecap.rj.r.appspot.com/quickrecap/activity/update/${activity.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'private': privateValue,
        }),
      )
          .timeout(Duration(seconds: 10)); // Configura el timeout aquí

      if (response.statusCode == 200) {
        setState(() {
          // Encuentra la actividad y actualiza su estado de privacidad
          final index = activities.indexWhere((a) => a.id == activity.id);
          if (index != -1) {
            activities[index].private = privateValue;
          }
        });
      } else {
        print('No pudimos cambiar la privacidad de esta actividad');
        _showErrorSnackBar('No pudimos cambiar la privacidad de esta actividad');
      }
    } on TimeoutException catch (_) {
      print('No pudimos cambiar la privacidad de esta actividad');
      _showErrorSnackBar('La solicitud tardó demasiado, por favor intente de nuevo.');
    } on SocketException catch (_) {
      print('No pudimos cambiar la privacidad de esta actividad');
      _showErrorSnackBar('Error de conexión. Verifique su conexión a internet.');
    } catch (e) {
      print('No pudimos cambiar la privacidad de esta actividad');
      _showErrorSnackBar('Ocurrió un error inesperado: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50.0,
        left: 10.0,
        right: 10.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Color(0xff2d2d2d),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    // Inserta la entrada en el overlay
    overlay?.insert(overlayEntry);

    // Ocultar el overlay después de 3 segundos
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  List<Activity> getFilteredActivities() {
    List<Activity> results = allActivities.where((activity) {
      bool matchesSearch = activity.name.toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesType = _currentValue == 'Todos' || activity.activityType == _currentValue;
      return matchesSearch && matchesType;
    }).toList();
    setState(() {
      displayableActivityQuantity= results.length;
    });
    return results;
  }

  List<HistoryActivity> getFilteredHistoryActivities() {
    List<HistoryActivity> results = historyActivities.where((activity) {
      bool matchesSearch = activity.activityName.toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesType = _currentValue == 'Todos' || activity.activityType == _currentValue;
      return matchesSearch && matchesType;
    }).toList();
    setState(() {
      displayableActivityQuantity= results.length;
    });
    return results;
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
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
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
                            style: TextStyle(color: Colors.black,fontFamily: 'Poppins',),
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
                              Tab(text: 'Historial')
                            ],
                            labelStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500
                            ), // Aplica el estilo aquí
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
                                '${isHistoryDisplayed ? getFilteredHistoryActivities().length : getFilteredActivities().length} actividades',
                                  style: TextStyle(
                                    color: kDark,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                DropdownButton<String>(
                                  value: _currentValue,
                                  icon:
                                  Icon(Icons.arrow_drop_down, color: kDark),
                                  underline: Container(),
                                  dropdownColor: Colors.white,
                                  style: TextStyle(
                                      color: kDark,
                                      fontFamily: 'Poppins',
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
                                            style: TextStyle(color: kDark),
                                          ),
                                        );
                                      }).toList(),
                                  onChanged: (String? newValue) {
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
                          Expanded(
                            child: TabBarView(
                              children: [
                                _buildCreatedActivityList(0, context),
                                _buildFavoriteActivityList(1, context),
                                _buildHistoryActivityList(2, context),
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

  Widget _buildCreatedActivityList(int currentTabIndex, BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text(error!, style: TextStyle(color: Colors.red)));
    }

    List<Activity> filteredActivities = getFilteredActivities();

    if (filteredActivities.isEmpty) {
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

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      itemCount: filteredActivities.length,
      itemBuilder: (context, index) {
        final activity = filteredActivities[index];
        final isLastItem = index == filteredActivities.length - 1;

        return Column(
          children: [
            Container(
              height: 65,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      playActivity(context, activity.id);
                    },
                    child: Icon(
                      Icons.play_circle_fill_outlined,
                      color: kPrimaryLight,
                      size: 40,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      activity.name,
                      style: TextStyle(
                        color: kGrey2,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _showOptionsBottomSheet(context, activity),
                    child: Icon(
                      Icons.settings,
                      color: kGrey,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
            if (!isLastItem)
              Divider(
                color: Color(0xffD9D9D9),
                thickness: 1.0,
                indent: 12,
                endIndent: 12,
              ),
          ],
        );
      },
    );
  }


  Widget _buildFavoriteActivityList(int currentTabIndex, BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text(error!, style: TextStyle(color: Colors.red)));
    }

    List<dynamic> filteredActivities = getFilteredActivities();

    if (filteredActivities.isEmpty) {
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

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      itemCount: filteredActivities.length,
      itemBuilder: (context, index) {
        final activity = filteredActivities[index];
        final isLastItem = index == filteredActivities.length - 1;
        bool isFavorite = activity.favorite;

        return Column(
          children: [
            Container(
              height: 65,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      playActivity(context, activity.id);
                    },
                    child: Icon(
                      Icons.play_circle_fill_outlined,
                      color: kPrimaryLight,
                      size: 40,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      activity.name,
                      style: TextStyle(
                        color: kGrey2,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });

                      try {
                        int userId = await localStorageService.getCurrentUserId();
                        final response = await http.post(
                          Uri.parse('https://quickrecap.rj.r.appspot.com/quickrecap/favorite/update/${activity.id}'),
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
                            activity.favorite = !isFavorite;
                            getFilteredActivities();
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('No pudimos agregar esta actividad a tus favoritos'),
                              backgroundColor: Color(0xffFFCFD0),
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
                    child: Icon(
                      Icons.bookmark,
                      color: isFavorite ? Color(0xffffd100) : Color(0xffa2a2a2),
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            if (!isLastItem)
              Divider(
                color: Color(0xffD9D9D9),
                thickness: 1.0,
                indent: 12,
                endIndent: 12,
              ),
          ],
        );
      },
    );
  }


  Widget _buildHistoryActivityList(int currentTabIndex, BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text(error!, style: TextStyle(color: Colors.red)));
    }

    List<HistoryActivity> historyActivities = getFilteredHistoryActivities();

    if (historyActivities.isEmpty) {
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

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      itemCount: historyActivities.length,
      itemBuilder: (context, index) {
        final activity = historyActivities[index];
        final isLastItem = index == historyActivities.length - 1;

        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              height: 65,
              child: Row(
                children: [
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      activity.activityName,
                      style: TextStyle(
                        color: kGrey2,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
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
                          "${activity.correctAnswers}/${activity.numberOfQuestions}",
                          style: TextStyle(
                            color: kPrimaryLight,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!isLastItem)
              Divider(
                color: Color(0xffD9D9D9),
                thickness: 1.0,
                indent: 12,
                endIndent: 12,
              ),
          ],
        );
      },
    );
  }


  void _removeActivityById(int activityId) {
    setState(() {
      allActivities.removeWhere((activity) => activity.id == activityId);
    });
  }

  void _addFavoriteActivityById(int activityId) {
    setState(() {
      final activity = allActivities.firstWhere(
            (activity) => activity.id == activityId,
        orElse: () => throw Exception('Activity not found'),
      );

      activity.favorite = true; // Cambiamos favorite porque ya no es final
    });
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
                          'Configuracion de la actividad',
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
                              // Primer item (Favoritos)
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
                                        Uri.parse('https://quickrecap.rj.r.appspot.com/quickrecap/favorite/update/${activity.id}'),
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
                                          _addFavoriteActivityById(activity.id);
                                          getFilteredActivities();
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('No pudimos agregar esta actividad a tus favoritos'),
                                            backgroundColor: Color(0xffFFCFD0),
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
                                child: GestureDetector(
                                  onTap: () {
                                    // Cierra el bottom sheet actual antes de abrir el nuevo
                                    Navigator.of(context).pop();
                                    // Después de cerrar el bottom sheet, abre uno nuevo
                                    showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                      ),
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setModalState) {
                                            return Padding(
                                              padding: EdgeInsets.all(20),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment.centerLeft, // Alinear el icono a la izquierda
                                                        child: IconButton(
                                                          icon: Icon(Icons.close),
                                                          onPressed: () => Navigator.pop(context),
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: 10), // Ajusta este valor según necesites
                                                          child: Text(
                                                            'Ajustes de privacidad',
                                                            style: TextStyle(
                                                              color: Color(0XFF212121),
                                                              fontFamily: 'Poppins',
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 15),
                                                  Text(
                                                    '¿Quién puede ver tu actividad?',
                                                    style: TextStyle(
                                                      color: Color(0XFF757575),
                                                      fontFamily: 'Poppins',
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: 20),
                                                  Column(
                                                    children: [
                                                      ListTile(
                                                        title: Text('Todo el mundo'),
                                                        leading: Icon(Icons.public),
                                                        trailing: Container(
                                                          width: 24,
                                                          height: 24,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            border: Border.all(color: Color(
                                                                0xFFCEC6FF), width: 2),
                                                          ),
                                                          child: isDialogLoading && isChangingPrivacyFor == 'public'
                                                              ? SizedBox(
                                                            width: 16,
                                                            height: 16,
                                                            child: CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6D5BFF)),
                                                            ),
                                                          )
                                                              : !activity.private
                                                              ? Container(
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Color(0xFF6D5BFF),
                                                            ),
                                                          )
                                                              : null,
                                                        ),
                                                        onTap: () async {
                                                          if (activity.private == true) {
                                                            setModalState(() {
                                                              isDialogLoading = true;
                                                              isChangingPrivacyFor = 'public'; // Indicar que se está cambiando a público
                                                            });
                                                            await _updateActivityPrivacy(activity, false);
                                                            setModalState(() {
                                                              isDialogLoading = false;
                                                              isChangingPrivacyFor = null; // Restablecer el estado
                                                            });
                                                          }
                                                        },
                                                      ),
                                                      ListTile(
                                                        title: Text('Solo tú'),
                                                        leading: Icon(Icons.lock),
                                                        trailing: Container(
                                                          width: 24,
                                                          height: 24,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            border: Border.all(color: Color(0xFFCEC6FF), width: 2),
                                                          ),
                                                          child: isDialogLoading && isChangingPrivacyFor == 'private'
                                                              ? SizedBox(
                                                            width: 16,
                                                            height: 16,
                                                            child: CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6D5BFF)),
                                                            ),
                                                          )
                                                              : activity.private
                                                              ? Container(
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Color(0xFF6D5BFF),
                                                            ),
                                                          )
                                                              : null,
                                                        ),
                                                        onTap: () async {
                                                          if (activity.private == false) {
                                                            setModalState(() {
                                                              isDialogLoading = true;
                                                              isChangingPrivacyFor = 'private'; // Indicar que se está cambiando a privado
                                                            });
                                                            await _updateActivityPrivacy(activity, true);
                                                            setModalState(() {
                                                              isDialogLoading = false;
                                                              isChangingPrivacyFor = null; // Restablecer el estado
                                                            });
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
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
                                        Icon(
                                          Icons.lock,
                                          color: Color(0xff4d4a4b),
                                          size: 30, // Aumentar el tamaño del icono
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "Ajustes de \nprivacidad",
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
                        Padding(
                          padding: EdgeInsets.only(left: 6, bottom: 7),
                          child: Text('Tipo:',
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
                            activity.activityType ?? 'Sin categoria',
                            style: TextStyle(
                                color: kPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
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
                              backgroundColor: Color(0xffEB2525),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0,
                              minimumSize: Size(100, 60), // Especifica width y height
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Añade padding si es necesario
                            ),
                            child: Text(
                              'Eliminar Actividad',
                              style: TextStyle(
                                color: kWhite,
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () {
                              // Cierra el diálogo actual antes de abrir el BottomSheet
                              Navigator.of(context).pop();
                              showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                ),
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Confirmar eliminación',
                                          style: TextStyle(
                                            color: kDark,
                                            fontFamily: 'Poppins',
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          '¿Desea eliminar la actividad "${activity.name}"?',
                                          style: TextStyle(
                                            color: kDark,
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 20),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: double.infinity, // Hace que el botón ocupe todo el ancho
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  padding: EdgeInsets.symmetric(vertical: 15),
                                                ),
                                                child: Text(
                                                  'Eliminar',
                                                  style: TextStyle(color: kWhite),
                                                ),
                                                onPressed: () async {
                                                  Navigator.of(context).pop(); // Cierra el BottomSheet de confirmación
                                                  try {
                                                    final response = await http.delete(
                                                      Uri.parse('https://quickrecap.rj.r.appspot.com/quickrecap/activity/delete/${activity.id}'),
                                                      headers: <String, String>{
                                                        'Content-Type': 'application/json; charset=UTF-8',
                                                      },
                                                    );
                                                    if (response.statusCode == 204) {
                                                      _removeActivityById(activity.id);
                                                    }
                                                  } catch (e) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text('Error de conexión: $e')),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 10), // Espacio entre los botones
                                            SizedBox(
                                              width: double.infinity, // Hace que el botón ocupe todo el ancho
                                              child: TextButton(
                                                child: Text(
                                                  'Cancelar',
                                                  style: TextStyle(color: kGrey),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Cierra el BottomSheet
                                                },
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(vertical: 15),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
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