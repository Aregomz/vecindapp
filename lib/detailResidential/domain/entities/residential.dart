class Residential {
  final int id;
  final String calle;
  final String numeroCasa;
  final String nombreNeighborhood;
  final bool modoVisita;
  final String codigoInvitado;
  final int codeUses;
  final String qrBase64;

  Residential({
    required this.id,
    required this.calle,
    required this.numeroCasa,
    required this.nombreNeighborhood,
    required this.modoVisita,
    required this.codigoInvitado,
    required this.codeUses,
    required this.qrBase64,
  });

  // ✅ Método copyWith agregado
  Residential copyWith({
    int? id,
    String? calle,
    String? numeroCasa,
    String? nombreNeighborhood,
    bool? modoVisita,
    String? codigoInvitado,
    int? codeUses,
    String? qrBase64,
  }) {
    return Residential(
      id: id ?? this.id,
      calle: calle ?? this.calle,
      numeroCasa: numeroCasa ?? this.numeroCasa,
      nombreNeighborhood: nombreNeighborhood ?? this.nombreNeighborhood,
      modoVisita: modoVisita ?? this.modoVisita,
      codigoInvitado: codigoInvitado ?? this.codigoInvitado,
      codeUses: codeUses ?? this.codeUses,
      qrBase64: qrBase64 ?? this.qrBase64,
    );
  }
}
