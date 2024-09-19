import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrecap/ui/constants/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 190.h, // Ajusta la altura si es necesario
                decoration: BoxDecoration(
                  color: kPrimary,
                  image: DecorationImage(
                    image: AssetImage('assets/images/background-top.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 15.h), // Ajusta el padding superior
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Mi perfil",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.logout,
                                color: Colors.white,
                                size: 30.sp,
                              ),
                              onPressed: () {
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Positioned(
            top: 100.h, // Ajusta esta posición si es necesario para mover la sección de perfil
            left: 10.w,
            right: 10.w,
            child: _buildProfileSection(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60.h,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.home, size: 30.sp),
                  Icon(Icons.grid_view, size: 30.sp),
                  Icon(Icons.add_circle_outline, size: 30.sp),
                  Icon(Icons.person, size: 30.sp),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundImage: AssetImage('assets/images/profile_pic.png'),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Diego Talledo Sanchez',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff212121)
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, '/configuration');
                  // Acción para el botón de configuración
                },
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Divider(
            color: Color(0xffD9D9D9), // Puedes ajustar el color si lo deseas
            thickness: 1.0, // Ajusta el grosor del Divider
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn('1,025', 'puntos\n'),
              Container(
                height: 78.0, // Ajusta la altura según sea necesario
                child: VerticalDivider(
                  color: Color(0xFFD9D9D9), // Color del Divider
                  thickness: 1,
                  width: 1,
                ),
              ),
              _buildStatColumn('105', 'actividades\ncompletadas'),
              Container(
                height: 78.0, // Ajusta la altura según sea necesario
                child: VerticalDivider(
                  color: Color(0xFFD9D9D9), // Color del Divider
                  thickness: 1,
                  width: 1,
                ),
              ),
              _buildStatColumn('10', 'actividades\ngeneradas'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          value,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF212121),
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: Color(0xFF5B5B5B),
          ),
        ),
      ],
    );
  }
}