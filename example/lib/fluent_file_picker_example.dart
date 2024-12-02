import 'package:fluent_ui/fluent_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui_utils/fluent_ui_utils.dart';

class FluentFilePickerExample extends StatefulWidget {
  const FluentFilePickerExample({super.key});

  @override
  FluentFilePickerExampleState createState() => FluentFilePickerExampleState();
}

class FluentFilePickerExampleState extends State<FluentFilePickerExample> {
  List<PlatformFile> selectedFiles = [];
  List<String> fileUrls = [
    // Example URLs for testing
    'https://www.example.com/sample.pdf',
    'https://www.example.com/sample.jpg',
  ];

  void _onFilesChanged(List<PlatformFile> files) {
    setState(() {
      selectedFiles = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      home: ScaffoldPage(
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fluent File Picker Demo',
                style: FluentTheme.of(context).typography.title,
              ),
              const SizedBox(height: 16),
              FluentFilePicker(
                documents: selectedFiles,
                fileUrls: fileUrls,
                onDocumentsChanged: _onFilesChanged,
                editable: true,
                showCameraButton: true,
                previewOnly: false,
                isValidationRequired: true,
              ),
              const SizedBox(height: 16),
              if (selectedFiles.isNotEmpty)
                Text(
                  'Selected Files:',
                  style: FluentTheme.of(context).typography.subtitle,
                ),
              ...selectedFiles.map(
                    (file) => Text(
                  file.name,
                  style: FluentTheme.of(context).typography.body,
                ),
              ),
              if (selectedFiles.isEmpty)
                const Text(
                  'No files selected yet.',
                  style: TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
