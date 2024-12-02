import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluent_ui_utils/fluent_ui_utils.dart';

class FluentUploadImageExample extends StatelessWidget {
  const FluentUploadImageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(title: Text('Fluent Upload Image Example')),
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using FluentUploadImage
            const FluentUploadImage(
              height: 150.0, // Set the desired height of the upload container
              radius: 15.0,  // Set the border radius for the upload container
              uniqueKey: Key("image_upload"),
            ),
            const SizedBox(height: 20),
            Button(
              onPressed: () {
                print('This is an example action!');
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}