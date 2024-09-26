import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectPdfScreen extends StatefulWidget {
  const SelectPdfScreen({Key? key}) : super(key: key);

  @override
  _SelectPdfScreenState createState() => _SelectPdfScreenState();
}

class _SelectPdfScreenState extends State<SelectPdfScreen> {
  // Simulación de lista de PDFs
  final List<Map<String, String>> pdfList = [
    {"name": "SEMANA 15 DERECHO PROCESAL..."},
    {"name": "DERECHO PROCESAL CIVIL I"},
    {"name": "SEMANA 13 DERECHO"},
    {"name": "DERECHO PROCESAL CIVIL II"},
  ];

  // Método que construye el widget de un ítem de PDF
  Widget _buildPdfItem({required String pdfName}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              color: Color(0xffeaeaea), // Ajusta el color si es necesario
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(Icons.insert_drive_file, size: 70.sp, color: Colors.grey[700]), // Ajusta el color si es necesario
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        toolbarHeight: 45.h,
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                width: MediaQuery.of(context).size.width * 0.6, // Ajuste de ancho al 60% del ancho de la pantalla
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
            Text(
              'Mis PDFs',
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: "poppins",
              ),
            ),
            SizedBox(height: 5.h),
            Divider(
              color: Color(0xffD9D9D9), // Puedes cambiar el color si lo deseas
              thickness: 1, // Ajusta el grosor del separador
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 1,
                ),
                itemCount: pdfList.length,
                itemBuilder: (context, index) {
                  return _buildPdfItem(pdfName: pdfList[index]["name"]!);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Text(
                'Has llegado al final de los resultados',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
