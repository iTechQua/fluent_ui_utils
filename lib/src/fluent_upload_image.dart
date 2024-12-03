import 'dart:io';
import 'package:clay_containers/clay_containers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show AlertDialog;

class FluentUploadImage extends StatefulWidget {
  const FluentUploadImage({
    super.key,
    required this.height,
    required this.radius,
    this.uniqueKey,
    this.isWeb,
    this.webFiles,
    this.files,
  });

  final Key? uniqueKey;
  final double height;
  final double radius;
  final bool? isWeb;
  final List<File>? files;
  final List<Uint8List>? webFiles;

  @override
  State<FluentUploadImage> createState() => _FluentUploadImageState();
}

class _FluentUploadImageState extends State<FluentUploadImage> {
  late List<File> files = [];
  late List<Uint8List> webFiles = [];

  @override
  void initState() {
    super.initState();

    files = widget.files?? [];
    webFiles = widget.webFiles ?? [];
  }

  Future<List<File>?> pickImageFiles() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null && result.paths.isNotEmpty) {
      // Safely handle null paths and map them to List<File>
      setState(() {
        files = result.paths
            .where((path) => path != null) // Filter out null paths
            .map((path) => File(path!)) // Convert to File
            .toList();
      });

      return widget.files; // Return the updated list of files
    } else {
      return []; // Return an empty list if no file was picked
    }
  }

  Future<List<Uint8List>?> pickWebImageFiles() async {
    // Pick image files for web
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    // If the user picks files and they are not empty
    if (result != null && result.files.isNotEmpty) {
      // Convert files to List<Uint8List> (files as bytes)
      webFiles = result.files
          .map((file) => file.bytes!) // file.bytes is the byte data of the file
          .toList();

      return widget.webFiles; // Return the list of Uint8List (files in bytes)
    } else {
      return []; // Return an empty list if no files were picked
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color baseColor = Color(0xFFF2F2F2);
    const Color darkColor = Color(0xFF2F2E2E);

    return GestureDetector(
      onTap: () async {
        final FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png'],
        );
        if (result != null) {
          setState(() {
            if (kIsWeb) {
              webFiles = result.files.map((file) => file.bytes!).toList();
            } else {
              files = result.paths.map((path) => File(path!)).toList();
            }
          });
        }
      },
      // onTap: () async => pickImageFiles,
      child: MouseRegion(
        key: widget.uniqueKey,
        cursor: SystemMouseCursors.click,
        child: ClayContainer(
          height: widget.height,
          borderRadius: widget.radius,
          color: FluentTheme.of(context).brightness == Brightness.dark
              ? darkColor
              : baseColor,
          curveType: CurveType.convex,
          emboss: true,
          child: kIsWeb && webFiles.isNotEmpty
              ? Stack(
            children: [
              Image.memory(
                webFiles.first,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned(
                top: 10,
                right: 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blue.light,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      FluentIcons.more_vertical,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      // Show options for replace or delete
                      await showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:
                            const Text('What would you like to do?'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(FluentIcons.delete),
                                  title: const Text('Delete Image'),
                                  onPressed: () {
                                    // Delete the file
                                    setState(() {
                                      webFiles.clear();
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(FluentIcons.refresh),
                                  title: const Text('Replace Image'),
                                  onPressed: () async {
                                    // Replace the file with a new one (pick image from file picker)
                                    final newFile =
                                    await pickWebImageFiles(); // Use your file picker logic here
                                    setState(() {
                                      webFiles[0] = newFile!
                                          .first; // Replace the file
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          )
              : files.isNotEmpty
              ? Stack(
            children: [
              Image.file(
                files.first,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned(
                top: 10,
                right: 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blue.light,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      FluentIcons.more_vertical,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      // Show options for replace or delete
                      await showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                                'What would you like to do?'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(FluentIcons.delete),
                                  title: const Text('Delete Image'),
                                  onPressed: () {
                                    // Delete the file
                                    setState(() {
                                      files.clear();
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading:
                                  const Icon(FluentIcons.refresh),
                                  title: const Text('Replace Image'),
                                  onPressed: () async {
                                    // Replace the file with a new one (pick image from file picker)
                                    final newFile =
                                    await pickImageFiles(); // Use your file picker logic here
                                    setState(() {
                                      files[0] = newFile!
                                          .first; // Replace the file
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          )
              : const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FluentIcons.cloud_upload, size: 18),
                Text(
                  'Upload Image',
                  style: TextStyle(
                      fontSize: 18, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
