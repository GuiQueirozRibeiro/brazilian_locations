#ifndef FLUTTER_PLUGIN_BRAZILIAN_LOCATIONS_PLUGIN_H_
#define FLUTTER_PLUGIN_BRAZILIAN_LOCATIONS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace brazilian_locations {

class BrazilianLocationsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  BrazilianLocationsPlugin();

  virtual ~BrazilianLocationsPlugin();

  // Disallow copy and assign.
  BrazilianLocationsPlugin(const BrazilianLocationsPlugin&) = delete;
  BrazilianLocationsPlugin& operator=(const BrazilianLocationsPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace brazilian_locations

#endif  // FLUTTER_PLUGIN_BRAZILIAN_LOCATIONS_PLUGIN_H_
