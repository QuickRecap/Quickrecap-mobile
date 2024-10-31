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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Música',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Consumer<AudioProvider>(
                  builder: (context, audioProvider, child) {
                    return Switch(
                      value: audioProvider.isMusicEnabled,
                      onChanged: (bool value) {
                        audioProvider.toggleMusic();
                      },
                      activeColor: Colors.purple, // O el color que prefieras
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}