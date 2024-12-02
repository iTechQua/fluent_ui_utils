#include "include/fluent_ui_utils/fluent_ui_utils_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "fluent_ui_utils_plugin.h"

void FluentUiUtilsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  fluent_ui_utils::FluentUiUtilsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
