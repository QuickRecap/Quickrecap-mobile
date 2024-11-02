import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quickrecap/data/api/home_api.dart';
import 'package:quickrecap/data/repositories/local_storage_service.dart';
import 'package:quickrecap/domain/entities/activity.dart';
import 'package:quickrecap/domain/entities/home.dart';
import 'package:quickrecap/domain/entities/user.dart';
import 'package:quickrecap/ui/constants/constants.dart';
import 'package:quickrecap/ui/controllers/tab_index_controller.dart';
import 'package:quickrecap/ui/pages/views/home/all_activities_screen.dart';
import 'package:quickrecap/ui/pages/views/home/category_screen.dart';
import 'package:http/http.dart' as http;
import '../activities/activity_service.dart';
import 'widgets/options_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeApi _homeService = HomeApi();
  HomeStats? _stats;
  List<Activity> activities = [];
  List<Activity> topActivities = []; // Corrected type
  bool isDialogLoading = false;

  LocalStorageService localStorageService = LocalStorageService();


  @override
  void initState() {
    super.initState();
    _loadStats();
    fetchActivities();
  }

  Future<void> _loadStats() async {
    try {
      final stats = await _homeService.getHomeStats();
      setState(() {
        _stats = stats;
      });
    } catch (e) {}
  }

  final List<Map<String, dynamic>> categories = [
    {'name': 'Quiz', 'icon': Icons.quiz, 'activityType': 'Quiz'},
    {'name': 'Gaps', 'icon': Icons.space_bar, 'activityType': 'Gaps'},
    {'name': 'Flashcards', 'icon': Icons.style, 'activityType': 'Flashcards'},
    {'name': 'Linkers', 'icon': Icons.link, 'activityType': 'Linkers'},
  ];

  void _addFavoriteActivityById(int activityId) {
    setState(() {
      final activity = activities.firstWhere(
            (activity) => activity.id == activityId,
        orElse: () => throw Exception('Activity not found'),
      );

      activity.favorite = true; // Cambiamos favorite porque ya no es final
    });
  }


  Future<void> fetchActivities() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/quickrecap/activity/research'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          activities = jsonData.take(2).map((data) => Activity.fromJson(data)).toList();
          topActivities = activities; // Now correctly typed as List<Activity>
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching activities: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: Stack(
        children: [
          Container(
            height: 200.h,
            decoration: BoxDecoration(
              color: kPrimary,
              image: DecorationImage(
                image: AssetImage('assets/images/background-top.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 25.h),
                    // Header with avatar and greeting
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25.r,
                              backgroundColor: kWhite,
                              child: Icon(
                                Icons.person,
                                size: 30.sp,
                                color: kPrimary,
                              ),
                            ),
                            SizedBox(width: 15.w),
                            FutureBuilder<User?>(
                              future: LocalStorageService().getCurrentUser(),
                              builder: (context, snapshot) {
                                String userName =
                                    "Usuario"; // Valor por defecto

                                if (snapshot.hasData && snapshot.data != null) {
                                  userName = snapshot.data!.firstName;
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hola, $userName!",
                                      style: TextStyle(
                                        color: kWhite,
                                        fontSize: 18.sp,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "¿Listo para aprender?",
                                      style: TextStyle(
                                        color: kWhite,
                                        fontSize: 16.sp,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
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
                        )
                      ],
                    ),
                    SizedBox(height: 20.h),
                    // White container with statistics
                    Container(
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: kDark.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatItem(
                                title: "Actividades",
                                icon: Icons.sports_esports,
                                value:
                                    _stats?.totalActividades.toString() ?? "0",
                              ),
                              _buildStatItem(
                                title: "PDF's",
                                icon: Icons.description,
                                value: _stats?.totalArchivos.toString() ?? "0",
                              ),
                              _buildStatItem(
                                title: "Usuarios",
                                icon: Icons.person,
                                value: _stats?.totalUsuarios.toString() ?? "0",
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            "Empieza ahora a crear tus propias actividades!",
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: kGrey2,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.find<TabIndexController>().tabIndex = 2;
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimary,
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.h, horizontal: 12.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                              ),
                              child: Text(
                                "Crear actividad",
                                style: TextStyle(
                                  color: kWhite,
                                  fontSize: 14.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    // Top Activities section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Top Actividades",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: kGrey2,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AllActivitiesScreen(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                "Ver todos",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: kPrimary,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Icon(
                                Icons.arrow_forward,
                                color: kPrimary,
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    // Top activities list
                    ...topActivities.map((activity) => GestureDetector(
                      onTap: () {
                        // Llamamos al bottom dialog pasándole la activity
                      },
                      child: Container(
                        height: 65.h,
                        margin: EdgeInsets.only(bottom: 10.h),
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: [
                            BoxShadow(
                              color: kDark.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Llama a la función playActivity
                                playActivity(context, activity.id);  // Llama a playActivity con el ID de la actividad
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
                                activity.name!,
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
                    )),
                    // Categories section
                    SizedBox(height: 10.h),
                    Text(
                      "Categorías",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: kGrey2,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      margin: EdgeInsets.only(bottom: 20.h),
                      child: SizedBox(
                        height: 90.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoryScreen(
                                      title: categories[index]['name'],
                                      activityType: categories[index]['name'],
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 15.w),
                                child: _buildCategoryCard(
                                  icon: categories[index]['icon'],
                                  name: categories[index]['name'],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String title,
    required IconData icon,
    required String value,
  }) {
    return Container(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              color: kGrey2,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 7.h),
          Row(
            children: [
              Icon(icon, color: kPrimary, size: 24.sp),
              SizedBox(width: 5.w),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: kGrey2,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required String name,
  }) {
    return Container(
      width: 90.w,
      height: 90.h, // Agregamos altura fija para controlar mejor el espacio
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 10.h), // Reducimos el padding vertical
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32.sp,
              color: kDark,
            ),
            SizedBox(height: 6.h),
            Text(
              name,
              style: TextStyle(
                color: kGrey2,
                fontSize: 13.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
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
