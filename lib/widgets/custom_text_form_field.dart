import 'package:chat_project/utils/validated_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final bool isEnabled;
  final Color? filledColor;
  final bool hasValidator;
  final int? maxLines;
  final bool hasBorder;
  final bool isSecured;
  final String validateText;
  final ValueChanged<String?>? onChange;
  final bool isLtr;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final String hintText;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    this.isEnabled = true,
    this.filledColor,
    this.hasValidator = true,
    this.hasBorder = true,
    this.isSecured = false,
    required this.validateText,
    this.onChange,
    this.isLtr = false,
    this.keyboardType,
    this.prefixIcon,
    required this.hintText, this.maxLines,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isObscure = false;

  @override
  void didChangeDependencies() {
    _isObscure = widget.isSecured;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        maxLines: widget.maxLines ?? 1,
        controller: widget.controller,
        inputFormatters: [
          LengthLimitingTextInputFormatter(
            widget.validateText.toLowerCase().contains('phone') ? 8 : 7000,
          ),
          if (widget.validateText.toLowerCase().contains('phone'))
            FilteringTextInputFormatter.digitsOnly
        ],
        textDirection: widget.isLtr ? TextDirection.ltr : null,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          hintText: widget.hintText,
          // suffixText: widgets.validateText.toLowerCase().contains('phone')
          //     // &&
          //     // context.read<LocaleProvider>().isArabic!
          //
          //     ? '965+ '
          //     : null,
          prefixText: widget.validateText.toLowerCase().contains('phone')
              // &&
              //     context.read<LocaleProvider>().isArabic!

              ? '+965 '
              : null,
          prefixStyle: Theme.of(context).textTheme.labelMedium,
          suffixStyle: Theme.of(context).textTheme.labelMedium,
          fillColor: !widget.isEnabled ? Colors.grey : widget.filledColor,
          enabled: widget.isEnabled,
          filled: widget.filledColor != null,
          suffixIcon: widget.isSecured
              ? IconButton(
                  icon: Icon(
                    !_isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    setState(
                      () {
                        _isObscure = !_isObscure;
                      },
                    );
                  },
                )
              : null,
          prefixIcon: widget.prefixIcon != null
              ? Icon(
                  widget.prefixIcon,
                  color: Colors.greenAccent,
                )
              : null,
          border: widget.hasBorder
              ? const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                )
              : InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
        ),
        style: Theme.of(context).textTheme.labelMedium,
        obscureText: _isObscure,
        onChanged: widget.onChange,
        validator: (value) {
          if (value!.isEmpty && !value.isNotNull && widget.hasValidator) {
            return "Required field";
          }

          // Validation for passwords to not to be minimum than 8 chars.
          if ((widget.validateText.toLowerCase().contains('password') ||
                  widget.isSecured) &&
              (value.length < 6 || value.isValidPassword)) {
            return "Password not valid";
          }
          // Validation for name to only have letters or [., -, space, or (,)]
          if (widget.validateText.toLowerCase().contains("name") &&
              (value.length < 3 ||
                  // !value.isValidNameAr ||
                  // !value.isValidNameEn ||
                  int.tryParse(value) is int)) {
            return "Name not valid";
          }
          if (widget.validateText.toLowerCase().contains("description") &&
              value.isEmpty) {
            return "Required field";
          }
          // Validation for Email address to match known email address patterns
          if (value.isNotEmpty &&
              widget.validateText.toLowerCase().contains("email") &&
              value.isValidEmail) {
            return "Email not valid";
          }
          return null;
        },
      ),
    );
  }
}
