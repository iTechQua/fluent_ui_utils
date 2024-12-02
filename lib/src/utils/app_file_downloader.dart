import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> checkPermissions() async {
  final Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
    Permission.manageExternalStorage,
    Permission.mediaLibrary,
    Permission.accessMediaLocation,
    Permission.photos,
    Permission.location,
  ].request();

  if ((statuses[Permission.manageExternalStorage]!.isPermanentlyDenied ||
          statuses[Permission.storage]!.isPermanentlyDenied ||
          statuses[Permission.mediaLibrary]!.isPermanentlyDenied ||
          statuses[Permission.accessMediaLocation]!.isPermanentlyDenied ||
          statuses[Permission.photos]!.isPermanentlyDenied ||
          statuses[Permission.location]!.isPermanentlyDenied) &&
      Platform.isAndroid) {
    openAppSettings();
  }
  return statuses.values.every((status) => status.isGranted);
}

Future<void> downloadAndSaveFiles(List<String> urls) async {
  final directory = await getTemporaryDirectory();
  final Dio dio = Dio();

  for (final String url in urls) {
    try {
      // Get the file name from the URL
      final fileName = url.split('/').last;
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      // Check if the file already exists
      if (await file.exists()) {
        print('File already exists: $filePath');
      } else {
        // Download the file if it doesn't exist
        final response =
            await dio.download(url, filePath);
        if (response.statusCode == 200) {
          print('File saved: $filePath');
        } else {
          print('Failed to download file: $url');
        }
      }
    } catch (e) {
      print('Error downloading or saving file: $e');
    }
  }
}

Future<List<PlatformFile>> convertToPlatformFiles(List<String> urls) async {
  final directory = await getTemporaryDirectory();
  final List<PlatformFile> platformFiles = [];

  for (final String url in urls) {
    final fileName = url.split('/').last;
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);

    if (await file.exists()) {
      platformFiles.add(
        PlatformFile(
          name: fileName,
          size: await file.length(),
          path: filePath,
          bytes: await file.readAsBytes(),
        ),
      );
    }
  }

  return platformFiles;
}
