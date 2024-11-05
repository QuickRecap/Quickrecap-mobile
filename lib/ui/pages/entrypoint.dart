import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickrecap/ui/constants/constants.dart';
import 'package:quickrecap/ui/controllers/tab_index_controller.dart';
import 'package:quickrecap/ui/pages/views/create/create_screen.dart';
import 'package:quickrecap/ui/pages/views/games/games_screen.dart';
import 'package:quickrecap/ui/pages/views/home/home_screen.dart';
import 'package:quickrecap/ui/pages/views/profile/profile_dart.dart';
import '../../domain/entities/pdf.dart';
import '../../domain/entities/user.dart';
import '../../data/repositories/local_storage_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final TabIndexController controller;
  Pdf? selectedPdf;
  final GlobalKey<HomeScreenState> homeKey = GlobalKey();
  final GlobalKey<GamesScreenState> gamesKey = GlobalKey();
  final GlobalKey<CreateScreenState> createKey = GlobalKey();
  final GlobalKey<ProfileScreenState> profileKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = Get.put(TabIndexController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      if (args != null && args.containsKey('selectedPdf')) {
        setState(() {
          selectedPdf = args['selectedPdf'] as Pdf?;
        });
      }
      final initialIndex = args?['initialIndex'] as int? ?? 0;
      controller.tabIndex = initialIndex;
    });
  }

  void refreshCurrentView(int index) {
    switch (index) {
      case 0:
        if (homeKey.currentState != null) {
          homeKey.currentState!.refresh();
        }
        break;
      case 1:
        if (gamesKey.currentState != null) {
          gamesKey.currentState!.refresh();
        }
        break;
      case 2:
        if (createKey.currentState != null) {
          createKey.currentState!.refresh();
        }
        break;
      case 3:
        if (profileKey.currentState != null) {
          profileKey.currentState!.refresh();
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<Widget> pageList = [
        HomeScreen(key: homeKey),
        GamesScreen(key: gamesKey),
        CreateScreen(key: createKey, selectedPdf: selectedPdf),
        ProfileScreen(key: profileKey),
      ];

      return Scaffold(
        body: IndexedStack(
          index: controller.tabIndex,
          children: pageList,
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.white),
          child: BottomNavigationBar(
            showUnselectedLabels: true,
            unselectedIconTheme: const IconThemeData(color: kDisabled, size: 45),
            unselectedItemColor: kDisabled,
            unselectedLabelStyle: const TextStyle(color: kDisabled),
            showSelectedLabels: true,
            selectedIconTheme: const IconThemeData(color: kDark, size: 45),
            selectedItemColor: kDark,
            selectedLabelStyle: const TextStyle(color: kDark),
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.tabIndex,
            onTap: (value) async {
              if (controller.tabIndex != value) {  // Solo si cambiamos de tab
                controller.tabIndex = value;
                refreshCurrentView(value);  // Refrescamos la vista actual

                if (value == 2 && selectedPdf == null) {
                  print('Navegando a CreateScreen sin PDF seleccionado');
                }
              }
            },
            items: [
              const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 5, right: 0, bottom: 0, left: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home),
                      Text('Home', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, color: Color(0xff565656))),
                    ],
                  ),
                ),
                label: '',
              ),
              const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 5, right: 0, bottom: 0, left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.dashboard),
                      Text('Actividades', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, color: Color(0xff565656))),
                    ],
                  ),
                ),
                label: '',
              ),
              const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 5, right: 0, bottom: 0, left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline),
                      Text('Crear', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, color: Color(0xff565656))),
                    ],
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 5, right: 5, bottom: 0, left: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      controller.tabIndex == 3
                          ? const Icon(Icons.person)
                          : const Icon(Icons.person_2_outlined),
                      const Text('Perfil', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, color: Color(0xff565656))),
                    ],
                  ),
                ),
                label: '',
              ),
            ],
          ),
        ),
      );
    });
  }
}