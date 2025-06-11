import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mydexef/core/class_constants/constants_methods.dart';
import 'package:mydexef/utils/cash_helper.dart';
import 'package:mydexef/utils/constants.dart';
import '../../../../../core/class_constants/Routes.dart';
import '../../../../../core/arguments.dart';
import '../../../../../core/class_constants/app_constants_values.dart';
import '../../../../../core/size_widgets/app_screen_size.dart';
import '../../../../../core/widgets/alert_dialog.dart';
import '../../../../../core/widgets/custom_round_button.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/size_widgets/responsive_widget.dart';
import '../../../../../core/widgets/default_login_screen.dart';
import '../../../../../core/widgets/default_text.dart';
import '../../../../../core/size_widgets/app_font_style.dart';
import '../../../../../core/widgets/network_failed.dart';
import '../../../../../style/colors/colors.dart';
import '../../../../../utils/app_localizations.dart';
import '../../../../../utils/regex.dart';
import '../../../domain/entity/register_with_google_entity.dart';
import '../../../domain/entity/verify_code_entity.dart';
import '../../../presentation/cubit/verify_phone_google_face_cubit/verify_phone_google_face_cubit.dart';
import '../../../presentation/cubit/verify_phone_google_face_cubit/verify_phone_google_face_states.dart';
import 'verify_code_social.dart';
import 'package:mydexef/locator.dart' as di;
import 'dart:ui' as ui;

class VerifyPhoneNumber extends StatefulWidget {
  const VerifyPhoneNumber({
    Key? key,
  }) : super(key: key);

  @override
  State<VerifyPhoneNumber> createState() => _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  VerifyPhoneGoogleFaceCubit? verifyPhoneGoogleFaceCubit;
  final formKey = GlobalKey<FormState>();
  VerifyCodeEntity? verifyCodeEntity;
  RegisterByGoogleEntity? registerByGoogleEntity;
  bool visibleContainer = false;
  dynamic location;
  bool isTap = false;
  double opacity = 0.0;
  String initialCountry = 'EG';
  PhoneNumber number = PhoneNumber(isoCode: 'EG');
  String? countryCode, phoneNumber;
  Orientation? orientation;
  int maxLength = 10;

////////////////////////////////////////////////////////////////////////////////
  getLocation() {
    if (visibleContainer) {
      location = Offset(1, 0);
    } else {
      location = Offset(0, 0);
    }
    return location;
  }

////////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 5), () {
      setState(() {
        visibleContainer = true;
        opacity = 1.0;
      });
    });
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        isTap = true;
      });
    });
    super.initState();
  }

////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    ArgumentsVerifyPhoneNumber? args = CacheHelper.getObjectFromPrefs(
        key: Constants.verifyPhoneNumberArguments.toString(),
        model: ArgumentsVerifyPhoneNumber);
    orientation = MediaQuery.of(context).orientation;
    if(args != null){
      nameController.text =
      (args.name == null || args.name == "null") ? '' : args.name;
      emailController.text = (args.email == null || args.email == "null") ? "Invalid Email" : args.email;
    }
    return BlocProvider(
      create: (context) => di.locator<VerifyPhoneGoogleFaceCubit>(),
      child:
      BlocConsumer<VerifyPhoneGoogleFaceCubit, VerifyPhoneGoogleFaceStates>(
        listener: (context, state) {
          listenerMethod(state, context);
        },
        builder: (context, state) {
          verifyPhoneGoogleFaceCubit = VerifyPhoneGoogleFaceCubit.get(context);
          return DefaultLoginScreen(
            isLoading: state is RegisterByGoogleStateLoading ||
                state is RegisterFacebookLoading || state is RegisterAppleLoading,
            body: args != null
                // ? (isTap == true ||
                // (kIsWeb &&
                //     MediaQuery.of(context).size.shortestSide < 600)) ||
                // (orientation == Orientation.portrait)
                ? _buildRow(context, state, args)
                // : _buildStack(context, state, args)
                : const Center(child:  NetworkFailed()),
          );
        },
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////
  void listenerMethod(VerifyPhoneGoogleFaceStates state, BuildContext context) {
    if (state is RegisterByGoogleStateSuccess) {
      //Navigator.of(context).pushNamedAndRemoveUntil(VerifyCodeSocial.route, (route) => false);
      Router.neglect(context, () {
        // context.go(Routes.verifyCodeSocial);
        context.go(Routes.verifyCodeChooseSocial);
      });
      CacheHelper.saveObjectToPrefs(
          key: Constants.verifyCodeSocialArguments.toString(),
          object: ArgumentsResetPasswordVerifyCode(
            mobileID: state.registerByGoogleEntity.data!.mobileId,
            isFromGoogle: true,
            isFromFacebook: false,
            isApple: false
          ));
      CacheHelper.saveObjectToPrefs(key: Constants.verifyCodeScreenArguments.toString(), object: ArgumentsVerifyCodeScreen(
          mobileId:state.registerByGoogleEntity.data!.mobileId,
          fromPage: 'verifySocial',
      ));
      CacheHelper.saveData(key: Constants.emailOrPhoneReset.toString(), value: phoneController.text);
      CacheHelper.saveData(key: Constants.mobileId.toString(), value: state.registerByGoogleEntity.data?.mobileId);

      // showAlertDialog(
      //     context: context,
      //     isSuccess: true,
      //     title: AppLocalizations.of(context)!.translate('loginSuccessfully'),
      //     textColor: Colors.black);
    } else if (state is RegisterByGoogleStateError) {
      // showAlertDialog(
      //     context: context,
      //     isSuccess: false,
      //     title: "${state.registerByGoogleEntity.errors!.first.message}",
      //     textColor: Colors.black);
    } else if (state is RegisterFacebookSuccess) {
      // showAlertDialog(
      //     context: context,
      //     isSuccess: true,
      //     title: AppLocalizations.of(context)!.translate('loginSuccessfully'),
      //     textColor: Colors.black);
      CacheHelper.saveObjectToPrefs(
          key: Constants.verifyCodeSocialArguments.toString(),
          object: ArgumentsResetPasswordVerifyCode(
            mobileID: state.registerFacebookEntity.data!.mobileId,
            isFromGoogle: false,
            isFromFacebook: true,
            isApple: false
          ));
      CacheHelper.saveObjectToPrefs(key: Constants.verifyCodeScreenArguments.toString(), object: ArgumentsVerifyCodeScreen(
          mobileId:  state.registerFacebookEntity.data!.mobileId,
          fromPage: 'verifySocial'
      ));
      CacheHelper.saveData(key: Constants.mobileId.toString(), value: state.registerFacebookEntity.data?.mobileId);

      Router.neglect(context, () => context.go(Routes.verifyCodeSocial));
    } else if (state is RegisterFacebookError) {
      // showAlertDialog(
      //     context: context,
      //     isSuccess: false,
      //     subTitle: "${state.registerFacebookEntity.errors!.first.message}",
      //     title: AppLocalizations.of(context)!.translate('failed'),
      //     textColor: Colors.black);
    }else if (state is RegisterFacebookFailure){
      // showAlertDialog(
      //     context: context,
      //     isSuccess: false,
      //     subTitle: getErrorMessage(state.message),
      //     title: AppLocalizations.of(context)!.translate('networkFailed'),
      //     textColor: Colors.black);
    }else if(state is RegisterByGoogleStateFailure){
      // showAlertDialog(
      //     context: context,
      //     isSuccess: false,
      //     subTitle: getErrorMessage(state.message),
      //     title: AppLocalizations.of(context)!.translate('networkFailed'),
      //     textColor: Colors.black);
    }else if(state is RegisterAppleSuccess){
      CacheHelper.saveObjectToPrefs(
          key: Constants.verifyCodeSocialArguments.toString(),
          object: ArgumentsResetPasswordVerifyCode(
              mobileID: state.registerAppleEntity.data!.mobileId,
              isFromGoogle: false,
              isFromFacebook: false,
              isApple: true
          ));
      CacheHelper.saveObjectToPrefs(key: Constants.verifyCodeScreenArguments.toString(), object: ArgumentsVerifyCodeScreen(
        mobileId:state.registerAppleEntity.data!.mobileId,
        fromPage: 'verifySocial',
      ));
      CacheHelper.saveData(key: Constants.emailOrPhoneReset.toString(), value: phoneController.text);
      CacheHelper.saveData(key: Constants.mobileId.toString(), value: state.registerAppleEntity.data?.mobileId);
      Router.neglect(context, () => context.go(Routes.verifyCodeChooseSocial));
    }
  }

////////////////////////////////////////////////////////////////////////////////
  Widget _buildRow(BuildContext context, VerifyPhoneGoogleFaceStates state,
      ArgumentsVerifyPhoneNumber args) =>
      AbsorbPointer(
        absorbing:state is RegisterByGoogleStateLoading || state is RegisterAppleLoading ,
        child: Row(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width -
                  AppScreenSize.appWidgetSize.getLoginRightPanelWidth(context),
              decoration: BoxDecoration(color: cloudBackground, boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.16),
                  offset: Offset(0, 0),
                  blurRadius: 12.0,
                )
              ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Visibility(
                  //   visible: false,
                  //   child: Row(
                  //     children: [
                  //       InkWell(
                  //         onTap: () {
                  //           Navigator.pop(context);
                  //         },
                  //         child: Padding(
                  //           padding:
                  //               EdgeInsets.only(top: 50, left: 50, right: 50),
                  //           child: SvgPicture.asset("assets/images/back.svg"),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ResponsiveWidget(
                          localWidthRatio: 388 / 640,
                          child:  getImage(path:'images/verification_code.svg',isSvg: true , height: MediaQuery.of(context).size.height * (238 / 800),),
                        ),
                        SizedBox(
                          height: 38.h,
                        ),
                        DefaultText(
                          text: 'My dexef',
                          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 43, mobileFontSize: 41.sp),
                          fontFamily: AppFontStyle.appFontFamily.readex,
                          fontWeight: FontWeight.w400,
                          fontColor: brush,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  ResponsiveWidget(
                    localWidthRatio: ratioLogoMiniWidth,
                    fixedHeight: MediaQuery.of(context).size.height *
                        ratioLogoMiniHeight,
                    bottomPadding: MediaQuery.of(context).size.height *
                        ratioHeightUnderLogo,
                    child:getImage(path: 'images/dexef_logo_body.svg',isSvg: true ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: AppScreenSize.appWidgetSize.getLoginRightPanelWidth(context),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Directionality(
                      textDirection: context.locale.languageCode == 'en' ? ui.TextDirection.ltr : ui.TextDirection.rtl,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ResponsiveWidget(
                            localWidthRatio: ratioWidthComponentLogin,
                            child: DefaultText(
                              text: AppLocalizations.of(context)!.translate('accountLinked'),
                              isTextTheme: true,
                              themeStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: success,
                                  height: 1.5,
                                  fontWeight:  FontWeight.w400,
                                  fontFamily: AppFontStyle.appFontFamily.readex
                              )
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ResponsiveWidget(
                            localWidthRatio: ratioWidthComponentLogin,
                            child: DefaultText(
                              text:AppLocalizations.of(context)!.translate('verifyData'),
                              isTextTheme: true,
                              themeStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                                color:brushLines,
                                fontWeight:  FontWeight.w400,
                                fontFamily: AppFontStyle.appFontFamily.readex,
                                fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 10, mobileFontSize: 8.sp)
                              )
                            )
                          ),
                          const SizedBox(
                            height: 36,
                          ),
                          ResponsiveWidget(
                            localWidthRatio: ratioWidthComponentLogin,
                            fixedHeight: 68,
                            child: CustomTextFormField(
                              label: AppLocalizations.of(context)!.translate('name'),
                              autoFocus: false,
                              controller: nameController,
                              readOnly: !(nameController.text == '' && args.isApple == true),
                              // readOnly: args.name != null ? true : false,
                              validator: (value) {
                                if (value! == "Invalid Name") {
                                  return AppLocalizations.of(context)!.translate('requireName');
                                }
                                return null;
                              },
                              onFieldSubmitted: state
                              is RegisterByGoogleStateLoading ||
                                  state is RegisterFacebookLoading
                                  ? (_) {}
                                  : (_) async {
                                if (formKey.currentState!.validate()) {
                                  if (phoneNumber == null) {
                                    // Fluttertoast.showToast(msg: "Phone Number Require!");
                                  } else {
                                    String? phone = phoneNumber!.startsWith('0')
                                        ? phoneNumber!.replaceFirst('0', '')
                                        : phoneNumber;
                                    if (args.isGoogle == true) {
                                      await verifyPhoneGoogleFaceCubit?.registerByGoogle(
                                          token: args.token,
                                          email: args.email ?? emailController.text,
                                          mobile: phoneNumber!,
                                          countryCode: countryCode!.substring(1).trim(),
                                          sourceId: 2);
                                      log('token = ${args.token}');
                                      log('email = ${args.email}');
                                      log('phoneNumber = ${countryCode! + phone!}');
                                      log('countryCode = ${countryCode!.substring(1).trim()}');
                                    } else if (args.isFacebook == true) {
                                      await verifyPhoneGoogleFaceCubit?.registerByFacebook(
                                          token: args.token,
                                          email: args.email ?? emailController.text,
                                          mobile: phoneNumber!,
                                          countryCode: countryCode!.substring(1).trim(),
                                          sourceId: 2);
                                    } else if (args.isApple == true) {
                                      await verifyPhoneGoogleFaceCubit?.registerByApple(
                                          token: args.token,
                                          email: args.email ?? emailController.text,
                                          mobile: phoneNumber!,
                                          countryCode: countryCode!.substring(1).trim(),
                                          sourceId: 1);
                                    }
                                  }
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          ResponsiveWidget(
                            localWidthRatio: ratioWidthComponentLogin,
                            fixedHeight: 68,
                            child: CustomTextFormField(
                              autoFocus: false,
                              label: AppLocalizations.of(context)!.translate('email'),
                              controller: emailController,
                              readOnly: (args.email != null || args.email != 'null' && args.email != "Invalid Email")
                                  ? true
                                  : false,
                              validator: (value) {
                                if (value! == "Invalid Email") {
                                  return AppLocalizations.of(context)!.translate('requireMail');
                                }
                                else if (!emailRegexNew.hasMatch(value)) {
                                  return AppLocalizations.of(context)!.translate('invalidEmail');
                                }
                                return null;
                              },
                              onFieldSubmitted: state
                              is RegisterByGoogleStateLoading ||
                                  state is RegisterFacebookLoading
                                  ? (_) {}
                                  : (_) async {
                                if (formKey.currentState!.validate()) {
                                  if (phoneNumber == null) {
                                    // Fluttertoast.showToast(msg: "Phone Number Require!");
                                  } else {
                                    String? phone = phoneNumber!.startsWith('0')
                                        ? phoneNumber!.replaceFirst('0', '')
                                        : phoneNumber;
                                    if (args.isGoogle == true) {
                                      await verifyPhoneGoogleFaceCubit?.registerByGoogle(
                                          token: args.token,
                                          email: args.email ?? emailController.text,
                                          mobile: phoneNumber!,
                                          countryCode: countryCode!.substring(1).trim(),
                                          sourceId: 2);
                                      log('token = ${args.token}');
                                      log('email = ${args.email}');
                                      log('phoneNumber = ${countryCode! + phone!}');
                                      log('countryCode = ${countryCode!.substring(1).trim()}');
                                    } else if (args.isFacebook == true) {
                                      await verifyPhoneGoogleFaceCubit?.registerByFacebook(
                                          token: args.token,
                                          email: args.email ?? emailController.text,
                                          mobile: phoneNumber!,
                                          countryCode: countryCode!.substring(1).trim(),
                                          sourceId: 2);
                                    } else if (args.isApple == true) {
                                      await verifyPhoneGoogleFaceCubit?.registerByApple(
                                          token: args.token,
                                          email: args.email ?? emailController.text,
                                          mobile: phoneNumber!,
                                          countryCode: countryCode!.substring(1).trim(),
                                          sourceId: 1);
                                    }
                                  }
                                }

                              },
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          // WidgetResponsiveBuilder(
                          //   localWidthRatio: ratioWidthComponentLogin,
                          //   fixedHeight: 68,
                          //   child: IntlPhoneField(
                          //     onSubmitted: (value) {
                          //       nextPressed(args);
                          //     },
                          //     dropdownIcon: const Icon(
                          //       Icons.arrow_drop_down,
                          //       color: Colors.black,
                          //     ),
                          //     controller: phoneController,
                          //     // pickerDialogStyle: PickerDialogStyle,
                          //     dropdownTextStyle: const TextStyle(
                          //         color: Colors.black, fontSize: 14),
                          //     showCountryFlag: false,
                          //     dropdownIconPosition: IconPosition.trailing,
                          //     // pickerDialogStyle: PickerDialogStyle(
                          //     //   width: 300,
                          //     // ),
                          //
                          //     flagsButtonPadding: const EdgeInsets.only(left: 15),
                          //     initialCountryCode: "EG",
                          //     // invalidNumberMessage: AppLocalizations.of(context)!.translate('invalidPhoneNumber'),
                          //     invalidNumberMessage: '',
                          //     disableLengthCheck: false,
                          //     style: TextStyle(
                          //         fontSize: AppFontSize.getFontSize(context, 16),
                          //         color: Colors.black),
                          //     decoration: InputDecoration(
                          //         errorStyle: const TextStyle(height: .5),
                          //         helperStyle: const TextStyle(color: Colors.black),
                          //         labelStyle: const TextStyle(
                          //             color: brushLines, fontSize: 14),
                          //         labelText: AppLocalizations.of(context)!.translate('phoneNumber'),
                          //         border: OutlineInputBorder(
                          //           borderRadius: BorderRadius.circular(25),
                          //           borderSide: BorderSide(color:state is RegisterByGoogleStateError ? redColor : brushBorder),
                          //         ),
                          //         enabledBorder: OutlineInputBorder(
                          //             borderRadius: BorderRadius.circular(25),
                          //             borderSide:  BorderSide(
                          //               color: state is RegisterByGoogleStateError ? redColor :brushBorder,
                          //             )),
                          //         focusedBorder: OutlineInputBorder(
                          //             borderRadius: BorderRadius.circular(25),
                          //             borderSide: BorderSide(color:state is RegisterByGoogleStateError ? redColor : selectedBorder)),
                          //         errorBorder: OutlineInputBorder(
                          //             borderRadius: BorderRadius.circular(25),
                          //             borderSide:
                          //             const BorderSide(color: Colors.red))),
                          //     autovalidateMode: AutovalidateMode.disabled,
                          //     validator: (value) {
                          //       print('222222222222222${value?.number}');
                          //       if (value!.number.isEmpty) {
                          //         return AppLocalizations.of(context)!.translate('required');
                          //       } else if (!phoneNumberRegex
                          //           .hasMatch(value.number)) {
                          //         return AppLocalizations.of(context)!.translate('invalidPhoneNumber');
                          //       }
                          //       return null;
                          //     },
                          //
                          //     onChanged: (phone) {
                          //       if (phoneController.text.startsWith('0')) {
                          //         phoneController.value = TextEditingValue(
                          //           text: phoneController.text.substring(1),
                          //           selection: TextSelection.fromPosition(
                          //             TextPosition(offset: phoneController.text.length - 1),
                          //           ),
                          //         );
                          //       }
                          //       phoneNumber = phone.number;
                          //       countryCode = phone.countryCode;
                          //       // print(phoneNumber![phoneNumber!.length - 1]);
                          //       // print("countryCode $countryCode");
                          //     },
                          //
                          //     onCountryChanged: (country) {
                          //       print(country.dialCode);
                          //       countryCode = country.dialCode;
                          //       print("countryCode $countryCode");
                          //     },
                          //   ),
                          // ),

                          Theme(
                            data: Theme.of(context).copyWith(
                              textTheme: const TextTheme(
                                titleMedium: TextStyle(color:brush,),
                                bodyMedium: TextStyle(color: cannot),
                              ),
                            ),
                            child:  ResponsiveWidget(
                              localWidthRatio: ratioWidthComponentLogin,
                              child: InternationalPhoneNumberInput(
                                initialValue: number,
                                searchBoxDecoration: const InputDecoration(
                                  hintStyle: TextStyle(color: Colors.blue),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                                /////
                                // focusNode: phoneFocusNode,
                                spaceBetweenSelectorAndTextField: 0,
                                textFieldController: phoneController,
                                maxLength: maxLength,
                                autofillHints: [AutofillHints.telephoneNumberNational],
                                onFieldSubmitted: (value) {
                                  nextPressed(args);
                                },
                                onInputValidated: (value) {},
                                formatInput: false,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!.translate('required');
                                  } else if (!phoneNumberRegex1.hasMatch(value)) {
                                    return AppLocalizations.of(context)!.translate('invalidPhoneNumber');
                                  }
                                  return null;
                                },
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 16, mobileFontSize: 14.sp),
                                ),
                                selectorConfig: const SelectorConfig(
                                  selectorType: PhoneInputSelectorType.DIALOG,
                                  setSelectorButtonAsPrefixIcon: true,
                                  showFlags: false,
                                  leadingPadding: 10,
                                  trailingSpace: false,
                                ),
                                inputDecoration:  InputDecoration(
                                    errorStyle: const TextStyle(height: .5),
                                    helperStyle: const TextStyle(color: Colors.black),
                                    labelStyle: TextStyle(
                                        color: brushLines, fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 14, mobileFontSize: 12.sp)),
                                    labelText: AppLocalizations.of(context)!.translate('phoneNumber'),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(color:state is RegisterByGoogleStateError ? redColor : brushBorder),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide:  BorderSide(
                                          color: state is RegisterByGoogleStateError ? redColor :brushBorder,
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: BorderSide(color:state is RegisterByGoogleStateError ? redColor : selectedBorder)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide:
                                        const BorderSide(color: Colors.red))),
                                onInputChanged: (phone) {
                                  // phoneNumber = phone.phoneNumber;
                                  // countryCode = phone.dialCode.toString();
                                  print('Phone number ===$phoneNumber');
                                  print('countryCode ===${phone.dialCode}');
                                  phoneNumber = phone.phoneNumber;
                                  countryCode = phone.dialCode;
                                  setState(() {
                                    verifyPhoneGoogleFaceCubit?.errorMessage = null;
                                    if (phoneController.text.startsWith('0')) {
                                      phoneController.value = TextEditingValue(
                                        text: phoneController.text.substring(1),
                                        selection: TextSelection.fromPosition(
                                          TextPosition(offset: phoneController.text.length - 1),
                                        ),
                                      );
                                    }
                                    maxLength = countries
                                        .firstWhere((element) => element.dialCode.toString() == phone.dialCode?.substring(1).toString())
                                        .maxLength;
                                  });
                                },
                                inputBorder: InputBorder.none,
                              ),
                            ),
                          ),
                          ResponsiveWidget(
                            localWidthRatio: ratioWidthComponentLogin,
                            child: DefaultText(
                              text: verifyPhoneGoogleFaceCubit?.errorMessage ?? '',
                              isTextTheme: true,
                              maxLines: 2,
                              themeStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                                color: redColor,
                                height: 1.5,
                                fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 10, mobileFontSize: 8.sp),
                              )
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          ResponsiveWidget(
                            fixedHeight: 48,
                            localWidthRatio: ratioWidthComponentLogin,
                            child: CustomRoundedButton(
                                title: AppLocalizations.of(context)!.translate('next'),
                                isLoading: state is RegisterByGoogleStateLoading || state is RegisterFacebookLoading ? true : false,
                                onPressed: state is RegisterByGoogleStateLoading || state is RegisterFacebookLoading ? () {
                                  debugPrint('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
                                }:() async {
                                  nextPressed(args);
                                }),
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

////////////////////////////////////////////////////////////////////////////////
//   Widget _buildStack(BuildContext context, VerifyPhoneGoogleFaceStates state, ArgumentsVerifyPhoneNumber args) =>
//       Stack(
//         alignment: Alignment.centerLeft,
//         children: [
//           AnimatedSlide(
//             offset: getLocation(),
//             duration: Duration(milliseconds: 300),
//             child: AnimatedOpacity(
//               opacity: opacity,
//               duration: Duration(milliseconds: 300),
//               child: Container(
//                 height: MediaQuery.of(context).size.height,
//                 width: AppScreenSize.getLoginRightPanelWidth(context),
//                 child: Center(
//                   child: SingleChildScrollView(
//                     child: Form(
//                       key: formKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           WidgetResponsiveBuilder(
//                             localWidthRatio: ratioWidthComponentLogin,
//                             child: DefaultText(
//                               text: AppLocalizations.of(context)!.translate('accountLinked'),
//                               fontSize: AppFontSize.getFontSize(context, 32),
//                               fontFamily: 'DXRound',
//                               fontWeight: FontWeight.w400,
//                               fontColor: success,
//                             ),
//                           ),
//                           WidgetResponsiveBuilder(
//                             localWidthRatio: ratioWidthComponentLogin,
//                             child: DefaultText(
//                               text: AppLocalizations.of(context)!.translate('verifyData'),
//                               fontSize: AppFontSize.getFontSize(context, 16),
//                               fontColor: brushLines,
//                               fontFamily: 'DXRound',
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 30,
//                           ),
//                           WidgetResponsiveBuilder(
//                             localWidthRatio: ratioWidthComponentLogin,
//                             fixedHeight: 68,
//                             child: CustomTextFormField(
//                               label: AppLocalizations.of(context)!.translate('name'),
//                               autoFocus: false,
//                               controller: nameController,
//                               readOnly: !(nameController.text == '' && args.isApple == true),
//
//                               validator: (value) {
//                                 if (value! == "Invalid Name") {
//                                   return AppLocalizations.of(context)!.translate('requireName');
//                                 }
//                                 // return null;
//                               },
//                               onFieldSubmitted: state
//                               is RegisterByGoogleStateLoading ||
//                                   state is RegisterFacebookLoading
//                                   ? (_) {}
//                                   : (_) async {
//                                 if (formKey.currentState!.validate()) {
//                                   if (phoneNumber == null) {
//                                     // Fluttertoast.showToast(msg: "Phone Number Require!");
//                                   } else {
//                                     String? phone = phoneNumber!.startsWith('0')
//                                         ? phoneNumber!.replaceFirst('0', '')
//                                         : phoneNumber;
//                                     if (args.isGoogle == true) {
//                                       await verifyPhoneGoogleFaceCubit?.registerByGoogle(
//                                           token: args.token,
//                                           email: args.email ?? emailController.text,
//                                           mobile: phoneNumber!,
//                                           countryCode: countryCode!.substring(1).trim(),
//                                           sourceId: 2);
//                                       log('token = ${args.token}');
//                                       log('email = ${args.email}');
//                                       log('phoneNumber = ${countryCode! + phone!}');
//                                       log('countryCode = ${countryCode!.substring(1).trim()}');
//                                     } else if (args.isFacebook == true) {
//                                       await verifyPhoneGoogleFaceCubit?.registerByFacebook(
//                                           token: args.token,
//                                           email: args.email ?? emailController.text,
//                                           mobile: phoneNumber!,
//                                           countryCode: countryCode!.substring(1).trim(),
//                                           sourceId: 2);
//                                     } else if (args.isApple == true) {
//                                       await verifyPhoneGoogleFaceCubit?.registerByApple(
//                                           token: args.token,
//                                           email: args.email ?? emailController.text,
//                                           mobile: phoneNumber!,
//                                           countryCode: countryCode!.substring(1).trim(),
//                                           sourceId: 1);
//                                     }
//                                   }
//                                 }
//                                 },
//                             ),
//                           ),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           WidgetResponsiveBuilder(
//                             localWidthRatio: ratioWidthComponentLogin,
//                             fixedHeight: 68,
//                             child: CustomTextFormField(
//                               autoFocus: false,
//                               label: AppLocalizations.of(context)!.translate('email'),
//                               controller: emailController,
//                               readOnly: emailController.text != "Invalid Email"
//                                   ? true
//                                   : false,
//                               validator: (value) {
//                                 if (value! == "Invalid Email") {
//                                   return AppLocalizations.of(context)!.translate('required');
//                                 }
//                                 else if (!emailRegexNew.hasMatch(value)) {
//                                   return AppLocalizations.of(context)!.translate('invalidEmail');
//                                 }
//                                 return null;
//                               },
//                               onFieldSubmitted: state
//                               is RegisterByGoogleStateLoading ||
//                                   state is RegisterFacebookLoading
//                                   ? (_) {}
//                                   : (_) async {
//                                 if (formKey.currentState!.validate()) {
//                                   if (phoneNumber == null) {
//                                     // Fluttertoast.showToast(msg: "Phone Number Require!");
//                                   } else {
//                                     String? phone = phoneNumber!.startsWith('0')
//                                         ? phoneNumber!.replaceFirst('0', '')
//                                         : phoneNumber;
//                                     if (args.isGoogle == true) {
//                                       await verifyPhoneGoogleFaceCubit?.registerByGoogle(
//                                           token: args.token,
//                                           email: args.email ?? emailController.text,
//                                           mobile: phoneNumber!,
//                                           countryCode: countryCode!.substring(1).trim(),
//                                           sourceId: 2);
//                                       log('token = ${args.token}');
//                                       log('email = ${args.email}');
//                                       log('phoneNumber = ${countryCode! + phone!}');
//                                       log('countryCode = ${countryCode!.substring(1).trim()}');
//                                     } else if (args.isFacebook == true) {
//                                       await verifyPhoneGoogleFaceCubit?.registerByFacebook(
//                                           token: args.token,
//                                           email: args.email ?? emailController.text,
//                                           mobile: phoneNumber!,
//                                           countryCode: countryCode!.substring(1).trim(),
//                                           sourceId: 2);
//                                     } else if (args.isApple == true) {
//                                       await verifyPhoneGoogleFaceCubit?.registerByApple(
//                                           token: args.token,
//                                           email: args.email ?? emailController.text,
//                                           mobile: phoneNumber!,
//                                           countryCode: countryCode!.substring(1).trim(),
//                                           sourceId: 1);
//                                     }
//                                   }
//                                 }
//                                 },
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           WidgetResponsiveBuilder(
//                             localWidthRatio: ratioWidthComponentLogin,
//                             fixedHeight: 48,
//                             child: IntlPhoneField(
//                               onSubmitted: (value) {
//                                 Fluttertoast.showToast(msg: 'dfesef');
//                               },
//                               dropdownIcon: Icon(
//                                 Icons.arrow_drop_down,
//                                 color: Colors.black,
//                               ),
//                               controller: phoneController,
//                               // pickerDialogStyle: PickerDialogStyle,
//                               dropdownTextStyle:
//                               TextStyle(color: Colors.black, fontSize: 14),
//                               showCountryFlag: false,
//                               dropdownIconPosition: IconPosition.trailing,
//                               pickerDialogStyle: PickerDialogStyle(
//                                 width: 300,
//                               ),
//                               flagsButtonPadding: EdgeInsets.only(left: 15),
//                               initialCountryCode: "EG",
//                               invalidNumberMessage: AppLocalizations.of(context)!.translate('invalidPhoneNumber'),
//                               disableLengthCheck: true,
//                               style: TextStyle(
//                                   fontSize:
//                                   AppFontSize.getFontSize(context, 16),
//                                   color: Colors.black),
//                               decoration: InputDecoration(
//                                   errorStyle: TextStyle(height: .5),
//                                   helperStyle: TextStyle(color: Colors.black),
//                                   labelStyle: TextStyle(
//                                       color: brushLines, fontSize: 14),
//                                   labelText: AppLocalizations.of(context)!.translate('phoneNumber'),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(25),
//                                     borderSide: BorderSide(color: brushBorder),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(25),
//                                       borderSide: BorderSide(
//                                         color: brushBorder,
//                                       )),
//                                   focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(25),
//                                       borderSide:
//                                       BorderSide(color: selectedBorder)),
//                                   errorBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(25),
//                                       borderSide:
//                                       BorderSide(color: Colors.red))),
//                               autovalidateMode:
//                               AutovalidateMode.onUserInteraction,
//                               validator: (value) {
//                                 print(value!.number);
//                                 if (value.number.isEmpty) {
//                                   return  AppLocalizations.of(context)!.translate('required');
//                                 } else if (!phoneNumberRegex
//                                     .hasMatch(value.number)) {
//                                   return AppLocalizations.of(context)!.translate('invalidPhoneNumber');
//                                 }
//                                 return null;
//                               },
//                               onChanged: (phone) {
//                                 phoneNumber = phone.number;
//                                 countryCode = phone.countryCode;
//                                 print(phoneNumber![phoneNumber!.length - 1]);
//                                 print("countryCode $countryCode");
//                               },
//                               onCountryChanged: (country) {
//                                 print(country.dialCode);
//                                 countryCode = country.dialCode;
//                                 print("countryCode $countryCode");
//                               },
//                             ),
//                           ),
//                           SizedBox(
//                             height: 50,
//                           ),
//                           WidgetResponsiveBuilder(
//                             fixedHeight: 48,
//                             localWidthRatio: ratioWidthComponentLogin,
//                             child: CustomRoundedButton(
//                                 title:AppLocalizations.of(context)!.translate('next'),
//                                 isLoading: state is RegisterByGoogleStateLoading || state is RegisterFacebookLoading ? true : false,
//                                 onPressed: state is RegisterByGoogleStateLoading ||state is RegisterFacebookLoading ? null
//                                     : () async {
//                                   if (formKey.currentState!.validate()) {
//                                     if (phoneNumber == null) {
//                                       // Fluttertoast.showToast(msg: "Phone Number Require!");
//                                     } else {
//                                       String? phone = phoneNumber!.startsWith('0')
//                                           ? phoneNumber!.replaceFirst('0', '')
//                                           : phoneNumber;
//                                       if (args.isGoogle == true) {
//                                         await verifyPhoneGoogleFaceCubit?.registerByGoogle(
//                                             token: args.token,
//                                             email: args.email ?? emailController.text,
//                                             mobile: phoneNumber!,
//                                             countryCode: countryCode!.substring(1).trim(),
//                                             sourceId: 2);
//                                         log('token = ${args.token}');
//                                         log('email = ${args.email}');
//                                         log('phoneNumber = ${countryCode! + phone!}');
//                                         log('countryCode = ${countryCode!.substring(1).trim()}');
//                                       } else if (args.isFacebook == true) {
//                                         await verifyPhoneGoogleFaceCubit?.registerByFacebook(
//                                             token: args.token,
//                                             email: args.email ?? emailController.text,
//                                             mobile: phoneNumber!,
//                                             countryCode: countryCode!.substring(1).trim(),
//                                             sourceId: 2);
//                                       } else if (args.isApple == true) {
//                                         await verifyPhoneGoogleFaceCubit?.registerByApple(
//                                             token: args.token,
//                                             email: args.email ?? emailController.text,
//                                             mobile: phoneNumber!,
//                                             countryCode: countryCode!.substring(1).trim(),
//                                             sourceId: 1);
//                                       }
//                                     }
//                                   }
//                                 }),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Visibility(
//             //visible: true,
//             visible: (MediaQuery.of(context).size.width < AppConstants.minimumScreenSize) ? false : true,
//             child: Container(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width -
//                   AppScreenSize.getLoginRightPanelWidth(context),
//               decoration: BoxDecoration(color: cloudBackground, boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(.16),
//                   offset: Offset(0, 0),
//                   blurRadius: 12.0,
//                 )
//               ]),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Visibility(
//                   //   visible: false,
//                   //   child: Row(
//                   //     children: [
//                   //       InkWell(
//                   //         onTap: () {
//                   //           Navigator.pop(context);
//                   //         },
//                   //         child: Padding(
//                   //           padding:
//                   //               EdgeInsets.only(top: 50, left: 50, right: 50),
//                   //           child: SvgPicture.asset("assets/images/back.svg"),
//                   //         ),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                   Column(
//                     children: [
//                       WidgetResponsiveBuilder(
//                           localWidthRatio: 188 / 640,
//                           child:
//                           getImage(path: 'images/app_logo.svg',isSvg: true,  height: MediaQuery.of(context).size.height *
//                               (214 / 800), ),
//                       ),
//                       SizedBox(
//                         height: 38.h,
//                       ),
//                       DefaultText(
//                         text: 'Smart Restaurant POS',
//                         isTextTheme: true,
//                         themeStyle: Theme.of(context).textTheme.headlineLarge!.copyWith(
//                             color:brush,
//                             height: 1.5,
//                             fontWeight:  FontWeight.w400,
//                             fontFamily: AppFontFamily.dexefRound
//                         )
//                       ),
//                     ],
//                   ),
//                   WidgetResponsiveBuilder(
//                     localWidthRatio: ratioLogoMiniWidth,
//                     fixedHeight: MediaQuery.of(context).size.height * ratioLogoMiniHeight,
//                     bottomPadding: MediaQuery.of(context).size.height * ratioHeightUnderLogo,
//                     child:getImage(path: 'images/dexef_logo_body.svg',isSvg: true ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );

  void nextPressed(ArgumentsVerifyPhoneNumber args) async {
    if (formKey.currentState!.validate()) {
      if (phoneNumber == null) {
        // Fluttertoast.showToast(msg: "Phone Number Require!");
      } else {
        String? phone = phoneNumber!.startsWith('0')
            ? phoneNumber!.replaceFirst('0', '')
            : phoneNumber;
        if (args.isGoogle == true) {
          await verifyPhoneGoogleFaceCubit?.registerByGoogle(
              token: args.token,
              email: args.email ?? emailController.text,
              mobile: phoneNumber!,
              countryCode: countryCode!.substring(1).trim(),
              sourceId: 2);
          log('token = ${args.token}');
          log('email = ${args.email}');
          log('phoneNumber = ${countryCode! + phone!}');
          log('countryCode = ${countryCode!.substring(1).trim()}');
        } else if (args.isFacebook == true) {
          await verifyPhoneGoogleFaceCubit?.registerByFacebook(
              token: args.token,
              email: args.email ?? emailController.text,
              mobile: phoneNumber!,
              countryCode: countryCode!.substring(1).trim(),
              sourceId: 2);
        } else if (args.isApple == true) {
          await verifyPhoneGoogleFaceCubit?.registerByApple(
              token: args.token,
              email: args.email ?? emailController.text,
              mobile: phoneNumber!,
              countryCode: countryCode!.substring(1).trim(),
              sourceId: 1);
        }
      }
    }
  }
}

// SizedBox(
//   height: 75,
//   width: 394,
//   child: IntlPhoneField(dropdownIcon: Icon(Icons.arrow_drop_down,color:  Colors.black,),
//     controller: phoneController,
//     flagsButtonPadding: EdgeInsets.only(left: 15),
//     showCountryFlag: false,dropdownIconPosition: IconPosition.trailing,
//     pickerDialogStyle: PickerDialogStyle(width: 300,),
//     dropdownTextStyle: TextStyle(color: Colors.black,fontSize: 14),
//     initialCountryCode: "EG",
//     invalidNumberMessage: "invalid phone number",
//     style: TextStyle(fontSize: 14, color :Colors.black),
//     decoration: InputDecoration(
//         helperStyle: TextStyle(color:  Colors.black),
//         labelStyle: TextStyle(color: greyTextColor,fontSize: 14),
//         labelText: "Phone Number",
//         border: OutlineInputBorder(
//           borderSide: BorderSide(
//               color: textFieldBorderColor
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(25),
//             borderSide: BorderSide(
//               color:textFieldBorderColor,
//             )
//         ),
//         focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(25),
//             borderSide: BorderSide(
//                 color: textFieldBorderColor
//             )
//         ),
//         errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(25),
//             borderSide: BorderSide(
//                 color: Colors.red
//             )
//         )
//
//     ),
//     onChanged: (phone) {
//       phoneNumber = phone.number;
//       countryCode = phone.countryCode;
//       print(phoneNumber);
//       print(countryCode);
//     },
//     autovalidateMode: AutovalidateMode.onUserInteraction,
//     validator: (value){
//       print(value!.number);
//       if (value.number.isEmpty){
//         return "required";
//       } else if (!phoneNumberRegex.hasMatch(value.number)) {
//         return "invalid phone number";
//       }
//       return null;
//     },
//     onCountryChanged: (country) {
//       print(country.dialCode);
//       countryCode =  country.dialCode;
//     },
//   ),
// ),

// Container(
//   // height: 60,
//   padding: EdgeInsets.symmetric(horizontal: 15),
//   decoration: BoxDecoration(
//       border: Border.all(color: textFieldBorderColor),
//       borderRadius: BorderRadius.circular(25)),
//   child: InternationalPhoneNumberInput(
//     textFieldController: phoneController,
//     textStyle: TextStyle(fontSize: 16),
//     initialValue: number,
//     selectorConfig: SelectorConfig(
//       selectorType: PhoneInputSelectorType.DIALOG,
//     ),
//     onInputChanged: (phone) {
//       phoneNumber = phone.phoneNumber;
//       countryCode = phone.dialCode;
//       // print('ssssss= ${phone.phoneNumber}');
//       // print('ffffff= ${phone.dialCode}');
//     },
//     inputBorder: InputBorder.none,
//   ),
// ),
/////////////////////////////////////////////////////////////////////////////////////////////////////////////// the button
// ConditionalBuilder(
//   condition: state is !RegisterByGoogleStateLoading,
//   builder: (context) => CustomRoundedButton(
//       title: "Next",
//       onPressed: () async {
//         if(formKey.currentState!.validate()){
//           if(phoneNumber  == null){
//             Fluttertoast.showToast(msg: "Phone Number Require!");
//           }else {
//             String? phone = phoneNumber!.startsWith('0') ? phoneNumber!.replaceFirst('0', '') : phoneNumber;
//             if(args.isGoogle == true){
//               await registerByGoogleFacebookCubit?.registerByGoogle(
//                   token: args.token,
//                   email: args.email,
//                   mobile: countryCode!+phone!,
//                   countryCode: countryCode!.substring(1).trim(),
//                   sourceId: 2
//               );
//               print('token = ${args.token}');
//               print('email = ${args.email}');
//               print('phoneNumber = ${countryCode!+phone!}');
//               print('countryCode = ${countryCode!.substring(1).trim()}');
//             }else if (args.iFacebook == true){
//               await registerByGoogleFacebookCubit?.registerByFacebook(
//                   token: args.token,
//                   email:  args.email,
//                   mobile: countryCode!+phone!,
//                   countryCode: countryCode!.substring(1).trim(),
//                   sourceId: 2
//               );
//             }
//           }
//         }
//       }),
//   fallback: (context) => CustomLoadingButton(),
// ),
