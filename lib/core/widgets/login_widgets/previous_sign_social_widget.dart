import 'package:auth_dexef/core/rest/image_paths.dart';
import 'package:auth_dexef/core/widgets/login_widgets/social_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/size_widgets/app_font_style.dart';
import '../../../features/login/presentation/cubit/login_cubit.dart';
import '../../../features/login/presentation/cubit/login_state.dart';
import '../../rest/app_constants.dart';
import '../../rest/app_localizations.dart';
import '../../rest/firebase_auth.dart';
import '../../rest/methods.dart';
import '../../theme/colors.dart';
import '../public/default_text.dart';

class PreviousSignSocialWidget extends StatelessWidget {
  final LoginCubit loginCubit;
  final String loginType;
  final String phoneText;
  final LoginState state;
  const PreviousSignSocialWidget({
    super.key,
    required this.loginCubit,
    required this.loginType,
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
        getSocialButton(context),
      ],
    );
  }
////////////////////////////////////////////////////////////////////////////////
  Widget getSocialButton(BuildContext context){
    if(loginType == AppConstants.googleString){
      return SocialButton(
        buttonColor: state is SignInWithGoogleWebLoading ||
            state is LoginWithGoogleLoading ||
            state is SignInWithGoogleMobileLoading
            ? opacityGoogle
            : Colors.white,
        preventTap: state is SignInWithGoogleWebLoading ||
            state is LoginWithGoogleLoading ||
            state is SignInWithGoogleMobileLoading,
        onTap: () async {
          if (kIsWeb) {
            loginCubit.errorMessage = null;
            loginCubit.signInWithGoogleWeb(true).then((value) {
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
        imagePath: ImagesPath.googleIcon,
        text: AppLocalizations.of(context)!.translate('signGoogle'),
      );
    }else if(loginType == AppConstants.appleString){
      return SocialButton(
        buttonColor: state is SignInAppleLoadingFirebase ||
            state is LoginWithAppleLoading
            ? opacityGoogle
            : Colors.white,
        preventTap: state is LoginWithAppleLoading || state is SignInAppleLoadingFirebase,
        onTap: () async {
          loginCubit.signInWithAppleWeb(context);
        },
        imagePath: ImagesPath.appleIcon,
        text: AppLocalizations.of(context)!.translate('signApple'),
      );
    }else{
      return const SizedBox();
    }
  }
}
