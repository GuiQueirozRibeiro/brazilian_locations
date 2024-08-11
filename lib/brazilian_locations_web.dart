import 'dart:async';
import 'dart:html' as html show window;

/// Todo implementation of BrazilianLocations Web
class BrazilianLocations {
  static Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }
}
