import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrecap/ui/constants/constants.dart';
import 'package:quickrecap/domain/entities/activity.dart';
import 'package:http/http.dart' as http;

class AllActivitiesScreen extends StatefulWidget {
  const AllActivitiesScreen({Key? key}) : super(key: key);

  @override
  State<AllActivitiesScreen> createState() => _AllActivitiesScreenState();
}

class _AllActivitiesScreenState extends State<AllActivitiesScreen> {
  String _currentValue = 'Todos';
  String searchQuery = '';
  List<Activity> activities = [];


  @override
  void initState() {
    super.initState();
    fetchActivities();
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
          activities = jsonData.map((data) => Activity.fromJson(data)).toList();
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching activities: $e');
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
                        // Contador y filtro
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.h,
                            horizontal: 10.w,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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

                        // Lista de actividades
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 1.h),
                            itemCount: getFilteredActivities().length,
                            itemBuilder: (context, index) {
                              final activity = getFilteredActivities()[index];
                              return Container(
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
                                    Icon(
                                      Icons.play_circle_fill_outlined,
                                      color: kPrimaryLight,
                                      size: 35.sp,
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
}
