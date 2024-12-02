import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluent_ui_utils_example/fluent_dropdown_button_example.dart';
import 'package:fluent_ui_utils_example/fluent_dropdown_search_example.dart';
import 'package:itq_utils/itq_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      title: 'Fluent UI Utils Example',
      theme: FluentThemeData.light(),
      darkTheme: FluentThemeData.dark(),
      themeMode: ThemeMode.system,
      home:Column(
        children: [
          GestureDetector(
            onTap: (){
              const FluentDropdownSearchExample().launch(context);
            },
            child: const Text('Dropdown Search Example'),
          ),
          GestureDetector(
            onTap: (){
              const FluentDropdownButtonExample().launch(context);
            },
            child: const Text('Dropdown Button Example'),
          ),
        ],
      ),
    );
  }
}
