import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluent_ui_utils/fluent_ui_utils.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class FluentDataTableExample extends StatelessWidget {
  const FluentDataTableExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the header and row data
    final Map<String, dynamic> tableHeader = {
      'Name': 'string',
      'Age': 'int',
      'Department': 'string',
    };

    final List<Map<String, dynamic>> data = [
      {'Name': 'John Doe', 'Age': 29, 'Department': 'HR'},
      {'Name': 'Jane Smith', 'Age': 34, 'Department': 'Finance'},
      {'Name': 'Alice Brown', 'Age': 28, 'Department': 'Engineering'},
      {'Name': 'Bob Johnson', 'Age': 42, 'Department': 'Marketing'},
    ];

    return ScaffoldPage(
      content: FluentDataTable<Map<String, dynamic>>(
        widthMode: ColumnWidthMode.auto,
        tableHeaderDataMap: tableHeader,
        tableRowDataList: data,
        toMakeTableMapFunction: (item) => item,
        fileName: 'Employee_Data',
        actionBuilder: (rowData) => Button(
          child: const Text('Details'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => ContentDialog(
                title: const Text('Row Details'),
                content: Text(rowData.toString()),
                actions: [
                  Button(
                    child: const Text('Close'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            );
          },
        ),
        pageSize: 5,
      ),
    );
  }
}
