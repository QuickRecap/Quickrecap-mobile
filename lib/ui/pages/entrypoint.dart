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
    return Obx(() => Scaffold(
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
                      const IconThemeData(color: kDisabled, size: 45),
                  unselectedItemColor: kDisabled,
                  unselectedLabelStyle: const TextStyle(color: kDisabled),

                  // ------- SELECTED STYLES ------- //
                  showSelectedLabels: true,
                  selectedIconTheme:
                      const IconThemeData(color: kDark, size: 45),
                  selectedItemColor:
                      kDark, // Color del label cuando está seleccionado
                  selectedLabelStyle: const TextStyle(color: kDark),

                  // ------- FUNCTIONS ------- //
                  type: BottomNavigationBarType.fixed,
                  currentIndex: controller.tabIndex,
                  onTap: (value) {
                    controller.tabIndex = value;
                  },

                  // ------- ITEMS ------- //
                  items: [
                    const BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.home),
                            Text('Home',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                    fontSize:
                                        15)), 
                          ],
                        ),
                      ),
                      label: '',
                    ),
                    const BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.dashboard),
                            Text('Minijuegos', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, color: Color(0xff565656))),
                          ],
                        ),
                      ),
                      label: '',
                    ),
                    const BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_circle_outline),
                            Text('Crear', style: TextStyle(fontFamily: 'Poppins', fontSize: 15)),
                          ],
                        ),
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            controller.tabIndex == 3
                                ? const Icon(Icons.person)
                                : const Icon(Icons.person_2_outlined),
                            const Text('Perfil',
                                style: TextStyle(fontFamily: 'Poppins', fontSize: 15)),
                          ],
                        ),
                      ),
                      label: '',
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }
}
