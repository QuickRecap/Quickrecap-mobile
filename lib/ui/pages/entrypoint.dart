import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickrecap/ui/constants/constants.dart';
import 'package:quickrecap/ui/controllers/tab_index_controller.dart';
import 'package:quickrecap/ui/pages/views/create/create_screen.dart';
import 'package:quickrecap/ui/pages/views/games/games_screen.dart';
import 'package:quickrecap/ui/pages/views/home/home_screen.dart';
import 'package:quickrecap/ui/pages/views/profile/profile_dart.dart';
import '../../domain/entities/pdf.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final TabIndexController controller;
  Pdf? selectedPdf;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TabIndexController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      if (args != null && args.containsKey('selectedPdf')) {
        print("PDF seleccionado en entrypoint: ${args['selectedPdf']}");
        setState(() {
          selectedPdf = args['selectedPdf'] as Pdf?;
        });
      }
      final initialIndex = args?['initialIndex'] as int? ?? 0;
      controller.tabIndex = initialIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print('Navegando a CreateScreen con PDF: ${selectedPdf?.name}');
      final List<Widget> pageList = [
        const HomeScreen(),
        const GamesScreen(),
        CreateScreen(selectedPdf: selectedPdf), // Pasa el PDF aquí.
        const ProfileScreen(),
      ];

      return Scaffold(
        body: IndexedStack(
          index: controller.tabIndex,
          children: pageList,
        ),
        bottomNavigationBar: Theme(
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
            selectedItemColor: kDark,
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
                      Text('Home', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, color: Color(0xff565656))),
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
                      Text('Crear', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, color: Color(0xff565656))),
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