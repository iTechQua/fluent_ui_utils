<div align="center">
<a href="https://pub.dev/packages/fluent_ui_utils/"><img src="https://img.shields.io/pub/v/fluent_ui_utils.svg" /></a>
<a href="https://opensource.org/licenses/MIT" target="_blank"><img src="https://img.shields.io/badge/License-MIT-yellow.svg"/></a>
<a href="https://opensource.org/licenses/Apache-2.0" target="_blank"><img src="https://badges.frapsoft.com/os/v1/open-source.svg?v=102"/></a>
<a href="https://github.com/iTechQua/fluent_ui_utils/issues" target="_blank"><img alt="GitHub: bhoominn" src="https://img.shields.io/github/issues-raw/iTechQua/fluent_ui_utils?style=flat" /></a>
<img src="https://img.shields.io/github/last-commit/iTechQua/fluent_ui_utils" />

<a href="https://discord.com/channels/854023838136533063/854023838576672839" target="_blank"><img src="https://img.shields.io/discord/854023838136533063" /></a>
<a href="https://github.com/iTechQua"><img alt="GitHub: bhoominn" src="https://img.shields.io/github/followers/iTechQua?label=Follow&style=social" /></a>
<a href="https://github.com/iTechQua/fluent_ui_utils"><img src="https://img.shields.io/github/stars/iTechQua/fluent_ui_utils?style=social" /></a>

<a href="https://saythanks.io/to/iTechQua" target="_blank"><img src="https://img.shields.io/badge/Say%20Thanks-!-1EAEDB.svg"/></a>
<a href="https://github.com/sponsors/iTechQua"><img src="https://img.shields.io/github/sponsors/iTechQua" /></a>

<a href="https://www.buymeacoffee.com/iTechQua"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=bhoominn&button_colour=5F7FFF&font_colour=ffffff&font_family=Cookie&outline_colour=000000&coffee_colour=FFDD00"></a>

</div>

## Show some love and like to support the project

### Say Thanks Here
<a href="https://saythanks.io/to/iTechQua" target="_blank"><img src="https://img.shields.io/badge/Say%20Thanks-!-1EAEDB.svg"/></a>

### Follow Me on Twitter
<a href="https://x.com/iTechQua" target="_blank"><img src="https://img.shields.io/twitter/follow/iTechQua?color=1DA1F2&label=Followers&logo=twitter" /></a>

## Platform Support

| Android | iOS | MacOS  | Web | Linux | Windows |
| :-----: | :-: | :---:  | :-: | :---: | :-----: |
|   ✔️    | ✔️  |  ✔️   | ✔️  |  ✔️   |   ✔️   |

## Installation

Add this package to `pubspec.yaml` as follows:

```console
$ flutter pub add fluent_ui_utils
```

Import package

```dart
import 'package:fluent_ui_utils/fluent_ui_utils.dart';
```

# Fluent UI Widgets for Flutter

This repository contains custom widgets for Flutter applications built using **Fluent UI**. The following widgets are included:

- **FluentDataTable**: A dynamic, searchable, and exportable data table.
- **FluentDropdownButton**: A dropdown menu with custom styling and functionality.
- **FluentDropdownSearch**: A dropdown menu with a search field.
- **FluentFilePicker**: A file picker for handling file selection.
- **FluentTextBox**: A customizable text input widget.
- **FluentUploadImage**: An image uploader with a preview feature.

---

# Features

### FluentDataTable
A highly customizable data table with built-in pagination, search, and export options (Excel and PDF).

#### Features:
- Dynamically generates table headers and rows.
- Supports data filtering and pagination.
- Exports data to Excel and PDF formats.
- Adjustable page size and column width.

#### Usage:
```dart
FluentDataTable<MyDataType>(
  widthMode: ColumnWidthMode.fill,
  tableHeaderDataMap: {
    'Name': 'name',
    'Age': 'age',
    'City': 'city',
  },
  tableRowDataList: myDataList,
  toMakeTableMapFunction: (data) => {
    'Name': data.name,
    'Age': data.age,
    'City': data.city,
  },
  actionBuilder: (rowData) => IconButton(
    icon: const Icon(FluentIcons.edit),
    onPressed: () => handleEdit(rowData),
  ),
  fileName: 'my_table_data',
  pageSize: 10,
),
```

### FluentDropdownButton
A dropdown menu for selecting items with a clean Fluent UI design.

#### Features:
- Supports multiple item types.
- Customizable icons and text.

#### Usage:
```dart
FluentDropdownButton<String>(
  items: ['Option 1', 'Option 2', 'Option 3'],
  selectedItem: selectedOption,
  onChanged: (value) {
    setState(() {
      selectedOption = value;
    });
  },
),
```

### FluentDropdownSearch
A dropdown menu that includes a search bar for filtering items.

#### Features:
- Search functionality for long item lists.
- Provides real-time filtering.

#### Usage:
```dart
FluentDropdownSearch<String>(
  items: ['Apple', 'Banana', 'Cherry', 'Date'],
  selectedItem: selectedItem,
  onChanged: (value) {
    setState(() {
      selectedItem = value;
    });
  },
  searchHint: 'Search fruits...',
),
```

### FluentFilePicker
A widget for selecting files from the device.

#### Features:
- Supports single or multiple file selections.
- Displays file names after selection.

#### Usage:
```dart
FluentFilePicker(
  onFilesPicked: (files) {
    setState(() {
      pickedFiles = files;
    });
  },
),
```

### FluentTextBox
A styled text input widget.

#### Features:
- Built-in validation options.
- Supports placeholders and prefix/suffix icons.

#### Usage:
```dart
FluentTextBox(
  placeholder: 'Enter your name',
  controller: TextEditingController(),
  prefix: const Icon(FluentIcons.contact),
),
```

### FluentUploadImage
A widget for uploading and previewing images.

#### Features:
- Supports image preview.
- Handles image compression before upload.

#### Usage:
```dart
FluentUploadImage(
  onImageSelected: (imageFile) {
    setState(() {
      selectedImage = imageFile;
    });
  },
),
```
# How to Use

#### Add the required dependencies to your `pubspec.yaml` file:

```yaml
dependencies:
  fluent_ui: ^3.10.0
  syncfusion_flutter_datagrid: ^21.2.7
  syncfusion_flutter_xlsio: ^21.2.7
  path_provider: ^2.0.14
  universal_html: ^2.0.5
  pdf: ^3.10.3
```

#### Import the widgets in your Dart files:

```dart
import 'package:fluent_ui/fluent_ui.dart';
import 'path_to_widgets/fluent_data_table.dart';
import 'path_to_widgets/fluent_dropdown_button.dart';
import 'path_to_widgets/fluent_dropdown_search.dart';
import 'path_to_widgets/fluent_file_picker.dart';
import 'path_to_widgets/fluent_text_box.dart';
import 'path_to_widgets/fluent_upload_image.dart';
```