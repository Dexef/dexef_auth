import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../rest/app_localizations.dart';
import '../../rest/methods.dart';
import '../../size_widgets/app_font_style.dart';
import '../../theme/colors.dart';
import '../public/default_text.dart';

class SocialButton extends StatelessWidget {
  final void Function()? onTap;
  final bool preventTap;
  final Color? buttonColor;
  final String imagePath;
  final String text;

  const SocialButton({
    super.key,
    this.onTap,
    this.preventTap = false,
    this.buttonColor,
    required this.imagePath,
    required this.text
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,  // Removes the background highlight color
      splashColor: Colors.transparent,     // Removes the splash color
      onTap: preventTap ? null : onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: buttonColor ?? Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: brushBorder,)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getImage(path: imagePath , isSvg: true),
              const SizedBox(width: 5),
              DefaultText(
                text: text,
                isTextTheme: true,
                themeStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 13, mobileFontSize: 11.sp),
                )),
            ],
          ),
        ),
      ),
    );
  }
}
