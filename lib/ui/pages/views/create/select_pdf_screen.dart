import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectPdfScreen extends StatefulWidget {
  const SelectPdfScreen({Key? key}) : super(key: key);

  @override
  _SelectPdfScreenState createState() => _SelectPdfScreenState();
}

class _SelectPdfScreenState extends State<SelectPdfScreen> {
  final List<Map<String, String>> pdfList = [
    {"name": "SEMANA 15 DERECHO PROCESAL..."},
    {"name": "DERECHO PROCESAL CIVIL I"},
    {"name": "SEMANA 13 DERECHO"},
    {"name": "DERECHO PROCESAL CIVIL II"},
    {"name": "SEMANA 15 DERECHO PROCESAL..."},
    {"name": "DERECHO PROCESAL CIVIL I"},
    {"name": "SEMANA 13 DERECHO"},
    {"name": "DERECHO PROCESAL CIVIL II"},
  ];

  Widget _buildPdfItem({required String pdfName}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 125.w,
            height: 125.w,
            decoration: BoxDecoration(
              color: Color(0xffF3F3F3),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.insert_drive_file_outlined, size: 100.sp, color: Colors.grey[700]),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              pdfName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        toolbarHeight: 55.h,
        title: Text(
          'Selecciona un PDF',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontFamily: "poppins",
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'o',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                      fontFamily: "poppins",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.upload_file, color: Colors.white),
                        label: Text(
                          'Sube un PDF',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontFamily: "poppins",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF8375FD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        onPressed: () {
                          // Lógica para subir PDF
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              child: Container(
                // En lugar de usar `color: Colors.white`, lo colocamos dentro de la `decoration`
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: Colors.white, // El color se mueve aquí
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xffD9D9D9), // Color del borde inferior
                      width: 1.0, // Grosor del borde inferior
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mis PDFs',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontFamily: "poppins",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(10.w),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return _buildPdfItem(pdfName: pdfList[index]["name"]!);
                },
                childCount: pdfList.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Text(
                'Has llegado al final de los resultados',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xff9A9A9A), fontSize: 14.sp),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 30.h),  // Añadimos espacio adicional aquí
          ),
        ],
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 39.h;  // Reduce la altura máxima del header

  @override
  double get minExtent => 39.h;  // Reduce la altura mínima del header

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
