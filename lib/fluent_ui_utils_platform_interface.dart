import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fluent_ui_utils_method_channel.dart';

abstract class FluentUiUtilsPlatform extends PlatformInterface {
  /// Constructs a FluentUiUtilsPlatform.
  FluentUiUtilsPlatform() : super(token: _token);

  static final Object _token = Object();

  static FluentUiUtilsPlatform _instance = MethodChannelFluentUiUtils();

  /// The default instance of [FluentUiUtilsPlatform] to use.
  ///
  /// Defaults to [MethodChannelFluentUiUtils].
  static FluentUiUtilsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FluentUiUtilsPlatform] when
  /// they register themselves.
  static set instance(FluentUiUtilsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
