import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrecap/ui/constants/constants.dart';
import 'package:quickrecap/domain/entities/activity.dart';
import 'package:http/http.dart' as http;
import '../../../../data/repositories/local_storage_service.dart';
import '../activities/activity_service.dart';
import 'widgets/options_bottom_sheet.dart';

class CategoryScreen extends StatefulWidget {
  final String title;
  final String activityType;

  const CategoryScreen({
    Key? key,
    required this.title,
    required this.activityType,
  }) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String searchQuery = '';
  List<Activity> activities = [];
  bool isLoading = false;

  LocalStorageService localStorageService = LocalStorageService();

  @override
  void initState() {
    super.initState();
    fetchActivities();
  }

  Future<void> fetchActivities() async {
    setState(() {
      isLoading = true;
    });

    int userId = await localStorageService.getCurrentUserId();
    try {
      final url = 'https://quickrecap.rj.r.appspot.com/quickrecap/activity/research?user_id=$userId&tipo=${widget.activityType}';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

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
    if (searchQuery.isEmpty) {
      return activities;
    }

    return activities.where((activity) {
      return activity.name.toLowerCase().contains(searchQuery.toLowerCase());
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
                  padding: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: kWhite),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        widget.title,
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

                // Contenedor blanco con contador y lista
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
                        // Solo contador
                        Padding(
                          padding: EdgeInsets.only( top: 20.h, bottom: 10, left: 20.w, right: 20.w),
                          child: Row(
                            children: [
                              Text(
                                '${getFilteredActivities().length} actividades',
                                style: TextStyle(
                                  color: kDark,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Lista de actividades
                        Expanded(
                          child: isLoading
                              ? Center(
                            child: CircularProgressIndicator(),
                          )
                              : activities.isEmpty
                              ? Center(
                            child: Text(
                              'No hay actividades que mostrar',
                              style: TextStyle(
                                color: Color(0xff9A9A9A),
                                fontSize: 16.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                              : ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 1.h),
                                  itemCount: getFilteredActivities().length,
                                  itemBuilder: (context, index) {
                                    final activity = getFilteredActivities()[index];
                                    final isLastItem = index == getFilteredActivities().length - 1;
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // Llamamos al bottom dialog pasándole la activity
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
                                                    // Llama a la función PlayActivity
                                                    playActivity(context, activity.id);  // Llama a playActivity
                                                  },
                                                  child: Icon(
                                                    Icons.play_circle_fill_outlined,
                                                    color: kPrimaryLight,
                                                    size: 35.sp,
                                                  ),
                                                ),
                                                SizedBox(width: 12.w),
                                                Expanded(
                                                  child: Text(
                                                    activity.name,
                                                    style: TextStyle(
                                                      color: kGrey2,
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14.sp,
                                                    ),
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
    OptionsBottomSheet.show(
      context,
      activity,
      _addFavoriteActivityById,
    );
  }
}