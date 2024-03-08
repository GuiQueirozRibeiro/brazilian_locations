//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <brazilian_locations/brazilian_locations_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) brazilian_locations_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "BrazilianLocationsPlugin");
  brazilian_locations_plugin_register_with_registrar(brazilian_locations_registrar);
}
