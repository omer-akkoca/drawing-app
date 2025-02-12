import 'package:drawing/models/stroke.dart';
import 'package:flutter/material.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<Stroke> _strokes = [];
  List<Stroke> _redoStokes = [];
  List<Offset> _currentPoints = [];
  Color _selectedColor = Colors.black;
  double _brushSize = 4.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Draw Your Dream"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  _currentPoints.add(details.localPosition);
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  _currentPoints.add(details.localPosition);
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _strokes.add(Stroke(
                    points: List.from(_currentPoints),
                    color: _selectedColor,
                    brushSize: _brushSize,
                  ));
                  _currentPoints = [];
                  _redoStokes = [];
                });
              },
              child: CustomPaint(
                painter: DrawPainter(
                  strokes: _strokes,
                  currentPoints: _currentPoints,
                  currentColor: _selectedColor,
                  currentBrushSize: _brushSize,
                ),
                size: Size.infinite,
              ),
            ),
          ),
          _buildToolBar(),
        ],
      ),
    );
  }

  Widget _buildToolBar(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[200],
      child: Row(
        children: [

          // Undo button
          IconButton(
            onPressed: _strokes.isNotEmpty ? (){
              setState(() {
                _redoStokes.add(_strokes.removeLast());
              });
            } : null,
            icon: const Icon(Icons.undo),
          ),

          // Redo button
          IconButton(
            onPressed: _redoStokes.isNotEmpty ? (){
              setState(() {
                _strokes.add(_redoStokes.removeLast());
              });
            } : null,
            icon: const Icon(Icons.redo),
          ),

          const Spacer(),

          // Brush size dropdown
          DropdownButton<double>(
            value: _brushSize,
            items: const [
              DropdownMenuItem(value: 2, child: Text("Small")),
              DropdownMenuItem(value: 4, child: Text("Medium")),
              DropdownMenuItem(value: 8, child: Text("Large")),
            ],
            onChanged: (value){
              if (value != null) {
                setState(() {
                  _brushSize = value;
                });
              }
            },
          ),
          const SizedBox(width: 4),
          // Color picker
          Row(
            children: [
              _buildColorButton(Colors.black),
              _buildColorButton(Colors.red),
              _buildColorButton(Colors.blue),
              _buildColorButton(Colors.green),
              _buildColorButton(Colors.orange),
            ],
          )
        ],
      ),
    );
  }
  Widget _buildColorButton(Color color){
    return GestureDetector(
      onTap: (){
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 24,
          height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _selectedColor == color ? Colors.grey : Colors.transparent,
            width: 2
          )
        ),
      ),
    );
  }
}

class DrawPainter extends CustomPainter {
  final List<Stroke> strokes;
  final List<Offset> currentPoints;
  final Color currentColor;
  final double currentBrushSize;

  DrawPainter({
    super.repaint,
    required this.strokes,
    required this.currentPoints,
    required this.currentColor,
    required this.currentBrushSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for(var stroke in strokes){
      final paint = Paint()
          ..color = stroke.color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = stroke.brushSize;
      for(int i=0; i< stroke.points.length - 1; i++){
        if (stroke.points[i] != Offset.zero && stroke.points[i+1] != Offset.zero) {
          canvas.drawLine(stroke.points[i], stroke.points[i+1], paint);
        }  
      }
    }

    //draw the current active stroke
    final paint = Paint()
      ..color = currentColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = currentBrushSize;
    for(int i=0; i< currentPoints.length - 1; i++){
      if (currentPoints[i] != Offset.zero && currentPoints[i+1] != Offset.zero) {
        canvas.drawLine(currentPoints[i], currentPoints[i+1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
