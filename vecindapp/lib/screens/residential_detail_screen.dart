import 'package:flutter/material.dart';
import 'package:vecindapp/models/residential.dart';
import 'package:vecindapp/utils/visit_code_generator.dart';
import 'package:vecindapp/widgets/visit_code_card.dart';
import 'package:screenshot/screenshot.dart';
import 'package:vecindapp/widgets/custom_appbar_clipper.dart';

class ResidentialDetailScreen extends StatefulWidget {
  final Residential res;

  const ResidentialDetailScreen({super.key, required this.res});

  @override
  State<ResidentialDetailScreen> createState() => _ResidentialDetailScreenState();
}

class _ResidentialDetailScreenState extends State<ResidentialDetailScreen> with SingleTickerProviderStateMixin {
  bool visitasActivas = true;
  String? codigoGenerado;
  List<String> codigosMultiples = [];
  ScreenshotController screenshotController = ScreenshotController();
  Map<String, ScreenshotController> multipleControllers = {};

  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void generarCodigo() {
    setState(() {
      codigoGenerado = generateVisitCode();
    });
  }

  void generarMultiplesCodigos() {
    setState(() {
      codigosMultiples = List.generate(3, (_) => generateVisitCode());
      multipleControllers = {
        for (var code in codigosMultiples) code: ScreenshotController()
      };
    });
  }

  void descargarCodigo(ScreenshotController controller) async {
    final image = await controller.capture();
    if (image != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Código guardado como imagen"),
        backgroundColor: Colors.green,
      ));
    }
  }

  void mostrarModalEditar() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Editar Residencial", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                decoration: InputDecoration(labelText: "Código de residencial"),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Calle"),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Número de casa"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF003C8F)),
                onPressed: () => Navigator.pop(context),
                child: Text("Guardar cambios", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void eliminarResidencia() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("¿Eliminar residencia?"),
        content: Text("Esta acción no se puede deshacer."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: CustomAppBarClipper(),
            child: Container(
              height: 115,
              color: Color(0xFF003C8F),
              alignment: Alignment.center,
              child: Image.asset('assets/iconVA1.png', height: 70),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 120, left: 16, right: 16, bottom: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Detalles de residencial",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: ListTile(
                            title: Text("Calle: ${widget.res.street}"),
                            subtitle: Text("Casa: ${widget.res.houseNumber}"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Card(
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      color: visitasActivas ? Colors.green.shade100 : Colors.grey.shade200,
                      child: SwitchListTile(
                        title: Text("Modo Visitas"),
                        subtitle: Text(visitasActivas ? "Activado" : "Desactivado"),
                        value: visitasActivas,
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.grey,
                        onChanged: (val) => setState(() => visitasActivas = val),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Código de Visita", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          SizedBox(height: 8),
                          Text("Proporciona este codigo a tu visita para que pueda ingresar a la colonia."),
                          SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF003C8F)),
                            onPressed: generarCodigo,
                            child: Text("Generar código", style: TextStyle(color: Colors.white)),
                          ),
                          if (codigoGenerado != null) ...[
                            SizedBox(height: 20),
                            VisitCodeCard(
                              code: codigoGenerado!,
                              controller: screenshotController,
                              onDownload: () => descargarCodigo(screenshotController),
                            )
                          ]
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Generar varios códigos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          SizedBox(height: 10),
                          Text("Desde aqui puedes generar varios accesos a la vez, no olvides compartilos con tus visitas!"),
                          SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF003C8F)),
                            onPressed: generarMultiplesCodigos,
                            child: Text("Generar 3 códigos", style: TextStyle(color: Colors.white)),
                          ),
                          SizedBox(height: 10),
                          ...codigosMultiples.map((code) => Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: VisitCodeCard(
                                  code: code,
                                  controller: multipleControllers[code]!,
                                  onDownload: () => descargarCodigo(multipleControllers[code]!),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: mostrarModalEditar,
                          icon: Icon(Icons.edit, color: Color(0xFF003C8F)),
                          label: Text("Editar Residencia", style: TextStyle(color: Color(0xFF003C8F))),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          ),
                          onPressed: eliminarResidencia,
                          icon: Icon(Icons.delete),
                          label: Text("Eliminar", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
