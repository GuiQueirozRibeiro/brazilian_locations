import 'dart:async';
import 'dart:js_interop';

@JS('navigator.userAgent')
external String get userAgent;

class BrazilianLocations {
  static Future<String?> getPlatformVersion() async {
    // Acessa a versão do navegador (userAgent) via JS interop
    final version = userAgent;
    return version;
  }
}
