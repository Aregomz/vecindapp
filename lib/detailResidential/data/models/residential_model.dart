import '../../domain/entities/residential.dart';

class ResidentialModel extends Residential {
  ResidentialModel({
    required int id,
    required String calle,
    required String numeroCasa,
    required String nombreNeighborhood,
    required bool modoVisita,
    required String codigoInvitado,
    required int codeUses,
    required String qrBase64,
  }) : super(
          id: id,
          calle: calle,
          numeroCasa: numeroCasa,
          nombreNeighborhood: nombreNeighborhood,
          modoVisita: modoVisita,
          codigoInvitado: codigoInvitado,
          codeUses: codeUses,
          qrBase64: qrBase64,
        );

  factory ResidentialModel.fromJson(Map<String, dynamic> json) {
    final fullQr = json['codigoInvitado'] ?? '';
    final cleanedBase64 = fullQr.contains('base64,')
        ? fullQr.split('base64,')[1]
        : '';

    return ResidentialModel(
      id: json['id'],
      calle: json['calle'],
      numeroCasa: json['numeroCasa'],
      nombreNeighborhood: json['nombreNeighborhood'],
      modoVisita: json['modoVisita'] ?? false,
      codigoInvitado: '', // ya no usas el texto como antes
      codeUses: json['codeUses'] ?? 0,
      qrBase64: cleanedBase64, // solo el base64 puro
    );
  }
}
