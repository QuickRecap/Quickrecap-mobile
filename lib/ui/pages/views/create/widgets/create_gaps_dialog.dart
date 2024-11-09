import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quickrecap/domain/entities/gaps_activity.dart';
import '../../activities/gaps/play_gaps_activity.dart';
import 'custom_input.dart';
import 'custom_select_input.dart';
import '../../../../providers/gaps_provider.dart';

class CreateGapsDialog extends StatefulWidget {
  final TextEditingController activityNameController;
  final TextEditingController activityTypeController;
  final TextEditingController activityTimeController;
  final TextEditingController activityQuantityController;
  final selectedPdf;

  const CreateGapsDialog({
    Key? key,
    required this.activityNameController,
    required this.activityTypeController,
    required this.activityTimeController,
    required this.activityQuantityController,
    required this.selectedPdf,
  }) : super(key: key);

  @override
  State<CreateGapsDialog> createState() => _CreateGapsDialogState();

  static void show(BuildContext context, {
    required TextEditingController activityNameController,
    required TextEditingController activityTypeController,
    required TextEditingController activityTimeController,
    required TextEditingController activityQuantityController,
    required selectedPdf,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return CreateGapsDialog(
          activityNameController: activityNameController,
          activityTypeController: activityTypeController,
          activityTimeController: activityTimeController,
          activityQuantityController: activityQuantityController,
          selectedPdf: selectedPdf,
        );
      },
    );
  }
}

class _CreateGapsDialogState extends State<CreateGapsDialog> {
  GapsActivity? gapsActivity;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isConfigView = true;
  bool _isSuccess = false;
  bool _isRepeated = false;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        if (_isConfigView) {
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
                            fontSize: 18,
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
                  const SizedBox(height: 10),
                  CustomInput(
                    controller: widget.activityNameController,
                    label: 'Ingresa un nombre',
                    validator: (value) {
                      if(_isRepeated == true){
                        return 'Ya tienes una actividad con este nombre.';
                      }
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      // Expresión regular para permitir solo letras, números y espacios
                      RegExp regExp = RegExp(r'^[a-zA-Z0-9\s\-_]+$');
                      if (!regExp.hasMatch(value)) {
                        return 'No se permiten caracteres especiales';
                      }

                      return null;
                    },
                    maxLength: 50,
                    isDisabled: false,
                    isLoading: _isLoading, // Add this line
                  ),
                  const SizedBox(height: 15),
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
                  const SizedBox(height: 10),
                  CustomInput(
                    controller: widget.activityTypeController,
                    label: 'Actividad',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      return null;
                    },
                    maxLength: 50, // Aquí defines el límite de caracteres
                    isDisabled: true, // Aquí defines si el campo está deshabilitado
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tiempo por oracion: ',
                      style: TextStyle(
                        color: Color(0xff585858),
                        fontSize: 14.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomSelectInput(
                    label: "Selecciona una opción",
                    value: widget.activityTimeController.text.isEmpty ? null : widget.activityTimeController.text,
                    options: ["60", "45", "30", "20", "15"],
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.activityTimeController.text = newValue ?? '';
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecciona una opción';
                      }
                      return null;
                    },
                    isLoading: _isLoading, // Add this line
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Numero de oraciones: ',
                      style: TextStyle(
                        color: Color(0xff585858),
                        fontSize: 14.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomSelectInput(
                    label: "Selecciona una opción",
                    isActivity: true,
                    suffix: " oraciones",
                    value: widget.activityQuantityController.text.isEmpty ? null : widget.activityQuantityController.text,
                    options: ["15", "10", "8", "5"],
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.activityQuantityController.text = newValue ?? '';
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecciona una opción';
                      }
                      return null;
                    },
                    isLoading: _isLoading, // Add this line
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                        setState(() {
                          _isRepeated = false;
                        });
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          final gapsProvider = Provider.of<GapsProvider>(context, listen: false);

                          final result = await gapsProvider.createGaps(
                            widget.activityNameController.text,
                            int.parse(widget.activityTimeController.text),
                            int.parse(widget.activityQuantityController.text),
                            widget.selectedPdf?.url ?? "",
                          );

                          if (result!.isSuccess) {
                            setState(() {
                              gapsActivity = result.data;
                              _isConfigView = false;
                              _isSuccess = true;
                            });
                          } else {
                            if (result.statusCode == 400) {
                              print('Error: Nombre de actividad duplicado');
                              setState(() {
                                _isConfigView = true;
                                _isSuccess = false;
                                _isRepeated = true;
                                _formKey.currentState?.validate();
                              });
                            } else {
                              print('Error inesperado: ${result.error}');
                              setState(() {
                                _isConfigView = false;
                                _isSuccess = false;
                              });
                            }
                          }

                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6D5BFF),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          : Text('Crear',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          )),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.all(26.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Configuracion de la actividad',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            color: Color(0xff424242),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Icon(
                  _isSuccess ? Icons.check_circle : Icons.error,
                  size: 80,
                  color: _isSuccess ? Colors.green : Colors.red,
                ),
                SizedBox(height: 20),
                Text(
                  _isSuccess ? 'Actividad Creada' : 'Ups! Hubo un error',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    color: Color(0xff424242),
                  ),
                ),
                if (!_isSuccess)
                  Text(
                    'generando la actividad',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Poppins",
                      color: Color(0xff585858),
                    ),
                  ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_isSuccess && gapsActivity != null) {
                        // Navegamos a PlayQuizActivity, pasando la instancia de quizActivity
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayGapsActivity(gapsActivity: gapsActivity!), // Usamos el operador ! para indicar que no es nulo
                          ),
                        );
                      }
                      else {
                        setState(() {
                          _isConfigView = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6D5BFF),
                      padding: const EdgeInsets.symmetric(vertical: 19),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      _isSuccess ? 'Jugar' : 'Volver',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}