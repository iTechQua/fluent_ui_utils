import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluent_ui_utils/fluent_ui_utils.dart';

class FluentDropdownSearchExample extends StatelessWidget {
  const FluentDropdownSearchExample({super.key});

  @override
  Widget build(BuildContext context) {
    // List of items for the dropdown
    final List<String> items = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];

    // Function to convert items to string
    String itemToString(String item) => item;

    return ScaffoldPage(
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FluentDropdownSearch<String>(
              // List of dropdown items
              items: items,
              // Label for the dropdown
              labelText: 'Select an Option',
              // Hint text for the dropdown
              hintText: 'Choose an option',
              // Custom function to display items as strings
              itemAsString: itemToString,
              // Callback when an item is selected
              onChanged: (value) {
                debugPrint('Selected value: $value');
              },
              // Validation for the dropdown
              isValidationRequired: true,
              errorText: 'Please select an option!',
              // Enable or disable search box
              isSearchBoxRequired: true,
            ),
          ],
        ),
      ),
    );
  }
}
