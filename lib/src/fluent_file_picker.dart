import 'dart:io';

import 'package:fluent_ui_utils/src/utils/app_file_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:itq_utils/itq_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FluentFilePicker extends StatefulWidget {
  final List<PlatformFile>? documents;
  final List<String>? fileUrls;
  final Function(List<PlatformFile>)? onDocumentsChanged;
  final bool? editable;
  final bool? previewOnly;
  final bool? isValidationRequired;
  final bool showCameraButton;

  const FluentFilePicker({
    super.key,
    this.documents,
    this.fileUrls,
    this.onDocumentsChanged,
    this.editable,
    this.previewOnly,
    this.isValidationRequired,
    this.showCameraButton = true,
  });

  @override
  State<FluentFilePicker> createState() => _FluentFilePickerState();
}

class _FluentFilePickerState extends State<FluentFilePicker> {
  List<PlatformFile> _documents = [];
  List<String> _downloadingFiles = [];
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.documents != null) {
      _documents = widget.documents!;
    }
    checkPermissions();
    if (widget.fileUrls != null) {
      _downloadFiles(widget.fileUrls!);
    }
  }

  Future<void> _downloadFiles(List<String> urls) async {
    setState(() {
      _downloadingFiles = List.from(urls);
    });

    await downloadAndSaveFiles(urls);

    List<PlatformFile> downloadedFiles = await convertToPlatformFiles(urls);

    setState(() {
      _documents.addAll(downloadedFiles);
      _downloadingFiles.clear();
    });

    widget.onDocumentsChanged?.call(_documents);
  }

  void _openFile(PlatformFile file) {
    if (file.extension == 'jpg' ||
        file.extension == 'png' ||
        file.extension == 'jpeg' ||
        file.extension == 'pdf') {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return ContentDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      file.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(FluentIcons.chrome_close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(
                          maxHeight: 400,
                        ),
                        child: file.extension == 'pdf'
                            ? file.bytes != null
                                ? SfPdfViewer.memory(file.bytes!)
                                : const Center(
                                    child: Text("Cannot preview file"),
                                  )
                            : file.bytes != null
                                ? Image.memory(
                                    file.bytes!,
                                    fit: BoxFit.contain,
                                  )
                                : const Center(
                                    child: Text("Cannot preview file"),
                                  ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              Button(
                child: const Text('Close'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    } else {
      _showInfoBar(context, 'Cannot preview ${file.extension} files');
    }
  }

  void _showInfoBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late final OverlayEntry
        overlayEntry; // Declare as late to allow initialization later

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 20,
        left: 20,
        right: 20,
        child: InfoBar(
          title: Text(message),
          severity: InfoBarSeverity.warning,
          isLong: true,
          action: Button(
            child: const Text('Dismiss'),
            onPressed: () => overlayEntry.remove(),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }

  void _removeFile(PlatformFile file) {
    setState(() {
      _documents.remove(file);
    });
    widget.onDocumentsChanged?.call(_documents);
  }

  void _showSizeLimitDialog(String fileName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ContentDialog(
          title: const Text('File Too Large'),
          content: Text(
            '$fileName exceeds the 2MB size limit and will not be added.',
          ),
          actions: [
            Button(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        );
      },
    );
  }

  // Define the missing _buildDownloadingItem method
  Widget _buildDownloadingItem(String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Row(
          children: [
            Container(
              width: 60,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileItem(PlatformFile file) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          if (file.extension == 'jpg' ||
              file.extension == 'png' ||
              file.extension == 'jpeg' ||
              file.extension == 'pdf')
            GestureDetector(
              onTap: () => _openFile(file),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: AssetImage('assets/fileIcon.png'),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => _openFile(file),
              child: Text(
                file.name,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (!(widget.previewOnly ?? false))
            if (widget.editable ?? true)
              IconButton(
                icon: Icon(
                  FluentIcons.cancel,
                  color: Colors.red,
                  size: 18,
                ),
                onPressed: () => _removeFile(file),
              ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        final File file = File(pickedFile.path);
        final int fileSize = await file.length();
        const int maxSize = 2 * 1024 * 1024; // 2MB

        if (fileSize > maxSize) {
          _showSizeLimitDialog(pickedFile.name);
        } else {
          final PlatformFile platformFile = PlatformFile(
            path: pickedFile.path,
            name: pickedFile.name,
            size: fileSize,
          );

          setState(() {
            _documents.add(platformFile);
          });
          widget.onDocumentsChanged?.call(_documents);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Image picking error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return FormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: _documents,
      validator: (files) {
        if (widget.isValidationRequired ?? false) {
          if (files == null || files.isEmpty) {
            return 'Please select a file.';
          }
        }
        return null;
      },
      builder: (state) => Column(
        children: [
          if (!(widget.previewOnly ?? false))
            if (widget.editable ?? true)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        try {
                          final FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowMultiple: true,
                            allowedExtensions: [
                              'jpg',
                              'jpeg',
                              'png',
                              'pdf',
                              'doc',
                              'docx',
                            ],
                          );
                          if (result != null) {
                            final filteredFiles = result.files.where((file) {
                              const int maxSize = 2 * 1024 * 1024; // 2MB
                              if (file.size > maxSize) {
                                _showSizeLimitDialog(file.name);
                                return false;
                              }
                              return true;
                            }).toList();

                            setState(() {
                              _documents.addAll(filteredFiles);
                            });
                            widget.onDocumentsChanged?.call(_documents);
                            state.didChange(_documents);
                          }
                        } catch (e) {
                          if (kDebugMode) {
                            print('File picking error: $e');
                          }
                        }
                      },
                      child: Row(
                        children: [
                          Container(
                            height: screenHeight / 20,
                            width: screenWidth * 0.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color:
                                    state.hasError ? Colors.red : Colors.blue,
                                style: BorderStyle.none,
                              ),
                            ),
                            child: DottedBorder(
                              color: state.hasError ? Colors.red : Colors.blue,
                              dashPattern: const [5, 5],
                              borderType: BorderType.rRect,
                              radius: const Radius.circular(7),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FluentIcons.file_template,
                                      color: state.hasError
                                          ? Colors.red
                                          : Colors.blue,
                                    ),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: Text(
                                        'Upload File',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: state.hasError
                                              ? Colors.red
                                              : Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Add more buttons for other features like taking pictures
                          if (widget.showCameraButton)
                            GestureDetector(
                              onTap: () => _pickImage(ImageSource.camera),
                              child: Container(
                                height: screenHeight / 20,
                                width: screenWidth * 0.25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                    color: state.hasError
                                        ? Colors.red
                                        : Colors.orange,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                child: DottedBorder(
                                  color: state.hasError
                                      ? Colors.red
                                      : Colors.orange,
                                  dashPattern: const [5, 5],
                                  borderType: BorderType.rRect,
                                  radius: const Radius.circular(7),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FluentIcons.camera,
                                          color: state.hasError
                                              ? Colors.red
                                              : Colors.orange,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          'Camera',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: state.hasError
                                                ? Colors.red
                                                : Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          if (_documents.isNotEmpty || _downloadingFiles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!(widget.previewOnly ?? false)) ...[
                    if (widget.editable ?? true)
                      const Text(
                        'Selected files:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      const Text(
                        'Attached files:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                  ..._documents.map((file) => _buildFileItem(file)),
                  ..._downloadingFiles.map((url) => _buildDownloadingItem(url)),
                ],
              ),
            ),
          if (state.hasError)
            Text(
              'Please select a file',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}
