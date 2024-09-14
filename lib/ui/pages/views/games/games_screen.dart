import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrecap/ui/common/custom_container.dart';
import 'package:quickrecap/ui/constants/constants.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: PreferredSize(preferredSize: Size.fromHeight(105.h), child: Container(height: 130,)),
      body: SafeArea(
        child: CustomContainer(containerContent: Container())
      )
    );
  }
}