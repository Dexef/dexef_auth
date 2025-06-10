import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../size_widgets/app_font_style.dart';
import '../../theme/colors.dart';
import 'default_text.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    required this.label,
    this.controller,
    Key? key,
    this.validator,
    this.keyboardType,
    this.onChange,
    this.hint,
    this.isEnabled,
    this.prefix,
    this.suffix,
    this.onTap,
    this.readOnly = false,
    this.onFieldSubmitted,
    this.width = 394,
    this.focusNode,
    this.autoFocus = false,
    this.contentPaddingHorizontal = 24,
    this.contentPaddingVertical = 12,
    this.radius = 25,
    this.height,
    this.fillColor = Colors.white,
    this.enabledBorderColor = brushBorder,
    this.focusBorderColor = selectedBorder,
    this.errorBorderColor = Colors.red,
    this.minLines = 1,
    this.isDense,
    this.maxLines,
    this.isBorder = true,
    this.isCollapsed,
    this.hoverColor = Colors.transparent,
    this.hintFontSize = 16,
    this.sameBorderColor = false,
    this.inputFormatters,
    this.maxLength,
    this.errorState = false,
    this.autofillHints,
  }) : super(key: key);
  String label;
  String? hint;
  TextEditingController? controller;
  String? Function(String?)? validator;
  TextInputType? keyboardType;
  Function(String)? onChange;
  Widget? prefix;
  Widget? suffix;
  bool? isEnabled;
  List<TextInputFormatter>? inputFormatters;
  double width;
  double? height;
  dynamic onTap;
  bool readOnly = false;
  Function(String)? onFieldSubmitted;
  FocusNode? focusNode;
  bool autoFocus;
  double contentPaddingHorizontal;
  double contentPaddingVertical;
  double radius;
  Color? fillColor;
  Color enabledBorderColor;
  Color focusBorderColor;
  Color errorBorderColor;
  Color hoverColor;
  int minLines;
  bool? isDense;
  int? maxLines;
  final bool isBorder;
  bool? isCollapsed;
  double hintFontSize;
  bool sameBorderColor;
  int? maxLength;
  bool errorState = false;
  Iterable<String>? autofillHints ;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines,
      autofocus: autoFocus,
      focusNode: focusNode,
      onChanged: onChange,
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      buildCounter: (
          BuildContext context, {
            required int currentLength,
            required bool isFocused,
            required int? maxLength,
          }) {
        return null;
      },
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      enabled: isEnabled,
      inputFormatters: inputFormatters,
      style: Theme.of(context).textTheme.labelSmall!.copyWith(
          color: blackColor
      ),
      readOnly: readOnly,
      decoration: InputDecoration(
          fillColor: fillColor ?? Colors.white,
          isCollapsed: isCollapsed ?? false,
          hoverColor: hoverColor,
          hintText: hint,
          hintStyle: TextStyle(
            color: brushLines,
            fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: hintFontSize, mobileFontSize: (hintFontSize-2).sp)
          ),
          contentPadding: EdgeInsets.symmetric(
              horizontal: contentPaddingHorizontal,
              vertical: contentPaddingVertical),
          helperStyle: const TextStyle(
            height: .2,
          ),
          errorStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: Colors.red,
              height: 1
          ),
          //helperText: "",
          prefixIcon: prefix ?? null,
          suffixIcon: suffix,
          isDense: isDense,
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: DefaultText(
              text: label,
              isTextTheme: true,
              themeStyle:Theme.of(context).textTheme.labelSmall?.copyWith(
                color: brushLines,
              ),
            ),
          ),
          border: OutlineInputBorder(),
          enabledBorder: isBorder
              ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(
                color: sameBorderColor
                    ? brush.withOpacity(.03)
                    : errorState  ? redColor: enabledBorderColor,
              ))
              : InputBorder.none,
          focusedBorder: isBorder
              ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(
                  color: sameBorderColor
                      ? brush.withOpacity(.03)
                      :  errorState  ? redColor:focusBorderColor))
              : InputBorder.none,
          disabledBorder: isBorder
              ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: errorState  ? redColor: enabledBorderColor))
              : InputBorder.none,
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: errorState  ? redColor: errorBorderColor)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: errorBorderColor))),
    );
  }
}
