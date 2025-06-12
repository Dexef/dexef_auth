import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:auth_dexef/locator.dart' as di;
import 'package:intl_phone_field/phone_number.dart';
import '../../../../../core/size_widgets/app_screen_size.dart';
import '../../../../../core/size_widgets/responsive_widget.dart';
import '../../../../../core/size_widgets/app_font_style.dart';
import '../../../../core/rest/app_constants.dart';
import '../../../../core/rest/app_localizations.dart';
import '../../../../core/rest/arguments.dart';
import '../../../../core/rest/cash_helper.dart';
import '../../../../core/rest/constants.dart';
import '../../../../core/rest/firebase_auth.dart';
import '../../../../core/rest/methods.dart';
import '../../../../core/rest/routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/dialog/alert_dialog.dart';
import '../../../../core/widgets/login_widgets/donnot_have_account_widget.dart';
import '../../../../core/widgets/login_widgets/email_login_widget.dart';
import '../../../../core/widgets/login_widgets/google_apple_button_widget.dart';
import '../../../../core/widgets/login_widgets/left_panel_widget.dart';
import '../../../../core/widgets/login_widgets/password_login_Widget.dart';
import '../../../../core/widgets/login_widgets/previous_sign_social_widget.dart';
import '../../../../core/widgets/login_widgets/switch_language_widget.dart';
import '../../../../core/widgets/public/default_login_screen.dart';
import '../../../../core/widgets/public/default_text.dart';
import '../../../../core/widgets/public/network_failed.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import 'dart:ui' as ui;


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginCubit? loginCubit;
  bool isTap = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();
  TextEditingController choosePhoneCode = TextEditingController();
  late bool rememberMeChecker;
  UserCredential? credFaceWeb;
  String? imagePath;
  String? phoneOrEmail;
  int maxLength = 10;
  PhoneNumber? phoneNumber;

////////////////////////////////////////////////////////////////////////////////
  void checkRememberMe() {
    rememberMeChecker = CacheHelper.getData(key: Constants.rememberMeChecker.toString()) ?? false;
    phoneController.text = CacheHelper.getData(key: Constants.emailOrPhone.toString()) ?? "";
    if (rememberMeChecker) {
      phoneController.text = CacheHelper.getData(key: Constants.emailOrPhone.toString()) ?? "";
      passwordController.text = CacheHelper.getData(key: Constants.password.toString()) ?? "";
    }
  }
////////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    phoneOrEmail = loginCubit?.socialLogin == AppConstants.googleString
      ? loginCubit!.credGoogleWeb!.user!.email! : loginCubit?.socialLogin == AppConstants.appleString
      ? loginCubit!.appleEmail!
      : phoneController.text;
    checkRememberMe();
    _updateImagePath();
    super.initState();
  }
////////////////////////////////////////////////////////////////////////////////
  void _updateImagePath() {
    imagePath = loginCubit?.validateEmailEntity?.data?.type == null
      ? 'images/login_first.png'
      : loginCubit?.validateEmailEntity?.data?.type == AppConstants.normalString
      ? 'images/login_password.png'
      : 'images/login_email.png';
  }
////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        getListenerForValidate(state);
        getListenerForGoogle(loginCubit!, state);
        getListenerForNormalDesign(loginCubit!, state);
        getListenerForApple(loginCubit!, state);
      },
      builder: (context, state) {
        loginCubit = LoginCubit.get(context);
        // loginCubit?.getEmailType();
        debugPrint("emailType ${loginCubit?.loginType}");
        return AbsorbPointer(
          absorbing: state is LoginLoading || state is GettingDialCode || state is ValidateEmailLoading,
          child: DefaultLoginScreen(
            isLoading: loginCubit?.isLoading,
            body: state is GetIPForCountryLoading ? const SizedBox() : state is GetIPForCountryError || state is GetIPForCountryFailure
                ? const NetworkFailed() : desktopLogin(state, phoneOrEmail!),
          ),
        );
      },
    );
  }
////////////////////////////////////////////////////////////////////////////////
  desktopLogin(LoginState state, String phoneOrEmail) {
    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        children: [
          LeftPanelWidget(imagePath: imagePath,),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: AppScreenSize.appWidgetSize.getLoginRightPanelWidth(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LanguageSwitchWidget(constraints: constraints,),
                Flexible(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Directionality(
                        textDirection: getLanguageCode(context) == 'en' ||  getLanguageCode(context) == 'fr' ? ui.TextDirection.ltr : ui.TextDirection.rtl,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ResponsiveWidget(
                              localWidthRatio: constraints.maxWidth > 1280 ? ratioWidthComponentLogin : 1,
                              startPadding: 24,
                              endPadding: 24,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DefaultText(
                                    text: AppLocalizations.of(context)!.translate('welcomeBack'),
                                    isTextTheme: true,
                                    themeStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                        fontFamily: AppFontStyle.appFontFamily.readex,
                                        fontSize: getLanguageCode(context) == 'en' ? AppFontStyle.appFontSize.setFontSize(context, webFontSize: 32, mobileFontSize: 30.sp) : AppFontStyle.appFontSize.setFontSize(context, webFontSize: 44, mobileFontSize: 42.sp),
                                        height: 1.2,
                                        fontWeight: FontWeight.w500
                                    ),
                                    align: TextAlign.start,
                                  ),
                                  getLanguageCode(context) == 'en' ? const SizedBox(height: 14,) : const SizedBox(height: 10,),

                                  (loginCubit?.loginType == AppConstants.googleString ||
                                      loginCubit?.loginType == AppConstants.appleString) &&
                                      loginCubit?.modifyDataFromPassword ==
                                          false
                                      ? PreviousSignSocialWidget(
                                    state: state,
                                    emailType: loginCubit?.loginType ?? "",
                                    loginCubit: loginCubit!,
                                    phoneText: phoneController.text,
                                  ) :
                                  loginCubit?.loginType ==
                                      AppConstants.normalString &&
                                      loginCubit?.modifyDataFromPassword ==
                                          false
                                  // state is ValidateEmailSuccess &&  emailType == AppConstants.normalString &&loginCubit?.modifyDataFromPassword == false
                                      ? PasswordLoginWidget(
                                    loginCubit: loginCubit!,
                                    state: state,
                                    formKey: formKey,
                                    passwordController: passwordController,
                                    passwordFocusNode: passwordFocusNode,
                                    phoneOrEmail: phoneOrEmail,
                                    rememberMeChecker: rememberMeChecker,
                                  ):loginCubit?.loginType == AppConstants.normalString ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const HaveAccountWidget(),
                                      const SizedBox(height: 44),
                                      loginCubit?.validateEmailEntity?.data == null || loginCubit?.modifyDataFromPassword == true ? EmailLoginWidget(
                                        phoneOrEmail: phoneController,
                                        formKey: formKey,
                                        state: state,
                                        loginCubit: loginCubit!,
                                        emailFocusNode: emailFocusNode,
                                        // countriesList: countries,
                                      ) : loginCubit?.loginType ==
                                          AppConstants.normalString
                                          ? PasswordLoginWidget(
                                        loginCubit: loginCubit!,
                                        state: state,
                                        formKey: formKey,
                                        passwordController: passwordController,
                                        passwordFocusNode: passwordFocusNode,
                                        phoneOrEmail: phoneOrEmail,
                                        rememberMeChecker: rememberMeChecker,
                                      ) : loginCubit?.loginType == null
                                          ? EmailLoginWidget(
                                        phoneOrEmail: phoneController,
                                        formKey: formKey,
                                        state: state,
                                        loginCubit: loginCubit!,
                                        emailFocusNode: emailFocusNode,
                                        // countriesList: countries,
                                      )
                                          : const SizedBox(),
                                      const SizedBox(height: 20),
                                      Center(
                                        child: DefaultText(
                                            text: AppLocalizations.of(context)!
                                                .translate('or'),
                                            isTextTheme: true,
                                            themeStyle: Theme
                                                .of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: brushIcon,
                                              fontFamily: 'DXRound',
                                            )
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      SocialButtonWidget(
                                        loginCubit: loginCubit!,
                                        state: state,
                                      ),
                                    ],
                                  ) : PreviousSignSocialWidget(
                                    state: state,
                                    emailType: loginCubit?.loginType ?? "",
                                    loginCubit: loginCubit!,
                                    phoneText: phoneController.text,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      );
    });
  }
////////////////////////////////////////////////////////////////////////////////
  getListenerForGoogle(LoginCubit loginCubit, LoginState state) {
    if (state is LoginWithGoogleSuccess) {
      CacheHelper.saveData(key: Constants.isLoggedFromGoogle.toString(), value: true);
      Navigator.pop(context);
      goHome();
      loginCubit.isLoading = false;
    } else if (state is LoginWithGoogleError) {
      loginCubit.validateEmailNormal(loginCubit.credGoogleWeb!.user!.email!);
    } else if (state is ValidateEmailError) {
      if (loginCubit.socialLogin == 'Google') {
        loginCubit.signInWithGoogleWeb(false);
      } else if (loginCubit.socialLogin == 'apple') {
        // loginCubit.signUpWithApple();
        CacheHelper.saveData(
          key: Constants.appleToken.toString(),
          value: '${loginCubit.idToken}'
        );
        context.go(Routes.verifyPhoneNumber);
        CacheHelper.saveObjectToPrefs(
          key: Constants.verifyPhoneNumberArguments.toString(),
          object: ArgumentsVerifyPhoneNumber(
            email: "${FirebaseAuth.instance.currentUser?.email}",
            name: "${FirebaseAuth.instance.currentUser?.displayName}",
            token: loginCubit.idToken,
            isGoogle: false,
            isApple: true,
            isFacebook: false
          )
        );
      }
    }else if (state is SignInWithGoogleWebSuccess) {
      CacheHelper.saveData(key: Constants.tokenGoogle.toString(), value: kIsWeb
        ?'${loginCubit.credGoogleWeb?.credential?.accessToken}'
        :'${googleAuth?.accessToken}'
      );
      context.go(Routes.verifyPhoneNumber);
      CacheHelper.saveObjectToPrefs(
        key: Constants.verifyPhoneNumberArguments.toString(),
        object: ArgumentsVerifyPhoneNumber(
          email: "${FirebaseAuth.instance.currentUser?.email}",
          name: "${FirebaseAuth.instance.currentUser?.displayName}",
          token: kIsWeb ? '${loginCubit.credGoogleWeb?.credential?.accessToken}' : '${googleAuth?.accessToken}',
          isGoogle: true,
          isApple: false,
          isFacebook: false
        )
      );
    }
  }
////////////////////////////////////////////////////////////////////////////////
  getListenerForApple(LoginCubit loginCubit, LoginState state) {
    if (state is SignInAppleSuccessFirebase) {
      loginCubit.loginWithApple(token: loginCubit.idToken!);
      CacheHelper.saveData(key: Constants.appleToken.toString(), value: '${loginCubit.idToken}');
      context.go(Routes.verifyPhoneNumber);
      CacheHelper.saveObjectToPrefs(
        key: Constants.verifyPhoneNumberArguments.toString(),
        object: ArgumentsVerifyPhoneNumber(
          email: "${FirebaseAuth.instance.currentUser?.email}",
          name: "${FirebaseAuth.instance.currentUser?.displayName}",
          token: loginCubit.idToken,
          isGoogle: false,
          isApple: true,
          isFacebook: false
        )
      );
    } else if (state is SignInAppleErrorFirebase) {
      showAlertDialog(
          context: context,
          isSuccess: false,
          title: AppLocalizations.of(context)!.translate('signUpFailed'),
          textColor: Colors.black
      );
    } else if (state is LoginWithAppleSuccess) {
      CacheHelper.saveData(key: Constants.isLoggedFromApple.toString(), value: true);
    } else if (state is LoginWithAppleError) {
      loginCubit.validateEmailNormal(loginCubit.appleEmail!);
    }
  }
////////////////////////////////////////////////////////////////////////////////
  getListenerForNormalDesign(LoginCubit loginCubit, LoginState state) {
    if (state is LoginSuccess) {
      CacheHelper.saveData(key: Constants.isLoggedFromGoogle.toString(), value: false);
      CacheHelper.saveData(key: Constants.isLoggedFromApple.toString(), value: false);
    } else if (state is LoginError) {
      isLoadingLogin = false;
    }
  }
////////////////////////////////////////////////////////////////////////////////
  void goHome() {
    if (CacheHelper.getData(key: Constants.appUrlIfNotLoggedIn.toString()) == '' ||
        CacheHelper.getData(key: Constants.appUrlIfNotLoggedIn.toString()) == null) {
      // Router.neglect(context, () {context.go(Routes.homePage);});
    } else {
      Router.neglect(context, () {
        context.go(CacheHelper.getData(key: Constants.appUrlIfNotLoggedIn.toString()));
      });
    }
  }
////////////////////////////////////////////////////////////////////////////////
  getListenerForValidate(LoginState state){
    if (state is ValidateEmailSuccess) {
      if(state.validateEmailEntity?.data?.customerStatus == null){
        loginCubit?.loginType = loginCubit?.validateEmailEntity?.data?.type ?? CacheHelper.getData(key: Constants.emailType.toString());
        phoneOrEmail = loginCubit?.socialLogin == AppConstants.googleString
            ? loginCubit!.credGoogleWeb!.user!.email!
            : loginCubit?.socialLogin == AppConstants.appleString
            ? loginCubit!.appleEmail! : phoneController.text;
        _updateImagePath();
      }else{
        Router.neglect(context,()=> context.go(Routes.verifyCodeSocial));
        CacheHelper.saveObjectToPrefs(
          key: Constants.verifyCodeSocialArguments.toString(),
          object: ArgumentsResetPasswordVerifyCode(
            mobileID: state.validateEmailEntity?.data!.customerStatus?.mobileId?.toInt(),
            isFromGoogle: true,
            isFromFacebook: false,
            isApple: false
          )
        );
        CacheHelper.saveObjectToPrefs(
          key: Constants.verifyCodeScreenArguments.toString(),
          object: ArgumentsVerifyCodeScreen(
            mobileId: state.validateEmailEntity?.data!.customerStatus?.mobileId?.toInt(),
            fromPage: AppConstants.verifySocialString,
          )
        );
      }
    }
  }
}
