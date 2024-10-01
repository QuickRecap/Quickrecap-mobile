import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../domain/entities/pdf.dart';


class CreateScreen extends StatefulWidget {
  final Pdf? selectedPdf; // Cambiado a selectedPdf

  const CreateScreen({Key? key, this.selectedPdf}) : super(key: key);

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {

  @override
  Widget build(BuildContext context) {
    final Pdf? selectedPdf = widget.selectedPdf; // Obtener el PDF directamente

    print(selectedPdf != null ? 'PDF seleccionado en createScreen: ${selectedPdf.name}' : 'No se recibió un PDF seleccionado');

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75.h),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 75.h,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'Crear una actividad',
            style: TextStyle(
              color: Color(0xff212121),
              fontSize: 24.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 36.w),
            child: Column(
              children: [
                // Botón para seleccionar PDF
                InkWell(
                  onTap: () async {
                    // Navega a la pantalla de selección de PDF y espera a recibir el pdfUrl
                    final pdf = await Navigator.pushNamed(context, '/select_pdf');
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDEBFF),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: const Color(0xFF6D5BFF),
                        width: 2.w,
                      ),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/pdf-create-icon.png',
                          height: 60.h,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          selectedPdf != null ? selectedPdf!.name : 'Selecciona un PDF',
                          style: TextStyle(
                            color: const Color(0xFF6D5BFF),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                Text(
                  'Selecciona un modo',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Poppins",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 24.h),

                // Modos de actividad
                Column(
                  children: [
                    _buildModeOption(
                      icon: Icons.quiz,
                      title: 'Quiz',
                      description: 'Elige la opción correcta.',
                      isEnabled: selectedPdf != null, // Control de habilitación
                    ),
                    _buildModeOption(
                      icon: Icons.extension,
                      title: 'Gaps',
                      description: 'Completa los espacios.',
                      isEnabled: selectedPdf != null, // Control de habilitación
                    ),
                    _buildModeOption(
                      icon: Icons.style,
                      title: 'Flashcards',
                      description: 'Responde antes de girar.',
                      isEnabled: selectedPdf != null, // Control de habilitación
                    ),
                    _buildModeOption(
                      icon: Icons.link,
                      title: 'Linkers',
                      description: 'Relaciona términos y conceptos.',
                      isEnabled: selectedPdf != null, // Control de habilitación
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método para construir las opciones de modo
  Widget _buildModeOption({
    required IconData icon,
    required String title,
    required String description,
    required bool isEnabled,
  }) {
    return GestureDetector(
      onTap: isEnabled
          ? () {
        // Acción solo si el botón está habilitado
        print('Acción del modo $title');
      }
          : null, // No acción si está deshabilitado
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10.r,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 36.sp,
              color: isEnabled ? Colors.black : Colors.black.withOpacity(0.3),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: isEnabled ? Colors.black : Colors.black.withOpacity(0.3),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: isEnabled ? Colors.grey[600] : Colors.grey[600]!.withOpacity(0.3),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
