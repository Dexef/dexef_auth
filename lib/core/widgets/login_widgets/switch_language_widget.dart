import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../../core/size_widgets/responsive_widget.dart';
import '../../../../../../core/size_widgets/app_font_style.dart';
import '../../rest/app_constants.dart';
import '../../rest/app_localizations.dart';
import '../../rest/cash_helper.dart';
import '../../rest/constants.dart';
import '../../rest/methods.dart';
import '../../theme/colors.dart';
import '../public/default_text.dart';
import '../public/pop_up_menu_widget.dart';

class LanguageSwitchWidget extends StatefulWidget {
  final BoxConstraints constraints;
  final bool fromDialog;
  const LanguageSwitchWidget({super.key, required this.constraints, this.fromDialog = false});
  @override
  State<LanguageSwitchWidget> createState() => _LanguageSwitchWidgetState();
}

class _LanguageSwitchWidgetState extends State<LanguageSwitchWidget> {
  String currentLang = getLanguage();
  bool isArabic = CacheHelper.getData(key: Constants.isArabic.toString()) ?? true;
  @override
  Widget build(BuildContext context) {
    List<String> optionsLanguages = [
      AppLocalizations.of(context)!.translate('arabic'),
      AppLocalizations.of(context)!.translate('english'),
      AppLocalizations.of(context)!.translate('french'),
    ];
    return ResponsiveWidget(
      endPadding: widget.constraints.maxWidth > AppConstants.minimumScreenSize ? 50 : 24,
      topPadding: 22,
      localWidthRatio: 1,
      child: Row(
        mainAxisAlignment: widget.fromDialog ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
        children: [
          if(widget.fromDialog)...[
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: ()=> Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsetsDirectional.only(start: 40),
                  child: Icon(Icons.close, size: 32,),
                ),
              ),
            ),
          ],
          Visibility(
            visible: widget.fromDialog ? false : true,
            child: Row(
              children: [
                Visibility(
                  visible: false,
                  child: Transform.scale(
                    scale: .6,
                    child: CupertinoSwitch(
                      value: CacheHelper.getData(key: Constants.isArabic.toString()) ?? isArabic,
                      activeColor: success,
                      trackColor: brushLines,
                      onChanged: (bool isChange) {
                        CacheHelper.saveData(key: Constants.isArabic.toString(), value: isChange);
                        if (isChange) {
                          context.locale = const Locale('ar');
                          CacheHelper.saveData(key: Constants.appLanguage.toString(), value: 'ar');
                          currentLang = "AR";
                        } else {
                          context.locale = const Locale('en');
                          CacheHelper.saveData(key: Constants.appLanguage.toString(), value: 'en');
                          currentLang = "EN";
                        }
                      },
                    ),
                  ),
                ),
                // const SizedBox(
                //   width: 5,
                // ),
                PopUpMenuWidget(
                  optionsName: optionsLanguages,
                  setWidthMenu: false,
                  onSelected: (value){
                    if(value == 0){
                      CacheHelper.saveData(key: Constants.isArabic.toString(), value: true);
                      context.locale = const Locale('ar');
                      CacheHelper.saveData(key: Constants.appLanguage.toString(), value: 'ar');
                      currentLang = "AR";
                    }else if(value == 1){
                      CacheHelper.saveData(key: Constants.isArabic.toString(), value: false);
                      context.locale = const Locale('en');
                      CacheHelper.saveData(key: Constants.appLanguage.toString(), value: 'en');
                      currentLang = "EN";
                    }else if(value == 2){
                      CacheHelper.saveData(key: Constants.isArabic.toString(), value: false);
                      context.locale = const Locale('fr');
                      CacheHelper.saveData(key: Constants.appLanguage.toString(), value: 'fr');
                      currentLang = "FR";
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/arabic_english.svg",
                        color: brushIcon,
                      ),
                      DefaultText(
                        text: currentLang,
                        fontColor: brush,
                        fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 15, mobileFontSize: 13.sp),
                        fontWeight: FontWeight.w400,
                        fontFamily: AppFontStyle.appFontFamily.readex,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
