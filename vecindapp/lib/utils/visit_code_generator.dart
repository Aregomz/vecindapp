import 'dart:math';

String generateVisitCode() {
  final random = Random();
  return (100000 + random.nextInt(900000)).toString(); // 6 dígitos
}
