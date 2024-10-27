import 'package:flutter/material.dart';
import '../../../../../domain/entities/linkers.dart';
import '../../../../../domain/entities/linkers_activity.dart';

class ReviewAnswersLinkers extends StatefulWidget {
  final LinkersActivity linkersActivity;

  ReviewAnswersLinkers({required this.linkersActivity});

  @override
  _ReviewAnswersLinkersState createState() => _ReviewAnswersLinkersState();
}

class _ReviewAnswersLinkersState extends State<ReviewAnswersLinkers> {
  int _currentIndex = 0;
  bool isShowingCorrectAnswers = false;
  int? selectedWordIndex;
  int? selectedDefinitionIndex;
  // Variable para almacenar las conexiones que se muestran actualmente
  List<LinkerItem>? _displayedConnections;

  @override
  void initState() {
    super.initState();
    // Inicializamos con las conexiones del usuario
    _displayedConnections = List.from(
        widget.linkersActivity.linkers![_currentIndex].selectedLinkerItems ?? []
    );
    _initializeLinkerExercise();
  }

  void _nextLinker() {
    if (_currentIndex < widget.linkersActivity.linkers!.length - 1) {
      setState(() {
        _currentIndex++;
        isShowingCorrectAnswers = false;
        _initializeLinkerExercise();
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _previousLinker() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _initializeLinkerExercise();
      });
    }
  }

  void toggleShowCorrectAnswers() {
    Linkers currentLinker = widget.linkersActivity.linkers![_currentIndex];
    setState(() {
      isShowingCorrectAnswers = !isShowingCorrectAnswers;

      if (isShowingCorrectAnswers) {
        // Mostrar las respuestas correctas en _displayedConnections
        _displayedConnections?.clear();

        // Generar las conexiones correctas basadas en posiciones coincidentes
        for (var linkerItem in currentLinker.linkerItems) {
          int wordPosition = linkerItem.wordItem.position!;

          var matchingDefinition = currentLinker.linkerItems
              .firstWhere((item) => item.definitionItem.position == wordPosition)
              .definitionItem;

          var correctConnection = LinkerItem(
              wordItem: linkerItem.wordItem,
              definitionItem: matchingDefinition
          );

          _displayedConnections?.add(correctConnection);
        }
      } else {
        // Restaurar las conexiones del usuario
        _displayedConnections = List.from(
            currentLinker.selectedLinkerItems ?? []
        );
      }
    });
  }

  // Método para crear conexiones
  void _createConnection(int wordIndex, int definitionIndex) {
    var currentLinker = widget.linkersActivity.linkers![_currentIndex];

    // Crear un nuevo LinkerItem que conecte los elementos seleccionados por el usuario
    var selectedWord = currentLinker.linkerItems[wordIndex].wordItem;
    var selectedDefinition = currentLinker.linkerItems[definitionIndex].definitionItem;

    // Eliminar conexiones previas que involucren cualquiera de los elementos
    currentLinker.selectedLinkerItems?.removeWhere((item) =>
    item.wordItem.position == selectedWord.position ||
        item.definitionItem.position == selectedDefinition.position
    );

    // Crear un nuevo LinkerItem con la conexión seleccionada por el usuario
    var newConnection = LinkerItem(
        wordItem: selectedWord,
        definitionItem: selectedDefinition
    );

    // Agregar la nueva conexión
    currentLinker.selectedLinkerItems?.add(newConnection);
  }

  void _initializeLinkerExercise() {
    // Limpiar las selecciones actuales
    selectedWordIndex = null;
    selectedDefinitionIndex = null;

    setState(() {
      // Usamos _displayedConnections en lugar de modificar directamente selectedLinkerItems
      _displayedConnections = List.from(
          widget.linkersActivity.linkers![_currentIndex].selectedLinkerItems ?? []
      );
    });
  }

  void _showContentDialog(String content, String type) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                type,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                ),
              ),
              SizedBox(height: 10),
              Text(
                content,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Color(0xFF212121),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cerrar',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6D5BFF),
                  minimumSize: Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Linkers currentLinker = widget.linkersActivity.linkers![_currentIndex];

    // Calculamos la altura para dos líneas de texto
    final double containerHeight = (TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20,
    ).fontSize! * 1.2 * 2) + 16; // 2 líneas * altura de línea + padding vertical

    return Scaffold(
        backgroundColor: Color(0xFFF6F8FC),
        appBar: AppBar(
          backgroundColor: Color(0xFFF6F8FC),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  height: 13,
                  decoration: BoxDecoration(
                    color: Color(0x1A6D5BFF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (_currentIndex + 1) /
                        widget.linkersActivity.linkers!.length,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF6D5BFF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Color(0xff6D5BFF),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  '${_currentIndex + 1}/${widget.linkersActivity.linkers!.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Row(
                            children: [
                              Text(
                                "Pregunta ${_currentIndex + 1}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF212121),
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(
                                  isShowingCorrectAnswers ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,
                                  color: Color(0xFF212121),
                                ),
                                onPressed: toggleShowCorrectAnswers,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        // Contenedor de las columnas con Stack para las líneas
                        Stack(
                          children: [
                            // Primero dibujamos las líneas de conexión
                            ..._displayedConnections!.map((linkerItem) {
                              int wordIndex = currentLinker.linkerItems.indexWhere(
                                    (item) => item.wordItem.position == linkerItem.wordItem.position,
                              );
                              int definitionIndex = currentLinker.linkerItems.indexWhere(
                                    (item) => item.definitionItem.position == linkerItem.definitionItem.position,
                              );

                              return CustomPaint(
                                painter: LinePainter(
                                  startIndex: wordIndex,
                                  endIndex: definitionIndex,
                                  color: Color(0xFF6D5BFF),
                                ),
                                size: Size(
                                  MediaQuery.of(context).size.width,
                                  containerHeight * currentLinker.linkerItems.length,
                                ),
                              );
                            }).toList(),

                            // Luego las columnas de words y definitions
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Columna de palabras (izquierda)
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Column(
                                      children: currentLinker.linkerItems.asMap().entries.map((entry) {
                                        int index = entry.key;
                                        var item = entry.value;
                                        bool isSelected = selectedWordIndex == index;
                                        bool isConnected = currentLinker.selectedLinkerItems!.any(
                                                (selectedItem) => selectedItem.wordItem.position == item.wordItem.position
                                        );

                                        return GestureDetector(
                                          onLongPress: () => _showContentDialog(item.wordItem.content, 'Palabra'),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.35,
                                            height: containerHeight,
                                            margin: EdgeInsets.only(bottom: 35),
                                            padding: EdgeInsets.symmetric(horizontal: 12),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Color(0xFF6D5BFF), width: 1),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(15),
                                                bottomRight: Radius.circular(15),
                                              ),
                                              color: isSelected || isConnected
                                                  ? Color(0xFF6D5BFF)
                                                  : Colors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                item.wordItem.content,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 17,
                                                  color: isSelected || isConnected
                                                      ? Colors.white
                                                      : Color(0xFF212121),
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 70),
                                // Columna de definiciones (derecha)
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Column(
                                      children: currentLinker.linkerItems.asMap().entries.map((entry) {
                                        int index = entry.key;
                                        var item = entry.value;
                                        bool isSelected = selectedDefinitionIndex == index;
                                        bool isConnected = currentLinker.selectedLinkerItems!.any(
                                                (selectedItem) => selectedItem.definitionItem.position == item.definitionItem.position
                                        );

                                        return GestureDetector(
                                          onLongPress: () => _showContentDialog(item.definitionItem.content, 'Definición'),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.35,
                                            height: containerHeight,
                                            margin: EdgeInsets.only(bottom: 35),
                                            padding: EdgeInsets.symmetric(horizontal: 12),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Color(0xFF6D5BFF), width: 1),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                bottomLeft: Radius.circular(15),
                                              ),
                                              color: isSelected || isConnected
                                                  ? Color(0xFF6D5BFF)
                                                  : Colors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                item.definitionItem.content,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 17,
                                                  color: isSelected || isConnected
                                                      ? Colors.white
                                                      : Color(0xFF212121),
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Center(
                          child: Text(
                            "Manten presionado para ver el texto completo",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Color(0xFF727272),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.all(16.0), // Ajusta el valor según tus necesidades
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: _previousLinker,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff7464FC),
                                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                                  disabledBackgroundColor: Colors.grey[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                ),
                                child: Text(
                                  "Anterior",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Spacer(),
                              ElevatedButton(
                                onPressed: _nextLinker,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff7464FC),
                                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                                  disabledBackgroundColor: Colors.grey[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                ),
                                child: Text(
                                  _currentIndex < widget.linkersActivity.linkers!.length - 1 ? "Siguiente" : "Salir",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

}

class LinePainter extends CustomPainter {
  final int startIndex;
  final int endIndex;
  final Color color;

  LinePainter({
    required this.startIndex,
    required this.endIndex,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Ajustamos las medidas para coincidir con el layout
    final containerHeight = 100.0; // Altura total incluyendo el margen
    final containerActualHeight = 70.0; // Altura real del contenedor
    final containerWidth = size.width * 0.35;
    final gap = size.width * 0.3;

    // Calculamos la posición Y considerando el margen superior inicial y la altura del contenedor
    final startY = (startIndex * containerHeight) + (containerActualHeight / 2);
    final endY = (endIndex * containerHeight) + (containerActualHeight / 2);

    // Definimos los puntos de inicio y fin
    final startPoint = Offset(containerWidth, startY);
    final endPoint = Offset(size.width - containerWidth, endY);

    // Dibujamos la línea
    final path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);

    // Puntos de control para la curva
    final controlPoint1 = Offset(
        startPoint.dx + gap * 0.5,
        startY
    );
    final controlPoint2 = Offset(
        endPoint.dx - gap * 0.5,
        endY
    );

    path.cubicTo(
        controlPoint1.dx, controlPoint1.dy,
        controlPoint2.dx, controlPoint2.dy,
        endPoint.dx, endPoint.dy
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}