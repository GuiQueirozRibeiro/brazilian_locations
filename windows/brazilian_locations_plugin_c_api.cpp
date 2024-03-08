#include "include/brazilian_locations/brazilian_locations_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "brazilian_locations_plugin.h"

void BrazilianLocationsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  brazilian_locations::BrazilianLocationsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
