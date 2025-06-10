import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/size_widgets/app_font_style.dart';
import '../../../dexef_auth/login/presentation/cubit/login_cubit.dart';
import '../../../dexef_auth/login/presentation/cubit/login_states.dart';
import '../../rest/app_localizations.dart';
import '../../rest/firebase_auth.dart';
import '../../rest/methods.dart';
import '../../theme/colors.dart';
import '../public/default_text.dart';

class SocialButtonWidget extends StatelessWidget {
  final LoginState state;
  final LoginCubit loginCubit;
  const SocialButtonWidget({
    super.key,
    required this.state,
    required this.loginCubit
  });
  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Expanded(
          child: InkWell(
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,  // Removes the background highlight color
            splashColor: Colors.transparent,     // Removes the splash color
            onTap: state is GoogleLoginLoading || state is GoogleFirebaseLoginMobileLoading || state is GoogleFirebaseLoginWebLoading ? null : () async {
              if (kIsWeb) {
                loginCubit.errorMessage = null;
                loginCubit.googleFirebaseLoginWeb().then((value) {
                  if (loginCubit.credGoogleWeb?.credential?.accessToken != null) {
                    loginCubit.loginWithGoogle(token: '${loginCubit.credGoogleWeb?.credential?.accessToken}');
                  }});
              } else {
                loginCubit.googleFirebaseLoginMobile().then((value) {
                  loginCubit.loginWithGoogle(token: "${googleAuth?.accessToken}");
                });
              }
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                height: 48,
                //padding: EdgeInsets.symmetric(horizontal: 20),
                decoration:
                BoxDecoration(
                    color: state is GoogleFirebaseLoginWebLoading
                        || state is GoogleLoginLoading
                        || state is GoogleFirebaseLoginMobileLoading ? opacityGoogle : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: brushBorder,)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getImage(path: 'images/signin_google.svg', isSvg: true),
                    const SizedBox(width: 5),
                    DefaultText(
                        text: AppLocalizations.of(context)!.translate('signGoogle'),
                        isTextTheme: true,
                        themeStyle: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 13, mobileFontSize: 11.sp))),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: InkWell(
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,  // Removes the background highlight color
            splashColor: Colors.transparent,     // Removes the splash color
            onTap: state is AppleLoginLoading || state is AppleLoginFirebaseWebLoading ? null : () async {
              loginCubit.errorMessage = null;
              loginCubit.appleLoginFirebaseWeb();
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                height: 48,
                //padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: state is AppleLoginLoading || state is AppleLoginFirebaseWebLoading ? opacityGoogle : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: brushBorder,)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center,
                  children: [
                    getImage(
                        path:
                        'images/apple.svg',
                        isSvg:
                        true),
                    const SizedBox(width: 5),
                    DefaultText(
                        text: AppLocalizations.of(context)!.translate(
                            'signApple'),
                        isTextTheme:
                        true,
                        themeStyle: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 13, mobileFontSize: 11.sp),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
