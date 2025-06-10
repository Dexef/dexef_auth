import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../rest/app_localizations.dart';
import '../../size_widgets/app_font_style.dart';
import '../../size_widgets/app_screen_size.dart';
import '../../theme/colors.dart';
// static search bar

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    this.onChanged,
    this.controller,
    this.borderColor,
    this.radius
  });
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final Color? borderColor;
  final double? radius;
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 40,
      width: AppScreenSize.appDesignSize.isWebPlatform(context) ? AppScreenSize.appWidgetSize.widgetWidth(context, 400) : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 25),
        color: Colors.white
      ),
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 12, mobileFontSize: 10.sp),
        ),
        decoration:  InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: AppScreenSize.appDesignSize.isWebPlatform(context) ? 11 : 11),
          border: InputBorder.none,
          hintText: AppLocalizations.of(context)!.translate('Search'),
          hintStyle: const TextStyle(
            color: description,
          ),
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? Colors.white),
            borderRadius: BorderRadius.circular(radius ?? 25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? Colors.white),
            borderRadius: BorderRadius.circular(radius ?? 25),
          ),
          // fillColor: Colors.transparent
        ),
        onChanged: onChanged,
      ),
    );


  }
}