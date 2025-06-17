import 'package:auth_dexef/features/register/presentation/cubit/register_cubit.dart';
import 'package:auth_dexef/features/resetPassword/presentation/cubit/reset_password_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../../../../../core/size_widgets/app_screen_size.dart';
import '../../../../../core/size_widgets/responsive_widget.dart';
import '../../../../../core/size_widgets/app_font_style.dart';
import 'dart:ui' as ui;

import '../../../../core/rest/app_localizations.dart';
import '../../../../core/rest/arguments.dart';
import '../../../../core/rest/cash_helper.dart';
import '../../../../core/rest/constants.dart';
import '../../../../core/rest/methods.dart';
import '../../../../core/rest/routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/public/custom_round_button.dart';
import '../../../../core/widgets/public/default_login_screen.dart';
import '../../../../core/widgets/public/default_text.dart';
import '../../../../core/widgets/public/network_failed.dart';
import '../cubit/register_states.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen>
    with WidgetsBindingObserver {
  TextEditingController codeControllerOne = TextEditingController();
  TextEditingController codeControllerTwo = TextEditingController();
  TextEditingController codeControllerThree = TextEditingController();
  TextEditingController codeControllerFour = TextEditingController();
  TextEditingController codeControllerFive = TextEditingController();
  TextEditingController codeControllerSix = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isCountDown = true;
  bool visibleContainer = false;
  int userBlockCounter = 0;
  dynamic location;
  bool isTap = false;
  double opacity = 0.0;
  String? code;
  late RegisterCubit registerCubit;
  FocusNode firstNode = FocusNode();
  FocusNode secondNode = FocusNode();
  FocusNode thirdNode = FocusNode();
  FocusNode fourthNode = FocusNode();
  FocusNode fiveNode = FocusNode();
  bool isValidCode = true;
  Orientation? orientation;

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
    codeControllerOne.clear();
    codeControllerTwo.clear();
    codeControllerThree.clear();
    codeControllerFour.clear();
    codeControllerFive.clear();
    codeControllerSix.clear();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    codeControllerOne.dispose();
    codeControllerTwo.dispose();
    codeControllerThree.dispose();
    codeControllerFour.dispose();
    codeControllerFive.dispose();
    codeControllerSix.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        ResetPasswordCubit.instance.checkDate();
        break;
      case AppLifecycleState.inactive:
        // verifyCodeCubit?.checkDate();
        break;
      case AppLifecycleState.paused:
        // verifyCodeCubit?.checkDate();
        break;
      case AppLifecycleState.detached:
        // verifyCodeCubit?.checkDate();
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    ArgumentsVerifyCodeScreen? args = CacheHelper.getObjectFromPrefs(
      key: Constants.verifyCodeScreenArguments.toString(),
      model: ArgumentsVerifyCodeScreen
    );
    return BlocConsumer<RegisterCubit, RegisterStates>(
      listener: (context, state) {},
      builder: (context, state) {
        registerCubit = RegisterCubit.instance;
        return DefaultLoginScreen(
          isLoading: state is VerifyMobileLoading || state is ChangeMobileLoading,
          body: args != null ? _buildRow(context, state, args) : const Center(child: NetworkFailed()),
        );
      },
    );
  }

////////////////////////////////////////////////////////////////////////////////
  Widget _buildRow(
    BuildContext context,
      RegisterStates state,
    ArgumentsVerifyCodeScreen args,
  ) =>
      AbsorbPointer(
        absorbing: state is VerifyMobileLoading,
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width -
                  AppScreenSize.appWidgetSize.getLoginRightPanelWidth(context),
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(color: cloudBackground, boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.16),
                  offset: Offset(0, 0),
                  blurRadius: 12.0,
                )
              ]),
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
                  //           child:
                  //               SvgPicture.asset("assets/images/back.svg"),
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
                              fit: BoxFit.contain),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        DefaultText(
                          text: AppLocalizations.of(context)!
                              .translate('verifyDescriptionMainScreen'),
                          isTextTheme: true,
                          themeStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  height: 1.5,
                                  wordSpacing: 1.5,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppFontStyle.appFontFamily.readex),
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
                        path: 'images/dexef_logo_body.svg',
                        isSvg: true,
                        fit: BoxFit.contain),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: AppScreenSize.appWidgetSize.getLoginRightPanelWidth(context),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
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
                                  .headlineSmall!
                                  .copyWith(
                                      color: userLoginText,
                                      fontWeight: FontWeight.w800,
                                      fontFamily:
                                          AppFontStyle.appFontFamily.readex)),
                          const SizedBox(
                            height: 20,
                          ),
                          ResponsiveWidget(
                            localWidthRatio: AppScreenSize.appDesignSize.isWebPlatform(context)
                                ? ratioWidthComponentLogin
                                : 0.8,
                            child: InkWell(
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              // Removes the background highlight color
                              splashColor: Colors.transparent,
                              // Removes the splash color

                              onTap: () {},
                              child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .translate('enterVerify'),
                                      style: TextStyle(
                                          fontSize: AppFontStyle.appFontSize.setFontSize(
                                              context, webFontSize: 16, mobileFontSize: 14.sp),
                                          height: 1.5,
                                          color: brush,
                                          fontFamily: 'DXRound',
                                          fontWeight: FontWeight.w400),
                                      children: [
                                        WidgetSpan(
                                            child: InkWell(
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          // Removes the background highlight color
                                          splashColor: Colors.transparent,
                                          // Removes the splash color

                                          onTap: () {
                                            // if (isCountDown == false) {
                                            // context.go(Routes.verifyCodeChoose);
                                            Router.neglect(context, () {
                                              context.pushNamed(
                                                  Routes.changePhoneNumber);
                                            });
                                            CacheHelper.saveObjectToPrefs(
                                                key: Constants
                                                    .changePhoneNumberArguments
                                                    .toString(),
                                                object:
                                                    ArgumentsChangePhoneNumber(
                                                  mobileID: args.mobileId,
                                                  password: args.password,
                                                  email: args.email,
                                                  isFacebook: false,
                                                  isGoogle: false,
                                                ));
                                            CacheHelper.saveObjectToPrefs(
                                              key: Constants
                                                  .verifyCodeScreenArguments
                                                  .toString(),
                                              object: ArgumentsVerifyCodeScreen(
                                                mobileId: args.mobileId,
                                                fromPage: 'changePhoneNumber',
                                              ),
                                            );
                                            // }
                                          },
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: DefaultText(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .translate('wrongNumber'),
                                                isTextTheme: true,
                                                themeStyle: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall!
                                                    .copyWith(
                                                        color: primary,
                                                        height: 1.5,
                                                        fontWeight: AppFontStyle.fontWeightCustoms.regular,
                                                        fontFamily:
                                                            AppFontStyle
                                                                .appFontFamily.readex)),
                                          ),
                                        ))
                                      ])),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
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
                                    onFieldSubmitted: (_) {
                                      if (formKey.currentState!.validate()) {
                                        isValidCode = true;
                                        code =
                                            "${codeControllerOne.text}${codeControllerTwo.text}${codeControllerThree.text}${codeControllerFour.text}${codeControllerFive.text}";
                                        print(args.mobileId);
                                        print('CODE IS $code');
                                        print("email is ${args.email}");
                                        // registerCubit.verifyCodeSms(
                                        //   mobileId: args.mobileId!,
                                        //   code: code!,
                                        //   email: args.email,
                                        //   password: args.password,
                                        // );
                                      } else {
                                        setState(() {
                                          isValidCode = false;
                                        });
                                      }
                                    },
                                    // maxLength: 1,
                                    autofocus: true,
                                    controller: codeControllerOne,
                                    style: TextStyle(
                                        fontSize: AppFontStyle.appFontSize.setFontSize(
                                            context, webFontSize: 22, mobileFontSize: 20.sp),
                                        color: Colors.black),
                                    textAlign: TextAlign.center,
                                    validator: (value) {
                                      // if (value!.isEmpty) {
                                      //   return "";
                                      // }
                                      // return null;
                                    },
                                    // maxLength: 1,
                                    focusNode: firstNode,
                                    onChanged: (value) {
                                      if (codeControllerOne.text.isNotEmpty) {
                                        if (value.isNotEmpty) {
                                          secondNode.requestFocus();
                                          codeControllerOne.text = value[0];
                                          if (value.length == 5) {
                                            setState(() {
                                              codeControllerOne.text = value[0];
                                              codeControllerTwo.text = value[1];
                                              codeControllerThree.text =
                                                  value[2];
                                              codeControllerFour.text =
                                                  value[3];
                                              codeControllerFive.text =
                                                  value[4];
                                            });
                                          }
                                        }
                                      } else {
                                        firstNode.requestFocus();
                                      }
                                    },
                                    decoration: const InputDecoration(
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
                                    onFieldSubmitted: (_) {
                                      if (formKey.currentState!.validate()) {
                                        isValidCode = true;
                                        code =
                                            "${codeControllerOne.text}${codeControllerTwo.text}${codeControllerThree.text}${codeControllerFour.text}${codeControllerFive.text}";
                                        print(args.mobileId);
                                        print('CODE IS $code');
                                        print("email is ${args.email}");
                                        // verifyCodeCubit!.verifyCodeSms(
                                        //   mobileId: args.mobileId!,
                                        //   code: code!,
                                        //   email: args.email,
                                        //   password: args.password,
                                        // );
                                      } else {
                                        setState(() {
                                          isValidCode = false;
                                        });
                                      }
                                    },
                                    controller: codeControllerTwo,
                                    style: TextStyle(
                                        fontSize: AppFontStyle.appFontSize.setFontSize(
                                            context, webFontSize: 22, mobileFontSize: 20.sp),
                                        color: Colors.black),
                                    maxLength: 1,
                                    textAlign: TextAlign.center,
                                    focusNode: secondNode,
                                    onChanged: (value) {
                                      if (codeControllerTwo.text.isNotEmpty) {
                                        thirdNode.requestFocus();
                                      } else {
                                        firstNode.requestFocus();
                                      }
                                    },
                                    validator: (value) {
                                      // if (value!.isEmpty) {
                                      //   return "";
                                      // }
                                      // return null;
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
                                    onFieldSubmitted: (_) {},
                                    maxLength: 1,
                                    controller: codeControllerThree,
                                    style: TextStyle(
                                        fontSize: AppFontStyle.appFontSize.setFontSize(
                                            context, webFontSize: 22, mobileFontSize: 20.sp),
                                        color: Colors.black),
                                    textAlign: TextAlign.center,
                                    focusNode: thirdNode,
                                    onChanged: (value) {
                                      if (codeControllerThree.text.isNotEmpty) {
                                        fourthNode.requestFocus();
                                      } else {
                                        secondNode.requestFocus();
                                      }
                                    },
                                    validator: (value) {
                                      // if (value!.isEmpty) {
                                      //   return "";
                                      // }
                                      // return null;
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
                                    onFieldSubmitted: (_) {
                                      if (formKey.currentState!.validate()) {
                                        isValidCode = true;
                                        code =
                                            "${codeControllerOne.text}${codeControllerTwo.text}${codeControllerThree.text}${codeControllerFour.text}${codeControllerFive.text}";
                                        print(args.mobileId);
                                        print('CODE IS $code');
                                        print("email is ${args.email}");
                                        // verifyCodeCubit!.verifyCodeSms(
                                        //   mobileId: args.mobileId!,
                                        //   code: code!,
                                        //   email: args.email,
                                        //   password: args.password,
                                        // );
                                      } else {
                                        setState(() {
                                          isValidCode = false;
                                        });
                                      }
                                    },
                                    maxLength: 1,
                                    validator: (value) {
                                      // if (value!.isEmpty) {
                                      //   return "";
                                      // }
                                      // return null;
                                    },
                                    textAlign: TextAlign.center,
                                    controller: codeControllerFour,
                                    style: TextStyle(
                                        fontSize: AppFontStyle.appFontSize.setFontSize(
                                            context, webFontSize: 22, mobileFontSize: 20.sp),
                                        color: Colors.black),
                                    focusNode: fourthNode,
                                    onChanged: (value) {
                                      if (codeControllerFour.text.isNotEmpty) {
                                        fiveNode.requestFocus();
                                      } else {
                                        thirdNode.requestFocus();
                                      }
                                    },
                                    decoration: const InputDecoration(
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
                                    onFieldSubmitted: (_) {
                                      if (formKey.currentState!.validate()) {
                                        isValidCode = true;
                                        code =
                                            "${codeControllerOne.text}${codeControllerTwo.text}${codeControllerThree.text}${codeControllerFour.text}${codeControllerFive.text}";
                                        print(args.mobileId);
                                        print('CODE IS $code');
                                        print("email is ${args.email}");
                                        // verifyCodeCubit!.verifyCodeSms(
                                        //   mobileId: args.mobileId!,
                                        //   code: code!,
                                        //   email: args.email,
                                        //   password: args.password,
                                        // );
                                      } else {
                                        setState(() {
                                          isValidCode = false;
                                        });
                                      }
                                    },
                                    maxLength: 1,
                                    validator: (value) {
                                      // if (value!.isEmpty) {
                                      //   return "";
                                      // }
                                      // return null;
                                    },
                                    textAlign: TextAlign.center,
                                    controller: codeControllerFive,
                                    style: TextStyle(
                                        fontSize: AppFontStyle.appFontSize.setFontSize(
                                            context, webFontSize: 22, mobileFontSize: 20.sp),
                                        color: Colors.black),
                                    focusNode: fiveNode,
                                    onChanged: (value) {
                                      if (codeControllerFive.text.isNotEmpty) {
                                        fiveNode.requestFocus();
                                      } else {
                                        fourthNode.requestFocus();
                                      }
                                    },
                                    decoration: const InputDecoration(
                                        counterText: "",
                                        border: InputBorder.none),
                                  )),
                                ],
                              ),
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
                                                  fontSize:
                                                      AppFontStyle.appFontSize.setFontSize(
                                                          context, webFontSize: 12, mobileFontSize: 10.sp),
                                                  height: 1.5,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      AppFontStyle.appFontFamily.readex))
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          ResponsiveWidget(
                            localWidthRatio:
                                AppScreenSize.appDesignSize.isWebPlatform(context) ? ratioImageWidth : 0.8,
                            child: DefaultText(
                              text: state is VerifyMobileError
                                  ? (state.message)
                                  : '',
                              isTextTheme: true,
                              themeStyle: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                    color: Colors.red,
                                  ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ResponsiveWidget(
                            localWidthRatio: AppScreenSize.appDesignSize.isWebPlatform(context)
                                ? ratioWidthComponentLogin
                                : 0.8,
                            fixedHeight: 48,
                            child: CustomRoundedButton(
                                isLoading: state is VerifyMobileLoading,
                                title: AppLocalizations.of(context)!
                                    .translate('verify'),
                                onPressed: () {
                                  setState(() {
                                    registerCubit.errorMessage = '';
                                  });
                                  if (formKey.currentState!.validate()) {
                                    isValidCode = true;
                                    code =
                                        "${codeControllerOne.text}${codeControllerTwo.text}${codeControllerThree.text}${codeControllerFour.text}${codeControllerFive.text}";
                                    print(args.mobileId);
                                    print('CODE IS $code');
                                    print("email is ${args.email}");
                                    // verifyCodeCubit!.verifyCodeSms(
                                    //   mobileId: args.mobileId!,
                                    //   code: code!,
                                    //   email: args.email,
                                    //   password: args.password,
                                    // );
                                  } else {
                                    setState(() {
                                      isValidCode = false;
                                    });
                                  }
                                }),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ResponsiveWidget(
                            localWidthRatio: AppScreenSize.appDesignSize.isWebPlatform(context)
                                ? ratioWidthComponentLogin
                                : 0.8,
                            child: DefaultText(
                              text: AppLocalizations.of(context)!
                                  .translate('takeTIme'),
                              align: TextAlign.start,
                              isTextTheme: true,
                              themeStyle: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                      color: brush,
                                      height: 1.5,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: AppFontStyle.appFontFamily.readex),
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          ResponsiveWidget(
                            localWidthRatio: AppScreenSize.appDesignSize.isWebPlatform(context)
                                ? ratioWidthComponentLogin
                                : 0.8,
                            child: Row(
                              children: [
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: ResetPasswordCubit.instance.differenceTime !=
                                          Duration.zero
                                      ?
                                      //                                StreamBuilder(
                                      //                                 builder: (context, snapShot){
                                      //                                   return Countdown(
                                      //                                     seconds: verifyCodeCubit!.differenceTime!.inSeconds,
                                      //                                     build: (BuildContext context, double time) {
                                      //                                       return Row(
                                      //                                         children: [
                                      //                                           DefaultText(
                                      //                                             text: " ${AppLocalizations.of(context)!.translate('resendCode')} ",
                                      //                                             align: TextAlign.start,
                                      //                                             isTextTheme: true,
                                      //                                             themeStyle: Theme.of(context).textTheme.labelSmall!
                                      //                                                 .copyWith(
                                      //                                                 color: primary,
                                      //                                                 height: 1.5,
                                      //                                                 fontWeight: FontWeight.w400,
                                      //                                                 fontFamily: AppFontFamily.dexefRound),
                                      //                                           ),
                                      //                                           DefaultText(
                                      //                                             text: " ${enforceLTRForNumbers("${(time.toInt() ~/ 60).toString().padLeft(2, '0')}:${(time % 60).toString().padLeft(2, '0')}")}",
                                      //                                             align: TextAlign.start,
                                      //                                             isTextTheme: true,
                                      //                                             themeStyle: Theme.of(context).textTheme.labelSmall!
                                      //                                                 .copyWith(
                                      //                                                 color: primary,
                                      //                                                 height: 1.5,
                                      //                                                 fontWeight: FontWeight.w400,
                                      //                                                 fontFamily: AppFontFamily.dexefRound),
                                      //                                           ),
                                      //                                         ],
                                      //                                       );
                                      //                                     },
                                      //                                     interval: Duration(seconds: 1),
                                      //                                     onFinished: () {
                                      //                                       verifyCodeCubit?.defaultDate();
                                      //                                       // setState(() {
                                      //                                       //   verifyCodeCubit?.differenceTime = Duration.zero;
                                      //                                       // });
                                      //                                       print('Timer is done!');
                                      //                                     },
                                      //                                   );
                                      //                                 },
                                      //                                 stream: verifyCodeCubit?.checkDate(),
                                      //                                 // child: Countdown(
                                      //                                 //         seconds: verifyCodeCubit!.differenceTime!.inSeconds,
                                      //                                 //         build: (BuildContext context, double time) {
                                      //                                 //           return Row(
                                      //                                 //             children: [
                                      //                                 //               DefaultText(
                                      //                                 //                 text: " ${AppLocalizations.of(context)!.translate('resendCode')} ",
                                      //                                 //                 align: TextAlign.start,
                                      //                                 //                 isTextTheme: true,
                                      //                                 //                 themeStyle: Theme.of(context).textTheme.labelSmall!
                                      //                                 //                     .copyWith(
                                      //                                 //                         color: primary,
                                      //                                 //                         height: 1.5,
                                      //                                 //                         fontWeight: FontWeight.w400,
                                      //                                 //                         fontFamily: AppFontFamily.dexefRound),
                                      //                                 //               ),
                                      //                                 //               DefaultText(
                                      //                                 //                 text: " ${enforceLTRForNumbers("${(time.toInt() ~/ 60).toString().padLeft(2, '0')}:${(time % 60).toString().padLeft(2, '0')}")}",
                                      //                                 //                 align: TextAlign.start,
                                      //                                 //                 isTextTheme: true,
                                      //                                 //                 themeStyle: Theme.of(context).textTheme.labelSmall!
                                      //                                 //                     .copyWith(
                                      //                                 //                         color: primary,
                                      //                                 //                         height: 1.5,
                                      //                                 //                         fontWeight: FontWeight.w400,
                                      //                                 //                         fontFamily: AppFontFamily.dexefRound),
                                      //                                 //               ),
                                      //                                 //             ],
                                      //                                 //           );
                                      //                                 //         },
                                      //                                 //         interval: Duration(seconds: 1),
                                      //                                 //         onFinished: () {
                                      //                                 //           verifyCodeCubit?.defaultDate();
                                      //                                 //           // setState(() {
                                      //                                 //           //   verifyCodeCubit?.differenceTime = Duration.zero;
                                      //                                 //           // });
                                      //                                 //           print('Timer is done!');
                                      //                                 //         },
                                      //                                 //       ),
                                      //                                   )
                                      Countdown(
                                          seconds: ResetPasswordCubit.instance
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
                                            ResetPasswordCubit.instance.defaultDate();
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

                                          onTap: state is ResendCodeLoading
                                              ? () {}
                                              : () {
                                                  codeControllerOne.clear();
                                                  codeControllerTwo.clear();
                                                  codeControllerThree.clear();
                                                  codeControllerFour.clear();
                                                  codeControllerFive.clear();
                                                  registerCubit
                                                      .resendCodeSms(
                                                    mobileId: args.mobileId!,
                                                  );
                                                  // WidgetsBinding.instance.addPostFrameCallback((_) {
                                                  //   verifyCodeCubit?.checkDate();
                                                  //   verifyCodeCubit?.checkDate();
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
                                                    fontFamily: AppFontStyle
                                                        .appFontFamily.readex),
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
                          //             // if (isCountDown == false) {
                          //               codeControllerOne.clear();
                          //               codeControllerTwo.clear();
                          //               codeControllerThree.clear();
                          //               codeControllerFour.clear();
                          //               codeControllerFive.clear();
                          //               // codeControllerOne.clear();
                          //               print('mobile id ========${args.mobileId}');
                          //               verifyCodeCubit!.resendCodeSms(
                          //                   mobileId: args.mobileId!);
                          //               isCountDown = true;
                          //             // }
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
                          //                             themeStyle:Theme.of(context).textTheme.labelSmall!.copyWith(
                          //                               color:primary,
                          //                               height: 1.5,
                          //                               fontWeight:  FontWeight.w400,
                          //                               fontFamily: AppFontFamily.dexefRound
                          //                             ),
                          //                           ),
                          //                           DefaultText(
                          //                             text: " ${enforceLTRForNumbers("${(time.toInt() ~/ 60).toString().padLeft(2, '0')}:${(time % 60).toString().padLeft(2, '0')}")}",
                          //                             align: TextAlign.start,
                          //                             isTextTheme: true,
                          //                             themeStyle:Theme.of(context).textTheme.labelSmall!.copyWith(
                          //                                 color:primary,
                          //                                 height: 1.5,
                          //                                 fontWeight:  FontWeight.w400,
                          //                                 fontFamily: AppFontFamily.dexefRound
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
                          //                       themeStyle:Theme.of(context).textTheme.labelSmall!.copyWith(
                          //                         color:primary,
                          //                         height: 1.5,
                          //                         fontWeight: FontWeight.w400,
                          //                         fontFamily: AppFontFamily.dexefRound
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
                          //             const SizedBox(
                          //               height: 90,
                          //             ),
                          //             isCountDown
                          //                 ? Row(
                          //                     children: [
                          //                       // Text(
                          //                       //   "You have been blocked",
                          //                       //   textAlign: TextAlign.start,
                          //                       //   style: TextStyle(
                          //                       //     fontSize: 16,
                          //                       //     height: 1.5,
                          //                       //     color: Colors.red,
                          //                       //     fontFamily: "DXRound",
                          //                       //   ),
                          //                       // ),
                          //                       Countdown(
                          //                         seconds: 3600,
                          //                         build: (BuildContext context,
                          //                                 double time) =>
                          //                             Row(
                          //                           children: [
                          //                             DefaultText(
                          //                               text:
                          //                                   "${AppLocalizations.of(context)!.translate('blockedFor')}  ${(time.toInt() ~/ 60).toString().padLeft(2, '0')}:${(time % 60).toString().padLeft(2, '0')}",
                          //                               align: TextAlign.start,
                          //                               isTextTheme: true,
                          //                               themeStyle: Theme.of(
                          //                                       context)
                          //                                   .textTheme
                          //                                   .labelSmall!
                          //                                   .copyWith(
                          //                                       color: Colors.red,
                          //                                       height: 1.5,
                          //                                       fontWeight:
                          //                                           FontWeight
                          //                                               .w400,
                          //                                       fontFamily:
                          //                                           AppFontFamily
                          //                                               .dexefRound),
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
                          //                 : const SizedBox()
                          //           ],
                          //         ),
                          //       )
                          //     : const SizedBox()
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
}

/////////////////////////////////////////////////////////////////////////////////////////// box verification code
// Padding(
//   padding: EdgeInsets.symmetric(horizontal: 40.0),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Container(
//         height: 68,
//         width: 263,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(4),
//             border: Border.all(color: textFieldBorderColor)),
//         child: Row(
//           children: [
//             Expanded(
//                 child: TextFormField(
//               onFieldSubmitted: (_) {
//                 if (formKey.currentState!.validate()) {
//                   isValidCode = true;
//                   code = "${codeControllerOne.text}${codeControllerTwo.text}${codeControllerThree.text}${codeControllerFour.text}${codeControllerFive.text}";
//                   print(args.mobileId);
//                   print('CODE IS $code');
//                   print(
//                       "email is ${args.email}");
//                   verifyCodeCubit!
//                       .verifyCodeSms(
//                     mobileId: args.mobileId!,
//                     code: code!,
//                     email: args.email,
//                     password: args.password,
//                   );
//                 } else {
//                   setState(() {
//                     isValidCode = false;
//                   });
//                 }
//               },
//               maxLength: 1,
//               autofocus: true,
//               controller: codeControllerOne,
//               style: TextStyle(fontSize: loginFontSizeH3),
//               textAlign: TextAlign.center,
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return "";
//                 }
//                 return null;
//               },
//               focusNode: firstNode,
//               onChanged: (value) {
//                 if (value.isNotEmpty) {
//                   secondNode.requestFocus();
//                 }
//               },
//               decoration: InputDecoration(
//                   counterText: "",
//                   border: InputBorder.none),
//             )),
//             Container(
//               height: 68,
//               width: 1,
//               color: textFieldBorderColor,
//             ),
//             Expanded(
//                 child: TextFormField(
//               onFieldSubmitted: (_) {
//                 if (formKey.currentState!
//                     .validate()) {
//                   isValidCode = true;
//                   code =
//                       "${codeControllerOne.text}${codeControllerTwo.text}${codeControllerThree.text}${codeControllerFour.text}${codeControllerFive.text}";
//                   print(args.mobileId);
//                   print('CODE IS $code');
//                   print(
//                       "email is ${args.email}");
//                   verifyCodeCubit!
//                       .verifyCodeSms(
//                     mobileId: args.mobileId!,
//                     code: code!,
//                     email: args.email,
//                     password: args.password,
//                   );
//                 } else {
//                   setState(() {
//                     isValidCode = false;
//                   });
//                 }
//               },
//               controller: codeControllerTwo,
//                   style: TextStyle(fontSize: loginFontSizeH3),
//               maxLength: 1,
//               textAlign: TextAlign.center,
//               focusNode: secondNode,
//               onChanged: (value) {
//                 if (value.isNotEmpty) {
//                   thirdNode.requestFocus();
//                 } else {
//                   firstNode.requestFocus();
//                 }
//               },
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return "";
//                 }
//                 return null;
//               },
//               decoration: InputDecoration(
//                   counterText: "",
//                   border: InputBorder.none),
//             )),
//             Container(
//               height: 68,
//               width: 1,
//               color: textFieldBorderColor,
//             ),
//             Expanded(
//                 child: TextFormField(
//               onFieldSubmitted: (_) {
//                 if (formKey.currentState!
//                     .validate()) {
//                   isValidCode = true;
//                   code =
//                       "${codeControllerOne.text}${codeControllerTwo.text}${codeControllerThree.text}${codeControllerFour.text}${codeControllerFive.text}";
//                   print(args.mobileId);
//                   print('CODE IS $code');
//                   print(
//                       "email is ${args.email}");
//                   verifyCodeCubit!
//                       .verifyCodeSms(
//                     mobileId: args.mobileId!,
//                     code: code!,
//                     email: args.email,
//                     password: args.password,
//                   );
//                 } else {
//                   setState(() {
//                     isValidCode = false;
//                   });
//                 }
//               },
//               maxLength: 1,
//               controller: codeControllerThree,
//                   style: TextStyle(fontSize: loginFontSizeH3),
//               textAlign: TextAlign.center,
//               focusNode: thirdNode,
//               onChanged: (value) {
//                 print("ddddddddddddd");
//                 if (value.isNotEmpty) {
//                   fourthNode.requestFocus();
//                 } else {
//                   secondNode.requestFocus();
//                 }
//               },
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return "";
//                 }
//                 return null;
//               },
//               decoration: InputDecoration(
//                   counterText: "",
//                   border: InputBorder.none),
//             )),
//             Container(
//               height: 68,
//               width: 1,
//               color: textFieldBorderColor,
//             ),
//             Expanded(
//                 child: TextFormField(
//               onFieldSubmitted: (_) {
//                 if (formKey.currentState!
//                     .validate()) {
//                   isValidCode = true;
//                   code =
//                       "${codeControllerOne.text}${codeControllerTwo.text}${codeControllerThree.text}${codeControllerFour.text}${codeControllerFive.text}";
//                   print(args.mobileId);
//                   print('CODE IS $code');
//                   print(
//                       "email is ${args.email}");
//                   verifyCodeCubit!
//                       .verifyCodeSms(
//                     mobileId: args.mobileId!,
//                     code: code!,
//                     email: args.email,
//                     password: args.password,
//                   );
//                 } else {
//                   setState(() {
//                     isValidCode = false;
//                   });
//                 }
//               },
//               maxLength: 1,
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return "";
//                 }
//                 return null;
//               },
//               textAlign: TextAlign.center,
//               controller: codeControllerFour,
//                   style: TextStyle(fontSize: loginFontSizeH3),
//               focusNode: fourthNode,
//               onChanged: (value) {
//                 if (value.isNotEmpty) {
//                   fiveNode.requestFocus();
//                 } else {
//                   thirdNode.requestFocus();
//                 }
//               },
//               decoration: InputDecoration(
//                   counterText: "",
//                   border: InputBorder.none),
//             )),
//             Container(
//               height: 68,
//               width: 1,
//               color: textFieldBorderColor,
//             ),
//             Expanded(
//                 child: TextFormField(
//               onFieldSubmitted: (_) {
//                 if (formKey.currentState!
//                     .validate()) {
//                   isValidCode = true;
//                   code =
//                       "${codeControllerOne.text}${codeControllerTwo.text}${codeControllerThree.text}${codeControllerFour.text}${codeControllerFive.text}";
//                   print(args.mobileId);
//                   print('CODE IS $code');
//                   print(
//                       "email is ${args.email}");
//                   verifyCodeCubit!
//                       .verifyCodeSms(
//                     mobileId: args.mobileId!,
//                     code: code!,
//                     email: args.email,
//                     password: args.password,
//                   );
//                 } else {
//                   setState(() {
//                     isValidCode = false;
//                   });
//                 }
//               },
//               maxLength: 1,
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return "";
//                 }
//                 return null;
//               },
//               textAlign: TextAlign.center,
//               controller: codeControllerFive,
//                   style: TextStyle(fontSize: loginFontSizeH3),
//               focusNode: fiveNode,
//               onChanged: (value) {
//                 if (value.isEmpty) {
//                   fourthNode.requestFocus();
//                 }
//               },
//               decoration: InputDecoration(
//                   counterText: "",
//                   border: InputBorder.none),
//             )),
//           ],
//         ),
//       ),
//     ],
//   ),
// ),
/////////////////////////////////////////////////////////////////////////////////////////// the button
// ConditionalBuilder(
//   condition: state is !LoadingState,
//   builder: (context) => CustomRoundedButton(
//     isLoading: state is LoadingState,
//       title: "Verify",
//       onPressed: () {
//         if (formKey.currentState!.validate()) {
//           isValidCode = true;
//           code = "${codeControllerOne
//               .text}${codeControllerTwo
//               .text}${codeControllerThree
//               .text}${codeControllerFour
//               .text}${codeControllerFive.text}";
//           print(args.mobileId);
//           print('CODE IS $code');
//           print("email is ${args.email}");
//           verifyCodeCubit!.verifyCodeSms(
//             mobileId: args.mobileId!,
//             code: code!,
//             email: args.email,
//             password: args.password,
//           );
//         }else{
//           setState(() {
//             isValidCode = false;
//           });
//         }
//       }),
//   fallback: (context) => CustomLoadingButton(),
// ),
/////////////////////////////////////////////////////////////////////////////////////////// the time
// Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     SizedBox( height: 90,),
//     isCountDown
//         ?  Countdown(
//       seconds: 5,
//       build: (BuildContext context, double time) =>
//           Row(
//             children: [
//               Text(
//                 "Please wait ${time.toInt()} seconds to can send again",
//                 textAlign: TextAlign.start,
//                 style: TextStyle(
//                   fontSize: 16,
//                   height: 1.5,
//                   color: counterGreenColor,
//                   fontFamily: "DXRound",
//                 ),
//               ),
//
//             ],
//           ),
//       interval: Duration(seconds: 1),
//       onFinished: () {
//         setState(() {
//           isCountDown = false;
//         });
//         print('Timer is done!');
//       },
//     )
//         : SizedBox()
//
//
//   ],
// ),
