import 'package:flutter/material.dart';
import 'package:vecindapp/models/residential.dart';

class ResidentialDetailScreen extends StatelessWidget {
  final Residential res;

  const ResidentialDetailScreen({required this.res, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Residencial'),
        backgroundColor: Color(0xFF003C8F),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Código: ${res.code}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Calle: ${res.street}", style: TextStyle(fontSize: 16)),
            Text("Número de casa: ${res.houseNumber}", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
