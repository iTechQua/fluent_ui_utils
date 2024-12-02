#ifndef FLUTTER_PLUGIN_FLUENT_UI_UTILS_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUENT_UI_UTILS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace fluent_ui_utils {

class FluentUiUtilsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FluentUiUtilsPlugin();

  virtual ~FluentUiUtilsPlugin();

  // Disallow copy and assign.
  FluentUiUtilsPlugin(const FluentUiUtilsPlugin&) = delete;
  FluentUiUtilsPlugin& operator=(const FluentUiUtilsPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace fluent_ui_utils

#endif  // FLUTTER_PLUGIN_FLUENT_UI_UTILS_PLUGIN_H_
