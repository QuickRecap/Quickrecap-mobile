import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrecap/ui/constants/constants.dart';
import 'package:quickrecap/ui/common/custom_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> topActivities = [
    {'name': 'Quiz de Derecho Penal', 'play_count': '99'},
    {'name': 'Gaps de Derecho Procesal', 'play_count': '76'},
  ];

  final List<Map<String, dynamic>> categories = [
    {'name': 'Quiz', 'icon': Icons.quiz},
    {'name': 'Gaps', 'icon': Icons.space_bar},
    {'name': 'Flashcards', 'icon': Icons.style},
    {'name': 'Linkers', 'icon': Icons.link},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: Stack(
        children: [
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
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15.h),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hola, Diego!",
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
                            // Logout button action
                          },
                        ),
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
                                value: "125",
                              ),
                              _buildStatItem(
                                title: "PDF's",
                                icon: Icons.description,
                                value: "72",
                              ),
                              _buildStatItem(
                                title: "Usuarios",
                                icon: Icons.person,
                                value: "100",
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            "Empieza a crear tus propias actividades!",
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: kGrey2,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {},
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
                          onTap: () {},
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
                    ...topActivities.map((activity) => Container(
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
                                  activity['name']!,
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
                                    activity['play_count'].toString(),
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
                            return Padding(
                              padding: EdgeInsets.only(right: 15.w),
                              child: _buildCategoryCard(
                                icon: categories[index]['icon'],
                                name: categories[index]['name'],
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
    return Column(
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
        boxShadow: [
          BoxShadow(
            color: kDark.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 10.h), // Reducimos el padding vertical
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32.sp, // Reducimos ligeramente el tamaño del icono
              color: kDark,
            ),
            SizedBox(
                height: 6.h), // Reducimos el espacio entre el icono y el texto
            Text(
              name,
              style: TextStyle(
                color: kGrey2,
                fontSize: 13.sp, // Ajustamos ligeramente el tamaño del texto
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
