// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stylelezza/utils/app_colors.dart';

/// A custom text field widget that provides flexible styling and validation.
class CustomTextField extends StatefulWidget {
  final String? labelText;
  final Color borderColor;
  final Color? onTapBorderColor;
  final TextEditingController controller;
  bool isObsecure;
  bool isEnabled;
  final String? hintText;
  final int? maxLength;
  final TextInputType? keyBoardType;
  final List<TextInputFormatter>? inputFormatter;
  final Widget? prefixWidget;
  final bool suffixIcon;
  bool showError;
  final RegExp? validationRegex;
  final Color? inputValueColor;
  final double? inputValueSize;
  final FontWeight? inputValueWeight;
  final Color? filledColor;
  final Function(String)? onChanged;
  final Function()? onClearPressed;
  final VoidCallback? onTap;
  final String? errorMessage;
  final Color? enabledBorderColor;
  CustomTextField({
    super.key,
    this.labelText,
    this.borderColor = Colors.grey,
    this.onTapBorderColor = AppColors.textPrimaryColor,
    required this.controller,
    this.isObsecure = false,
    this.isEnabled = true,
    this.maxLength,
    this.keyBoardType,
    this.inputFormatter,
    this.prefixWidget,
    this.showError = false,
    this.validationRegex,
    this.inputValueColor,
    this.inputValueSize,
    this.inputValueWeight,
    this.filledColor,
    this.hintText,
    this.suffixIcon = false,
    this.onChanged,
    this.onClearPressed,
    this.onTap,
    this.errorMessage,
    this.enabledBorderColor,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              _isFocused = hasFocus;
            });
          },
          child: GestureDetector(
            onTap: widget.onTap,
            child: TextFormField(
              
              enabled: widget.isEnabled,
              maxLength: widget.maxLength,
              obscureText: widget.isObsecure,
              keyboardType: widget.keyBoardType,
              inputFormatters: widget.inputFormatter,
              controller: widget.controller,
              onChanged: (value) {
                if (widget.showError && widget.validationRegex != null) {
                  setState(() {
                    widget.showError = !widget.validationRegex!.hasMatch(value);
                  });
                }
                if (widget.onChanged != null) {
                  widget.onChanged!(value); // Pass the updated value to parent
                }
                if (_isFocused && widget.showError) {
                  setState(() {
                    widget.showError = value.length != widget.maxLength;
                  });
                }
                if (_isFocused && widget.showError) {
                  setState(() {
                    widget.showError = value.length < 3;
                  });
                }
              },
              style: GoogleFonts.publicSans(
                color: widget.inputValueColor ?? AppColors.textPrimaryColor,
                fontSize: widget.inputValueSize ?? 14.0,
                fontWeight: widget.inputValueWeight ?? FontWeight.w400,
              ),
              decoration: InputDecoration(
                labelText: widget.labelText,
                hintText: widget.hintText,
                hintStyle: GoogleFonts.publicSans(
                  color: AppColors.borderColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                fillColor: widget.filledColor,
                filled: widget.filledColor != null,
                labelStyle:
                    GoogleFonts.publicSans(color: AppColors.textSubH1Color),
                prefixIcon: widget.prefixWidget,
                suffixIcon: widget.suffixIcon
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.isObsecure = !widget.isObsecure;
                          });
                        },
                        child: Icon(
                          widget.isObsecure
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.primaryMainColor,
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(
                    color: widget.showError ? Colors.red : widget.borderColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(
                    color:
                        widget.showError ? Colors.red : AppColors.borderColor,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(
                    color: widget.showError
                        ? Colors.red
                        : (!_isFocused && widget.controller.text.isNotEmpty)
                            ? (widget.enabledBorderColor ??
                                AppColors.textPrimaryColor)
                            : AppColors.borderColor,
                    width: (!_isFocused && widget.controller.text.isNotEmpty)
                        ? 1.0
                        : 1.0,
                  ),
                ),
                counterText: '',
              ),
            ),
          ),
        ),
        if (widget.showError)
          Row(
            children: [
              SvgPicture.asset('assets/svg/alert_icon.svg',
                  height: 16, width: 16),
              const SizedBox(width: 8),
              Text(
                widget.errorMessage ??
                    'Please enter a valid  ${widget.labelText?.toLowerCase() ?? 'input'}',
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
      ],
    );
  }
}
