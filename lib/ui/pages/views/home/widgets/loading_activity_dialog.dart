import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingActivityDialog {
  static Future<void> show(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) => TweenAnimationBuilder(
        duration: const Duration(milliseconds: 300),
        tween: Tween<double>(begin: 0, end: 1),
        curve: Curves.easeOutCubic,
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            width: 250.w,
            padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder(
                  duration: const Duration(seconds: 1),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.rotate(
                      angle: value * 2 * 3.14159,
                      child: child,
                    );
                  },
                  child: SizedBox(
                    width: 60.w,
                    height: 53.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 6.w,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8375FD)),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 400),
                  tween: Tween<double>(begin: 0, end: 1),
                  curve: Curves.easeOut,
                  builder: (context, double value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    'Cargando\nActividad',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 400),
                  tween: Tween<double>(begin: 0, end: 1),
                  curve: Curves.easeOut,
                  builder: (context, double value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    'Puede tomar unos segundos\ndependiendo de la actividad',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}