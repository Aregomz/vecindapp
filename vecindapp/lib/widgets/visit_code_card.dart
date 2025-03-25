import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

class VisitCodeCard extends StatelessWidget {
  final String code;
  final ScreenshotController controller;
  final VoidCallback onDownload;

  const VisitCodeCard({
    super.key,
    required this.code,
    required this.controller,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Screenshot(
          controller: controller,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
            ),
            child: Column(
              children: [
                Text(
                  "CÓDIGO DE VISITA",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF003C8F),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  code,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Este código debes darlo en la caseta de entrada",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: onDownload,
          icon: Icon(Icons.download),
          label: Text("Descargar código"),
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF003C8F)),
        )
      ],
    );
  }
}
