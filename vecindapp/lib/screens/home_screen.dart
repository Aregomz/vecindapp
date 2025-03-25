import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vecindapp/models/residential.dart';
import 'package:vecindapp/providers/residential_provider.dart';
import 'package:vecindapp/screens/residential_detail_screen.dart';
import 'package:vecindapp/widgets/residential_card.dart';
import 'package:vecindapp/widgets/custom_appbar_clipper.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  void showRegisterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Registrarse a residencial", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("Ingrese los datos para registrarse a una residencial",
                  style: TextStyle(color: Colors.grey)),

              SizedBox(height: 20),
              TextField(
                controller: codeController,
                decoration: InputDecoration(labelText: "Código de vecindario"),
              ),
              TextField(
                controller: streetController,
                decoration: InputDecoration(labelText: "Calle"),
              ),
              TextField(
                controller: numberController,
                decoration: InputDecoration(labelText: "Número de casa"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (codeController.text.isNotEmpty &&
                      streetController.text.isNotEmpty &&
                      numberController.text.isNotEmpty) {
                    final newRes = Residential(
                      code: codeController.text.trim(),
                      street: streetController.text.trim(),
                      houseNumber: numberController.text.trim(),
                    );
                    Provider.of<ResidentialProvider>(context, listen: false).addResidential(newRes);
                    Navigator.pop(context);
                    codeController.clear();
                    streetController.clear();
                    numberController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF003C8F)),
                child: Text("Registrarse"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final residentials = context.watch<ResidentialProvider>().residentials;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo AppBar personalizado
          ClipPath(
            clipper: CustomAppBarClipper(),
            child: Container(
              height: 115,
              color: Color(0xFF003C8F),
              alignment: Alignment.center,
              child: Image.asset('assets/iconVA1.png', height: 90),
            ),
          ),

          // Contenido debajo del AppBar
          Padding(
            padding: EdgeInsets.only(top: 120, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mis residenciales",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: residentials.isEmpty
                      ? Center(
                          child: Text(
                            "Aún no estás registrado en ninguna residencial.",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          itemCount: residentials.length,
                          itemBuilder: (context, index) {
                            return ResidentialCard(
                              res: residentials[index],
                              onViewDetails: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ResidentialDetailScreen(res: residentials[index]),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showRegisterModal(context),
        backgroundColor: Color(0xFF003C8F),
        child: Icon(Icons.add),
      ),
    );
  }
}
