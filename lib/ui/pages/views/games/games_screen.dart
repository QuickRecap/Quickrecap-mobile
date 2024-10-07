import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrecap/ui/constants/constants.dart';
import '../../../../data/repositories/local_storage_service.dart';
import '../../../../domain/entities/user.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchUserId();
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
                            color: Colors.white,
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
                            color: Colors.black.withOpacity(0.1),
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
                                  '4 actividades',
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
                                    fontWeight: FontWeight.w500
                                  ),
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
                                        style: TextStyle(color: kDark), // Asegura que el texto de las opciones también sea negro
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
                            child: TabBarView(
                              children: [
                                _buildActivityList(),
                                _buildActivityList(),
                                _buildActivityList(),
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

  Widget _buildActivityList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      itemCount: 4,
      itemBuilder: (context, index) {
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
                  'Quiz de Derecho Penal',
                  style: TextStyle(
                    color: kGrey2,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                  width: 10), // Ajusta este valor para controlar el espacio
              Icon(Icons.star, color: Colors.grey),
            ],
          ),
        );
      },
    );
  }
}
