import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../blocs/residential_detail_bloc.dart';
import '../../domain/entities/residential.dart';

class DetailResidential extends StatelessWidget {
  final int residentialId;

  const DetailResidential({Key? key, required this.residentialId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ResidentialDetailBloc>().add(FetchResidentialById(residentialId));

    return Scaffold(
      appBar: AppBar(title: const Text("Detalle de Residencial")),
      body: BlocConsumer<ResidentialDetailBloc, ResidentialDetailState>(
        listener: (context, state) {
          if (state is ResidentialDetailLoaded) {
            print("✅ [UI] Datos actualizados: Código Invitado = ${state.residential.codigoInvitado}");
          }
        },
        builder: (context, state) {
          if (state is ResidentialDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ResidentialDetailLoaded) {
            final residential = state.residential;
            return Column(
              children: [
                _buildDetailCard(residential),
                _buildGuestCodeCard(context, residential),
                _buildVisitModeCard(context, residential),
              ],
            );
          } else {
            return const Center(child: Text("Error al cargar"));
          }
        },
      ),
    );
  }

  Widget _buildDetailCard(Residential residential) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow("Calle", residential.calle),
              _buildDetailRow("Número de Casa", residential.numeroCasa),
              _buildDetailRow("Nombre del Vecindario", residential.nombreNeighborhood),
              _buildDetailRow("Modo Visita", residential.modoVisita ? "Sí" : "No"),
              _buildDetailRow("Usos de Código", residential.codeUses.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestCodeCard(BuildContext context, Residential residential) {
    // ✅ Verifica que el base64 llega
    print("📷 QR en vista (${residential.id}): ${residential.qrBase64.length} caracteres");
    if (residential.qrBase64.isNotEmpty) {
      print("🧬 QR base64 inicio: ${residential.qrBase64.substring(0, 30)}...");
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Código QR de Invitado",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (residential.qrBase64.isNotEmpty) ...[
                Image.memory(
                  base64Decode(residential.qrBase64),
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final bytes = base64Decode(residential.qrBase64);
                      final tempDir = await getTemporaryDirectory();
                      final file = await File('${tempDir.path}/codigo_qr.png').create();
                      await file.writeAsBytes(bytes);

                      await Share.shareXFiles(
                        [XFile(file.path)],
                        text: 'Aquí tienes tu código QR para ingresar al residencial.',
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Error al compartir el QR")),
                      );
                    }
                  },
                  icon: const Icon(Icons.share),
                  label: const Text("Compartir QR"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                ),
              ] else ...[
                const Text("QR no disponible"),
              ],
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _showGenerateCodeDialog(context),
                child: const Text("Generar Código"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisitModeCard(BuildContext context, Residential residential) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Modo Visita",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Switch(
                value: residential.modoVisita,
                onChanged: (newValue) => _showConfirmVisitModeDialog(context, newValue),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmVisitModeDialog(BuildContext context, bool newValue) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(newValue ? "Activar Modo Visita" : "Desactivar Modo Visita"),
          content: Text(newValue
              ? "¿Estás seguro de que quieres activar el Modo Visita?"
              : "¿Estás seguro de que quieres desactivar el Modo Visita?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ResidentialDetailBloc>().add(
                  ToggleVisitMode(residenciaId: residentialId, modoVisita: newValue),
                );
                Navigator.pop(dialogContext);
              },
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

void _showGenerateCodeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text("Generar Código de Invitado"),
        content: const Text("¿Deseas generar un nuevo código de invitado?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              print("📤 [UI] Enviando evento `GenerateGuestCode`");

              context.read<ResidentialDetailBloc>().add(
                GenerateGuestCode(residenciaId: residentialId, usos: 0), // usos ignorado en el backend
              );

              Navigator.pop(dialogContext);
            },
            child: const Text("Generar"),
          ),
        ],
      );
    },
  );
}

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
