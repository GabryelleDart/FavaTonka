import 'package:flutter/foundation.dart';

/// Endereço do computador onde estão rodando os containers Docker.
///
/// Padrões (nenhum ajuste é necessário nestes casos):
///  - emulador Android do Android Studio -> http://10.0.2.2 (é como o emulador enxerga o PC)
///  - Chrome, Windows, Linux, macOS e simulador do iPhone -> http://localhost
///
/// Para o celular físico (Android ou iPhone), informe o IP do PC na rede Wi-Fi:
///   flutter run --dart-define=URL_SERVICOS=http://192.168.0.10
const String _urlDefinida = String.fromEnvironment('URL_SERVICOS');

String get urlServicos {
  if (_urlDefinida.isNotEmpty) return _urlDefinida;
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2';
  }
  return 'http://localhost';
}

// Uma porta para cada container (veja servicos/docker-compose.yml)
String get urlPerfumes => '$urlServicos:5001';
String get urlComentarios => '$urlServicos:5002';
String get urlFavoritos => '$urlServicos:5003';
String get urlArquivos => '$urlServicos:5005';
