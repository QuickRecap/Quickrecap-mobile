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

  Future<User?> loadUserProfile() async {
    print("consultando a LocalStorageService");
    try {
      LocalStorageService localStorageService = LocalStorageService();
      User? user = await localStorageService.getCurrentUser();

      if (user != null) {
        return User(
          id: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
          gender: user.gender,
          phone: user.phone,
          email: user.email,
          birthday: user.birthday,
          profileImg: user.profileImg,
        );
      } else {
        print("No se encontró información del usuario.");
        return null;
      }
    } catch (e) {
      print("Error al cargar el perfil: $e");
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<Widget> pageList = [
        const HomeScreen(),
        const GamesScreen(),
            () {
          if (controller.tabIndex == 2) {
            return CreateScreen(selectedPdf: selectedPdf);
          } else {
            return Container(); // Un contenedor vacío cuando no está seleccionado
          }
        }(),
        FutureBuilder<User?>(
          future: loadUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // Mostramos un cargador mientras se obtienen los datos
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error al cargar el perfil'));
            }
            if (snapshot.hasData) {
              return ProfileScreen(user: snapshot.data!);
            } else {
              return Center(child: Text('No se encontró información del usuario.'));
            }
          },
        ),
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
            onTap: (value) async {
              controller.tabIndex = value;
              // Si se selecciona la pestaña de crear y no hay PDF seleccionado, puedes manejarlo aquí
              if (value == 2 && selectedPdf == null) {
                print('Navegando a CreateScreen sin PDF seleccionado');
                // Puedes mostrar un diálogo o snackbar aquí si lo deseas
              }
              if (value == 3) {
                // Si el índice es 3 (perfil), cargamos el perfil
                await loadUserProfile();
              }
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
                      Text('Actividades', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, color: Color(0xff565656))),
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