import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mydexef/core/class_constants/Routes.dart';
import 'package:mydexef/core/arguments.dart';
import 'package:mydexef/core/class_constants/constants_methods.dart';
import 'package:mydexef/core/widgets/custom_round_button.dart';
import 'package:mydexef/core/size_widgets/responsive_widget.dart';
import 'package:mydexef/core/widgets/default_text.dart';
import 'package:mydexef/core/size_widgets/app_font_style.dart';
import 'package:mydexef/features/auth/presentation/cubit/reset_password/reset_password_state.dart';
import 'package:mydexef/features/auth/presentation/cubit/verify_code/reset_verify_code.dart';
import 'package:mydexef/locator.dart' as di;
import 'package:mydexef/style/colors/colors.dart';
import 'package:mydexef/utils/cash_helper.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../../../../../core/class_constants/app_constants_values.dart';
import '../../../../../core/size_widgets/app_screen_size.dart';
import '../../../../../core/widgets/default_login_screen.dart';
import '../../../../../core/widgets/network_failed.dart';
import '../../../../../utils/app_localizations.dart';
import '../../../../../utils/constants.dart';
import 'dart:ui' as ui;

class ResetPasswordVerifyCode extends StatefulWidget {
  const ResetPasswordVerifyCode({Key? key}) : super(key: key);

  @override
  State<ResetPasswordVerifyCode> createState() =>
      _ResetPasswordVerifyCodeState();
}

class _ResetPasswordVerifyCodeState extends State<ResetPasswordVerifyCode>
    with WidgetsBindingObserver {
  TextEditingController codeControllerOne = TextEditingController();
  TextEditingController codeControllerTwo = TextEditingController();
  TextEditingController codeControllerThree = TextEditingController();
  TextEditingController codeControllerFour = TextEditingController();
  TextEditingController codeControllerFive = TextEditingController();
  TextEditingController codeControllerSix = TextEditingController();
  TextEditingController codeController = TextEditingController();
  FocusNode firstNode = FocusNode();
  FocusNode secondNode = FocusNode();
  FocusNode thirdNode = FocusNode();
  FocusNode fourthNode = FocusNode();
  FocusNode fiveNode = FocusNode();
  int userBlockCounter = 0;
  bool isCountDown = true;
  final formKey = GlobalKey<FormState>();

  // ResetPasswordCubit? resetPasswordCubit;
  bool visibleContainer = false;
  dynamic location;
  bool isTap = false;
  double opacity = 0.0;
  Orientation? orientation;
  bool isValidCode = true;
  ResetVerifyCodeCubit? resetVerifyCodeCubit;
  int mobileId = CacheHelper.getData(key: Constants.mobileId.toString());

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
    Future.delayed(Duration(milliseconds: 350), () {
      setState(() {
        isTap = true;
      });
    });
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  ////////////////////////////////////////////////////////////////////////////////
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        resetVerifyCodeCubit?.checkDate();
        break;
      case AppLifecycleState.inactive:
        // resetVerifyCodeCubit?.checkDate();
        break;
      case AppLifecycleState.paused:
        // resetVerifyCodeCubit?.checkDate();
        break;
      case AppLifecycleState.detached:
        // resetVerifyCodeCubit?.checkDate();
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  @override
  void didChangeDependencies() {
    resetVerifyCodeCubit?.checkDate();
    super.didChangeDependencies();
  }

////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context)!.settings.arguments as ArgumentsResetPasswordVerifyCode;
    orientation = MediaQuery.of(context).orientation;
    // getLoginFontSize(context);
    ArgumentsResetPasswordVerifyCode? args = CacheHelper.getObjectFromPrefs(
        key: Constants.verifyCodeSocialArguments.toString(),
        model: ArgumentsResetPasswordVerifyCode);
    int mobileId = CacheHelper.getData(key: Constants.mobileId.toString());
    resetVerifyCodeCubit?.checkDate();
    return BlocProvider(
      create: (context) => di.locator<ResetVerifyCodeCubit>(),
      child: BlocConsumer<ResetVerifyCodeCubit, ResetPasswordStates>(
        listener: (context, state) {
          if (state is VerifyForgetPasswordSuccess) {
            //Fluttertoast.showToast(msg: 'Success');
            //Navigator.of(context).pushNamedAndRemoveUntil(CreateNewPasswordScreen.route, (route) => false);

            CacheHelper.saveObjectToPrefs(
                key: Constants.createNewPasswordArguments.toString(),
                object: ArgumentsCreateNewPassword(
                  mobileID: args?.mobileID ?? mobileId,
                  code:
                      "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                ));

            Router.neglect(context, () {
              context.go(Routes.createNewPasswordScreen);
            });
          } else if (state is VerifyForgetPasswordFailed) {
            // showAlertDialog(
            //     context: context,
            //     isSuccess: false,
            //     title: AppLocalizations.of(context)!.translate('networkFailed'),
            //     subTitle: getErrorMessage(state.message),
            //     textColor: Colors.black);
          } else if (state is VerifyForgetPasswordError) {
            // showAlertDialog(
            //     context: context,
            //     isSuccess: false,
            //     title: AppLocalizations.of(context)!
            //         .translate('resetPasswordFailed'),
            //     subTitle: state.message,
            //     textColor: Colors.black);
          }
          // else if (state is ResendCodeSuccess || state is VerifyForgetPasswordSuccess) {
          //   resetVerifyCodeCubit?.checkDate();
          // }
        },
        builder: (context, state) {
          resetVerifyCodeCubit = ResetVerifyCodeCubit.get(context);
          final size = MediaQuery.of(context).size;
          return DefaultLoginScreen(
            isLoading: state is LoadingStateVerifyCode || State is LoadingState,
            body: args != null
                // ? (isTap == true || (kIsWeb && MediaQuery.of(context).size.shortestSide < 600)) ||(orientation == Orientation.portrait)
                ? _buildRow(size, state, args)
                // : _buildStack(size, state, args)
                : Center(child: NetworkFailed()),
          );
        },
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////
  Widget _buildRow(var size, ResetPasswordStates state,
          ArgumentsResetPasswordVerifyCode args) =>
      AbsorbPointer(
        absorbing: state is LoadingState || state is LoadingStateVerifyCode,
        child: Row(
          children: [
            Container(
              width:
                  size.width - AppScreenSize.appWidgetSize.getLoginRightPanelWidth(context),
              height: MediaQuery.of(context).size.height,
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
                  // Row(
                  //   children: [
                  //     InkWell(
                  //       onTap: () {
                  //         Navigator.pop(context);
                  //       },
                  //       child: Padding(
                  //         padding:
                  //             EdgeInsets.only(top: 50, left: 50, right: 50),
                  //         child: MouseRegion(
                  //           cursor: SystemMouseCursors.click,
                  //           child: SvgPicture.asset("assets/images/back.svg"),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ResponsiveWidget(
                          localWidthRatio: 388 / 640,
                          child: getImage(
                            path: 'images/verification_code.svg',
                            isSvg: true,
                            height: MediaQuery.of(context).size.height *
                                (238 / 800),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        DefaultText(
                            text: AppLocalizations.of(context)!
                                .translate('verifyDescriptionMainScreen'),
                            align: TextAlign.center,
                            isMultiLine: true,
                            isTextTheme: true,
                            themeStyle: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w500,
                                    wordSpacing: 1.5,
                                    height: 1.5,
                                    fontFamily:
                                        AppFontStyle.appFontFamily.readex)),
                      ],
                    ),
                  ),
                  ResponsiveWidget(
                    localWidthRatio: ratioLogoMiniWidth,
                    fixedHeight: MediaQuery.of(context).size.height *
                        ratioLogoMiniHeight,
                    bottomPadding: MediaQuery.of(context).size.height *
                        ratioHeightUnderLogo,
                    child: getImage(
                        path: 'images/dexef_logo_body.svg', isSvg: true),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: AppScreenSize.appWidgetSize.getLoginRightPanelWidth(context),
              child: Form(
                key: formKey,
                child: Center(
                  child: Directionality(
                    textDirection: context.locale.languageCode == 'en'
                        ? ui.TextDirection.ltr
                        : ui.TextDirection.rtl,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DefaultText(
                            text: AppLocalizations.of(context)!
                                .translate('verificationCode'),
                            isTextTheme: true,
                            themeStyle: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: userLoginText,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: AppFontStyle.appFontFamily.readex,
                                )),
                        const SizedBox(
                          height: 16,
                        ),
                        ResponsiveWidget(
                          localWidthRatio: AppScreenSize.appDesignSize.isWebPlatform(context)
                              ? ratioWidthComponentLogin
                              : 0.8,
                          child: DefaultText(
                            isMultiLine: true,
                            text: AppLocalizations.of(context)!
                                .translate('enterVerify'),
                            isTextTheme: true,
                            themeStyle: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                  fontFamily: AppFontStyle.appFontFamily.readex,
                                ),
                            align: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Directionality(
                          textDirection: ui.TextDirection.ltr,
                          child: ResponsiveWidget(
                            localWidthRatio:
                                AppScreenSize.appDesignSize.isWebPlatform(context) ? 263 / 640 : 0.8,
                            fixedHeight: 68,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: brushBorder)),
                            child: Row(
                              children: [
                                Expanded(
                                    child: TextFormField(
                                  autofocus: true,
                                  maxLength: 1,
                                  controller: codeControllerOne,
                                  style: TextStyle(
                                      fontSize:
                                          AppFontStyle.appFontSize.setFontSize(context, webFontSize: 30, mobileFontSize: 28.sp),
                                      color: Colors.black),
                                  textAlign: TextAlign.center,
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return AppLocalizations.of(context)!
                                  //         .translate('required');
                                  //   }
                                  //   return null;
                                  // },
                                  focusNode: firstNode,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      secondNode.requestFocus();
                                    }
                                  },
                                  onFieldSubmitted: (_) {
                                    if (formKey.currentState!.validate()) {
                                      setState(() {
                                        resetVerifyCodeCubit?.errorMessage = '';
                                      });
                                      print(
                                          'aaaaaaaa${args.mobileID == 0 || args.mobileID == null ? mobileId : args.mobileID}');
                                      resetVerifyCodeCubit?.verifyForgetPassword(
                                          code:
                                              "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                          mobileID: args.mobileID == 0 ||
                                                  args.mobileID == null
                                              ? mobileId
                                              : args.mobileID);
                                    } else {
                                      setState(() {
                                        isValidCode = false;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                      counterText: "",
                                      border: InputBorder.none),
                                )),
                                Container(
                                  height: 68,
                                  width: 1,
                                  color: brushBorder,
                                ),
                                Expanded(
                                    child: TextFormField(
                                  controller: codeControllerTwo,
                                  style: TextStyle(
                                    fontSize:
                                        AppFontStyle.appFontSize.setFontSize(context, webFontSize: 30, mobileFontSize: 28.sp),
                                    color: Colors.black,
                                  ),
                                  maxLength: 1,
                                  textAlign: TextAlign.center,
                                  focusNode: secondNode,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      thirdNode.requestFocus();
                                    } else {
                                      firstNode.requestFocus();
                                    }
                                  },
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return AppLocalizations.of(context)!
                                  //         .translate('required');
                                  //   }
                                  //   return null;
                                  // },
                                  onFieldSubmitted: (_) {
                                    if (formKey.currentState!.validate()) {
                                      setState(() {
                                        resetVerifyCodeCubit?.errorMessage = '';
                                      });
                                      print(
                                          'aaaaaaaa${args.mobileID == 0 || args.mobileID == null ? mobileId : args.mobileID}');
                                      resetVerifyCodeCubit?.verifyForgetPassword(
                                          code:
                                              "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                          mobileID: args.mobileID == 0 ||
                                                  args.mobileID == null
                                              ? mobileId
                                              : args.mobileID);
                                    } else {
                                      setState(() {
                                        isValidCode = false;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                      counterText: "",
                                      border: InputBorder.none),
                                )),
                                Container(
                                  height: 68,
                                  width: 1,
                                  color: brushBorder,
                                ),
                                Expanded(
                                    child: TextFormField(
                                  maxLength: 1,
                                  controller: codeControllerThree,
                                  style: TextStyle(
                                    fontSize:
                                        AppFontStyle.appFontSize.setFontSize(context, webFontSize: 30, mobileFontSize: 28.sp),
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                  focusNode: thirdNode,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      fourthNode.requestFocus();
                                    } else {
                                      secondNode.requestFocus();
                                    }
                                  },
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return AppLocalizations.of(context)!
                                  //         .translate('required');
                                  //   }
                                  //   return null;
                                  // },

                                  onFieldSubmitted: (_) {
                                    if (formKey.currentState!.validate()) {
                                      setState(() {
                                        resetVerifyCodeCubit?.errorMessage = '';
                                      });
                                      print(
                                          'aaaaaaaa${args.mobileID == 0 || args.mobileID == null ? mobileId : args.mobileID}');
                                      resetVerifyCodeCubit?.verifyForgetPassword(
                                          code:
                                              "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                          mobileID: args.mobileID == 0 ||
                                                  args.mobileID == null
                                              ? mobileId
                                              : args.mobileID);
                                    } else {
                                      setState(() {
                                        isValidCode = false;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                      counterText: "",
                                      border: InputBorder.none),
                                )),
                                Container(
                                  height: 68,
                                  width: 1,
                                  color: brushBorder,
                                ),
                                Expanded(
                                    child: TextFormField(
                                  maxLength: 1,
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return AppLocalizations.of(context)!
                                  //         .translate('required');
                                  //   }
                                  //   return null;
                                  // },
                                  textAlign: TextAlign.center,
                                  controller: codeControllerFour,
                                  style: TextStyle(
                                      fontSize:
                                          AppFontStyle.appFontSize.setFontSize(context, webFontSize: 30, mobileFontSize: 28.sp),
                                      color: Colors.black),
                                  focusNode: fourthNode,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      fiveNode.requestFocus();
                                    } else {
                                      thirdNode.requestFocus();
                                    }
                                  },
                                  onFieldSubmitted: (_) {
                                    if (formKey.currentState!.validate()) {
                                      setState(() {
                                        resetVerifyCodeCubit?.errorMessage = '';
                                      });
                                      print(
                                          'aaaaaaaa${args.mobileID == 0 || args.mobileID == null ? mobileId : args.mobileID}');
                                      resetVerifyCodeCubit?.verifyForgetPassword(
                                          code:
                                              "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                          mobileID: args.mobileID == 0 ||
                                                  args.mobileID == null
                                              ? mobileId
                                              : args.mobileID);
                                    } else {
                                      setState(() {
                                        isValidCode = false;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                      counterText: "",
                                      border: InputBorder.none),
                                )),
                                Container(
                                  height: 68,
                                  width: 1,
                                  color: brushBorder,
                                ),
                                Expanded(
                                    child: TextFormField(
                                  maxLength: 1,
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return AppLocalizations.of(context)!
                                  //         .translate('required');
                                  //   }
                                  //   return null;
                                  // },
                                  textAlign: TextAlign.center,
                                  controller: codeControllerFive,
                                  onFieldSubmitted: (_) {
                                    if (formKey.currentState!.validate()) {
                                      setState(() {
                                        resetVerifyCodeCubit?.errorMessage = '';
                                      });
                                      print(
                                          'aaaaaaaa${args.mobileID == 0 || args.mobileID == null ? mobileId : args.mobileID}');
                                      resetVerifyCodeCubit?.verifyForgetPassword(
                                          code:
                                              "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                          mobileID: args.mobileID == 0 ||
                                                  args.mobileID == null
                                              ? mobileId
                                              : args.mobileID);
                                    } else {
                                      setState(() {
                                        isValidCode = false;
                                      });
                                    }
                                  },
                                  style: TextStyle(
                                      fontSize:
                                          AppFontStyle.appFontSize.setFontSize(context, webFontSize: 30, mobileFontSize: 28.sp),
                                      color: Colors.black),
                                  focusNode: fiveNode,
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      fourthNode.requestFocus();
                                    }
                                  },
                                  decoration: InputDecoration(
                                      counterText: "",
                                      border: InputBorder.none),
                                )),
                              ],
                            ),
                          ),
                        ),
                        ResponsiveWidget(
                          localWidthRatio: AppScreenSize.appDesignSize.isWebPlatform(context)
                              ? ratioWidthComponentLogin
                              : 0.8,
                          child: DefaultText(
                            text: resetVerifyCodeCubit?.errorMessage ?? '',
                            isTextTheme: true,
                            themeStyle: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: redColor,
                                ),
                          ),
                        ),
                        isValidCode == false
                            ? ResponsiveWidget(
                                fixedHeight: 24,
                                localWidthRatio:
                                    AppScreenSize.appDesignSize.isWebPlatform(context) ? 263 / 640 : 0.8,
                                child: Row(
                                  children: [
                                    DefaultText(
                                      text: AppLocalizations.of(context)!
                                          .translate('invalidCode'),
                                      isTextTheme: true,
                                      themeStyle: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w400,
                                            height: 1.5,
                                            fontFamily:
                                                AppFontStyle.appFontFamily.readex,
                                            fontSize: AppFontStyle.appFontSize.setFontSize(
                                                context, webFontSize: 12, mobileFontSize: 10.sp),
                                          ),
                                    )
                                  ],
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 30,
                        ),
                        ResponsiveWidget(
                          localWidthRatio: AppScreenSize.appDesignSize.isWebPlatform(context)
                              ? ratioWidthComponentLogin
                              : 0.8,
                          fixedHeight: 48,
                          child: CustomRoundedButton(
                              isLoading: state is LoadingStateVerifyCode,
                              title: args.isFromGoogle == true ||
                                      args.isFromFacebook == true
                                  ? AppLocalizations.of(context)!
                                      .translate('verify')
                                  : AppLocalizations.of(context)!
                                      .translate('resetPassword'),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    resetVerifyCodeCubit?.errorMessage = '';
                                  });
                                  // isValidCode = true;
                                  // print(args.mobileID);
                                  // if (args.isFromGoogle == true) {
                                  //   resetPasswordCubit!
                                  //       .verifyCodeSmsForGoogleAndFacebook(
                                  //           mobileId: args.mobileID!,
                                  //           code:
                                  //               "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                  //           isFromGoogle: true,
                                  //           isFromFacebook: false);
                                  // } else if (args.isFromFacebook == true) {
                                  //   resetPasswordCubit!
                                  //       .verifyCodeSmsForGoogleAndFacebook(
                                  //           mobileId: args.mobileID!,
                                  //           code:
                                  //               "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                  //           isFromGoogle: false,
                                  //           isFromFacebook: true);
                                  // } else {
                                  //   resetPasswordCubit!.verifyForgetPassword(
                                  //       code:
                                  //           "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                  //       mobileID: args.mobileID!);
                                  // }
                                  print(
                                      'aaaaaaaa${args.mobileID == 0 || args.mobileID == null ? mobileId : args.mobileID}');
                                  resetVerifyCodeCubit?.verifyForgetPassword(
                                      code:
                                          "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                      mobileID: args.mobileID == 0 ||
                                              args.mobileID == null
                                          ? mobileId
                                          : args.mobileID);
                                } else {
                                  setState(() {
                                    isValidCode = false;
                                  });
                                }
                              }),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ResponsiveWidget(
                          localWidthRatio: AppScreenSize.appDesignSize.isWebPlatform(context)
                              ? ratioWidthComponentLogin
                              : 0.8,
                          child: DefaultText(
                            text: AppLocalizations.of(context)!
                                .translate('takeTIme'),
                            isTextTheme: true,
                            themeStyle: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: AppFontStyle.appFontFamily.readex,
                                  height: 1.5,
                                ),
                            align: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        ResponsiveWidget(
                          localWidthRatio: AppScreenSize.appDesignSize.isWebPlatform(context)
                              ? ratioWidthComponentLogin
                              : 0.8,
                          child: Row(
                            children: [
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: resetVerifyCodeCubit?.differenceTime !=
                                        Duration.zero
                                    ? Countdown(
                                        seconds: resetVerifyCodeCubit!
                                            .differenceTime!.inSeconds,
                                        build: (BuildContext context,
                                            double time) {
                                          return Row(
                                            children: [
                                              DefaultText(
                                                text:
                                                    " ${AppLocalizations.of(context)!.translate('resendCode')} ",
                                                align: TextAlign.start,
                                                isTextTheme: true,
                                                themeStyle: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall!
                                                    .copyWith(
                                                        color: primary,
                                                        height: 1.5,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily:
                                                            AppFontStyle
                                                                .appFontFamily.readex),
                                              ),
                                              DefaultText(
                                                text:
                                                    " ${enforceLTRForNumbers("${(time.toInt() ~/ 60).toString().padLeft(2, '0')}:${(time % 60).toString().padLeft(2, '0')}")}",
                                                align: TextAlign.start,
                                                isTextTheme: true,
                                                themeStyle: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall!
                                                    .copyWith(
                                                        color: primary,
                                                        height: 1.5,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily:
                                                            AppFontStyle
                                                                .appFontFamily.readex),
                                              ),
                                            ],
                                          );
                                        },
                                        interval: Duration(seconds: 1),
                                        onFinished: () {
                                          resetVerifyCodeCubit?.defaultDate();
                                          // setState(() {
                                          //   verifyCodeCubit?.differenceTime = Duration.zero;
                                          // });
                                          print('Timer is done!');
                                        },
                                      )
                                    : InkWell(
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        // Removes the background highlight color
                                        splashColor: Colors.transparent,
                                        // Removes the splash color

                                        onTap: state is LoadingState
                                            ? () {}
                                            : () {
                                                codeControllerOne.clear();
                                                codeControllerTwo.clear();
                                                codeControllerThree.clear();
                                                codeControllerFour.clear();
                                                codeControllerFive.clear();
                                                resetVerifyCodeCubit
                                                    ?.resendCodeSms(
                                                        mobileId: args.mobileID ==
                                                                    0 ||
                                                                args.mobileID ==
                                                                    null
                                                            ? mobileId
                                                            : args.mobileID!);
                                                // WidgetsBinding.instance.addPostFrameCallback((_) {
                                                //   resetVerifyCodeCubit?.checkDate();
                                                //   resetVerifyCodeCubit?.checkDate();
                                                // });
                                              },
                                        child: DefaultText(
                                          text: AppLocalizations.of(context)!
                                              .translate('resendNewCode'),
                                          align: TextAlign.start,
                                          isTextTheme: true,
                                          themeStyle: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .copyWith(
                                                  color: primary,
                                                  height: 1.5,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      AppFontStyle.appFontFamily.readex),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        // WidgetResponsiveBuilder(
                        //   localWidthRatio: ratioWidthComponentLogin,
                        //   child: Row(
                        //     children: [
                        //       InkWell(
                        //         onTap: () {
                        //           if (isCountDown == false) {
                        //             setState(() {
                        //               userBlockCounter++;
                        //             });
                        //           }
                        //           if (userBlockCounter == 3) {
                        //             isCountDown = true;
                        //           } else {
                        //             if (isCountDown == false) {
                        //               codeControllerOne.clear();
                        //               codeControllerTwo.clear();
                        //               codeControllerThree.clear();
                        //               codeControllerFour.clear();
                        //               codeControllerFive.clear();
                        //               resetVerifyCodeCubit.resendCodeSms(
                        //                   mobileId: args.mobileID == 0 || args.mobileID == null  ? mobileId : args.mobileID!);
                        //               isCountDown = true;
                        //             }
                        //           }
                        //         },
                        //         child: MouseRegion(
                        //           cursor: SystemMouseCursors.click,
                        //           child: userBlockCounter == 3
                        //               ? Text("")
                        //               : isCountDown
                        //                   ? Countdown(
                        //                       seconds: 120,
                        //                       build: (BuildContext context,
                        //                               double time) =>
                        //                           Row(
                        //                         children: [
                        //                           DefaultText(
                        //                             text: " ${AppLocalizations.of(context)!.translate('resendCode')} ",
                        //                             align: TextAlign.start,
                        //                             isTextTheme: true,
                        //                             themeStyle: getDimensionsWebDesktop(context) ? Theme.of(context).textTheme.labelSmall!.copyWith(
                        //                                 color:primary,
                        //                                 height: 1.5,
                        //                                 fontWeight:  FontWeight.w400,
                        //                                 fontFamily: AppFontFamily.dexefRound
                        //                             ):Theme.of(context).textTheme.labelSmall!.copyWith(
                        //                                 color:primary,
                        //                                 height: 1.5,
                        //                                 fontWeight:  FontWeight.w400,
                        //                                 fontFamily: AppFontFamily.dexefRound,
                        //                               fontSize: 12
                        //                             ),
                        //                           ),
                        //                           DefaultText(
                        //                             text: " ${enforceLTRForNumbers("${(time.toInt() ~/ 60).toString().padLeft(2, '0')}:${(time % 60).toString().padLeft(2, '0')}")}",
                        //                             align: TextAlign.start,
                        //                             isTextTheme: true,
                        //                             themeStyle: getDimensionsWebDesktop(context) ? Theme.of(context).textTheme.labelSmall!.copyWith(
                        //                                 color:primary,
                        //                                 height: 1.5,
                        //                                 fontWeight:  FontWeight.w400,
                        //                                 fontFamily: AppFontFamily.dexefRound
                        //                             ):Theme.of(context).textTheme.labelSmall!.copyWith(
                        //                                 color:primary,
                        //                                 height: 1.5,
                        //                                 fontWeight:  FontWeight.w400,
                        //                                 fontFamily: AppFontFamily.dexefRound,
                        //                               fontSize: 12
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                       interval: Duration(seconds: 1),
                        //                       onFinished: () {
                        //                         setState(() {
                        //                           isCountDown = false;
                        //                         });
                        //                         print('Timer is done!');
                        //                       },
                        //                     )
                        //                   : DefaultText(
                        //                       text: AppLocalizations.of(context)!.translate('resendNewCode'),
                        //                       align: TextAlign.start,
                        //                       isTextTheme: true,
                        //                       themeStyle:getDimensionsWebDesktop(context) ? Theme.of(context).textTheme.labelSmall!.copyWith(
                        //                             color: primary,
                        //                             fontWeight: FontWeight.w400,
                        //                             fontFamily: AppFontFamily.dexefRound,
                        //                             height: 1.5,
                        //                           ):Theme.of(context).textTheme.labelSmall!.copyWith(
                        //                         color: primary,
                        //                         fontWeight: FontWeight.w400,
                        //                         fontFamily: AppFontFamily.dexefRound,
                        //                         height: 1.5,
                        //                         fontSize: 12
                        //                       ),
                        //                     ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // userBlockCounter == 3
                        //     ? WidgetResponsiveBuilder(
                        //         localWidthRatio: ratioWidthComponentLogin,
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             SizedBox(
                        //               height: 90,
                        //             ),
                        //             isCountDown
                        //                 ? Row(
                        //                     children: [
                        //                       Countdown(
                        //                         seconds: 3600,
                        //                         build: (BuildContext context,
                        //                                 double time) =>
                        //                             Row(
                        //                           children: [
                        //                             DefaultText(
                        //                               text: "${AppLocalizations.of(context)!.translate('blockedFor')} ${(time.toInt() ~/ 60).toString().padLeft(2, '0')}:${(time % 60).toString().padLeft(2, '0')}",
                        //                               align: TextAlign.start,
                        //                               isTextTheme: true,
                        //                               themeStyle: getDimensionsWebDesktop(context) ?Theme.of(context).textTheme.labelSmall!.copyWith(
                        //                                 color: Colors.red,
                        //                                 fontWeight: FontWeight.w400,
                        //                                 fontFamily: AppFontFamily.dexefRound,
                        //                                 height: 1.5,
                        //                               ):Theme.of(context).textTheme.labelSmall!.copyWith(
                        //                                 color: Colors.red,
                        //                                 fontWeight: FontWeight.w400,
                        //                                 fontFamily: AppFontFamily.dexefRound,
                        //                                 height: 1.5,
                        //                                 fontSize: 12
                        //                               ),
                        //                             ),
                        //                           ],
                        //                         ),
                        //                         interval: Duration(seconds: 1),
                        //                         onFinished: () {
                        //                           setState(() {
                        //                             isCountDown = false;
                        //                           });
                        //                           print('Timer is done!');
                        //                         },
                        //                       )
                        //                     ],
                        //                   )
                        //                 : SizedBox()
                        //           ],
                        //         ))
                        //     : SizedBox()
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );

////////////////////////////////////////////////////////////////////////////////
  Widget _buildStack(var size, ResetPasswordStates state,
          ArgumentsResetPasswordVerifyCode args) =>
      Stack(
        children: [
          AnimatedSlide(
            offset: getLocation(),
            duration: Duration(milliseconds: 300),
            child: AnimatedOpacity(
                opacity: opacity,
                duration: Duration(milliseconds: 300),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: AppScreenSize.appWidgetSize.getLoginRightPanelWidth(context),
                  child: Form(
                    key: formKey,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DefaultText(
                            text: AppLocalizations.of(context)!
                                .translate('verificationCode'),
                            isTextTheme: true,
                            themeStyle: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: userLoginText,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: AppFontStyle.appFontFamily.readex,
                                ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          DefaultText(
                            isMultiLine: true,
                            text: AppLocalizations.of(context)!
                                .translate('enterVerify'),
                            isTextTheme: true,
                            themeStyle: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: brush,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: AppFontStyle.appFontFamily.readex,
                                  height: 1.5,
                                ),
                            align: TextAlign.center,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ResponsiveWidget(
                            localWidthRatio: 263 / 640,
                            fixedHeight: 68,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: brushBorder)),
                            child: Row(
                              children: [
                                Expanded(
                                    child: TextFormField(
                                  autofocus: true,
                                  maxLength: 1,
                                  controller: codeControllerOne,
                                  style: TextStyle(
                                    fontSize:
                                        AppFontStyle.appFontSize.setFontSize(context, webFontSize: 30, mobileFontSize: 28.sp),
                                  ),
                                  textAlign: TextAlign.center,
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return AppLocalizations.of(context)!
                                  //         .translate('required');
                                  //   }
                                  //   return null;
                                  // },
                                  focusNode: firstNode,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      secondNode.requestFocus();
                                    }
                                  },
                                  decoration: InputDecoration(
                                      counterText: "",
                                      border: InputBorder.none),
                                )),
                                Container(
                                  height: 68,
                                  width: 1,
                                  color: brushBorder,
                                ),
                                Expanded(
                                    child: TextFormField(
                                  controller: codeControllerTwo,
                                  style: TextStyle(
                                    fontSize:
                                        AppFontStyle.appFontSize.setFontSize(context, webFontSize: 30, mobileFontSize: 28.sp),
                                  ),
                                  maxLength: 1,
                                  textAlign: TextAlign.center,
                                  focusNode: secondNode,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      thirdNode.requestFocus();
                                    } else {
                                      firstNode.requestFocus();
                                    }
                                  },
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return AppLocalizations.of(context)!
                                  //         .translate('required');
                                  //   }
                                  //   return null;
                                  // },
                                  decoration: InputDecoration(
                                      counterText: "",
                                      border: InputBorder.none),
                                )),
                                Container(
                                  height: 68,
                                  width: 1,
                                  color: brushBorder,
                                ),
                                Expanded(
                                    child: TextFormField(
                                  maxLength: 1,
                                  controller: codeControllerThree,
                                  style: TextStyle(
                                    fontSize:
                                        AppFontStyle.appFontSize.setFontSize(context, webFontSize: 30, mobileFontSize: 28.sp),
                                  ),
                                  textAlign: TextAlign.center,
                                  focusNode: thirdNode,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      fourthNode.requestFocus();
                                    } else {
                                      secondNode.requestFocus();
                                    }
                                  },
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return AppLocalizations.of(context)!
                                  //         .translate('required');
                                  //   }
                                  //   return null;
                                  // },
                                  decoration: InputDecoration(
                                      counterText: "",
                                      border: InputBorder.none),
                                )),
                                Container(
                                  height: 68,
                                  width: 1,
                                  color: brushBorder,
                                ),
                                Expanded(
                                    child: TextFormField(
                                  maxLength: 1,
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return AppLocalizations.of(context)!
                                  //         .translate('required');
                                  //   }
                                  //   return null;
                                  // },
                                  textAlign: TextAlign.center,
                                  controller: codeControllerFour,
                                  style: TextStyle(
                                    fontSize:
                                        AppFontStyle.appFontSize.setFontSize(context, webFontSize: 30, mobileFontSize: 28.sp),
                                  ),
                                  focusNode: fourthNode,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      fiveNode.requestFocus();
                                    } else {
                                      thirdNode.requestFocus();
                                    }
                                  },
                                  decoration: InputDecoration(
                                      counterText: "",
                                      border: InputBorder.none),
                                )),
                                Container(
                                  height: 68,
                                  width: 1,
                                  color: brushBorder,
                                ),
                                Expanded(
                                    child: TextFormField(
                                  maxLength: 1,
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return AppLocalizations.of(context)!
                                  //         .translate('required');
                                  //   }
                                  //   return null;
                                  // },
                                  textAlign: TextAlign.center,
                                  controller: codeControllerFive,
                                  style: TextStyle(
                                    fontSize:
                                        AppFontStyle.appFontSize.setFontSize(context, webFontSize: 30, mobileFontSize: 28.sp),
                                  ),
                                  focusNode: fiveNode,
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      fourthNode.requestFocus();
                                    }
                                  },
                                  decoration: InputDecoration(
                                      counterText: "",
                                      border: InputBorder.none),
                                )),
                              ],
                            ),
                          ),
                          isValidCode == false
                              ? ResponsiveWidget(
                                  fixedHeight: 24,
                                  localWidthRatio: 263 / 640,
                                  child: Row(
                                    children: [
                                      DefaultText(
                                        text: AppLocalizations.of(context)!
                                            .translate('invalidCode'),
                                        isTextTheme: true,
                                        themeStyle: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                              color: Colors.red,
                                              fontSize: AppFontStyle.appFontSize.setFontSize(
                                                  context, webFontSize: 12, mobileFontSize: 10.sp),
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  AppFontStyle.appFontFamily.readex,
                                              height: 1.5,
                                            ),
                                      )
                                    ],
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 30,
                          ),
                          ResponsiveWidget(
                            localWidthRatio: ratioWidthComponentLogin,
                            fixedHeight: 48,
                            child: CustomRoundedButton(
                                isLoading: state is LoadingStateVerifyCode,
                                title: args.isFromGoogle == true ||
                                        args.isFromFacebook == true
                                    ? AppLocalizations.of(context)!
                                        .translate('verify')
                                    : AppLocalizations.of(context)!
                                        .translate('resetPassword'),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    // isValidCode = true;
                                    // print(args.mobileID);
                                    // if (args.isFromGoogle == true) {
                                    //   resetPasswordCubit!
                                    //       .verifyCodeSmsForGoogleAndFacebook(
                                    //       mobileId: args.mobileID!,
                                    //       code:
                                    //       "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                    //       isFromGoogle: true,
                                    //       isFromFacebook: false);
                                    // } else if (args.isFromFacebook == true) {
                                    //   resetPasswordCubit!
                                    //       .verifyCodeSmsForGoogleAndFacebook(
                                    //       mobileId: args.mobileID!,
                                    //       code:
                                    //       "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                    //       isFromGoogle: false,
                                    //       isFromFacebook: true);
                                    // } else {
                                    //   resetPasswordCubit!.verifyForgetPassword(
                                    //       code:
                                    //       "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                    //       mobileID: args.mobileID!);
                                    // }

                                    resetVerifyCodeCubit?.verifyForgetPassword(
                                        code:
                                            "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                        mobileID: args.mobileID!);
                                  } else {
                                    setState(() {
                                      isValidCode = false;
                                    });
                                  }
                                }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ResponsiveWidget(
                            localWidthRatio: ratioWidthComponentLogin,
                            child: DefaultText(
                              text: AppLocalizations.of(context)!
                                  .translate('takeTIme'),
                              isTextTheme: true,
                              themeStyle: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                    color: brush,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: AppFontStyle.appFontFamily.readex,
                                    height: 1.5,
                                  ),
                              align: TextAlign.start,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          ResponsiveWidget(
                            localWidthRatio: ratioWidthComponentLogin,
                            child: Row(
                              children: [
                                InkWell(
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,  // Removes the background highlight color
                                  splashColor: Colors.transparent,     // Removes the splash color

                                  onTap: () {
                                    if (isCountDown == false) {
                                      setState(() {
                                        userBlockCounter++;
                                      });
                                    }
                                    if (userBlockCounter == 3) {
                                      isCountDown = true;
                                    } else {
                                      if (isCountDown == false) {
                                        codeControllerOne.clear();
                                        codeControllerTwo.clear();
                                        codeControllerThree.clear();
                                        codeControllerFour.clear();
                                        codeControllerFive.clear();
                                        resetVerifyCodeCubit?.resendCodeSms(
                                            mobileId: args.mobileID!.toInt());
                                        isCountDown = true;
                                      }
                                    }
                                  },
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: userBlockCounter == 3
                                        ? Text("")
                                        : isCountDown
                                            ? Countdown(
                                                seconds: 120,
                                                build: (BuildContext context,
                                                        double time) =>
                                                    Row(
                                                  children: [
                                                    DefaultText(
                                                      text:
                                                          "${AppLocalizations.of(context)!.translate('resendCode')} ${(time.toInt() ~/ 60).toString().padLeft(2, '0')}:${(time % 60).toString().padLeft(2, '0')}",
                                                      align: TextAlign.start,
                                                      isTextTheme: true,
                                                      themeStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .labelSmall!
                                                              .copyWith(
                                                                color: primary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    AppFontStyle
                                                                        .appFontFamily.readex,
                                                              ),
                                                    ),
                                                  ],
                                                ),
                                                interval: Duration(seconds: 1),
                                                onFinished: () {
                                                  setState(() {
                                                    isCountDown = false;
                                                  });
                                                  print('Timer is done!');
                                                },
                                              )
                                            : DefaultText(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .translate('resendNewCode'),
                                                align: TextAlign.start,
                                                isTextTheme: true,
                                                themeStyle: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall!
                                                    .copyWith(
                                                      color: primary,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: AppFontStyle
                                                          .appFontFamily.readex,
                                                      height: 1.5,
                                                    ),
                                              ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          userBlockCounter == 3
                              ? ResponsiveWidget(
                                  localWidthRatio: ratioWidthComponentLogin,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 90,
                                      ),
                                      isCountDown
                                          ? Row(
                                              children: [
                                                Countdown(
                                                  seconds: 3600,
                                                  build: (BuildContext context,
                                                          double time) =>
                                                      Row(
                                                    children: [
                                                      DefaultText(
                                                        text:
                                                            "${AppLocalizations.of(context)!.translate('')} ${(time.toInt() ~/ 60).toString().padLeft(2, '0')}:${(time % 60).toString().padLeft(2, '0')}",
                                                        align: TextAlign.start,
                                                        isTextTheme: true,
                                                        themeStyle: Theme.of(
                                                                context)
                                                            .textTheme
                                                            .labelSmall!
                                                            .copyWith(
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontFamily:
                                                                  AppFontStyle
                                                                      .appFontFamily.readex,
                                                              height: 1.5,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  interval:
                                                      Duration(seconds: 1),
                                                  onFinished: () {
                                                    setState(() {
                                                      isCountDown = false;
                                                    });
                                                    print('Timer is done!');
                                                  },
                                                )
                                              ],
                                            )
                                          : SizedBox()
                                    ],
                                  ))
                              : SizedBox()
                        ],
                      ),
                    ),
                  ),
                )),
          ),
          Visibility(
            visible: (MediaQuery.of(context).size.width <
                    AppConstants.minimumScreenSize)
                ? false
                : true,
            child: Container(
              width:
                  size.width - AppScreenSize.appWidgetSize.getLoginRightPanelWidth(context),
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(color: cloudBackground, boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.16),
                  offset: Offset(0, 0),
                  blurRadius: 12.0,
                )
              ]),
              child: Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Row(
                    //   children: [
                    //     InkWell(
                    //       onTap: () {
                    //         Navigator.pop(context);
                    //       },
                    //       child: Padding(
                    //         padding:
                    //             EdgeInsets.only(top: 50, left: 50, right: 50),
                    //         child: MouseRegion(
                    //           cursor: SystemMouseCursors.click,
                    //           child: SvgPicture.asset("assets/images/back.svg"),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ResponsiveWidget(
                            localWidthRatio: 388 / 640,
                            child: getImage(
                              path: 'images/verification_code.svg',
                              isSvg: true,
                              height: MediaQuery.of(context).size.height *
                                  (238 / 800),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          DefaultText(
                            text: AppLocalizations.of(context)!
                                .translate('verifyDescriptionMainScreen'),
                            isTextTheme: true,
                            themeStyle: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: brush,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppFontStyle.appFontFamily.readex,
                                  wordSpacing: 1.5,
                                  height: 1.5,
                                ),
                            align: TextAlign.center,
                            isMultiLine: true,
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
                      child: getImage(
                          path: 'images/dexef_logo_body.svg', isSvg: true),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}
