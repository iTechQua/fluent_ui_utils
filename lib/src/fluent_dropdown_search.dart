import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:itq_utils/itq_utils.dart';

class FluentDropdownSearch<T> extends StatelessWidget {
  final List<T> items;
  final String? labelText;
  final Widget? label;
  final String? hintText;
  final String? errorText;
  final String Function(T)? itemAsString;
  final TextStyle? baseStyle;
  final Function(T?)? onChanged;
  final Widget Function(BuildContext, T?)? dropdownBuilder;
  final bool isSearchBoxRequired;
  final bool? enabled;
  final T? selectedItem; // Marked as final
  final bool? isValidationRequired;
  final bool Function(T, T)? compareFn;

  const FluentDropdownSearch({
    super.key,
    required this.items,
    this.baseStyle,
    this.label,
    this.labelText,
    this.itemAsString,
    this.onChanged,
    this.dropdownBuilder,
    this.hintText,
    this.errorText,
    this.isSearchBoxRequired = true,
    this.selectedItem,
    this.enabled = true,
    this.isValidationRequired = true,
    this.compareFn,
  });

  @override
  Widget build(BuildContext context) {
    // Get the current brightness
    final isDarkMode = FluentTheme.of(context).brightness == Brightness.dark;

    // Define colors based on theme
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor = isDarkMode ? const Color(0xFF2D2D2D) : Colors.white;
    final borderColor = isDarkMode ? Colors.grey[130] : Colors.grey[100];

    return material.Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (labelText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                labelText!,
              ),
            ),
          DropdownSearch<T>(
            enabled: enabled!,
            selectedItem: selectedItem,
            items: items,
            itemAsString: itemAsString,
            onChanged: onChanged,
            compareFn: compareFn ??
                    (item, selectedItem) => item == selectedItem, // Default compareFn if not provided
            dropdownDecoratorProps: DropDownDecoratorProps(
              baseStyle: baseStyle ?? TextStyle(
                fontSize: 12,
                color: textColor,
              ),
              dropdownSearchDecoration: material.InputDecoration(
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.8),
                ),
                isDense: true,
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.5),
                ),
                filled: true,
                fillColor: backgroundColor,
                border: material.OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: material.BorderSide(color: borderColor),
                ),
                enabledBorder: material.OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: material.BorderSide(color: borderColor),
                ),
                focusedBorder: material.OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: material.BorderSide(color: borderColor),
                ),
                suffixIconConstraints: const BoxConstraints(maxHeight: 40),
              ),
            ),
            validator: (value) {
              if (isValidationRequired ?? true) {
                if (value == null || value.toString().isEmpty) {
                  return errorText ?? 'This field is required';
                }
              }
              return null;
            },
            popupProps: PopupProps.menu(
              fit: FlexFit.loose,
              showSearchBox: isSearchBoxRequired,
              menuProps: MenuProps(
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              searchFieldProps: TextFieldProps(
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                ),
                decoration: material.InputDecoration(
                  isDense: true,
                  fillColor: backgroundColor,
                  focusColor: borderColor,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 16,
                  ),
                  border: material.OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: material.BorderSide(color: borderColor),
                  ),
                ),
              ),
              containerBuilder: (context, popupWidget) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode ? Colors.black : Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: popupWidget,
                );
              },
            ),
            dropdownBuilder: dropdownBuilder ?? ((context, selectedItem) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  selectedItem != null
                      ? (itemAsString?.call(selectedItem) ?? selectedItem.toString())
                      : hintText ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: selectedItem != null ? textColor : textColor.withOpacity(0.5),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
