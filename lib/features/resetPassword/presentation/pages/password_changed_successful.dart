import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/size_widgets/app_screen_size.dart';
import '../../../../../core/size_widgets/responsive_widget.dart';
import '../../../../../core/size_widgets/app_font_style.dart';
import 'dart:ui' as ui;

import '../../../../core/rest/app_localizations.dart';
import '../../../../core/rest/methods.dart';
import '../../../../core/rest/routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/public/default_login_screen.dart';
import '../../../../core/widgets/public/default_text.dart';

class PasswordChangedSuccessful extends StatelessWidget {
  PasswordChangedSuccessful({super.key});
  Orientation? orientation;
  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    return DefaultLoginScreen(
      body: Row(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width - AppScreenSize.appWidgetSize.getLoginRightPanelWidth(context),
            decoration: BoxDecoration(color: cloudBackground, boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.16),
                offset: Offset(0, 0),
                blurRadius: 12.0,
              )
            ]),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ResponsiveWidget(
                          localWidthRatio: 400/640,
                          child: getImage(path:'images/succes-password.svg',isSvg: true,  height: MediaQuery.of(context).size.height * (300/800),),
                        ),
                        const SizedBox(height: 50),
                        ResponsiveWidget(
                          localWidthRatio: 320/640,
                          child: DefaultText(
                            text: AppLocalizations.of(context)!.translate('passwordChanged'),
                            isTextTheme: true,
                            themeStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontFamily: AppFontStyle.appFontFamily.readex,
                              fontWeight: FontWeight.w400,
                              color: black,
                              height: 1.6,
                            )
                          ),
                        ),
                      ],
                    )),
                ResponsiveWidget(
                  localWidthRatio: ratioLogoMiniWidth,
                  fixedHeight: MediaQuery.of(context).size.height * ratioLogoMiniHeight,
                  child: getImage(path:  'images/dexef_logo_body.svg',isSvg: true),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * ratioHeightUnderLogo,
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: AppScreenSize.appWidgetSize.getLoginRightPanelWidth(context),
            child: Directionality(
              textDirection: context.locale.languageCode == 'en' ? ui.TextDirection.ltr : ui.TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DefaultText(
                      text: AppLocalizations.of(context)!.translate('passwordResetSuccessful'),
                      isTextTheme: true,
                      themeStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: success,
                        fontFamily: AppFontStyle.appFontFamily.readex,
                        fontWeight: FontWeight.w800,
                      )
                    ),
                    const SizedBox(height: 16,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: DefaultText(
                            text: AppLocalizations.of(context)!.translate('checkSignIn'),
                            isTextTheme: true,
                            themeStyle: Theme.of(context).textTheme.labelMedium,
                            isMultiLine: true,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                //Navigator.of(context).pushNamedAndRemoveUntil(Login.route, (route) => false);
                                Router.neglect(context, () {
                                  context.go(Routes.loginScreen);
                                });
                              },
                              child: DefaultText(
                                text:AppLocalizations.of(context)!.translate('signIn'),
                                isTextTheme: true,
                                themeStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: primary,
                                )
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
