import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
import 'package:mydexef/features/auth/presentation/cubit/1.login_cubit/login_cubit.dart';
import 'package:mydexef/features/auth/presentation/cubit/1.login_cubit/login_state.dart';
import '../../../../../../core/class_constants/constants_methods.dart';
import '../../../../../../core/firebase_authentication.dart';
import '../../../../../../core/widgets/default_text.dart';
import '../../../../../../core/size_widgets/app_font_style.dart';
import '../../../../../../style/colors/colors.dart';
import '../../../../../../utils/app_localizations.dart';

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
            onTap: state is LoginWithGoogleLoading || state is SignInWithGoogleLoading || state is SignInWithGoogleWebLoading ? null : () async {
              if (kIsWeb) {
                loginCubit.errorMessage = null;
                loginCubit.signInWithGoogleWeb().then((value) {
                  if (loginCubit.credGoogleWeb?.credential?.accessToken != null) {
                    loginCubit.loginWithGoogle(token: '${loginCubit.credGoogleWeb?.credential?.accessToken}');
                  }});
              } else {
                loginCubit.signInWithGoogle().then((value) {
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
                    color: state is SignInWithGoogleWebLoading || state is LoginWithGoogleLoading || state is SignInWithGoogleLoading
                        ? opacityGoogle
                        : Colors.white,
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
            onTap: state is AppleSignInLoading || state is SignUpAppleLoading? null : () async {
              loginCubit.errorMessage = null;
              loginCubit.signUpWithApple();
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                height: 48,
                //padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: state is AppleSignInLoading || state is SignUpAppleLoading ? opacityGoogle : Colors.white,
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
