import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mydexef/core/class_constants/app_constants_values.dart';
import 'package:mydexef/features/auth/presentation/cubit/1.login_cubit/login_cubit.dart';
import '../../../../../../core/class_constants/Routes.dart';
import '../../../../../../core/class_constants/constants_methods.dart';
import '../../../../../../core/firebase_authentication.dart';
import '../../../../../../core/widgets/default_text.dart';
import '../../../../../../core/size_widgets/app_font_style.dart';
import '../../../../../../style/colors/colors.dart';
import '../../../../../../utils/app_localizations.dart';
import '../../../../../../utils/cash_helper.dart';
import '../../../../../../utils/constants.dart';
import '../../../../login/presentation/cubit/login_state.dart';

class PreviousSignSocialWidget extends StatelessWidget {
  final LoginCubit loginCubit;
  final String emailType;
  final String phoneText;
  final LoginState state;
  const PreviousSignSocialWidget({
    super.key,
    required this.loginCubit,
    required this.emailType,
    required this.phoneText,
    required this.state
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.orange.withOpacity(0.4),
              minRadius: 25,
            ),
            const SizedBox(width: 20,),
            DefaultText(
              text: phoneText,
              isTextTheme: true,
              themeStyle: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        const SizedBox(height: 32,),
        DefaultText(
          text: AppLocalizations.of(context)?.translate('previouslySigned'),
          isTextTheme: true,
          themeStyle: Theme.of(context).textTheme.labelMedium,
          maxLines: 3,
        ),
        const SizedBox(height: 10),
        InkWell(
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,  // Removes the background highlight color
          splashColor: Colors.transparent,     // Removes the splash color
          onTap: () {
         loginCubit.modifyData();
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: DefaultText(
                text: AppLocalizations.of(context)!.translate('modifyData'),
                isTextTheme: true,
                themeStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontFamily: AppFontStyle.appFontFamily.readex,
                  fontWeight: FontWeight.w400,
                  color: primary,
                )),
          ),
        ),
        const SizedBox(height: 30),
        emailType == AppConstants.googleString ? InkWell(
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,  // Removes the background highlight color
          splashColor: Colors.transparent,     // Removes the splash color
          onTap: state is SignInWithGoogleWebLoading ||
              state is LoginWithGoogleLoading ||
              state is SignInWithGoogleLoading ? null : () async {
            if (kIsWeb) {
              loginCubit.errorMessage = null;
              loginCubit.signInWithGoogleWeb().then((value) {
                if (loginCubit.credGoogleWeb?.credential?.accessToken != null) {
                  loginCubit.loginWithGoogle(token: '${loginCubit.credGoogleWeb?.credential?.accessToken}');
                }
              });
            } else {
              loginCubit.signInWithGoogle().then((value) {
                loginCubit.loginWithGoogle(
                    token: "${googleAuth?.accessToken}");
              });
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              height: 48,
              //padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: state is SignInWithGoogleWebLoading ||
                      state is LoginWithGoogleLoading ||
                      state is SignInWithGoogleLoading
                      ? opacityGoogle
                      : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: brushBorder,
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getImage(path: 'images/signin_google.svg', isSvg: true),
                  const SizedBox(height: 5),
                  DefaultText(
                      text: AppLocalizations.of(context)!
                          .translate('signGoogle'),
                      isTextTheme: true,
                      themeStyle: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(
                        fontSize:
                        AppFontStyle.appFontSize.setFontSize(context, webFontSize: 13, mobileFontSize: 11.sp),
                      )),
                ],
              ),
            ),
          ),
        ) : const SizedBox(),
        const SizedBox(height: 16),
        emailType == AppConstants.appleString
            ? InkWell(
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,  // Removes the background highlight color
          splashColor: Colors.transparent,     // Removes the splash color
          onTap: state is AppleSignInLoading || state is SignUpAppleLoading ? null : () async {
            loginCubit.signUpWithApple();
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              height: 48,
              //padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: state is SignInWithFacebookWebLoading ||
                      state is LoginWithFacebookLoading ||
                      state is SignInWithFacebookLoading
                      ? opacityGoogle
                      : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: brushBorder,
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getImage(path: 'images/apple.svg', isSvg: true),
                  const SizedBox(width: 5),
                  DefaultText(
                      text: AppLocalizations.of(context)!
                          .translate('signApple'),
                      isTextTheme: true,
                      themeStyle: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(
                        fontSize:
                        AppFontStyle.appFontSize.setFontSize(context, webFontSize: 13, mobileFontSize: 11.sp),
                      )),
                ],
              ),
            ),
          ),
        ): const SizedBox(),
      ],
    );
  }
}
