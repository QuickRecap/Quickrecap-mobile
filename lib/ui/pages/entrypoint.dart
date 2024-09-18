import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickrecap/ui/constants/constants.dart';
import 'package:quickrecap/ui/controllers/tab_index_controller.dart';
import 'package:quickrecap/ui/pages/views/create/create_screen.dart';
import 'package:quickrecap/ui/pages/views/games/games_screen.dart';
import 'package:quickrecap/ui/pages/views/home/home_screen.dart';
import 'package:quickrecap/ui/pages/views/profile/profile_dart.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  List<Widget> pageList = const [
    HomeScreen(),
    GamesScreen(),
    CreateScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TabIndexController());
    return Obx(
      () => Scaffold(
        body: Stack(children: [
          pageList[controller.tabIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: Theme(
              data: Theme.of(context).copyWith(canvasColor: Colors.white),
              child: BottomNavigationBar(
                // ------- UNSELECTED STYLES ------- //

                showUnselectedLabels: true,
                unselectedIconTheme:
                    const IconThemeData(color: kDisabled, size: 40),
                unselectedItemColor: kDisabled,
                unselectedLabelStyle: const TextStyle(
                  color: kDisabled,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),

                showSelectedLabels: true,
                selectedIconTheme: const IconThemeData(color: kDark, size: 40),
                selectedItemColor: kDark,
                selectedLabelStyle: const TextStyle(
                  color: kDark,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),

                type: BottomNavigationBarType.fixed,
                currentIndex: controller.tabIndex,
                onTap: (value) {
                  controller.tabIndex = value;
                },
                items: [
                  const BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.all(7.0),
                      child: Icon(Icons.home),
                    ),
                    label: 'Home',
                  ),
                  const BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.all(7.0),
                      child: Icon(Icons.dashboard),
                    ),
                    label: 'Minijuegos',
                  ),
                  const BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.all(7.0),
                      child: Icon(Icons.add_circle_outline),
                    ),
                    label: 'Crear',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          controller.tabIndex == 3
                              ? const Icon(Icons.person)
                              : const Icon(Icons.person_2_outlined),
                        ],
                      ),
                    ),
                    label: 'Perfil',
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
