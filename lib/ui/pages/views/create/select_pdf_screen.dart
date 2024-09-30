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
      builder: (context) => AlertDialog(
        title: Text('Cargando'),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text(message),
          ],
        ),
      ),
    );
  }

  Future<void> _processUploadedPDF(BuildContext context, String downloadUrl) async {
    final timeoutDuration = Duration(seconds: 30);

    try {

      // Imprime la URL generada en la consola
      print('URL del PDF generado: $downloadUrl');

      final response = await http
          .post(
        Uri.parse('http://10.0.2.2:8000/api/process_pdf_claude/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'pdf_url': downloadUrl,
        }),
      )
          .timeout(timeoutDuration, onTimeout: () {
        Navigator.of(context).pop();
        _showErrorDialog(context, 'El proceso tomó demasiado tiempo y fue cancelado.');
        throw Exception('Timeout');
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        Navigator.of(context).pop(); // Cierra el diálogo de carga
      } else {
        Navigator.of(context).pop(); // Cierra el diálogo de carga
        _showErrorDialog(context, 'Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Cierra el diálogo de carga
      _showErrorDialog(context, 'Error al procesar el PDF: $e');
    }
  }


  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      File pdfFile = File(file.path!);
      // Verificar si el PDF es válido
      bool isValid = await isPDFValid(pdfFile);
      if (!isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('El archivo PDF seleccionado es inválido o está corrupto.')),
        );
        return;
      }
      await _showLoadingDialog(context, 'Subiendo PDF...');
      FirebaseStorage storage = FirebaseStorage.instance;
      // Genera un UUID
      var uuid = Uuid();
      String uniqueId = uuid.v4();
      // Crea un nombre único para el archivo
      String uniqueFileName = '${uniqueId}_${file.name}';
      Reference ref = storage.ref().child('uploads/$uniqueFileName');
      final metadata = SettableMetadata(
        contentType: 'application/pdf',
      );
      UploadTask uploadTask = ref.putFile(
        pdfFile,
        metadata,
      );
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      Navigator.of(context).pop(); // Cierra el diálogo de carga
      await _showLoadingDialog(context, 'Generando preguntas...');
      await _processUploadedPDF(context, downloadUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se seleccionó ningún archivo')),
      );
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
