import 'package:dio/dio.dart';
import '../../../core/storage/storage.dart';
import '../models/residential_model.dart';
import 'dart:io';

class ResidentialRemoteDataSource {
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://vecindappback-production.up.railway.app',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'accept': '*/*',
      'Content-Type': 'application/json',
    },
  ))
    ..interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      requestHeader: false,
      responseHeader: false,
    ));

  // ✅ Método corregido para enviar token a /auth/fcm-token
  Future<void> updateToken(String fcmToken) async {
    try {
      final userToken = await Storage.getToken();
      final response = await dio.post(
        '/auth/fcm-token',
        data: {'fcmToken': fcmToken},
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      if (response.statusCode == 201) {
        print('✅ Token FCM actualizado correctamente');
      } else {
        throw Exception('Error al actualizar token. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ [FCMS] DioException: ${e.message}');
      if (e.response != null) {
        print('🧾 Error body: ${e.response?.data}');
      }
      throw Exception("DioException: ${e.message}");
    } catch (e) {
      print('❌ [FCMS] Error general: $e');
      throw Exception("Error general al enviar token FCM: $e");
    }
  }

  Future<ResidentialModel> getResidentialById(int id) async {
    try {
      final token = await Storage.getToken();
      final response = await dio.get(
        '/residents/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      // ✅ Agrega este print justo después del response
    print('📦 Datos recibidos del backend: ${response.data}');

      if (response.statusCode == 200) {
        return ResidentialModel.fromJson(response.data);
      } else {
        throw Exception("Error al obtener el residencial");
      }
    } catch (e) {
      throw Exception("Error en getResidentialById: $e");
    }
  }

Future<String> generateGuestCode(int residenciaId, int usos) async {
  try {
    final token = await Storage.getToken();
    final response = await dio.post(
      '/residents/generate-visit-code',
      data: {
        'residenciaId': residenciaId, // ✅ solo este campo
        // 'usos': usos, ❌ no lo mandes más
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 201) {
      final fullBase64 = response.data["codigoInvitado"] ?? '';
      return fullBase64.contains('base64,')
          ? fullBase64.split('base64,')[1]
          : '';
    } else {
      throw Exception("Error al generar el código de invitado");
    }
  } catch (e) {
    throw Exception("Error en generateGuestCode: $e");
  }
}



  Future<void> toggleVisitMode(int residenciaId, bool modoVisita) async {
    try {
      final token = await Storage.getToken();
      final response = await dio.patch(
        '/residents/toggle-visit-mode',
        data: {"residenciaId": residenciaId, "modoVisita": modoVisita},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        print("✅ [RemoteData] Modo visita actualizado correctamente.");
      } else {
        throw Exception("Error al actualizar el modo visita");
      }
    } catch (e) {
      print("❌ [RemoteData] Error en toggleVisitMode: $e");
      throw Exception("Error al actualizar el modo visita");
    }
  }
}
