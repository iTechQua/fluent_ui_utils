import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FluentDropdownButton<B extends StateStreamable<S>, S>
    extends StatefulWidget {
  const FluentDropdownButton({
    super.key,
    required this.context,
    required this.title,
    required this.placeholder,
    required this.itemLists,
    this.selectedItem = '',
    required this.widthSize,
    this.masterTableResponse = false,
    this.validationRequired = true,
    this.selectedValues = const {},
    required this.onSelectionChanged,
    this.stateFieldMapping,
  });

  final BuildContext context;
  final String title;
  final String placeholder;
  final List<dynamic> itemLists;
  final String selectedItem;
  final double? widthSize;
  final bool? masterTableResponse;
  final bool validationRequired;
  final Map<String, String> selectedValues;
  final Function(String field, String value) onSelectionChanged;
  final Map<String, String>? stateFieldMapping;

  @override
  State<FluentDropdownButton<B, S>> createState() =>
      _FluentDropdownButtonState<B, S>();
}

class _FluentDropdownButtonState<B extends StateStreamable<S>, S>
    extends State<FluentDropdownButton<B, S>> {
  late String selectedItem;
  late Map<String, String> selectedValues;
  late List itemLists;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedItem;
    itemLists = widget.itemLists;
    selectedValues = Map.from(widget.selectedValues);
  }

  List<MenuFlyoutItem> _buildMenuItems(
      List items, Function(String) onSelect, FormFieldState<String> state) {
    return items
        .map(
          (item) => MenuFlyoutItem(
        text: widget.masterTableResponse!
            ? Text('${item.name}',
            overflow: TextOverflow.ellipsis, softWrap: true)
            : Text('$item',
            overflow: TextOverflow.ellipsis, softWrap: true),
        onPressed: () {
          final String selectedValue =
          widget.masterTableResponse! ? '${item.name}' : '$item';
          state.didChange(selectedValue);
          onSelect(selectedValue);
          _handleSelection(selectedValue);
        },
      ),
    )
        .toList();
  }

  void _handleSelection(String selectedValue) {
    setState(() {
      selectedItem = selectedValue;
      if (widget.stateFieldMapping != null &&
          widget.stateFieldMapping!.containsKey(widget.title)) {
        final String fieldName = widget.stateFieldMapping![widget.title]!;
        selectedValues[fieldName] = selectedValue;
      }
    });

    widget.onSelectionChanged(widget.title, selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            if (widget.validationRequired)
              Text(
                '*',
                style:
                TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        const SizedBox(height: 5),
        BlocBuilder<B, S>(
          builder: (context, state) {
            return SizedBox(
              width: widget.widthSize,
              child: widget.itemLists.isNotEmpty
                  ? FormField(
                builder: (FormFieldState<String> formState) {
                  return Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: DropDownButton(
                          title: Text(
                            selectedItem.isEmpty
                                ? widget.placeholder
                                : selectedItem,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 2,
                          ),
                          items: _buildMenuItems(
                            widget.itemLists,
                                (item) {
                              setState(() {
                                selectedItem = item;
                              });
                            },
                            formState,
                          ),
                        ),
                      ),
                      if (formState.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  );
                },
                validator: widget.validationRequired
                    ? (value) {
                  if (value == null ||
                      (value as String).isEmpty ||
                      selectedItem != value) {
                    return 'Please select an option';
                  }
                  return null;
                }
                    : null,
              )
                  : DropDownButton(
                disabled: true,
                title: const Text('No Option Available'),
                items: [
                  MenuFlyoutItem(
                    text: const Text('No Options Available'),
                    onPressed: () {},
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
