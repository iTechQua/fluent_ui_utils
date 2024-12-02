
import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluent_ui_utils/fluent_ui_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FluentDropdownButtonExample extends StatefulWidget {
  const FluentDropdownButtonExample({super.key});

  @override
  State<FluentDropdownButtonExample> createState() => _FluentDropdownButtonExampleState();
}

class _FluentDropdownButtonExampleState extends State<FluentDropdownButtonExample> {
  // List of items to display in the dropdown
  final List<String> _dropdownItems = ['Option 1', 'Option 2', 'Option 3'];

  // Current selected values mapped by field name
  final Map<String, String> _selectedValues = {};

  // Callback to handle selection changes
  void _onSelectionChanged(String field, String value) {
    setState(() {
      _selectedValues[field] = value;
    });
    debugPrint('Selected field: $field, value: $value');
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FluentDropdownButton<ExampleBloc, ExampleState>(
          // Provide a title for the dropdown
          title: 'Select Option',
          // Placeholder text for the dropdown
          placeholder: 'Please choose an option',
          // List of items for the dropdown
          itemLists: _dropdownItems,
          // Initially selected item
          selectedItem: _selectedValues['Select Option'] ?? '',
          // Width of the dropdown
          widthSize: 300.0,
          // Enable or disable validation
          validationRequired: true,
          // Pass selected values to the widget
          selectedValues: _selectedValues,
          // Callback for selection changes
          onSelectionChanged: _onSelectionChanged,
          // Optional mapping of state fields
          stateFieldMapping: const {
            'Select Option': 'selectedOption',
          },
          // Provide the current context
          context: context,
        ),
      ),
    );
  }
}


// Define the state
class ExampleState {
  final String someData;

  ExampleState({this.someData = ''});
}

// Define the Cubit class
class ExampleBloc extends Cubit<ExampleState> {
  ExampleBloc() : super(ExampleState());

  // Example method to update state
  void updateData(String newData) {
    emit(ExampleState(someData: newData));
  }
}

