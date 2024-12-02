import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fluent_ui_utils_platform_interface.dart';

/// An implementation of [FluentUiUtilsPlatform] that uses method channels.
class MethodChannelFluentUiUtils extends FluentUiUtilsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fluent_ui_utils');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
