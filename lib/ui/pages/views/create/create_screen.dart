import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../domain/entities/pdf.dart';
import '../../../../ui/constants/constants.dart';

class CreateScreen extends StatefulWidget {
  final Pdf? selectedPdf; // Cambiado a selectedPdf

  const CreateScreen({Key? key, this.selectedPdf}) : super(key: key);

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

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
                          Center( // Add the Center widget here
                            child: Text(
                              selectedPdf != null ? selectedPdf!.name : 'Selecciona un PDF',
                              style: TextStyle(
                                color: const Color(0xFF6D5BFF),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
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

  void _showQuizConfigDialog (BuildContext context) {
    bool _isLoading = false; // Mueve el estado aquí

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 26.0,
                right: 26.0,
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 16.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Center(
                          child: Text(
                            'Configuracion de la actividad',
                            style: TextStyle(
                              fontSize: 21,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              color: Color(0xff424242),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nombre: ',
                        style: TextStyle(
                          color: Color(0xff585858),
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    _buildTextField(
                      nameController,
                      'Nombre de la actividad',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese su nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tipo: ',
                        style: TextStyle(
                          color: Color(0xff585858),
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    _buildTextField(
                      nameController,
                      'Actividad',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese su nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tiempo por pregunta: ',
                        style: TextStyle(
                          color: Color(0xff585858),
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    _buildTextField(
                      nameController,
                      '10 minutos',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese su nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Numero de preguntas: ',
                        style: TextStyle(
                          color: Color(0xff585858),
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    _buildTextField(
                      nameController,
                      '15 preguntas',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese su nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {  // Cambia a async para poder usar await
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;  // Activa el loading
                            });

                            /*final supportProvider = Provider.of<SupportProvider>(context, listen: false);

                            try {
                              bool success = await supportProvider.reportError(
                                nameController.text,
                                descriptionController.text,
                              ).timeout(Duration(seconds: 10));

                              if (success) {
                                Navigator.of(context).pop(); // Cierra el diálogo si la respuesta es exitosa
                                _showSuccessSnackBar('Error reportado exitosamente.');
                              } else {
                                Navigator.of(context).pop();
                                _showErrorSnackBar('No se pudo reportar el error.');
                              }
                            } on TimeoutException {
                              Navigator.of(context).pop();
                              _showErrorSnackBar('La operación está tardando demasiado. Por favor, verifica tu conexión e inténtalo de nuevo.');
                            } catch (e) {
                              Navigator.of(context).pop();
                              _showErrorSnackBar('Ocurrió un error inesperado. Por favor, inténtalo de nuevo.');
                            } finally {
                              nameController.clear();
                              descriptionController.clear();

                              setState(() {
                                _isLoading = false;  // Desactiva el loading
                              });
                            }*/
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6D5BFF),
                          padding: const EdgeInsets.symmetric(vertical: 19),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                            : const Text(
                          'Crear',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String labelText,
      {bool isMultiline = false, String? Function(String?)? validator}
      ) {
    return Focus(
      child: Builder(
        builder: (BuildContext context) {
          final bool hasFocus = Focus.of(context).hasFocus;

          return TextFormField(
            controller: controller,
            decoration: InputDecoration(
              // El hintText solo se mostrará cuando no haya foco
              hintText: hasFocus ? null : labelText,
              hintStyle: TextStyle(
                color: Color(0xFF6D5BFF),
                fontSize: 18.0,
                fontFamily: 'Poppins',
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Color(0xFF6D5BFF), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: kPrimary, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Color(0xFF6D5BFF), width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
            ),
            style: TextStyle(color: Color(0xFF585858)),
            keyboardType: isMultiline ? TextInputType.multiline : TextInputType.text,
            maxLines: isMultiline ? null : 1,
            minLines: isMultiline ? 5 : 1,
            validator: validator,
          );
        },
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
        _showQuizConfigDialog(context);
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
