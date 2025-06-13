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
  late LoginCubit loginCubit;
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
    phoneOrEmail = LoginCubit.instance.loginType == AppConstants.googleString
      ? LoginCubit.instance.credGoogleWeb!.user!.email! : LoginCubit.instance.loginType == AppConstants.appleString
      ? LoginCubit.instance.appleCredential?.user?.email!
      : phoneController.text;
    checkRememberMe();
    _updateImagePath();
    super.initState();
  }
////////////////////////////////////////////////////////////////////////////////
  void _updateImagePath() {
    imagePath = LoginCubit.instance.loginType == null
      ? 'images/login_first.png'
      : LoginCubit.instance.loginType == AppConstants.normalString
      ? 'images/login_password.png'
      : 'images/login_email.png';
  }
////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        getListenerForValidate(LoginCubit.instance,state);
        getListenerForGoogle(LoginCubit.instance, state);
        getListenerForNormalDesign(LoginCubit.instance, state);
        getListenerForApple(LoginCubit.instance, state);
      },
      builder: (context, state) {
        loginCubit = LoginCubit.instance;
        debugPrint("emailType ${loginCubit.loginType}");
        return AbsorbPointer(
          absorbing: loginCubit.isLoading,
          child: DefaultLoginScreen(
            isLoading: loginCubit.isLoading,
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
                                  Visibility(
                                    visible: loginCubit.loginType == AppConstants.googleString
                                        || loginCubit.loginType == AppConstants.appleString,
                                    child: PreviousSignSocialWidget(
                                      state: state,
                                      emailType: loginCubit.loginType ?? "",
                                      loginCubit: loginCubit,
                                      phoneText: phoneController.text,
                                    ),
                                  ),
                                  Visibility(
                                    visible: loginCubit.loginType == AppConstants.normalString && loginCubit.writePassword == true,
                                    child: PasswordLoginWidget(
                                      loginCubit: loginCubit,
                                      state: state,
                                      formKey: formKey,
                                      passwordController: passwordController,
                                      passwordFocusNode: passwordFocusNode,
                                      phoneOrEmail: phoneOrEmail,
                                      rememberMeChecker: rememberMeChecker,
                                    ),
                                  ),
                                  Visibility(
                                    visible: loginCubit.loginType == null,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const HaveAccountWidget(),
                                        const SizedBox(height: 44),
                                        loginCubit.writePassword == false ? EmailLoginWidget(
                                          phoneOrEmail: phoneController,
                                          formKey: formKey,
                                          state: state,
                                          loginCubit: loginCubit,
                                          emailFocusNode: emailFocusNode,
                                        ): PasswordLoginWidget(
                                          loginCubit: loginCubit,
                                          state: state,
                                          formKey: formKey,
                                          passwordController: passwordController,
                                          passwordFocusNode: passwordFocusNode,
                                          phoneOrEmail: phoneOrEmail,
                                          rememberMeChecker: rememberMeChecker,
                                        ),
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
                                    ),
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
      if (loginCubit.loginType == AppConstants.googleString) {
        loginCubit.signInWithGoogleWeb(false);
      } else if (loginCubit.loginType == AppConstants.appleString) {
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
      loginCubit.validateEmailNormal(loginCubit.appleCredential!.user!.email!);
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
  getListenerForValidate(LoginCubit loginCubit, LoginState state){
    if (state is ValidateEmailSuccess) {
      if(state.validateEmailEntity?.data?.customerStatus == null){
        loginCubit.loginType = loginCubit.validateEmailEntity?.data?.type ?? CacheHelper.getData(key: Constants.emailType.toString());
        phoneOrEmail = loginCubit.loginType == AppConstants.googleString
            ? loginCubit.credGoogleWeb!.user!.email!
            : loginCubit.loginType == AppConstants.appleString
            ? loginCubit.appleCredential!.user!.email : phoneController.text;
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
