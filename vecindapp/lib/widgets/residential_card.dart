import 'package:flutter/material.dart';
import 'package:vecindapp/models/residential.dart';

class ResidentialCard extends StatelessWidget {
  final Residential res;
  final VoidCallback onViewDetails;

  const ResidentialCard({
    required this.res,
    required this.onViewDetails,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Residencial: ${res.code}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Calle: ${res.street}"),
            Text("Casa: ${res.houseNumber}"),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onViewDetails,
                child: Text("Ver detalles", style: TextStyle(color: Color(0xFF003C8F))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
