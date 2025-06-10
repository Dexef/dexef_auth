import 'package:flutter/material.dart';
import '../../../../core/size_widgets/app_screen_size.dart';
import '../../../../core/size_widgets/responsive_widget.dart';
import '../../../../core/size_widgets/app_font_style.dart';
import '../../rest/app_localizations.dart';
import '../../rest/methods.dart';
import '../../theme/colors.dart';
import '../public/default_text.dart';

class LeftPanelWidget extends StatelessWidget {
  final String? imagePath;
  const LeftPanelWidget({super.key, this.imagePath});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width - AppScreenSize.appWidgetSize.getLoginRightPanelWidth(context),
      decoration: BoxDecoration(color: cloudBackground, boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.16),
          offset: const Offset(0, 0),
          blurRadius: 12.0,
        )
      ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {},
                child: Padding(padding: const EdgeInsets.only(top: 50, left: 50, right: 50), child: Container(),),
              ),
            ],
          ),
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ResponsiveWidget(
                      localWidthRatio: ratioBackgroundWidth,
                      child: getImage(
                        path: "images/login_background.svg",
                        isSvg: true,
                        height: MediaQuery.of(context).size.height *
                            ratioBackgroundHeight,
                      )),
                  ResponsiveWidget(
                      localWidthRatio: ratioImageWidth,
                      child: getImage(path: imagePath!, height: MediaQuery.of(context).size.height * ratioImageHeight)
                  ),
                  // WidgetResponsiveBuilder(
                  //   localWidth: ratioImageWidth,
                  //   child: Image(
                  //     image: NetworkImage("assets/images/backgroundSignUp.png"),
                  //   ),
                  // ),
                ],
              ),
              DefaultText(
                text: 'Dexef Cloud',
                isTextTheme: true,
                themeStyle:
                Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontFamily: 'DXRound',
                  fontWeight: AppFontStyle.fontWeightCustoms.extraBold,
                ),
                maxLines: 1,
              ),
              const SizedBox(
                height: 8,
              ),
              DefaultText(
                text: AppLocalizations.of(context)?.translate('login_description'),
                isTextTheme: true,
                themeStyle:
                Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontFamily: 'DXRound',
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
              ),
            ],
          ),
          Visibility(
            visible: false,
            child: ResponsiveWidget(
              localWidthRatio: ratioLogoMiniWidth,
              fixedHeight: MediaQuery.of(context).size.height *
                  ratioLogoMiniHeight,
              bottomPadding: MediaQuery.of(context).size.height *
                  ratioHeightUnderLogo,
              child: getImage(
                  path: 'images/dexef_logo_body.svg',
                  isSvg: true,
                  fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
}
