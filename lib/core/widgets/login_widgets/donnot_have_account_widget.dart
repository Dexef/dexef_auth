import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/class_constants/Routes.dart';
import '../../../../../../core/class_constants/constants_methods.dart';
import '../../../../../../core/widgets/default_text.dart';
import '../../../../../../core/size_widgets/app_font_style.dart';
import '../../../../../../style/colors/colors.dart';
import '../../../../../../utils/app_localizations.dart';

class HaveAccountWidget extends StatelessWidget {
  final bool fromDialog;
  const HaveAccountWidget({super.key, this.fromDialog = false});
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: [
        DefaultText(
          text: AppLocalizations.of(context)!.translate('donotHaveAccount'),
          isTextTheme: true,
          themeStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontFamily: AppFontStyle.appFontFamily.readex,
            color: brushIcon,
            fontWeight: FontWeight.w400,
            fontSize: getLanguageCode(context) == 'en' || getLanguageCode(context) == 'fr' ? AppFontStyle.appFontSize.setFontSize(context, webFontSize: 16, mobileFontSize: 14.sp)
                : AppFontStyle.appFontSize.setFontSize(context, webFontSize: 14, mobileFontSize: 12.sp),
          ),
        ),
        // SizedBox(width: 6,),
        InkWell(
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,  // Removes the background highlight color
          splashColor: Colors.transparent,     // Removes the splash color
          onTap: () {
            if(fromDialog){
              Navigator.pop(context);
            }
            context.go(Routes.adminSignUpScreen);
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: DefaultText(
                text: AppLocalizations.of(context)!.translate('signUp'),
                isTextTheme: true,
                themeStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontFamily:  AppFontStyle.appFontFamily.readex,
                  fontWeight: FontWeight.w400,
                  fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 14, mobileFontSize: 12.sp),
                  color: primary,
                )
            ),
          ),
        ),
      ],
    );
  }
}
