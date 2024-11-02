import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../ui/constants/constants.dart';
import '../../../../ui/providers/audio_provider.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  bool? isAudioEnabled; // Variable para almacenar el estado inicial

  @override
  void initState() {
    super.initState();
    // Cargar el estado inicial desde el AudioProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final audioProvider = Provider.of<AudioProvider>(context, listen: false);
      setState(() {
        isAudioEnabled = audioProvider.isEnabled;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Musica y efectos',
              style: TextStyle(
                color: Color(0xff212121),
                fontSize: 20.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Música',
                    style: TextStyle(
                      color: Color(0xff212121),
                      fontSize: 16.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Consumer<AudioProvider>(
                    builder: (context, audioProvider, child) {
                      return Switch(
                        value: isAudioEnabled ?? audioProvider.isEnabled, // Usar la variable local
                        onChanged: (value) async {
                          setState(() {
                            isAudioEnabled = value; // Actualizar la variable local
                          });
                          await audioProvider.toggleAudio(); // Cambiar el valor en el provider
                        },
                        activeColor: Color(0xff6D5BFF),
                        inactiveThumbColor: Colors.grey,
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
