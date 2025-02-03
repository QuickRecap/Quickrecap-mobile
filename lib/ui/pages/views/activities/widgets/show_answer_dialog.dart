// show_answer_dialog.dart
import 'package:flutter/material.dart';

void showAnswerDialog(
    BuildContext context, {
      required bool correct,
      required VoidCallback onContinue,
    }) {
  String message = correct ? "¡Buen Trabajo!" : "Oops, Tu respuesta no es correcta";
  String subMessage = "No te preocupes, sigue intentandolo";
  String additionalMessage = correct ? "Excelente, continúa con la siguiente oracion" : "";
  Color backgroundColor = correct ? Color(0xFFBDFFC2) : Color(0xFFFFCFD0);
  Color textColor = correct ? Color(0xFF00C853) : Color(0xFFF44337);
  Color buttonTextColor = correct ? Color(0xFF00C853) : Color(0xFFF44337);

  showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Text(
                message,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (correct)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "+100 puntos",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF00C853),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  SizedBox(height: 10),
                  if (!correct)
                    Text(
                      subMessage,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
              if (additionalMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    additionalMessage,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff00C853),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onContinue();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: buttonTextColor,
                  ),
                ),
                child: Text(
                  "Continuar",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: buttonTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}