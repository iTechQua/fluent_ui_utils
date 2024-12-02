import 'package:fluent_ui/fluent_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluent_ui_utils/src/utils/app_text_styles.dart';

class FluentTextBox extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final String? iconPath;
  final Widget? label;
  final TextStyle? textStyle;
  final bool readOnly;
  final bool? obscureText; // Changed to nullable bool
  final Function()? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final BoxConstraints? prefixIconConstraints;
  final TextStyle? floatingLabelStyle;
  final FocusNode? focus;
  final bool isValidationRequired;
  final bool? enabled;
  final String? initialValue;
  final bool isMobile;
  final bool isEmail;
  final bool isPassword;
  final int? maxLines;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final Function(String)? onFieldSubmitted;
  final Iterable<String>? autoFillHints;
  final bool? enableSuggestions;
  final String? Function(String?)? validator;
  final VoidCallback? togglePasswordVisibility; // Added parameter
  final bool isOTP;
  final bool isConfirmPassword;
  final TextEditingController? matchingPasswordController;

  const FluentTextBox({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.errorText,
    this.iconPath,
    this.label,
    this.textStyle,
    this.readOnly = false,
    this.obscureText,
    this.onTap,
    this.initialValue,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.prefixIconConstraints,
    this.floatingLabelStyle,
    this.isValidationRequired = true,
    this.enabled = true,
    this.maxLines = 1,
    this.focus,
    this.isMobile = false,
    this.isEmail = false,
    this.isPassword = false,
    this.keyboardType,
    this.onFieldSubmitted,
    this.autoFillHints,
    this.validator,
    this.enableSuggestions,
    this.togglePasswordVisibility,
    this.isOTP = false,
    this.matchingPasswordController,
    this.isConfirmPassword = false,
  });

  @override
  State<FluentTextBox> createState() => _CustomTextBoxState();
}

class _CustomTextBoxState extends State<FluentTextBox> {
  late TextEditingController _controller;
  bool isSubmitted = false;
  bool _obscureText = true; // Added state variable

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null && _controller.text.isEmpty) {
      _controller.text = widget.initialValue!;
    }
    _obscureText = widget.obscureText ??
        true; // Initialize with provided value or default to true
  }

  @override
  void didUpdateWidget(FluentTextBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != null &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue!;
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  final requirements = {
    'Password must contain at least 8 characters': RegExp('.{8,}'),
    'Password must contain at least one uppercase letter': RegExp('[A-Z]'),
    'Password must contain at least one lowercase letter': RegExp('[a-z]'),
    'Password must contain at least one digit': RegExp(r'\d'),
    'Password must contain at least one special character':
        RegExp(r'[@$!%*?&]'),
  };

  String? validateField(String? value) {
    // If a custom validator function is provided, use it and return its result if there is an error
    if (widget.validator != null) {
      final String? customValidationResult = widget.validator!(value);
      if (customValidationResult != null) {
        return customValidationResult; // Return custom validator error if exists
      }
    }

    if (widget.isConfirmPassword && widget.matchingPasswordController != null) {
      if (value == null || value.isEmpty) {
        return 'Confirm password is required';
      }
      if (value != widget.matchingPasswordController!.text) {
        return 'Passwords do not match';
      }
    }

    if (widget.isPassword && !widget.isConfirmPassword && isSubmitted) {
      if (value == null || value.isEmpty) {
        return 'Password is required';
      }
      for (final requirement in requirements.entries) {
        if (!requirement.value.hasMatch(value)) {
          return requirement.key;
        }
      }
    }

    // Check if the field is for an email
    if (widget.isEmail) {
      if (value == null || value.isEmpty) {
        return 'Email is required';
      } else if (!RegExp(r'^[\w\.-]+@'
              r'[\w\.-]+\.'
              r'[a-zA-Z]{2,6}$')
          .hasMatch(value)) {
        return 'Please enter a valid email address';
      }
    }

    // Check if the field is for a mobile number
    if (widget.isMobile) {
      if (value == null || value.isEmpty) {
        return 'Mobile number is required';
      } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
        return 'Please enter a valid 10-digit mobile number';
      }
    }

    if (widget.isValidationRequired && (value == null || value.isEmpty)) {
      return 'This field is required';
    }
    return null;
  }

  bool allRequirementsMet(String value) {
    final requirements = [
      RegExp('.{8,}'), // At least 8 characters
      RegExp('[A-Z]'), // At least one uppercase letter
      RegExp('[a-z]'), // At least one lowercase letter
      RegExp(r'\d'), // At least one digit
      RegExp(r'[@$!%*?&]'), // At least one special character
    ];

    return requirements.every((regex) => regex.hasMatch(value));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = FluentTheme.of(context).brightness == Brightness.dark;
    final borderColor = isDarkMode ? Colors.grey[130] : Colors.grey[100];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.labelText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                widget.labelText!,
                style: widget.floatingLabelStyle ?? AppTextStyle.subtitle,
              ),
            ),
          FormField<String>(
            initialValue: _controller.text,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validateField,
            builder: (state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextBox(
                  controller: _controller,
                  placeholder: widget.hintText,
                  obscureText: widget.isPassword ? _obscureText : false,
                  placeholderStyle: GoogleFonts.manrope(),
                  style: widget.textStyle ?? const TextStyle(fontSize: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  foregroundDecoration: BoxDecoration(
                    border: Border.all(
                      color: state.hasError && widget.enabled!
                          ? Colors.red
                          : Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  readOnly: widget.readOnly,
                  enabled: widget.enabled,
                  onTap: widget.onTap,
                  onChanged: (value) {
                    setState(() {
                      isSubmitted = true;
                    });
                    widget.onChanged?.call(value);
                    state.didChange(value);
                  },
                  onSubmitted: (value) {
                    setState(() {
                      isSubmitted = true;
                    });
                    widget.onFieldSubmitted?.call(value);
                  },
                  keyboardType: widget.keyboardType,
                  focusNode: widget.focus,
                  maxLines: widget.maxLines,
                  maxLength: widget.isMobile ? 10 : null,
                  autofillHints: widget.autoFillHints,
                  enableSuggestions: widget.enableSuggestions ?? true,
                  prefix: widget.prefixIcon != null
                      ? Padding(
                          padding: const EdgeInsets.all(8),
                          child: widget.prefixIcon,
                        )
                      : widget.iconPath != null
                          ? Padding(
                              padding: const EdgeInsets.all(8),
                              child: Image.asset(widget.iconPath!),
                            )
                          : null,
                  suffix: widget.isPassword
                      ? IconButton(
                          icon: Icon(
                            _obscureText ? FluentIcons.hide : FluentIcons.view,
                            size: 20,
                          ),
                          onPressed: _togglePasswordVisibility,
                        )
                      : widget.suffixIcon != null
                          ? Padding(
                              padding: const EdgeInsets.all(8),
                              child: widget.suffixIcon,
                            )
                          : null,
                ),
                if (widget.isPassword &&
                    isSubmitted &&
                    !allRequirementsMet(_controller.text) &&
                    widget.enabled!)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: requirements.entries
                          .map((requirement) => Text(
                                requirement.key,
                                style: TextStyle(
                                  color: requirement.value
                                          .hasMatch(_controller.text)
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 12,
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                if (!widget.isPassword && state.hasError && widget.enabled!)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                if (widget.isPassword &&
                    state.hasError &&
                    _controller.text.isEmpty &&
                    widget.enabled!)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
