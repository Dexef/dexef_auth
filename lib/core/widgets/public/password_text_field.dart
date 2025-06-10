import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../size_widgets/app_font_style.dart';
import '../../theme/colors.dart';
import 'default_text.dart';

class PasswordTextFormField extends StatefulWidget {
  PasswordTextFormField({
    required this.label,
    required this.controller,
    Key? key,
    this.validator,
    this.keyboardType,
    this.onChange,
    this.isEnabled,
    this.onFieldSubmitted,
    this.errorState = false,
    this.focusNode,
    this.fillColor,
    this.autoFocus = false,
    this.borderRadius = 25, // Default value for border radius
  }) : super(key: key);

  String label;
  TextEditingController controller;
  String? Function(String?)? validator;
  TextInputType? keyboardType;
  Function(String)? onChange;
  Function(String)? onFieldSubmitted;
  bool? isEnabled;
  bool errorState = false;
  FocusNode? focusNode;
  Color? fillColor;
  bool autoFocus = false;
  double borderRadius; // Configurable border radius

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPasswordVisible,
      onChanged: widget.onChange,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      enabled: widget.isEnabled,
      focusNode: widget.focusNode,
      autofocus: widget.autoFocus,
      style: Theme.of(context).textTheme.labelSmall!.copyWith(color: blackColor),
      decoration: InputDecoration(
        hintStyle: TextStyle(
          color: brushLines,
          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 22, mobileFontSize: 20.sp),
        ),
        fillColor: widget.fillColor ?? Colors.white,
        contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 24, vertical: 12),
        helperStyle: const TextStyle(height: .2),
        helperText: "",
        errorStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
          color: Colors.red,
          height: 1,
        ),
        suffixIcon: Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 15),
          child: Focus(
            descendantsAreFocusable: false,
            canRequestFocus: false,
            child: IconButton(
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
              icon: Icon(isPasswordVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined),
              iconSize: 20,
              color: brushLines,
              autofocus: false,
              focusNode: FocusNode(
                canRequestFocus: false,
                descendantsAreFocusable: false,
              ),
            ),
          ),
        ),
        floatingLabelStyle: TextStyle(
          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 18, mobileFontSize: 16.sp),
        ),
        label: DefaultText(
          text: widget.label,
          isTextTheme: true,
          themeStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: brushLines,
            fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 15, mobileFontSize: 13.sp),
          ),
        ),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.errorState ? redColor : brushBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.errorState ? redColor : blueCircle,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.errorState ? redColor : brushBorder,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
