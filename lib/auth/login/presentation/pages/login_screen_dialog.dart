import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:auth_dexef/locator.dart' as di;
import 'dart:ui' as ui;
import '../../../../../core/size_widgets/app_screen_size.dart';
import '../../../../../core/size_widgets/responsive_widget.dart';
import '../../../../../core/size_widgets/app_font_style.dart';
import '../../../../../main.dart';
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
import '../../../../core/widgets/login_widgets/password_login_Widget.dart';
import '../../../../core/widgets/login_widgets/previous_sign_social_widget.dart';
import '../../../../core/widgets/login_widgets/switch_language_widget.dart';
import '../../../../core/widgets/public/default_text.dart';
import '../../../../core/widgets/public/network_failed.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class LoginScreenDialog extends StatefulWidget {
  const LoginScreenDialog({super.key});
  @override
  State<LoginScreenDialog> createState() => _LoginScreenDialogState();
}

class _LoginScreenDialogState extends State<LoginScreenDialog> {
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
    // emailType = loginCubit?.validateEmailEntity?.data?.type ?? CacheHelper.getData(key: Constants.emailType.toString());
    phoneOrEmail =
    loginCubit?.socialLogin == 'Google' ? loginCubit!.credGoogleWeb!.user!
        .email! : loginCubit?.socialLogin == 'apple' ? loginCubit!.appleEmail! : phoneController.text;
    checkRememberMe();
    _updateImagePath();
    super.initState();
  }
////////////////////////////////////////////////////////////////////////////////
  void _updateImagePath() {
    imagePath = loginCubit?.validateEmailEntity?.data?.type == null
        ? 'images/login_first.png'
        : loginCubit?.validateEmailEntity?.data?.type == 'Normal'
        ? 'images/login_password.png'
        : 'images/login_email.png';
  }

////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.locator<LoginCubit>()..getEmailType()..lookupUserCountry(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is ValidateEmailSuccess) {
            if (state.validateEmailEntity?.data?.customerStatus == null) {
              loginCubit?.emailType = loginCubit?.validateEmailEntity?.data?.type ?? CacheHelper.getData(key: Constants.emailType.toString());
              phoneOrEmail = loginCubit?.socialLogin == AppConstants.googleString
                ? loginCubit!.credGoogleWeb!.user!.email!
                : loginCubit?.socialLogin == AppConstants.appleString
                ? loginCubit!.appleEmail! : phoneController.text;
              _updateImagePath();
            } else {
              Router.neglect(context, () {
                context.go(Routes.verifyCodeSocial);
              });
              CacheHelper.saveObjectToPrefs(
                key: Constants.verifyCodeSocialArguments.toString(),
                object: ArgumentsResetPasswordVerifyCode(
                  mobileID: state.validateEmailEntity?.data!.customerStatus?.mobileId?.toInt(),
                  isFromGoogle: true,
                  isFromFacebook: false,
                  isApple: false
                ));
              CacheHelper.saveObjectToPrefs(
                key: Constants.verifyCodeScreenArguments.toString(),
                object: ArgumentsVerifyCodeScreen(
                  mobileId: state.validateEmailEntity?.data!.customerStatus?.mobileId?.toInt(),
                  fromPage: AppConstants.verifySocialString,
                ));
            }
          }
          getListenerForGoogle(loginCubit!, state);
          getListenerForNormalDesign(loginCubit!, state);
          getListenerForApple(loginCubit!, state);
        },
        builder: (context, state) {
          loginCubit = LoginCubit.get(context);
          debugPrint("emailType ${loginCubit?.emailType}");
          return AbsorbPointer(
            absorbing: state is LoginLoading || state is GettingDialCode || state is ValidateEmailLoading,
            child: Directionality(
              textDirection: currentContext.locale.languageCode == 'en' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
              child: Dialog(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                alignment: Alignment.center,
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                child: state is GetIPForCountryLoading ? const Center(child: CircularProgressIndicator(color: Colors.white,)) : state is GetIPForCountryError || state is GetIPForCountryFailure
                    ? const NetworkFailed() : desktopLogin(state, phoneOrEmail!),
              ),
            ),
          );
        },
      ),
    );
  }
////////////////////////////////////////////////////////////////////////////////
  desktopLogin(LoginState state, String phoneOrEmail) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: Colors.white,
        ),
        width: AppScreenSize.appDesignSize.isWebPlatform(context)? MediaQuery.sizeOf(context).width *.40 : MediaQuery.sizeOf(context).width * .96,
        height: MediaQuery.sizeOf(context).height * .70,
        child: loginCubit?.isLoading == true ? const Center(child: CircularProgressIndicator()):Column(
          children: [
            LanguageSwitchWidget(constraints: constraints, fromDialog:  true,),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Directionality(
                      textDirection: getLanguageCode(context) == 'en' ? ui.TextDirection.ltr : ui.TextDirection.rtl,
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
                                      fontSize: getLanguageCode(context) == 'en' ||  getLanguageCode(context) == 'fr'
                                          ? AppFontStyle.appFontSize.setFontSize(context, webFontSize: 32, mobileFontSize: 30.sp)
                                          : AppFontStyle.appFontSize.setFontSize(context, webFontSize: 44, mobileFontSize: 42.sp),
                                      height: 1.2,
                                      fontWeight: FontWeight.w700),
                                  align: TextAlign.start,
                                ),
                                getLanguageCode(context) == 'en' ? const SizedBox(height: 14,) : const SizedBox(height: 16,),
                                // state is ValidateEmailSuccess && loginCubit?.modifyDataFromPassword == false
                                (loginCubit?.emailType == AppConstants.googleString ||
                                    loginCubit?.emailType == AppConstants.appleString) &&
                                    loginCubit?.modifyDataFromPassword == false
                                    ? PreviousSignSocialWidget(
                                  state: state,
                                  emailType: loginCubit!.emailType,
                                  loginCubit: loginCubit!,
                                  phoneText: phoneController.text,
                                ) :
                                loginCubit?.emailType == AppConstants.normalString && loginCubit?.modifyDataFromPassword == false
                                // state is ValidateEmailSuccess &&  emailType == AppConstants.normalString &&loginCubit?.modifyDataFromPassword == false
                                    ? PasswordLoginWidget(
                                  loginCubit: loginCubit!,
                                  state: state,
                                  formKey: formKey,
                                  passwordController: passwordController,
                                  passwordFocusNode: passwordFocusNode,
                                  phoneOrEmail: phoneOrEmail,
                                  rememberMeChecker: rememberMeChecker,
                                ) : loginCubit?.googleOrAppleLogin == false
                                    ? Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  children: [
                                    const HaveAccountWidget(fromDialog: true,),
                                    const SizedBox(height: 44),
                                    loginCubit?.validateEmailEntity?.data ==
                                        null ||
                                        loginCubit?.modifyDataFromPassword ==
                                            true ? EmailLoginWidget(
                                      phoneOrEmail: phoneController,
                                      formKey: formKey,
                                      state: state,
                                      loginCubit: loginCubit!,
                                      emailFocusNode: emailFocusNode,
                                      // countriesList: countries,
                                    ) : loginCubit?.emailType ==
                                        AppConstants.normalString
                                        ? PasswordLoginWidget(
                                      loginCubit: loginCubit!,
                                      state: state,
                                      formKey: formKey,
                                      passwordController: passwordController,
                                      passwordFocusNode: passwordFocusNode,
                                      phoneOrEmail: phoneOrEmail,
                                      rememberMeChecker: rememberMeChecker,
                                    ) : loginCubit?.emailType == ''
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
                                  emailType: loginCubit!.emailType,
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
            ),
          ],
        ),
      );
    });
  }
////////////////////////////////////////////////////////////////////////////////
  getListenerForGoogle(LoginCubit loginCubit, LoginState state) {
    if (state is LoginWithGoogleSuccess) {
      CacheHelper.saveData(key: Constants.isLoggedFromGoogle.toString(), value: true);
      goHome();
      loginCubit.isLoading = false;
    } else if (state is LoginWithGoogleError) {
      loginCubit.validateEmailNormal(loginCubit.credGoogleWeb!.user!.email!);
    } else if (state is ValidateEmailError) {
      if (loginCubit.socialLogin == 'Google') {
        loginCubit.signUpWithGoogleWeb();
      } else if (loginCubit.socialLogin == 'apple') {
        // loginCubit.signUpWithApple();
        CacheHelper.saveData(
            key: Constants.appleToken.toString(),
            value: '${loginCubit.idToken}'
        );
        Navigator.pop(context);
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
    } else if (state is SignUpFirstGoogleWebSuccess) {
      CacheHelper.saveData(key: Constants.tokenGoogle.toString(), value: kIsWeb
          ? '${loginCubit.credGoogleWeb?.credential?.accessToken}'
          : '${googleAuth?.accessToken}'
      );
      Navigator.pop(context);
      context.go(Routes.verifyPhoneNumber);
      CacheHelper.saveObjectToPrefs(
          key: Constants.verifyPhoneNumberArguments.toString(),
          object: ArgumentsVerifyPhoneNumber(
              email: "${FirebaseAuth.instance.currentUser?.email}",
              name: "${FirebaseAuth.instance.currentUser?.displayName}",
              token: kIsWeb ? '${loginCubit.credGoogleWeb?.credential
                  ?.accessToken}' : '${googleAuth?.accessToken}',
              isGoogle: true,
              isApple: false,
              isFacebook: false)
      );
    }
  }
////////////////////////////////////////////////////////////////////////////////
  getListenerForApple(LoginCubit loginCubit, LoginState state) {
    if (state is SignUpAppleSuccess) {
      loginCubit.appleSignIn(token: loginCubit.idToken!);
      CacheHelper.saveData(key: Constants.appleToken.toString(), value: '${loginCubit.idToken}');
    } else if (state is AppleSignInSuccess) {
      CacheHelper.saveData(key: Constants.isLoggedFromApple.toString(), value: true);
      goHome();
    } else if (state is AppleSignInError) {
      loginCubit.validateEmailNormal(loginCubit.appleEmail!);
    } else if (state is SignUpAppleFirstSuccess) {
      CacheHelper.saveData(key: Constants.appleToken.toString(), value: '${loginCubit.idToken}');
      Navigator.pop(context);
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
    } else if (state is SignUpAppleError) {
      showAlertDialog(
          context: context,
          isSuccess: false,
          title: AppLocalizations.of(context)!.translate('signUpFailed'),
          textColor: Colors.black
      );
    }
  }
////////////////////////////////////////////////////////////////////////////////
  getListenerForNormalDesign(LoginCubit loginCubit, LoginState state) {
    if (state is LoginSuccess) {
      CacheHelper.saveData(key: Constants.isLoggedFromGoogle.toString(), value: false);
      CacheHelper.saveData(key: Constants.isLoggedFromApple.toString(), value: false);
      goHome();
    } else if (state is LoginUnSuccess) {
      isLoadingLogin = false;
    }
  }
////////////////////////////////////////////////////////////////////////////////
  void goHome(){
    bool whenTapBuy = CacheHelper.getData(key: Constants.whenTapBuy.toString()) ?? false;
    if (CacheHelper.getData(key: Constants.appUrlIfNotLoggedIn.toString()) == '' ||
        CacheHelper.getData(key: Constants.appUrlIfNotLoggedIn.toString()) == null) {
      Navigator.pop(context);
      // Router.neglect(context, () {context.go(Routes.homePage);});
    } else {
      Navigator.pop(context);
      // context.read<SearchControllerCustom>().refreshScaffold();
      // if(whenTapBuy){
      //   showDialog(
      //     context: context,
      //     builder: (context) {
      //       return const PaymentDetailsDialog();
      //     });
      // }
      Router.neglect(context, () {
        context.go(CacheHelper.getData(key: Constants.appUrlIfNotLoggedIn.toString()));
      });
    }
  }
}


