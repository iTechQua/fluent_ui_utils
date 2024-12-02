import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluent_ui_utils/fluent_ui_utils.dart';

class FluentTextBoxExample extends StatelessWidget {
  const FluentTextBoxExample({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();

    return FluentApp(
      theme: FluentThemeData.light(),
      home: ScaffoldPage(
        header: const PageHeader(
          title: Text('FluentTextBox Example'),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FluentTextBox(
              labelText: "Email Address",
              hintText: "Enter your email",
              isEmail: true,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(FluentIcons.mail),
              onChanged: (value) => print("Email: $value"),
            ),
            const SizedBox(height: 16),
            FluentTextBox(
              labelText: "Mobile Number",
              hintText: "Enter your mobile number",
              isMobile: true,
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(FluentIcons.phone),
              onChanged: (value) => print("Mobile: $value"),
            ),
            const SizedBox(height: 16),
            FluentTextBox(
              labelText: "Password",
              hintText: "Enter your password",
              isPassword: true,
              obscureText: true,
              controller: passwordController,
              togglePasswordVisibility: () => print("Toggle password visibility"),
              onChanged: (value) => print("Password: $value"),
            ),
            const SizedBox(height: 16),
            FluentTextBox(
              labelText: "Confirm Password",
              hintText: "Re-enter your password",
              isConfirmPassword: true,
              matchingPasswordController: passwordController,
              onChanged: (value) => print("Confirm Password: $value"),
            ),
            const SizedBox(height: 16),
            FluentTextBox(
              labelText: "Description",
              hintText: "Enter a description",
              maxLines: 4,
              textStyle: const TextStyle(fontSize: 14),
              onChanged: (value) => print("Description: $value"),
            ),
          ],
        ),
      ),
    );
  }
}
