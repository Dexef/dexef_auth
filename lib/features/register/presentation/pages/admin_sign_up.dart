import 'dart:developer';
import 'package:auth_dexef/core/rest/app_constants.dart';
import 'package:auth_dexef/features/login/presentation/cubit/login_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../../../../core/size_widgets/app_screen_size.dart';
import '../../../../../core/size_widgets/responsive_widget.dart';
import '../../../../../core/size_widgets/app_font_style.dart';
import '../../../../core/rest/app_localizations.dart';
import '../../../../core/rest/arguments.dart';
import '../../../../core/rest/cash_helper.dart';
import '../../../../core/rest/constants.dart';
import '../../../../core/rest/firebase_auth.dart';
import '../../../../core/rest/methods.dart';
import '../../../../core/rest/regex.dart';
import '../../../../core/rest/routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/dialog/alert_dialog.dart';
import '../../../../core/widgets/login_widgets/google_apple_button_widget.dart';
import '../../../../core/widgets/public/custom_round_button.dart';
import '../../../../core/widgets/public/custom_text_field.dart';
import '../../../../core/widgets/public/default_login_screen.dart';
import '../../../../core/widgets/public/default_text.dart';
import '../../../../core/widgets/public/password_text_field.dart';
import '../../../../core/widgets/register_widget/phone_widget.dart';
import '../../data/model/SignUpModel.dart';
import '../cubit/register_cubit.dart';

import 'package:intl_phone_field/countries.dart';
import 'dart:ui' as ui;

import '../../../../core/rest/sign_up_errors_values.dart';
import '../cubit/register_states.dart';

class AdminSignUp extends StatefulWidget {
  const AdminSignUp({Key? key}) : super(key: key);

  @override
  State<AdminSignUp> createState() => _AdminSignUpState();
}

class _AdminSignUpState extends State<AdminSignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneOrEmailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String? phoneNumber;
  String dialCode = "20";
  final formKey = GlobalKey<FormState>();
  String? registrationIP = 'sa';
  late RegisterCubit registerCubit;
  bool visibleContainer = false;
  dynamic location;
  bool isTap = false;
  double opacity = 0.0;
  String initialCountry = 'EG';
  String countryCode = "20";
  bool phoneValidationChecker = false;
  String currentLang = getLanguage();
  int maxNameLength = 30;
  UserCredential? credFaceWeb;
  Orientation? orientation;
  Widget? selectPage;
  BoxConstraints? constrains;
  int maxLength = 10;
  bool isArabic = CacheHelper.getData(key: Constants.isArabic.toString()) ?? true;
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

///////////////////////////////////////////////////////////////////////////// location for animation
  getLocation() {
    if (visibleContainer) {
      location = const Offset(1, 0);
    } else {
      location = const Offset(0, 0);
    }
    return location;
  }

////////////////////////////////////////////////////////////////////////////// init state
  @override
  void initState() {
    // signUpCubit?.lookupUserCountry();
    //selectPage = selectPage(context,);
    Future.delayed(const Duration(milliseconds: 5), () {
      setState(() {
        visibleContainer = true;
        opacity = 1.0;
      });
    });
    Future.delayed(const Duration(milliseconds: 350), () {
      setState(() {
        isTap = true;
      });
    });
    // getLanguage();
    super.initState();
  }

////////////////////////////////////////////////////////////////////////////// build
  Map<String, String> registerErrors = {};
  PhoneNumber? number;
  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    return BlocConsumer<RegisterCubit, RegisterStates>(
      builder: (context, state) {
        registerCubit = RegisterCubit.instance;
        number  = PhoneNumber(isoCode: LoginCubit.instance.userCountryCode ??'EG');
        return DefaultLoginScreen(
          isLoading: false,
          body: Directionality(
            textDirection: ui.TextDirection.ltr,
            child: _buildRow(context, state)
          ),
        );
      },
      listener: (context, state) async {
        getListenerForGoogleSignup(registerCubit, state);
        getListenerForNormalSignup(registerCubit, state);
        getListenerForApple(registerCubit, state);
      },
    );
  }

////////////////////////////////////////////////////////////////////////////////
  Widget _buildRow(BuildContext context, RegisterStates state) => LayoutBuilder(
    builder: (context, constraints) {
      return AbsorbPointer(
        absorbing: false,
        child: Row(
          children: [
            Container(
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
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ResponsiveWidget(
                                localWidthRatio: ratioBackgroundWidth,
                                child: getImage(path: "images/backgroundCloseShift.svg", isSvg: true, height: MediaQuery.of(context).size.height * ratioBackgroundHeight,)
                            ),
                            ResponsiveWidget(
                                localWidthRatio: ratioImageWidth,
                                child: getImage(path: "images/backgroundSignUp.png", height: MediaQuery.of(context).size.height * ratioImageHeight)
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
                          text: "Dexef Cloud",
                          align: TextAlign.center,
                          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 32, mobileFontSize: 30.sp),
                          fontWeight: FontWeight.w400,
                          fontColor: brush,
                          fontFamily: AppFontStyle.appFontFamily.readex,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        DefaultText(
                          text:
                          "Everything You Need to Work Remotely and Productivity",
                          align: TextAlign.center,
                          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 16, mobileFontSize: 14.sp),
                          fontWeight: FontWeight.w400,
                          fontColor: brush,
                          fontFamily: AppFontStyle.appFontFamily.readex,
                        ),
                      ],
                    ),
                  ),
                  ResponsiveWidget(
                      localWidthRatio: ratioLogoMiniWidth,
                      fixedHeight: MediaQuery.of(context).size.height * ratioLogoMiniHeight,
                      child: getImage(path: "images/dexef_logo_body.svg", isSvg: true, fit: BoxFit.contain)
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height *
                        ratioHeightUnderLogo,
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: AppScreenSize.appWidgetSize.getLoginRightPanelWidth(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ResponsiveWidget(
                    endPadding: constraints.maxWidth > 1280 ? 50 : 24,
                    topPadding: 22.h,
                    // bottomPadding: 16,
                    localWidthRatio: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Transform.scale(
                          scale: .6,
                          child: CupertinoSwitch(
                            value: CacheHelper.getData(key: Constants.isArabic.toString()) ?? isArabic,
                            activeColor: success,
                            trackColor: brushLines,
                            onChanged: (bool isChange) {
                              setState(() {
                                CacheHelper.saveData(key: Constants.isArabic.toString(), value: isChange);
                                if(CacheHelper.getData(key: Constants.isArabic.toString())){
                                  context.locale = const Locale('ar');
                                  CacheHelper.saveData(key: Constants.appLanguage.toString(), value: 'ar');
                                }else{
                                  context.locale = const Locale('en');
                                  CacheHelper.saveData(key: Constants.appLanguage.toString(), value: 'en');
                                }
                                if (CacheHelper.getData(key: Constants.isArabic.toString())) {
                                  currentLang = "AR";
                                } else {
                                  currentLang = "EN";
                                }
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        DefaultText(
                          text: currentLang,
                          isTextTheme: true,
                          themeStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color:brush,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppFontStyle.appFontFamily.readex,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Directionality(
                          textDirection: context.locale.languageCode == 'en' ? ui.TextDirection.ltr : ui.TextDirection.rtl,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ResponsiveWidget(
                                localWidthRatio: MediaQuery.of(context).size.width > 1280 ? ratioWidthComponentLogin : 1,
                                startPadding: MediaQuery.of(context).size.width > 1280 ? 0 : 24,
                                endPadding: MediaQuery.of(context).size.width > 1280 ? 0 : 24,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10,),
                                    DefaultText(
                                      text: AppLocalizations.of(context)!.translate('welcome'),
                                      align: TextAlign.start,
                                      isTextTheme: true,
                                      themeStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                        color:brush,
                                        fontFamily:  context.locale.languageCode == 'en' ? AppFontStyle.appFontFamily.readex : 'Tharwat',
                                        height: 1.2.h,
                                        fontSize: context.locale.languageCode == 'en'
                                            ? AppFontStyle.appFontSize.setFontSize(context, webFontSize: 32, mobileFontSize: 30.sp)
                                            : AppFontStyle.appFontSize.setFontSize(context, webFontSize: 44, mobileFontSize: 42.sp),
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    context.locale.languageCode == 'en' ? const SizedBox(height: 16,) :const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        DefaultText(
                                            text: '${AppLocalizations.of(context)!.translate('haveAccount')}  ',
                                            fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 14, mobileFontSize: 12.sp),
                                            fontColor: brushLines,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: AppFontStyle.appFontFamily.readex),
                                        InkWell(
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,  // Removes the background highlight color
                                          splashColor: Colors.transparent,     // Removes the splash color
                                          onTap: () => Router.neglect(context, () => context.go(Routes.loginScreen)),
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: DefaultText(
                                              text: ' ${AppLocalizations.of(context)!.translate('signIn')}',
                                              fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 14, mobileFontSize: 12.sp),
                                              fontColor: primary,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: AppFontStyle.appFontFamily.readex),
                                          ),
                                        ),
                                      ],
                                    ),
                                    context.locale.languageCode == 'en' ?  const SizedBox(
                                      height: 24,
                                    ):const SizedBox(height: 36,),
                                    Focus(
                                      focusNode: nameFocusNode,
                                      onKey: (FocusNode node, RawKeyEvent event) {
                                        if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.tab) {
                                          FocusScope.of(context).requestFocus(phoneFocusNode);
                                          return KeyEventResult.handled;
                                        }
                                        return KeyEventResult.ignored;
                                      },
                                      child: CustomTextFormField(
                                        controller: nameController,
                                        autoFocus: kIsWeb ? true : false,
                                        fillColor: Colors.white,
                                        label: AppLocalizations.of(context)!.translate('name'),
                                        maxLines: 1,
                                        autofillHints: const [AutofillHints.name],
                                        onFieldSubmitted: (value) {
                                          if (formKey.currentState!.validate()) {
                                            if (phoneNumber != null) {
                                              String phoneNum = "";
                                              if (countryCode[countryCode.length - 1] == "0" && phoneController.text[0] == "0") {
                                                phoneNum = countryCode + phoneController.text.substring(1);
                                              } else {
                                                phoneNum =
                                                    countryCode + phoneController.text;
                                              }
                                              registerCubit.registerNormal(
                                                email: phoneOrEmailController.text,
                                                name: nameController.text,
                                                phoneNumber: phoneNum,
                                                password: passwordController.text,
                                                countryCode: countryCode,
                                              );
                                            }
                                          }
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return AppLocalizations.of(context)!
                                                .translate('required');
                                          } else if (value.length > maxNameLength) {
                                            return AppLocalizations.of(context)!
                                                .translate('nameValidation');
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20,),
                                    PhoneWidget(
                                      initialNumber: number,
                                      choosePhoneCode: phoneController,
                                      cubit: registerCubit,
                                      states: state,
                                      phoneFocusNode: phoneFocusNode,
                                      maxLength: maxLength,
                                      validator: (value) {
                                        registerCubit.errorMessage = '';
                                        if (value!.isEmpty) {
                                          return AppLocalizations.of(context)!.translate('required');
                                        } else if (!phoneNumberRegex1.hasMatch(value)) {
                                          return AppLocalizations.of(context)!.translate('invalidPhoneNumber');
                                        }
                                        return null;
                                      },
                                      onInputChanged: (phone) {
                                        phoneNumber = phone.phoneNumber;
                                        countryCode = phone.dialCode.toString();
                                        setState(() {
                                          registerCubit.errorMessage = '';
                                          if (phoneController.text.startsWith('0')) {
                                            phoneController.value = TextEditingValue(
                                              text: phoneController.text.substring(1),
                                              selection: TextSelection.fromPosition(
                                                TextPosition(offset: phoneController.text.length - 1),
                                              ),
                                            );
                                          }
                                          maxLength = countries.firstWhere((element) => element.dialCode.toString() == phone.dialCode?.substring(1).toString()).maxLength;
                                        });
                                        LoginCubit.instance.userCountryCode = phone.isoCode;
                                      },
                                      onFieldSubmitted: (value){
                                        registerErrors = {};
                                        registerCubit.errorMessage = '';
                                        if (formKey.currentState!.validate()) {
                                          if (phoneNumber != null) {
                                            String phoneNum = "";
                                            if (countryCode[countryCode.length - 1] == "0" &&
                                                phoneController.text[0] == "0") {
                                              phoneNum = countryCode + phoneController.text.substring(1);
                                            } else {
                                              phoneNum = countryCode + phoneController.text;
                                            }
                                            registerCubit.registerNormal(
                                              email: phoneOrEmailController.text,
                                              name: nameController.text,
                                              phoneNumber: phoneNum,
                                              password: passwordController.text,
                                              countryCode: countryCode,
                                            );
                                          }
                                        }
                                      },
                                    ),
                                    DefaultText(
                                      text: state is RegisterNormalError && registerCubit.hasPhoneError(state.message) ? state.message : '',
                                      themeStyle: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.red),
                                      isTextTheme: true,
                                    ),
                                    const SizedBox(height: 10),
                                    CustomTextFormField(
                                      controller: phoneOrEmailController,
                                      focusNode: emailFocusNode,
                                      fillColor: Colors.white,
                                      maxLines: 1,
                                      errorState:  state is RegisterNormalError && registerCubit.hasEmailError(state.message),
                                      onChange: (string){
                                        setState(() {
                                          registerCubit.errorMessage = '';
                                        });
                                      },
                                      onFieldSubmitted: (value) {
                                        if (formKey.currentState!.validate()) {
                                          if (phoneNumber != null) {
                                            String phoneNum = "";
                                            if (countryCode[countryCode.length - 1] == "0" && phoneController.text[0] == "0") {
                                              phoneNum = countryCode + phoneController.text.substring(1);
                                            } else {
                                              phoneNum = countryCode + phoneController.text;
                                            }
                                            registerCubit.registerNormal(
                                              email: phoneOrEmailController.text,
                                              name: nameController.text,
                                              phoneNumber: phoneNum,
                                              password: passwordController.text,
                                              countryCode: countryCode,
                                            );
                                          }
                                        }
                                      },
                                      autoFocus:  kIsWeb ? true : false,
                                      label: AppLocalizations.of(context)!.translate('emailAddress'),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return AppLocalizations.of(context)!.translate('required');
                                        } else if (!emailRegexNew.hasMatch(value)) {
                                          return AppLocalizations.of(context)!.translate('invalidEmail');
                                        }
                                        return null;
                                      },
                                    ),
                                    DefaultText(
                                      text: state is RegisterNormalError && registerCubit.hasEmailError(state.message) ? state.message : '',
                                      isTextTheme: true,
                                      themeStyle: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.red)
                                    ),
                                    const SizedBox(height: 10,),
                                    PasswordTextFormField(
                                      controller: passwordController,
                                      focusNode: passwordFocusNode,
                                      onFieldSubmitted: (value) {
                                        if (formKey.currentState!.validate()) {
                                          if (phoneNumber != null) {
                                            String phoneNum = "";
                                            if (countryCode[countryCode.length - 1] == "0" && phoneController.text[0] == "0") {
                                              phoneNum = countryCode + phoneController.text.substring(1);
                                            } else {
                                              phoneNum = countryCode + phoneController.text;
                                            }
                                            registerCubit.registerNormal(
                                              email: phoneOrEmailController.text,
                                              name: nameController.text,
                                              phoneNumber: phoneNum,
                                              password: passwordController.text,
                                              countryCode: countryCode,
                                            );
                                          }
                                        }
                                      },
                                      label: AppLocalizations.of(context)!.translate('password'),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return AppLocalizations.of(context)!.translate('required');
                                        } else if (!passwordRegex.hasMatch(value)) {
                                          return AppLocalizations.of(context)!.translate('passwordValidation');
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10,),
                                    PasswordTextFormField(
                                      controller: confirmPasswordController,
                                      label: AppLocalizations.of(context)!.translate('confirmPassword'),
                                      focusNode: confirmPasswordFocusNode,
                                      onFieldSubmitted: (value) {
                                        if (formKey.currentState!.validate()) {
                                          if (phoneNumber != null) {
                                            String phoneNum = "";
                                            if (countryCode[countryCode.length - 1] == "0" && phoneController.text[0] == "0") {
                                              phoneNum = countryCode + phoneController.text.substring(1);
                                            } else {
                                              phoneNum = countryCode + phoneController.text;
                                            }
                                            registerCubit.registerNormal(
                                              email: phoneOrEmailController.text,
                                              name: nameController.text,
                                              phoneNumber: phoneNum,
                                              password: passwordController.text,
                                              countryCode: countryCode,
                                            );
                                          }
                                        }
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return AppLocalizations.of(context)!.translate('required');
                                        } else if (value != passwordController.text) {
                                          return AppLocalizations.of(context)!.translate('passwordNotSimilar');
                                        }
                                        return null;
                                      },
                                    ),
                                    DefaultText(
                                      text: state is RegisterNormalError && registerCubit.hasPhoneError(state.message) ? state.message : '',
                                      themeStyle: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.red),
                                      isTextTheme: true,
                                    ),
                                    const SizedBox(height: 30,),
                                    ResponsiveWidget(
                                      localWidthRatio: 1,
                                      fixedHeight: 48,
                                      child: CustomRoundedButton(
                                        isLoading: state is RegisterNormalLoading,
                                        title: AppLocalizations.of(context)!.translate('signUp'),
                                        onPressed: () {
                                          if (formKey.currentState!.validate()) {
                                            if (phoneNumber != null) {
                                              String phoneNum = "";
                                              if (countryCode[
                                              countryCode.length - 1] == "0" && phoneController.text[0] == "0") {
                                                phoneNum = countryCode + phoneController.text.substring(1);
                                              } else {
                                                phoneNum = countryCode + phoneController.text;
                                              }
                                              registerCubit.registerNormal(
                                                email: phoneOrEmailController.text,
                                                name: nameController.text,
                                                phoneNumber: phoneNum,
                                                password: passwordController.text,
                                                countryCode: countryCode,
                                              );
                                            }
                                          }
                                        }
                                      ),
                                    ),
                                    const SizedBox(height: 20,),
                                    Center(
                                      child: DefaultText(
                                        text: AppLocalizations.of(context)!.translate('or'),
                                        fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 14, mobileFontSize: 12.sp),
                                        fontColor: brushIcon,
                                        fontFamily: AppFontStyle.appFontFamily.readex,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SocialButtonWidget(
                                      googleButtonColor : Colors.white,
                                      appleButtonColor: Colors.white,
                                      googleButtonTap: () async {
                                        if (kIsWeb) {
                                          await registerCubit.signUpWithGoogleWeb();
                                        } else {
                                          await registerCubit.signUpWithGoogle(context);
                                        }
                                      },
                                      appleButtonTap: () async {
                                        registerCubit.signUpWithApple();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // Gap(20.h),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      );
    }
  );
////////////////////////////////////////////////////////////////////////////////
  getListenerForGoogleSignup(RegisterCubit signUpCubit, RegisterStates state) {
    if (state is SignUpGoogleSuccess || state is SignUpGoogleWebSuccess) {
      signUpCubit.validateEmailNormal(signUpCubit.credGoogleWeb!.user!.email!);
      log('token = ${CacheHelper.getData(key: Constants.tokenGoogle.toString())}');
    } else if (state is SignUpGoogleError || state is SignUpGoogleWebError || state is CanceledSignUpByUserWebGoogle) {
      signUpCubit.signOut();
    }
  }
////////////////////////////////////////////////////////////////////////////////
  getListenerForNormalSignup(RegisterCubit registerCubit, RegisterStates state) {
    if (state is RegisterNormalSuccess) {
      Router.neglect(context, () => context.go(Routes.loginScreen));
    } else if (state is RegisterNormalError) {
      showAlertDialog(
          context: context,
          isSuccess: false,
          title: AppLocalizations.of(context)!.translate('signUpFailed'),
          subTitle: getErrorMessage(state.message!),
          textColor: Colors.black);
    } else if (state is ValidateEmailSuccess){
      if(state.validateEmailEntity?.data?.customerStatus != null){
        Router.neglect(context, () {context.go(Routes.verifyCodeSocial);});
        CacheHelper.saveObjectToPrefs(
          key: Constants.verifyCodeSocialArguments.toString(),
          object: ArgumentsResetPasswordVerifyCode(
              mobileID: state.validateEmailEntity?.data!.customerStatus?.mobileId?.toInt(),
              isFromGoogle: true,
              isFromFacebook: false,
              isApple: false
          ));
        CacheHelper.saveObjectToPrefs(key: Constants.verifyCodeScreenArguments.toString(), object: ArgumentsVerifyCodeScreen(
          mobileId: state.validateEmailEntity?.data!.customerStatus?.mobileId?.toInt(),
          fromPage: 'verifySocial',
        ));
      }else{
        context.go(Routes.loginScreen);
        if(registerCubit.validateEmailEntity?.data?.type == AppConstants.normalString){
          CacheHelper.saveData(key: Constants.emailType.toString(), value: AppConstants.normalString);
          CacheHelper.saveData(key: Constants.emailOrPhone.toString(), value: registerCubit.validateEmailEntity?.data?.email);
        }else if(registerCubit.validateEmailEntity?.data?.type == AppConstants.googleString){
          CacheHelper.saveData(key: Constants.emailType.toString(), value: AppConstants.googleString);
        }else if(registerCubit.validateEmailEntity?.data?.type == AppConstants.appleString){
          CacheHelper.saveData(key: Constants.emailType.toString(), value: AppConstants.appleString);
        }
      }
    }
  }
////////////////////////////////////////////////////////////////////////////////
  getListenerForApple(RegisterCubit registerCubit, RegisterStates state){
    if (state is SignUpAppleSuccess) {
      registerCubit.validateEmailNormal(registerCubit.appleCredential!.user!.email!);
    } else if (state is ValidateEmailError) {
     if(registerCubit.validateEmailEntity!.data!.type == AppConstants.appleString){
       CacheHelper.saveData(
           key: Constants.appleToken.toString(),
           value: '${registerCubit.idToken}'
       );
       context.go(Routes.verifyPhoneNumber);
       CacheHelper.saveObjectToPrefs(
           key: Constants.verifyPhoneNumberArguments.toString(),
           object: ArgumentsVerifyPhoneNumber(
               email: "${FirebaseAuth.instance.currentUser?.email}",
               name: "${FirebaseAuth.instance.currentUser?.displayName}",
               token: registerCubit.idToken,
               isGoogle: false,
               isApple: true,
               isFacebook: false)
       );
     }else if(registerCubit.validateEmailEntity!.data!.type == AppConstants.googleString){
       CacheHelper.saveData(
           key: Constants.tokenGoogle.toString(),
           value: kIsWeb
               ? '${registerCubit.credGoogleWeb?.credential?.accessToken}'
               : '${googleAuth?.accessToken}');
       context.go(Routes.verifyPhoneNumber);
       CacheHelper.saveObjectToPrefs(
           key: Constants.verifyPhoneNumberArguments.toString(),
           object: ArgumentsVerifyPhoneNumber(
               email: "${FirebaseAuth.instance.currentUser?.email}",
               name: "${FirebaseAuth.instance.currentUser?.displayName}",
               token: kIsWeb ? '${registerCubit.credGoogleWeb?.credential?.accessToken}' : '${googleAuth?.accessToken}',
               isGoogle: true,
               isApple: false,
               isFacebook: false));
     }
    }else if(state is SignUpAppleError){
      showAlertDialog(
          context: context,
          isSuccess: false,
          title: AppLocalizations.of(context)!.translate('signUpFailed'),
          textColor: Colors.black
      );
    }
  }
}

