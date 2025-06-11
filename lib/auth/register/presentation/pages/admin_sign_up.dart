import 'dart:developer';
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
import 'package:mydexef/main.dart';
import '../../../../../core/class_constants/Routes.dart';
import '../../../../../core/arguments.dart';
import '../../../../../core/class_constants/constants_methods.dart';
import '../../../../../core/firebase_authentication.dart';
import '../../../../../core/size_widgets/app_screen_size.dart';
import '../../../../../core/widgets/alert_dialog.dart';
import '../../../../../core/widgets/custom_round_button.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/size_widgets/responsive_widget.dart';
import '../../../../../core/widgets/default_login_screen.dart';
import '../../../../../core/widgets/default_text.dart';
import '../../../../../core/widgets/password_text_field.dart';
import '../../../../../core/size_widgets/app_font_style.dart';
import '../../../../../style/colors/colors.dart';
import '../../../../../utils/app_localizations.dart';
import '../../../../../utils/cash_helper.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/regex.dart';
import '../../data/model/SignUpModel.dart';
import '../cubit/sign_up_cubit.dart';
import 'package:mydexef/locator.dart' as di;
import '../../../presentation/cubit/sign_up_cubit/sign_up_states.dart';
import 'package:intl_phone_field/countries.dart';
import 'dart:ui' as ui;

import '../../../../core/rest/sign_up_errors_values.dart';

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
  SignUpCubit? signUpCubit;
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
    return BlocConsumer<SignUpCubit, SignUpStates>(
      builder: (context, state) {
        signUpCubit = SignUpCubit.get(context);
        number  = PhoneNumber(isoCode: signUpCubit?.userCountryCode ??'EG');
        // credFaceWeb = signUpCubit!.credFaceWeb;
        return DefaultLoginScreen(
          isLoading: state is LoadingState,
          body: Directionality(
              textDirection: ui.TextDirection.ltr,
              child:
              // isTap == true ?
              _buildRow(context, state)
            // : _buildStack(context, state),
          ),
        );
      },
      listener: (context, state) async {
        getListenerForGoogleSignup(signUpCubit!, state);
        getListenerForNormalSignup(signUpCubit!, state);
        getListenerForApple(signUpCubit!, state);
      },
    );
  }

////////////////////////////////////////////////////////////////////////////////
  Widget _buildRow(BuildContext context, SignUpStates state) => LayoutBuilder(
    builder: (context, constraints) {
      return AbsorbPointer(
        absorbing: state is LoadingState,
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
                        // InkWell(
                        //   onTap: () {
                        //     // Locale myLocale= Localizations.localeOf(context);
                        //     setState(() {
                        //       // myLocale = context.locale;
                        //       if (context.locale == const Locale('en')) {
                        //         context.locale = const Locale('ar');
                        //         CacheHelper.saveData(
                        //             key: Constants.appLanguage.toString(),
                        //             value: 'ar');
                        //       } else {
                        //         context.locale = const Locale('en');
                        //         CacheHelper.saveData(
                        //             key: Constants.appLanguage.toString(),
                        //             value: 'en');
                        //       }
                        //       if (currentLang == "EN") {
                        //         currentLang = "AR";
                        //       } else {
                        //         currentLang = "EN";
                        //       }
                        //     });
                        //   },
                        //   child:getImage(path: 'icons/arabic_english.svg',isSvg: true,),
                        // ),
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
                                    SizedBox(height: 10,),
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
                                    context.locale.languageCode == 'en' ? SizedBox(height: 16,) :SizedBox(height: 10,),
                                    Row(
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      // mainAxisSize: MainAxisSize.min,
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      //if ((MediaQuery.of(context)
                                      //               .size
                                      //               .shortestSide <
                                      //               600)) {
                                      // Navigator.of(context).push(
                                      // SlideAnimation(page: Login()));
                                      // } else {
                                      // Router.neglect(context, () => context.go(Routes.loginScreen));
                                      // //GoRouter.of(context).pop((Route route) => false);
                                      // //popUntilPath(context, Routes.loginScreen);
                                      // }
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

                                          onTap: () => Router.neglect(
                                              context, () => context.go(Routes.loginScreen)),
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
                                    context.locale.languageCode == 'en' ?  SizedBox(
                                      height: 24,
                                    ):SizedBox(height: 36,),
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
                                            if (phoneNumber == null) {
                                            } else {
                                              String phoneNum = "";
                                              if (countryCode[countryCode.length - 1] == "0" && phoneController.text[0] == "0") {
                                                phoneNum = countryCode + phoneController.text.substring(1);
                                              } else {
                                                phoneNum =
                                                    countryCode + phoneController.text;
                                              }
                                              signUpCubit!.signUP(
                                                phoneOrEmailController.text,
                                                nameController.text,
                                                phoneNum,
                                                passwordController.text,
                                                countryCode,
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
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    //phone number
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        textTheme: const TextTheme(
                                          titleMedium: TextStyle(color:brush,fontFamily: 'Dexef'),
                                          bodyMedium: TextStyle(color: cannot,fontFamily: 'Dexef'),
                                        ),
                                      ),
                                      child: InternationalPhoneNumberInput(
                                        initialValue: number,
                                        // selectorTextStyle: TextStyle(fontSize: 14),
                                        searchBoxDecoration: InputDecoration(
                                          hintStyle: TextStyle(color: Colors.blue,fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 14, mobileFontSize: 12.sp)),
                                          focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue),
                                          ),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue),
                                          ),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue),
                                          ),
                                        ),
                                        /////
                                        focusNode: phoneFocusNode,
                                        spaceBetweenSelectorAndTextField: 0,
                                        textFieldController: phoneController,
                                        maxLength: maxLength,
                                        autofillHints: const [AutofillHints.telephoneNumberNational],
                                        onFieldSubmitted: (value) {
                                          registerErrors = {};
                                          signUpCubit?.errorMessage = '';
                                          if (formKey.currentState!.validate()) {
                                            if (phoneNumber == null) {
                                              // Fluttertoast.showToast(msg: "Phone Number Required!");
                                            } else {
                                              String phoneNum = "";
                                              if (countryCode[countryCode.length - 1] == "0" &&
                                                  phoneController.text[0] == "0") {
                                                phoneNum = countryCode + phoneController.text.substring(1);
                                              } else {
                                                phoneNum = countryCode + phoneController.text;
                                              }
                                              signUpCubit!.signUP(
                                                phoneOrEmailController.text,
                                                nameController.text,
                                                phoneNum,
                                                passwordController.text,
                                                countryCode,
                                              );
                                            }
                                          }
                                        },
                                        onInputValidated: (value) {},
                                        formatInput: false,
                                        validator: (value) {
                                          registerErrors = {};
                                          signUpCubit?.errorMessage = '';
                                          if (value!.isEmpty) {
                                            return AppLocalizations.of(context)!.translate('required');
                                          } else if (!phoneNumberRegex1.hasMatch(value)) {
                                            return AppLocalizations.of(context)!.translate('invalidPhoneNumber');
                                          }
                                          return null;
                                        },
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 14, mobileFontSize: 12.sp),
                                        ),
                                        selectorConfig: const SelectorConfig(
                                          selectorType: PhoneInputSelectorType.DIALOG,
                                          setSelectorButtonAsPrefixIcon: true,
                                          showFlags: false,
                                          leadingPadding: 10,
                                          trailingSpace: false,
                                        ),
                                        inputDecoration: phoneDecoration(context,signUpCubit!,state),
                                        onInputChanged: (phone) {
                                          phoneNumber = phone.phoneNumber;
                                          countryCode = phone.dialCode.toString();
                                          setState(() {
                                            if(state is SignUpFailed){
                                              state.signUpErrors.clear();
                                              // (state as SignUpFailed).signUpErrors.clear();
                                            }
                                            registerErrors = {};
                                            signUpCubit?.errorMessage = '';
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
                                          signUpCubit?.userCountryCode = phone.isoCode;


                                        },
                                        inputBorder: InputBorder.none,
                                      ),
                                    ),
                                    DefaultText(
                                      text: state is SignUpFailed
                                          ? state.signUpErrors
                                          .where((error) => signUpCubit!.hasPhoneError([error]))
                                          .fold<Map<String, String>>({}, (uniqueErrors, error) {
                                        uniqueErrors[error.message!] = error.message!;
                                        return registerErrors =uniqueErrors;
                                      }).values.join(', ')
                                          : '',
                                      themeStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                          color: Colors.red
                                      ),
                                      isTextTheme: true,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    //email
                                    CustomTextFormField(
                                      //width: 394,
                                      controller: phoneOrEmailController,
                                      focusNode: emailFocusNode,
                                      fillColor: Colors.white,
                                      maxLines: 1,
                                      // autofillHints: const [AutofillHints.email],
                                      errorState:  state is SignUpFailed && signUpCubit!.hasEmailError(state.signUpErrors),
                                      onChange: (string){
                                        setState(() {
                                          if(state is SignUpFailed){
                                            state.signUpErrors.clear();
                                            // (state as SignUpFailed).signUpErrors.clear();
                                          }
                                          registerErrors = {};

                                          signUpCubit?.errorMessage = '';
                                        });
                                      },
                                      onFieldSubmitted: (value) {
                                        if (formKey.currentState!.validate()) {
                                          print(phoneController.text);
                                          print(countryCode);

                                          if (phoneNumber == null) {
                                            // Fluttertoast.showToast(msg: "Phone Number Require!");
                                          } else {
                                            String phoneNum = "";
                                            if (countryCode[countryCode.length - 1] ==
                                                "0" &&
                                                phoneController.text[0] == "0") {
                                              phoneNum = countryCode +
                                                  phoneController.text.substring(1);
                                            } else {
                                              phoneNum =
                                                  countryCode + phoneController.text;
                                            }
                                            signUpCubit!.signUP(
                                              phoneOrEmailController.text,
                                              nameController.text,
                                              phoneNum,
                                              passwordController.text,
                                              countryCode,
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
                                      text: state is SignUpFailed
                                          ? state.signUpErrors
                                          .where((error) => signUpCubit!.hasEmailError([error]))
                                          .fold<Map<String, String>>({}, (uniqueErrors, error) {
                                        uniqueErrors[error.message!] = error.message!;
                                        return registerErrors = uniqueErrors;
                                      }).values.join(', ')
                                          : '',
                                      isTextTheme: true,
                                      themeStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                          color: Colors.red
                                      )
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    PasswordTextFormField(
                                      controller: passwordController,
                                      focusNode: passwordFocusNode,
                                      onFieldSubmitted: (value) {
                                        if (formKey.currentState!.validate()) {
                                          if (phoneNumber == null) {
                                            // Fluttertoast.showToast(msg: "Phone Number Require!");
                                          } else {
                                            String phoneNum = "";
                                            if (countryCode[countryCode.length - 1] ==
                                                "0" &&
                                                phoneController.text[0] == "0") {
                                              phoneNum = countryCode +
                                                  phoneController.text.substring(1);
                                            } else {
                                              phoneNum =
                                                  countryCode + phoneController.text;
                                            }
                                            print(phoneNum);
                                            signUpCubit!.signUP(
                                              phoneOrEmailController.text,
                                              nameController.text,
                                              // "+"+countryCode + phoneController.text,
                                              phoneNum,
                                              passwordController.text,
                                              countryCode,
                                            );
                                          }

                                          // signUpCubit!.signUP(
                                          //   phoneOrEmailController.text,
                                          //   nameController.text,
                                          //   "+2" + phoneController.text,
                                          //   passwordController.text,
                                          //   "20",
                                          // );
                                          // }
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
                                      // isPasswordVisible: true,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    PasswordTextFormField(
                                      controller: confirmPasswordController,
                                      label: AppLocalizations.of(context)!
                                          .translate('confirmPassword'),
                                      focusNode: confirmPasswordFocusNode,
                                      onFieldSubmitted: (value) {
                                        if (formKey.currentState!.validate()) {
                                          //   navigateTo(context, VerifyCodeScreen());
                                          //
                                          // }
                                          // if (phoneOrEmailController.text
                                          //     .contains("@")) {
                                          print("xxxxxxxxxxxxxxx0");
                                          // signUpCubit!.confirmEmail(phoneOrEmailController.text);
                                          // } else {
                                          print(phoneController.text);
                                          print(countryCode);

                                          if (phoneNumber == null) {
                                            // Fluttertoast.showToast(msg: "Phone Number Require!");
                                          } else {
                                            String phoneNum = "";
                                            if (countryCode[countryCode.length - 1] ==
                                                "0" &&
                                                phoneController.text[0] == "0") {
                                              phoneNum = countryCode +
                                                  phoneController.text.substring(1);
                                            } else {
                                              phoneNum =
                                                  countryCode + phoneController.text;
                                            }
                                            print(phoneNum);
                                            signUpCubit!.signUP(
                                              phoneOrEmailController.text,
                                              nameController.text,
                                              // "+"+countryCode + phoneController.text,
                                              phoneNum,
                                              passwordController.text,
                                              countryCode,
                                            );
                                          }

                                          // signUpCubit!.signUP(
                                          //   phoneOrEmailController.text,
                                          //   nameController.text,
                                          //   "+2" + phoneController.text,
                                          //   passwordController.text,
                                          //   "20",
                                          // );
                                          // }
                                        }
                                      },
                                      validator: (value) {
                                        print(value);
                                        print(confirmPasswordController.text);
                                        if (value!.isEmpty) {
                                          return AppLocalizations.of(context)!
                                              .translate('required');
                                        } else if (value != passwordController.text) {
                                          return AppLocalizations.of(context)!
                                              .translate('passwordNotSimilar');
                                        }
                                        return null;
                                      },
                                      // isPasswordVisible: true,
                                    ),
                                    DefaultText(
                                      text: state is SignUpFailed || state is LoadingState
                                          ? ''
                                          : signUpCubit?.errorMessage,
                                        isTextTheme: true,
                                        themeStyle:Theme.of(context).textTheme.labelMedium?.copyWith(
                                          color: redColor
                                        )
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    ResponsiveWidget(
                                      localWidthRatio: 1,
                                      fixedHeight: 48,
                                      child: CustomRoundedButton(
                                          isLoading: state is LoadingState,
                                          title: AppLocalizations.of(context)!.translate('signUp'),
                                          onPressed: () {
                                            if (formKey.currentState!.validate()) {
                                              if (phoneNumber == null) {
                                                // Fluttertoast.showToast(msg: "Phone Number Require!");
                                              } else {
                                                String phoneNum = "";
                                                if (countryCode[
                                                countryCode.length - 1] ==
                                                    "0" &&
                                                    phoneController.text[0] == "0") {
                                                  phoneNum = countryCode +
                                                      phoneController.text.substring(1);
                                                } else {
                                                  phoneNum = countryCode +
                                                      phoneController.text;
                                                }
                                                signUpCubit!.signUP(
                                                  phoneOrEmailController.text,
                                                  nameController.text,
                                                  // "+"+countryCode + phoneController.text,
                                                  phoneNum,
                                                  passwordController.text,
                                                  countryCode,
                                                );
                                              }
                                            }
                                          }),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: DefaultText(
                                        text: AppLocalizations.of(context)!.translate('or'),
                                        fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 14, mobileFontSize: 12.sp),
                                        fontColor: brushIcon,
                                        fontFamily: AppFontStyle.appFontFamily.readex,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    // Gap(20.h),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,  // Removes the background highlight color
                                            splashColor: Colors.transparent,     // Removes the splash color

                                            onTap: () async {
                                              if(state is SignUpFailed){
                                                state.signUpErrors.clear();
                                              }
                                              registerErrors = {};
                                              signUpCubit?.errorMessage = '';

                                              if (kIsWeb) {
                                                await signUpCubit
                                                    ?.signUpWithGoogleWeb();
                                                log('token = ${signUpCubit?.credGoogleWeb?.credential?.accessToken}');
                                                log('email = ${signUpCubit?.credGoogleWeb?.user?.email}');
                                                log('UID = ${signUpCubit?.credGoogleWeb?.user?.uid}');
                                              } else {
                                                await signUpCubit?.signUpWithGoogle(context);
                                                log('email = ${signUpCubit?.credGoogle.user?.email}');
                                                log('UID = ${signUpCubit?.credGoogle.user?.uid}');
                                                log('access token = ${googleAuth?.accessToken}');
                                              }
                                            },
                                            child: MouseRegion(
                                              cursor: SystemMouseCursors.click,
                                              child: Container(
                                                height: 48,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(25),
                                                    border: Border.all(
                                                      color: brushBorder,
                                                    )),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    getImage(path: 'images/signin_google.svg',isSvg: true, height: 48 / 2,
                                                      width: 48 / 2.w,),
                                                    const SizedBox(width: 5),
                                                    DefaultText(
                                                      text: AppLocalizations.of(context)!.translate('signUpGoogle'),
                                                      isTextTheme: true,
                                                      themeStyle: Theme.of(context).textTheme.labelSmall
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Gap(10.w),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,  // Removes the background highlight color
                                            splashColor: Colors.transparent,     // Removes the splash color

                                            onTap: () async {
                                              if(state is SignUpFailed){
                                                state.signUpErrors.clear();
                                              }
                                              registerErrors = {};
                                              signUpCubit?.errorMessage = '';
                                              signUpCubit?.signUpWithApple();
                                              // if (kIsWeb) {
                                              //   try {
                                              //     //  await FirebaseAuth.instance.signOut();
                                              //     debugPrint('Start');
                                              //     credFaceWeb = await signUpCubit
                                              //         ?.signUpWithFacebookWeb();
                                              //     debugPrint(
                                              //         'token is ${credFaceWeb!.credential!.accessToken!}');
                                              //     if (credFaceWeb != null &&
                                              //         credFaceWeb!.credential !=
                                              //             null &&
                                              //         credFaceWeb!.credential!
                                              //             .accessToken !=
                                              //             null) {
                                              //       navigateToVerifyPhoneScreen();
                                              //     } else {
                                              //       debugPrint('Null Token');
                                              //       // showAlertDialog(
                                              //       //     context: context,
                                              //       //     isSuccess: false,
                                              //       //     title:  AppLocalizations.of(context)!.translate('signUpFailed'),
                                              //       //     subTitle: AppLocalizations.of(context)!.translate('nullCredential'),
                                              //       //     textColor: Colors.black);
                                              //     }
                                              //   } catch (e) {
                                              //     debugPrint('Sign UP Failed Catch ${e.toString()}');
                                              //     // showAlertDialog(
                                              //     //     context: context,
                                              //     //     isSuccess: false,
                                              //     //     title:AppLocalizations.of(context)!.translate('signUpFailed'),
                                              //     //
                                              //     //     subTitle: e.toString(),
                                              //     //     textColor: Colors.black);
                                              //   }
                                              // } else {
                                              //   await signUpCubit?.signUpWithFacebook();
                                              //   print(
                                              //       'token ${signUpCubit?.loginResult?.accessToken?.token}');
                                              // }
                                            },
                                            child: MouseRegion(
                                              cursor: SystemMouseCursors.click,
                                              child: Container(
                                                height: 48,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(25),
                                                    border: Border.all(
                                                      color: brushBorder,
                                                    )),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    getImage(path: 'images/apple.svg',isSvg: true,height: 48 / 2, width: 48 / 2.w,),
                                                    const SizedBox(width: 5),
                                                    DefaultText(
                                                      text: AppLocalizations.of(
                                                          context)!
                                                          .translate(
                                                          'signUpApple'),
                                                      isTextTheme: true,
                                                      themeStyle: Theme.of(context).textTheme.labelSmall
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
//   Widget _buildStack(BuildContext context, SignUpStates state) => Stack(
//     children: [
//       AnimatedSlide(
//         duration: const Duration(milliseconds: 300),
//         offset: getLocation(),
//         child: AnimatedOpacity(
//           opacity: opacity,
//           duration: const Duration(milliseconds: 300),
//           child: SizedBox(
//             height: MediaQuery.of(context).size.height,
//             width: AppScreenSize.getLoginRightPanelWidth(context),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         // Locale myLocale = Localizations.localeOf(context);
//                         setState(() {
//                           // myLocale = context.locale;
//                           if (context.locale == const Locale('en')) {
//                             context.locale = const Locale('ar');
//                             CacheHelper.saveData(
//                                 key: Constants.appLanguage.toString(),
//                                 value: 'ar');
//                           } else {
//                             context.locale = const Locale('en');
//                             CacheHelper.saveData(
//                                 key: Constants.appLanguage.toString(),
//                                 value: 'en');
//                           }
//                           if (currentLang == "EN") {
//                             currentLang = "AR";
//                           } else {
//                             currentLang = "EN";
//                           }
//                         });
//                       },
//                       child:getImage(path: 'icons/arabic_english.svg',isSvg: true,),
//                     ),
//                     SizedBox(
//                       width: 5.w,
//                     ),
//                     DefaultText(
//                       text: currentLang,
//                       fontColor: brush,
//                       fontSize: AppFontSize.getFontSize(context, 14),
//                       fontWeight: FontWeight.w400,
//                       fontFamily: 'DXRound',
//                     ),
//                   ],
//                 ),
//                 Flexible(
//                   child: SingleChildScrollView(
//                     child: Center(
//                       child: Form(
//                         key: formKey,
//                         child: Padding(
//                           padding:
//                           const EdgeInsets.symmetric(horizontal: 0),
//                           child: Directionality(
//                             textDirection: CacheHelper.getData(
//                                 key: Constants.appLanguage
//                                     .toString()) ==
//                                 'en'
//                                 ? ui.TextDirection.rtl
//                                 : ui.TextDirection.ltr,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 WidgetResponsiveBuilder(
//                                   localWidthRatio: ratioWidthComponentLogin,
//                                   child: DefaultText(
//                                     text: AppLocalizations.of(context)!
//                                         .translate('welcome'),
//                                     align: TextAlign.start,
//                                     fontColor: brush,
//                                     fontSize: AppFontSize.getFontSize(
//                                         context, 32),
//                                     fontWeight: FontWeight.w800,
//                                     fontFamily: 'DXRoundBold',
//                                     height: 1.2.h,
//                                   ),
//                                 ),
//                                 WidgetResponsiveBuilder(
//                                   localWidthRatio: ratioWidthComponentLogin,
//                                   child: Row(
//                                     children: [
//                                       DefaultText(
//                                           text:
//                                           AppLocalizations.of(context)!
//                                               .translate('haveAccount'),
//                                           fontSize: AppFontSize.getFontSize(
//                                               context, 16),
//                                           fontColor: brush,
//                                           fontWeight: FontWeight.w400,
//                                           fontFamily: 'DXRound'),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 6),
//                                         child: MouseRegion(
//                                           cursor: SystemMouseCursors.click,
//                                           child: DefaultText(
//                                               text: AppLocalizations.of(
//                                                   context)!
//                                                   .translate('signIn'),
//                                               fontSize:
//                                               AppFontSize.getFontSize(
//                                                   context, 14),
//                                               fontColor: primary,
//                                               fontWeight: FontWeight.w400,
//                                               fontFamily: 'DXRound'),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Gap(30.h),
//                                 WidgetResponsiveBuilder(
//                                   localWidthRatio: ratioWidthComponentLogin,
//                                   fixedHeight: 68,
//                                   child: CustomTextFormField(
//                                     controller: nameController,
//                                     autoFocus: kIsWeb ? true : false,
//                                     label: AppLocalizations.of(context)!
//                                         .translate('name'),
//                                   ),
//                                 ),
//                                 Gap(5.h),
//                                 WidgetResponsiveBuilder(
//                                   localWidthRatio: ratioWidthComponentLogin,
//                                   child: InternationalPhoneNumberInput(
//                                     initialValue: number,
//                                     spaceBetweenSelectorAndTextField: 0,
//                                     textFieldController: phoneController,
//                                     formatInput: false,
//                                     textStyle: TextStyle(
//                                         fontSize: AppFontSize.getFontSize(
//                                             context, 16)),
//                                     selectorConfig: const SelectorConfig(
//                                         selectorType:
//                                         PhoneInputSelectorType.DIALOG,
//                                         setSelectorButtonAsPrefixIcon: true,
//                                         showFlags: false,
//                                         leadingPadding: 10,
//                                         trailingSpace: false),
//                                     inputDecoration: InputDecoration(
//                                         contentPadding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 24,
//                                             vertical: 12),
//                                         errorStyle:
//                                         const TextStyle(height: .5),
//                                         border: OutlineInputBorder(
//                                           borderRadius:
//                                           BorderRadius.circular(25),
//                                           borderSide: const BorderSide(
//                                               color: brushBorder),
//                                         ),
//                                         enabledBorder: OutlineInputBorder(
//                                             borderRadius:
//                                             BorderRadius.circular(25),
//                                             borderSide: const BorderSide(
//                                               color: brushBorder,
//                                             )),
//                                         label: DefaultText(
//                                           text: ' ${AppLocalizations.of(context)!.translate('phoneNumber')} ',
//                                           fontColor: brushLines,
//                                           fontFamily: AppFontFamily.dexef,
//                                           fontSize: AppFontSize.getFontSize(
//                                               context, 16),
//                                         ),
//                                         hintStyle: TextStyle(
//                                             color: Colors.grey,
//                                             fontSize:
//                                             AppFontSize.getFontSize(
//                                                 context, 12))),
//                                     onInputChanged: (phone) {
//                                       if (phoneController.text.startsWith('0')) {
//                                         phoneController.value = TextEditingValue(
//                                           text: phoneController.text.substring(1),
//                                           selection: TextSelection.fromPosition(
//                                             TextPosition(offset: phoneController.text.length - 1),
//                                           ),
//                                         );
//                                       }
//                                       phoneNumber = phone.phoneNumber;
//                                       countryCode =
//                                           phone.dialCode.toString();
//                                     },
//                                     inputBorder: InputBorder.none,
//                                   ),
//                                 ),
//                                 Gap(20.h),
//                                 WidgetResponsiveBuilder(
//                                   localWidthRatio: ratioWidthComponentLogin,
//                                   fixedHeight: 68,
//                                   child: CustomTextFormField(
//                                     width: 394,
//                                     controller: phoneOrEmailController,
//                                     autoFocus: false,
//                                     label: AppLocalizations.of(context)!
//                                         .translate('emailAddress'),
//                                   ),
//                                 ),
//                                 Gap(5.h),
//                                 WidgetResponsiveBuilder(
//                                   localWidthRatio: ratioWidthComponentLogin,
//                                   fixedHeight: 68,
//                                   child: PasswordTextFormField(
//                                     controller: passwordController,
//                                     label: AppLocalizations.of(context)!
//                                         .translate('profilePassword'),
//                                   ),
//                                 ),
//                                 Gap(5.h),
//                                 WidgetResponsiveBuilder(
//                                   localWidthRatio: ratioWidthComponentLogin,
//                                   fixedHeight: 68,
//                                   child: PasswordTextFormField(
//                                     controller: confirmPasswordController,
//                                     label: AppLocalizations.of(context)!
//                                         .translate('confirmPasswordSignup'),
//                                   ),
//                                 ),
//                                 Gap(30.h),
//                                 WidgetResponsiveBuilder(
//                                   localWidthRatio: ratioWidthComponentLogin,
//                                   fixedHeight: 48,
//                                   child: CustomRoundedButton(
//                                       isLoading: state is LoadingState,
//                                       title: AppLocalizations.of(context)!
//                                           .translate('signUp'),
//                                       onPressed: () {}),
//                                 ),
//                                 Gap(20.h),
//                                 Center(
//                                   child: DefaultText(
//                                     text: AppLocalizations.of(context)!
//                                         .translate('or'),
//                                     fontSize: AppFontSize.getFontSize(
//                                         context, 14),
//                                     fontColor: brushIcon,
//                                     fontFamily: 'DXRound',
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                                 Gap(20.h),
//                                 WidgetResponsiveBuilder(
//                                     localWidthRatio: ratioWidthComponentLogin,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Expanded(
//                                           child: MouseRegion(
//                                             cursor:
//                                             SystemMouseCursors.click,
//                                             child: InkWell(
//                                               onTap: () {},
//                                               child: Container(
//                                                 height: 48,
//                                                 decoration: BoxDecoration(
//                                                     borderRadius:
//                                                     BorderRadius
//                                                         .circular(25),
//                                                     border: Border.all(
//                                                       color: brushBorder,
//                                                     )),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .center,
//                                                   children: [
//                                                     getImage(path: 'images/signin_google.svg',isSvg: true, height: 48 / 2,
//                                                       width: 48 / 2.w,),
//
//                                                     Gap(10.w),
//                                                     DefaultText(
//                                                       text: AppLocalizations
//                                                           .of(context)!
//                                                           .translate(
//                                                           'signUpGoogle'),
//                                                       fontColor:
//                                                       brush,
//                                                       fontSize: AppFontSize
//                                                           .getFontSize(
//                                                           context, 14),
//                                                       fontWeight:
//                                                       FontWeight.w400,
//                                                       fontFamily:
//                                                       AppFontFamily
//                                                           .dexef,
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Gap(10.w),
//                                         Expanded(
//                                           child: MouseRegion(
//                                             cursor:
//                                             SystemMouseCursors.click,
//                                             child: InkWell(
//                                               onTap: () {},
//                                               child: Container(
//                                                 height: 48,
//                                                 decoration: BoxDecoration(
//                                                     borderRadius:
//                                                     BorderRadius
//                                                         .circular(25),
//                                                     border: Border.all(
//                                                       color: brushBorder,
//                                                     )),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .center,
//                                                   children: [
//                                                     getImage(path: 'images/signin_facebook.svg',isSvg: true, height: 48 / 2,
//                                                         width: 48 / 2.w),
//                                                     Gap(10.w),
//                                                     DefaultText(
//                                                       text: AppLocalizations
//                                                           .of(context)!
//                                                           .translate(
//                                                           'signUpFacebook'),
//                                                       fontColor:
//                                                       brush,
//                                                       fontSize: AppFontSize
//                                                           .getFontSize(
//                                                           context, 14),
//                                                       fontWeight:
//                                                       FontWeight.w400,
//                                                       fontFamily:
//                                                       AppFontFamily
//                                                           .dexef,
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     )),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Gap(20.h),
//               ],
//             ),
//           ),
//         ),
//       ),
//       Visibility(
//         visible: (MediaQuery.of(context).size.width < AppConstants.minimumScreenSize) ? false : true,
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width - AppScreenSize.getLoginRightPanelWidth(context),
//           decoration: BoxDecoration(color: cloudBackground, boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(.16),
//               offset: const Offset(0, 0),
//               blurRadius: 12.0,
//             )
//           ]),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Flexible(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         WidgetResponsiveBuilder(
//                           localWidthRatio: ratioBackgroundWidth,
//                           child:getImage(path: 'images/backgroundCloseShift.svg',isSvg: true, height: MediaQuery.of(context).size.height *
//                               ratioBackgroundHeight,),
//                         ),
//                         WidgetResponsiveBuilder(
//                             localWidthRatio: ratioImageWidth,
//                             child: getImage(path: "images/backgroundSignUp.png", height: MediaQuery.of(context).size.height * ratioImageHeight)
//                         ),
//                       ],
//                     ),
//                     DefaultText(
//                       text: "Dexef Cloud",
//                       align: TextAlign.center,
//                       fontSize: AppFontSize.getFontSize(context, 32),
//                       fontWeight: FontWeight.w400,
//                       fontColor: brush,
//                       fontFamily: 'DXRoundBold',
//                     ),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     DefaultText(
//                       text:AppLocalizations.of(context)!.translate('everyNeed'),
//                       align: TextAlign.center,
//                       fontSize: AppFontSize.getFontSize(context, 16),
//                       fontWeight: FontWeight.w400,
//                       fontColor: brush,
//                       fontFamily: 'DXRound',
//                     ),
//                   ],
//                 ),
//               ),
//               WidgetResponsiveBuilder(
//                 localWidthRatio: ratioLogoMiniWidth,
//                 fixedHeight: MediaQuery.of(context).size.height *
//                     ratioLogoMiniHeight,
//                 child:
//                 SvgPicture.asset('assets/images/dexef_logo_body.svg'),
//               ),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height *
//                     ratioHeightUnderLogo,
//               )
//             ],
//           ),
//         ),
//       ),
//     ],
//   );
////////////////////////////////////////////////////////////////////////////////
//   void navigateToVerifyPhoneScreen() {
//     context.go(Routes.verifyPhoneNumber);
//     CacheHelper.saveObjectToPrefs(
//         key: Constants.verifyPhoneNumberArguments.toString(),
//         object: ArgumentsVerifyPhoneNumber(
//             email: "${FirebaseAuth.instance.currentUser?.email}",
//             name: "${FirebaseAuth.instance.currentUser?.displayName}",
//             token: kIsWeb
//                 ? credFaceWeb?.credential?.accessToken
//                 : signUpCubit?.loginResult?.accessToken?.token,
//             isFacebook: true,
//             isGoogle: false));
//     // showAlertDialog(
//     //     context: context,
//     //     isSuccess: true,
//     //     title: AppLocalizations.of(context)!.translate('loginSuccessfully'),
//     //     //subTitle: state.message,
//     //     textColor: Colors.black);
//     kIsWeb
//         ? CacheHelper.saveData(
//         key: Constants.facebookToken.toString(),
//         value: credFaceWeb?.credential?.accessToken)
//         : CacheHelper.saveData(
//         key: Constants.facebookToken.toString(),
//         value: signUpCubit?.loginResult?.accessToken?.token);
//   }

////////////////////////////////////////////////////////////////////////////////
  getListenerForGoogleSignup(SignUpCubit signUpCubit, SignUpStates state) {
    if (state is SignUpGoogleSuccess || state is SignUpGoogleWebSuccess) {
      signUpCubit.validateEmailNormal(signUpCubit.credGoogleWeb!.user!.email!);

      // showAlertDialog(
      //     context: context,
      //     isSuccess: true,
      //     title: AppLocalizations.of(context)!.translate('loginSuccessfully'),
          // textColor: Colors.black);
      log('token = ${CacheHelper.getData(key: Constants.tokenGoogle.toString())}');
    } else if (state is SignUpGoogleError) {
      // showAlertDialog(
      //     context: context,
      //     isSuccess: false,
      //     title: state.message,
      //     textColor: Colors.black);
      signUpCubit.signOut();
    } else if (state is SignUpGoogleWebError) {
      // showAlertDialog(
      //     context: context,
      //     isSuccess: false,
      //     title: state.message,
      //     textColor: Colors.black);
      signUpCubit.signOut();
    }else if(state is CanceledSignUpByUserWebGoogle){
      // showAlertDialog(
      //     context: context,
      //     isSuccess: false,
      //     title: AppLocalizations.of(context)!.translate('networkFailed'),
      //     subTitle: state.message,
      //     textColor: Colors.black);
    }
  }
////////////////////////////////////////////////////////////////////////////////
//   getListenerForFacebookSignup(SignUpCubit signUpCubit, SignUpStates state) {
//     if (state is SignUpFaceBookSuccess || state is SignUpFaceBookWebSuccess) {
//       CacheHelper.saveObjectToPrefs(
//           key: Constants.verifyPhoneNumberArguments.toString(),
//           object: ArgumentsVerifyPhoneNumber(
//               token: kIsWeb
//                   ? credFaceWeb?.credential?.accessToken
//                   : signUpCubit.loginResult?.accessToken?.token,
//               email: "${FirebaseAuth.instance.currentUser?.email}",
//               name: "${FirebaseAuth.instance.currentUser?.displayName}",
//               isFacebook: true,
//               isApple: false,
//               isGoogle: false));
//       context.go(Routes.verifyPhoneNumber);
//       // showAlertDialog(
//       //     context: context,
//       //     isSuccess: true,
//       //     title: AppLocalizations.of(context)!.translate('loginSuccessfully'),
//       //     textColor: Colors.black);
//       kIsWeb
//           ? CacheHelper.saveData(
//           key: Constants.facebookToken.toString(),
//           value: credFaceWeb?.credential?.accessToken)
//           : CacheHelper.saveData(
//           key: Constants.facebookToken.toString(),
//           value: signUpCubit.loginResult?.accessToken?.token);
//     } else if (state is SignUpFaceBookWebError) {
//       // showAlertDialog(
//       //     context: context,
//       //     isSuccess: false,
//       //     title: AppLocalizations.of(context)!.translate('signUpFailed'),
//       //     subTitle: getErrorMessage(state.message!),
//       //     textColor: Colors.black);
//     } else if (state is SignUpFaceBookError) {
//       // showAlertDialog(
//       //     context: context,
//       //     isSuccess: false,
//       //     title: AppLocalizations.of(context)!.translate('signUpFailed'),
//       //     subTitle: getErrorMessage(state.message!),
//       //     textColor: Colors.black);
//     }
//   }
////////////////////////////////////////////////////////////////////////////////
  getListenerForNormalSignup(SignUpCubit signUpCubit, SignUpStates state) {
    if (state is SignUpSuccess) {
      Router.neglect(context, () => context.go(Routes.loginScreen));

      // working
      // CacheHelper.saveObjectToPrefs(
      //   key: Constants.verifyCodeScreenArguments.toString(),
      //   object: ArgumentsVerifyCodeScreen(
      //       mobileId: state.mobileID,
      //       email: phoneOrEmailController.text,
      //       password: passwordController.text,
      //       fromPage: 'signUp',
      //       mobilePhone: phoneController.text,
      //       countryCode: countryCode,
      //   ),
      // );
      // CacheHelper.saveData(key: Constants.mobileId.toString(), value: state.mobileID);
      // signUpCubit.signUpEntity?.data?.expiryDate == null
      //     ? Router.neglect(context, () => context.go(Routes.verifyCodeChooseSignUp))
      //     : Router.neglect(context, () => context.go(Routes.verifyCodeScreen))
      // ;
    } else if (state is SignUpFailed) {
      showAlertDialog(
          context: context,
          isSuccess: false,
          title: AppLocalizations.of(context)!.translate('signUpFailed'),
          subTitle: getErrorMessage(state.message),
          textColor: Colors.black);
    }
    else if(state is SignUpUnSuccess){
      showAlertDialog(
          context: context,
          isSuccess: false,
          title: AppLocalizations.of(context)!.translate('signUpFailed'),
          subTitle: getErrorMessage(state.message),
          textColor: Colors.black);
    }
    else if (state is ValidateEmailSuccess) {
      debugPrint("alaa ${state.validateEmailEntity?.data?.email}");
      if(state.validateEmailEntity?.data?.customerStatus != null){
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
        CacheHelper.saveObjectToPrefs(key: Constants.verifyCodeScreenArguments.toString(), object: ArgumentsVerifyCodeScreen(
          mobileId: state.validateEmailEntity?.data!.customerStatus?.mobileId?.toInt(),
          fromPage: 'verifySocial',
        ));
      }else{
        context.go(Routes.loginScreen);
        if(signUpCubit.validateEmailEntity?.data?.type =='Normal'){
          CacheHelper.saveData(key: Constants.emailType.toString(), value: 'Normal');
          CacheHelper.saveData(key: Constants.emailOrPhone.toString(), value: signUpCubit.validateEmailEntity?.data?.email);
        }else if(signUpCubit.validateEmailEntity?.data?.type =='Google'){
          CacheHelper.saveData(key: Constants.emailType.toString(), value: 'Google');
          // CacheHelper.saveData(key: Constants.emailAddress.toString(), value: signUpCubit.validateEmailEntity?.data?.email);
        }else if(signUpCubit.validateEmailEntity?.data?.type =='Apple'){
          CacheHelper.saveData(key: Constants.emailType.toString(), value: 'Apple');
          // CacheHelper.saveData(key: Constants.emailAddress.toString(), value: signUpCubit.validateEmailEntity?.data?.email);
        }
      }
    }
  }
////////////////////////////////////////////////////////////////////////////////
  getListenerForApple(SignUpCubit signUpCubit, SignUpStates state){
    if (state is SignUpAppleSuccess) {
      signUpCubit.validateEmailNormal(signUpCubit.appleEmail! );

      log('token = ${CacheHelper.getData(key: Constants.appleToken.toString())}');
    } else if (state is ValidateEmailError) {
     if(signUpCubit.socialLogin == 'apple'){
       CacheHelper.saveData(
           key: Constants.appleToken.toString(),
           value: '${signUpCubit.idToken}'
       );
       context.go(Routes.verifyPhoneNumber);
       CacheHelper.saveObjectToPrefs(
           key: Constants.verifyPhoneNumberArguments.toString(),
           object: ArgumentsVerifyPhoneNumber(
               email: "${FirebaseAuth.instance.currentUser?.email}",
               name: "${FirebaseAuth.instance.currentUser?.displayName}",
               token: signUpCubit.idToken,
               isGoogle: false,
               isApple: true,
               isFacebook: false)
       );
     }else if(signUpCubit.socialLogin =='Google'){
       CacheHelper.saveData(
           key: Constants.tokenGoogle.toString(),
           value: kIsWeb
               ? '${signUpCubit.credGoogleWeb?.credential?.accessToken}'
               : '${googleAuth?.accessToken}');
       context.go(Routes.verifyPhoneNumber);
       CacheHelper.saveObjectToPrefs(
           key: Constants.verifyPhoneNumberArguments.toString(),
           object: ArgumentsVerifyPhoneNumber(
               email: "${FirebaseAuth.instance.currentUser?.email}",
               name: "${FirebaseAuth.instance.currentUser?.displayName}",
               token: kIsWeb ? '${signUpCubit.credGoogleWeb?.credential?.accessToken}' : '${googleAuth?.accessToken}',
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
////////////////////////////////////////////////////////////////////////////////
  InputDecoration phoneDecoration(BuildContext context,SignUpCubit signUpCubit,SignUpStates state){
    return  InputDecoration(
      prefixStyle: const TextStyle(color: Colors.blue),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      errorStyle: const TextStyle(height:1,fontSize: 16,color: Colors.red,fontFamily: 'Dexef'),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        //state is SignUpFailed && (signUpCubit.errorMessage == "فشل العملية : [Mobile] موجود مسبقا"
        //          || signUpCubit.errorMessage == "Failed : [Mobile] Already Exists") ? redColor :
        borderSide: BorderSide( color: state is SignUpFailed && signUpCubit.hasPhoneError(state.signUpErrors) ?redColor : brushBorder ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide:  BorderSide(color:state is SignUpFailed &&signUpCubit.hasPhoneError(state.signUpErrors) ?redColor : brushBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: state is SignUpFailed && signUpCubit.hasPhoneError(state.signUpErrors) ?redColor :selectedBorder),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.red),
      ),
      label: DefaultText(
        text: '   ${AppLocalizations.of(context)!.translate('phoneNumber')}   ',
        fontColor: brushLines,
        fontFamily: 'Dexef',
        fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 14, mobileFontSize: 12.sp),
      ),
      hintStyle: TextStyle(
        color: Colors.black,
        fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 12, mobileFontSize: 10.sp),
      ),

    );
  }

}

