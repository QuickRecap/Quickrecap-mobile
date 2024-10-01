import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'create_screen.dart';
import '../../../../domain/entities/pdf.dart';

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

  Future<void> _showLoadingDialog(BuildContext context, String message) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8375FD)),
              ),
              SizedBox(height: 20.h),
              Text(
                'Subiendo PDF',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Puede tomar unos segundos\ndependiendo del peso del archivo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _processUploadedPDF(BuildContext context, String pdfName, String downloadUrl) async {
    try {
      Pdf selectedPdf = Pdf(
        name: pdfName,
        url: downloadUrl,
      );

      // Navegar al entrypoint (MainScreen) y pasar el PDF seleccionado
      Navigator.pushNamed(
        context,
        '/entrypoint',
        arguments: {
          'selectedPdf': selectedPdf,  // Aquí pasas el objeto Pdf
          'initialIndex': 2    // Para asegurarte que la pestaña "Crear" esté seleccionada
        },
      );
    } catch (e) {
      // Si ocurre un error durante el procesamiento, mostrar el diálogo de error
      _showErrorDialog(context, 'Error al procesar el PDF: $e');
    }
  }



  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 50.sp,
              ),
              SizedBox(height: 20.h),
              Text(
                'Oops!',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                child: Text('Salir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> isPDFValid(File pdfFile) async {
    try {
      // Intenta leer el PDF
      final bytes = await pdfFile.readAsBytes();
      // Intenta crear un documento PDF a partir de los bytes
      PdfDocument.fromBase64String(base64Encode(bytes));
      return true;
    } catch (e) {
      // Si hay una excepción, el PDF es probablemente inválido
      print('Error al validar PDF: $e');
      return false;
    }
  }

  Future<void> _handlePdfUpload() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        File pdfFile = File(file.path!);
        bool isValid = await isPDFValid(pdfFile);
        if (!isValid) {
          _showErrorDialog(context, 'El archivo PDF seleccionado es inválido o está corrupto.');
          return;
        }
        await _showLoadingDialog(context, 'Subiendo PDF...');

        FirebaseStorage storage = FirebaseStorage.instance;
        var uuid = Uuid();
        String uniqueId = uuid.v4();
        String fileName = file.name;
        String uniqueFileName = '${uniqueId}_${file.name}';
        Reference ref = storage.ref().child('uploads/$uniqueFileName');
        final metadata = SettableMetadata(contentType: 'application/pdf');
        UploadTask uploadTask = ref.putFile(pdfFile, metadata);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Cerrar el diálogo de carga antes de procesar el PDF
        Navigator.of(context).pop();

        // Procesar el PDF subido
        await _processUploadedPDF(context, fileName, downloadUrl);
      } else {
        _showErrorDialog(context, 'No se seleccionó ningún archivo');
      }
    } catch (e) {
      // Si ocurre un error durante la subida, mostrar el diálogo de error
      Navigator.of(context).pop(); // Cerrar el diálogo de carga si está abierto
      _showErrorDialog(context, 'Error al subir el PDF: $e');
    }
  }

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
                          backgroundColor: Color(0xFF8375FD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        onPressed: _handlePdfUpload,
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
