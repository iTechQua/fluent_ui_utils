import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:universal_html/html.dart' as html;

class FluentDataTable<T> extends StatefulWidget {
  const FluentDataTable({
    required this.widthMode,
    required this.tableHeaderDataMap,
    required this.tableRowDataList,
    required this.toMakeTableMapFunction,

    required this.fileName,
    required this.actionBuilder,
    super.key,
    this.height,
    this.pageSize = 10,
  });

  final double? height;
  final Map<String, dynamic> tableHeaderDataMap;
  final List<T> tableRowDataList;
  final Map<String, dynamic> Function(T) toMakeTableMapFunction;
  final Widget Function(T rowData) actionBuilder;
  final int pageSize;
  final ColumnWidthMode widthMode; // Made final
  final String fileName;

  @override
  FluentDataTableState<T> createState() =>
      FluentDataTableState<T>();
}

class FluentDataTableState<T>
    extends State<FluentDataTable<T>> {
  late List<DataGridRow> _tableRowData;
  late List<GridColumn> _tableHeader;
  late TextEditingController _searchController;
  int _currentPage = 0;
  int _pageSize = 10;
  String _searchQuery = '';
  late List<T> _filteredData;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredData = widget.tableRowDataList;
    _pageSize = widget.pageSize;

    // Build the header dynamically
    _tableHeader = <GridColumn>[
      GridColumn(
        columnName: 'ID',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text(
            'ID',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      ...widget.tableHeaderDataMap.keys.map((String key) {
        return GridColumn(
          columnName: key,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              key,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      }),
      GridColumn(
        columnName: 'Action',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text(
            'Action',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ];

    _updateTableData();
  }

  @override
  void didUpdateWidget(covariant FluentDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tableRowDataList != oldWidget.tableRowDataList) {
      _filteredData = widget.tableRowDataList;
      _updateTableData();
    }
  }

  void _updateTableData() {
    final int startIndex = _currentPage * _pageSize;
    final int endIndex = startIndex + _pageSize;
    final List<T> currentPageData = _filteredData.sublist(
      startIndex,
      endIndex.clamp(0, _filteredData.length),
    );

    _tableRowData = currentPageData.asMap().entries.map((entry) {
      final int index = entry.key;
      final T item = entry.value;

      return DataGridRow(
        cells: <DataGridCell>[
          DataGridCell<int>(columnName: 'ID', value: startIndex + index + 1),
          ...widget
              .toMakeTableMapFunction(item)
              .entries
              .map((MapEntry<String, dynamic> entry) {
            return DataGridCell<dynamic>(
              columnName: entry.key,
              value: entry.value,
            );
          }),
          DataGridCell<Widget>(
            columnName: 'Action',
            value: widget.actionBuilder(item),
          ),
        ],
      );
    }).toList();
  }

  void _changePage(int page) {
    setState(() {
      _currentPage = page;
      _updateTableData();
    });
  }

  void _filterData(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredData = widget.tableRowDataList.where((item) {
        final map = widget.toMakeTableMapFunction(item);
        return map.values.any(
          (value) => value.toString().toLowerCase().contains(_searchQuery),
        );
      }).toList();
      _currentPage = 0;
      _updateTableData();
    });
  }

  Future<void> _exportToExcel() async {
    try {
      final workbook = xlsio.Workbook();
      final sheet = workbook.worksheets[0];

      // Add headers
      sheet.getRangeByIndex(1, 1).setText('ID');
      var columnIndex = 2;
      for (final key in widget.tableHeaderDataMap.keys) {
        sheet.getRangeByIndex(1, columnIndex).setText(key);
        columnIndex++;
      }

      // Add data
      for (var i = 0; i < _filteredData.length; i++) {
        columnIndex = 1;
        // Add ID
        sheet.getRangeByIndex(i + 2, columnIndex).setValue(i + 1);
        columnIndex++;

        // Add row data
        final rowData = widget.toMakeTableMapFunction(_filteredData[i]);
        for (final value in rowData.values) {
          sheet.getRangeByIndex(i + 2, columnIndex).setValue(value.toString());
          columnIndex++;
        }
      }

      // Auto-fit columns
      sheet.autoFitColumn(1);
      for (var i = 1; i <= widget.tableHeaderDataMap.length; i++) {
        sheet.autoFitColumn(i + 1);
      }

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      await _saveFile(bytes, 'table_data.xlsx');
    } catch (e) {
      debugPrint('Error exporting to Excel: $e');
      // Show error message to user
      if (!mounted) return; // Ensure the widget is still mounted
      await showDialog(
        context: context,
        builder: (context) => ContentDialog(
          title: const Text('Export Error'),
          content: Text('Failed to export to Excel: $e'),
          actions: [
            Button(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _exportToPdf() async {
    try {
      debugPrint('Starting PDF export...');
      final pdf = pw.Document();

      // Prepare table data more efficiently
      final headers = ['ID', ...widget.tableHeaderDataMap.keys];
      final tableData = [
        headers,
        ..._filteredData.asMap().entries.map(
              (entry) => [
                (entry.key + 1).toString(),
                ...widget
                    .toMakeTableMapFunction(entry.value)
                    .values
                    .map((e) => e?.toString() ?? ''),
              ],
            ),
      ];

      // Define styles once
      final headerStyle = pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
        fontSize: 8, // Smaller font size for headers
      );

      const cellStyle = pw.TextStyle(
        fontSize: 7, // Smaller font size for cell content
      );

      final cellAlignments = {
        0: pw.Alignment.center,
        for (var i = 1; i < headers.length; i++) i: pw.Alignment.centerLeft,
      };

      // Create PDF content
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20), // Reduced margins
          build: (context) => [
            pw.TableHelper.fromTextArray(
              headers: tableData[0],
              data: tableData.sublist(1),
              border: pw.TableBorder.all(),
              headerStyle: headerStyle,
              cellStyle: cellStyle,
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.blue600,
              ),
              cellHeight: 25, // Reduced cell height
              cellAlignments: cellAlignments,
              oddRowDecoration: const pw.BoxDecoration(
                color: PdfColors.grey200,
              ),
            ),
          ],
        ),
      );

      final bytes = await pdf.save();
      final fileName =
          'table_data_${DateTime.now().millisecondsSinceEpoch}.pdf';

      await _saveFile(bytes, fileName);
    } catch (e, stackTrace) {
      _handleError('PDF Export Error', e, stackTrace);
    }
  }

  Future<void> _saveFile(List<int> bytes, String fileName) async {
    try {
      if (kIsWeb) {
        await _saveFileWeb(bytes, fileName);
      } else {
        await _saveFileNative(bytes, fileName);
      }
    } catch (e, stackTrace) {
      _handleError('Save Error', e, stackTrace);
    }
  }

  Future<void> _saveFileWeb(List<int> bytes, String fileName) async {
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..style.display = 'none';

    html.document.body?.append(anchor);
    anchor.click();
    // html.document.body?.removeChild(anchor);
    html.Url.revokeObjectUrl(url);
  }

  Future<void> _saveFileNative(List<int> bytes, String fileName) async {
    final directory = Platform.isWindows || Platform.isLinux || Platform.isMacOS
        ? await getDownloadsDirectory()
        : await getApplicationDocumentsDirectory();

    if (directory == null) {
      throw Exception('Unable to access system directory');
    }

    final filePath = '${directory.path}${Platform.pathSeparator}$fileName';
    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);

    if (mounted) {
      _showSuccessDialog(filePath, bytes.length);
    }
  }

  void _handleError(String title, dynamic error, StackTrace stackTrace) {
    debugPrint('$title: $error');
    debugPrint('Stack trace: $stackTrace');

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => ContentDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Error details:'),
                const SizedBox(height: 8),
                SelectableText(
                  error.toString(),
                  style: const TextStyle(fontFamily: 'Monospace', fontSize: 12),
                ),
              ],
            ),
          ),
          actions: [
            Button(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  void _showSuccessDialog(String filePath, int fileSize) {
    showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('Export Successful'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('File saved successfully!'),
            const SizedBox(height: 8),
            SelectableText('Location: $filePath'),
            const SizedBox(height: 4),
            Text('Size: ${(fileSize / 1024).toStringAsFixed(2)} KB'),
          ],
        ),
        actions: [
          Button(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Top bar with Search, Export and Page Size Selector
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              // Page Size Selector
              DropDownButton(
                title: Text('$_pageSize entries'),
                items: [5, 10, 20, 50]
                    .map(
                      (size) => MenuFlyoutItem(
                        text: Text('$size entries'),
                        onPressed: () {
                          setState(() {
                            _pageSize = size;
                            _currentPage = 0;
                            _updateTableData();
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(width: 10),
              // Export Button
              DropDownButton(
                title: const Text('Export'),
                items: [
                  MenuFlyoutItem(
                    text: const Text('Export to Excel'),
                    leading: const Icon(FluentIcons.excel_document),
                    onPressed: _exportToExcel,
                  ),
                  MenuFlyoutItem(
                    text: const Text('Export to PDF'),
                    leading: const Icon(FluentIcons.pdf),
                    onPressed: _exportToPdf,
                  ),
                ],
              ),
              const Spacer(),
              // Search Field
              SizedBox(
                width: 250,
                child: TextBox(
                  controller: _searchController,
                  onChanged: _filterData,
                  placeholder: 'Search',
                  prefix: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(FluentIcons.search),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Table
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double tableWidth = _tableHeader.length * 150.0;

            return SizedBox(
              height: widget.height ?? MediaQuery.of(context).size.height * 0.6,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    maxWidth: tableWidth > constraints.maxWidth
                        ? tableWidth
                        : constraints.maxWidth,
                  ),
                  child: SfDataGridTheme(
                    data: SfDataGridThemeData(
                      headerColor: Colors.blue,
                      gridLineColor: Colors.grey,
                      gridLineStrokeWidth: 0.1,
                    ),
                    child: SfDataGrid(
                      isScrollbarAlwaysShown: true,
                      columnWidthMode: widget.widthMode,
                      source: GenericDataSource(_tableRowData),
                      columns: _tableHeader,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        // Pagination and Footer
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Showing entries info
              Text(
                'Showing ${(_currentPage * _pageSize) + 1} to ${((_currentPage + 1) * _pageSize).clamp(1, _filteredData.length)} of ${_filteredData.length} entries',
              ),
              // Pagination
              Row(
                children: [
                  IconButton(
                    icon: const Icon(FluentIcons.chevron_left),
                    onPressed: _currentPage > 0
                        ? () => _changePage(_currentPage - 1)
                        : null,
                  ),
                  Text('Page ${_currentPage + 1}'),
                  IconButton(
                    icon: const Icon(FluentIcons.chevron_right),
                    onPressed:
                        (_currentPage + 1) * _pageSize < _filteredData.length
                            ? () => _changePage(_currentPage + 1)
                            : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GenericDataSource extends DataGridSource {
  GenericDataSource(this._dataSource);

  final List<DataGridRow> _dataSource;

  @override
  List<DataGridRow> get rows => _dataSource;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((DataGridCell cell) {
        if (cell.value is Widget) {
          return cell.value as Widget;
        }
        return Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text(
            cell.value.toString(),
            style: const TextStyle(fontSize: 13),
          ),
        );
      }).toList(),
    );
  }
}
