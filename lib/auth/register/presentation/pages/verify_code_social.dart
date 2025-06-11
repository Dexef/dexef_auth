import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:mydexef/core/size_widgets/app_font_style.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../../../../../core/class_constants/Routes.dart';
import '../../../../../core/arguments.dart';
import 'package:mydexef/locator.dart' as di;
import '../../../../../core/class_constants/app_constants_values.dart';
import '../../../../../core/class_constants/constants_methods.dart';
import '../../../../../core/class_constants/images_path.dart';
import '../../../../../core/size_widgets/app_screen_size.dart';
import '../../../../../core/widgets/alert_dialog.dart';
import '../../../../../core/widgets/custom_round_button.dart';
import '../../../../../core/size_widgets/responsive_widget.dart';
import '../../../../../core/widgets/default_login_screen.dart';
import '../../../../../core/widgets/default_text.dart';
import '../../../../../core/widgets/network_failed.dart';
import '../../../../../style/colors/colors.dart';
import '../../../../../utils/app_localizations.dart';
import '../../../../../utils/cash_helper.dart';
import '../../../../../utils/constants.dart';
import '../../../presentation/cubit/verify_code_cubit/verify_code_states.dart';
import '../../../presentation/cubit/verify_code_social_cubit/verify_code_social_cubit.dart';
import '../../../presentation/cubit/verify_code_social_cubit/verify_code_social_states.dart';
import 'dart:ui' as ui;

class VerifyCodeSocial extends StatefulWidget {
  const VerifyCodeSocial({Key? key}) : super(key: key);

  @override
  State<VerifyCodeSocial> createState() => _VerifyCodeSocialState();
}

class _VerifyCodeSocialState extends State<VerifyCodeSocial> {
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
  VerifyCodeSocialCubit? verifyCodeSocialCubit;
  bool visibleContainer = false;
  dynamic location;
  bool isTap = false;
  double opacity = 0.0;
  Orientation? orientation;
  bool isValidCode = true;
  String? code;

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
    // codeControllerOne.clear();
    // codeControllerTwo.clear();
    // codeControllerThree.clear();
    // codeControllerFour.clear();
    // codeControllerFive.clear();
    // codeControllerSix.clear();
    // codeController.clear();
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
    codeController.dispose();
    super.dispose();
  }

////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    ArgumentsResetPasswordVerifyCode? args = CacheHelper.getObjectFromPrefs(
        key: Constants.verifyCodeSocialArguments.toString(),
        model: ArgumentsResetPasswordVerifyCode);
    return BlocProvider(
      create: (context) => di.locator<VerifyCodeSocialCubit>(),
      child: BlocConsumer<VerifyCodeSocialCubit, VerifyCodeSocialStates>(
        listener: (context, state) {
          if (state is VerifyCodeGoogleFaceError) {
            // showAlertDialog(
            //     context: context,
            //     isSuccess: false,
            //     title: AppLocalizations.of(context)!.translate('failed'),
            //     subTitle: state.verifyCodeEntity.errors?[0].message,
            //     textColor: Colors.black);
          } else if (state is SignInWithGoogleSuccess ||
              state is SignInWithFaceSuccess ||
              state is AppleSignInSuccess) {
            // showAlertDialog(
            //     context: context,
            //     isSuccess: true,
            //     title: AppLocalizations.of(context)!.translate('success'),
            //     textColor: Colors.black
            // );
            Router.neglect(context,
                () => context.go(Routes.preparingDataScreenFromSocial));
          } else if (state is VerifyCodeGoogleFaceFailure) {
            // showAlertDialog(
            //     context: context,
            //     isSuccess: false,
            //     title: AppLocalizations.of(context)!.translate('networkFailed'),
            //     subTitle: state.message,
            //     textColor: Colors.black);
          } else if (state is SignInWithGoogleFailure) {
            // showAlertDialog(
            //     context: context,
            //     isSuccess: false,
            //     title:  AppLocalizations.of(context)!.translate('networkFailed'),
            //
            //     subTitle: state.message,
            //     textColor: Colors.black);
          } else if (state is SignInWithFaceFailure) {
            // showAlertDialog(
            //     context: context,
            //     isSuccess: false,
            //     title: AppLocalizations.of(context)!.translate('networkFailed'),
            //     subTitle: state.message,
            //     textColor: Colors.black);
          }
        },
        builder: (context, state) {
          verifyCodeSocialCubit = VerifyCodeSocialCubit.get(context);
          final size = MediaQuery.of(context).size;
          return DefaultLoginScreen(
            isLoading: state is VerifyCodeGoogleFaceLoading ||
                state is SignInWithFaceLoading ||
                state is SignInWithGoogleStartLoading,
            body: args != null
                // ? (isTap == true || (kIsWeb && MediaQuery.of(context).size.shortestSide < 600)) || (orientation == Orientation.portrait)
                ? _buildRow(size, state, args)
                // : _buildStack(size, state, args)
                : Center(child: Center(child: NetworkFailed())),
          );
        },
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////
  Widget _buildRow(var size, VerifyCodeSocialStates state,
          ArgumentsResetPasswordVerifyCode args) =>
      Row(
        children: [
          AbsorbPointer(
            absorbing: state is VerifyCodeGoogleFaceLoading ||
                state is SignInWithGoogleStartLoading ||
                state is ResendLoadingState ||
                state is AppleSignInLoading,
            child: Container(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: false,
                    child: Row(
                      children: [
                        InkWell(
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          // Removes the background highlight color
                          splashColor: Colors.transparent,
                          // Removes the splash color
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 50, left: 50, right: 50),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: SvgPicture.asset(ImagesPath.backIcon),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      ResponsiveWidget(
                        localWidthRatio: 388 / 640,
                        child: SvgPicture.asset(
                          ImagesPath.verificationCodeImage,
                          height:
                              MediaQuery.of(context).size.height * (238 / 800),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      DefaultText(
                          text: AppLocalizations.of(context)!
                              .translate('verifyDescriptionMainScreen'),
                          align: TextAlign.center,
                          isMultiLine: true,
                          isTextTheme: true,
                          themeStyle:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    wordSpacing: 1.5,
                                    height: 1.5,
                                    fontFamily: AppFontStyle.appFontFamily.readex,
                                  )),
                    ],
                  ),
                  ResponsiveWidget(
                    localWidthRatio: ratioLogoMiniWidth,
                    fixedHeight: MediaQuery.of(context).size.height *
                        ratioLogoMiniHeight,
                    bottomPadding: MediaQuery.of(context).size.height *
                        ratioHeightUnderLogo,
                    child: SvgPicture.asset(ImagesPath.dexefLogoBody),
                  ),
                ],
              ),
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
                    textDirection: context.locale.languageCode == 'en'
                        ? ui.TextDirection.ltr
                        : ui.TextDirection.rtl,
                    child: ResponsiveWidget(
                      localWidthRatio: (MediaQuery.of(context).size.width <
                              AppConstants.minimumScreenSize)
                          ? 1
                          : ratioWidthComponentLogin,
                      startPadding: (MediaQuery.of(context).size.width <
                              AppConstants.minimumScreenSize)
                          ? 20
                          : 0,
                      endPadding: (MediaQuery.of(context).size.width <
                              AppConstants.minimumScreenSize)
                          ? 20
                          : 0,
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
                                    wordSpacing: 1.5,
                                    height: 1.5,
                                    fontFamily: AppFontStyle.appFontFamily.readex,
                                  )),
                         const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {},
                            child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .translate('enterVerify'),
                                    style: TextStyle(
                                        fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 16, mobileFontSize: 14.sp),
                                        height: 1.5,
                                        color: brush,
                                        fontFamily: AppFontStyle.appFontFamily.readex,
                                        fontWeight: FontWeight.w400),
                                    children: [
                                      WidgetSpan(
                                          child: InkWell(
                                        onTap: () {
                                          // if (isCountDown == false) {
                                          CacheHelper.saveObjectToPrefs(
                                              key: Constants
                                                  .changePhoneNumberArguments
                                                  .toString(),
                                              object:
                                                  ArgumentsChangePhoneNumber(
                                                      mobileID: args.mobileID,
                                                      isGoogle:
                                                          args.isFromGoogle,
                                                      isFacebook:
                                                          args.isFromFacebook));
                                          CacheHelper.saveObjectToPrefs(
                                            key: Constants
                                                .verifyCodeScreenArguments
                                                .toString(),
                                            object: ArgumentsVerifyCodeScreen(
                                              mobileId: args.mobileID,
                                              fromPage: 'changePhoneNumber',
                                            ),
                                          );
                                          Router.neglect(context, () {
                                            context.pushNamed(
                                                Routes.changePhoneNumber);
                                          });
                                          // Router.neglect(context, () {
                                          //   context.pushNamed(Routes.verifyCodeChoose);
                                          // });
                                          CacheHelper.saveObjectToPrefs(
                                            key: Constants
                                                .verifyCodeScreenArguments
                                                .toString(),
                                            object: ArgumentsVerifyCodeScreen(
                                              mobileId: args.mobileID,
                                              fromPage: 'changePhoneNumber',
                                            ),
                                          );
                                          Fluttertoast.showToast(
                                              msg: "New Version 1");
                                          // }
                                        },
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: DefaultText(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .translate('wrongNumber'),
                                              isTextTheme: true,
                                              themeStyle: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!
                                                  .copyWith(
                                                      color: primary,
                                                      height: 1.5,
                                                      fontFamily: AppFontStyle.appFontFamily.readex,
                                                      fontWeight: AppFontStyle.fontWeightCustoms.regular)),
                                        ),
                                      ))
                                    ])),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          ResponsiveWidget(
                            localWidthRatio: 1,
                            fixedHeight: 68,
                            child: Directionality(
                              textDirection: ui.TextDirection.ltr,
                              child: ResponsiveWidget(
                                localWidthRatio:
                                    (MediaQuery.of(context).size.width <
                                            AppConstants.minimumScreenSize)
                                        ? 0.7
                                        : 263 / 640,
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
                                          print(args.mobileID);
                                          if (args.isFromGoogle == true) {
                                            verifyCodeSocialCubit!
                                                .verifyCodeSmsSocial(
                                                    mobileId: args.mobileID!,
                                                    code: "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                                    isFromGoogle: true,
                                                    isFromApple: false);
                                          } else if (args.isApple == true) {
                                            verifyCodeSocialCubit!
                                                .verifyCodeSmsSocial(
                                                    mobileId: args.mobileID!,
                                                    code:
                                                        "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                                    isFromGoogle: false,
                                                    isFromApple: true);
                                          }
                                        } else {
                                          setState(() {
                                            isValidCode = false;
                                          });
                                        }
                                      },
                                      style: TextStyle(
                                          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 22, mobileFontSize: 20.sp),
                                          color: Colors.black),
                                      // maxLength: 1,
                                      controller: codeControllerOne,
                                      textAlign: TextAlign.center,
                                      // validator: (value) {
                                      //   if (value!.isEmpty) {
                                      //     return "";
                                      //   }
                                      //   return null;
                                      // },
                                      focusNode: firstNode,
                                      onChanged: (value) {
                                        if (codeControllerOne.text.isNotEmpty) {
                                          if (value.isNotEmpty) {
                                            secondNode.requestFocus();
                                            codeControllerOne.text = value[0];
                                            if (value.length == 5) {
                                              setState(() {
                                                codeControllerOne.text =
                                                    value[0];
                                                codeControllerTwo.text =
                                                    value[1];
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
                                          print(args.mobileID);
                                          if (args.isFromGoogle == true) {
                                            verifyCodeSocialCubit!
                                                .verifyCodeSmsSocial(
                                                    mobileId: args.mobileID!,
                                                    code: codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text,
                                                    isFromGoogle: true,
                                                    isFromApple: false
                                            );
                                          } else if (args.isApple == true) {
                                            verifyCodeSocialCubit!
                                                .verifyCodeSmsSocial(
                                                    mobileId: args.mobileID!,
                                                    code: codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text,
                                                    isFromGoogle: false,
                                                    isFromApple: true
                                            );
                                          }
                                        } else {
                                          setState(() {
                                            isValidCode = false;
                                          });
                                        }
                                      },
                                      style: TextStyle(
                                          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 22, mobileFontSize: 20.sp),
                                          color: Colors.black),
                                      controller: codeControllerTwo,
                                      maxLength: 1,
                                      textAlign: TextAlign.center,
                                      focusNode: secondNode,
                                      onChanged: (_) {
                                        if (codeControllerTwo.text.isNotEmpty) {
                                          thirdNode.requestFocus();
                                        } else {
                                          firstNode.requestFocus();
                                        }
                                      },
                                      // validator: (value) {
                                      //   if (value!.isEmpty) {
                                      //     return "";
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
                                      onFieldSubmitted: (_) {
                                        if (formKey.currentState!.validate()) {
                                          isValidCode = true;
                                          print(args.mobileID);
                                          if (args.isFromGoogle == true) {
                                            verifyCodeSocialCubit!
                                                .verifyCodeSmsSocial(
                                                    mobileId: args.mobileID!,
                                                    code:
                                                        "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                                    isFromGoogle: true,
                                                    isFromApple: false);
                                          } else if (args.isApple == true) {
                                            verifyCodeSocialCubit!
                                                .verifyCodeSmsSocial(
                                                    mobileId: args.mobileID!,
                                                    code:
                                                        "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                                    isFromGoogle: false,
                                                    isFromApple: true);
                                          }
                                        } else {
                                          setState(() {
                                            isValidCode = false;
                                          });
                                        }
                                      },
                                      style: TextStyle(
                                          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 22, mobileFontSize: 20.sp),
                                          color: Colors.black),
                                      maxLength: 1,
                                      controller: codeControllerThree,
                                      textAlign: TextAlign.center,
                                      focusNode: thirdNode,
                                      onChanged: (_) {
                                        if (codeControllerThree
                                            .text.isNotEmpty) {
                                          fourthNode.requestFocus();
                                        } else {
                                          secondNode.requestFocus();
                                        }
                                      },
                                      // validator: (value) {
                                      //   if (value!.isEmpty) {
                                      //     return "";
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
                                      //     return "";
                                      //   }
                                      //   return null;
                                      // },
                                      textAlign: TextAlign.center,
                                      controller: codeControllerFour,
                                      onFieldSubmitted: (_) {
                                        if (formKey.currentState!.validate()) {
                                          isValidCode = true;
                                          print(args.mobileID);
                                          if (args.isFromGoogle == true) {
                                            verifyCodeSocialCubit!
                                                .verifyCodeSmsSocial(
                                                    mobileId: args.mobileID!,
                                                    code:
                                                        "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                                    isFromGoogle: true,
                                                    isFromApple: false);
                                          } else if (args.isApple == true) {
                                            verifyCodeSocialCubit!
                                                .verifyCodeSmsSocial(
                                                    mobileId: args.mobileID!,
                                                    code:
                                                        "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                                    isFromGoogle: false,
                                                    isFromApple: true);
                                          }
                                        } else {
                                          setState(() {
                                            isValidCode = false;
                                          });
                                        }
                                      },
                                      style: TextStyle(
                                          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 22, mobileFontSize: 20.sp),
                                          color: Colors.black),
                                      focusNode: fourthNode,
                                      onChanged: (_) {
                                        if (codeControllerFour
                                            .text.isNotEmpty) {
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
                                      onFieldSubmitted: (_) {
                                        if (formKey.currentState!.validate()) {
                                          isValidCode = true;
                                          print(args.mobileID);
                                          if (args.isFromGoogle == true) {
                                            verifyCodeSocialCubit!
                                                .verifyCodeSmsSocial(
                                                    mobileId: args.mobileID!,
                                                    code:
                                                        "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                                    isFromGoogle: true,
                                                    isFromApple: false);
                                          } else if (args.isApple == true) {
                                            verifyCodeSocialCubit!
                                                .verifyCodeSmsSocial(
                                                    mobileId: args.mobileID!,
                                                    code:
                                                        "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                                    isFromGoogle: false,
                                                    isFromApple: true);
                                          }
                                        } else {
                                          setState(() {
                                            isValidCode = false;
                                          });
                                        }
                                      },
                                      style: TextStyle(
                                          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 22, mobileFontSize: 20.sp),
                                          color: Colors.black),
                                      maxLength: 1,
                                      // validator: (value) {
                                      //   if (value!.isEmpty) {
                                      //     return "";
                                      //   }
                                      //   return null;
                                      // },
                                      textAlign: TextAlign.center,
                                      controller: codeControllerFive,
                                      focusNode: fiveNode,
                                      onChanged: (_) {
                                        if (codeControllerFive
                                            .text.isNotEmpty) {
                                          fiveNode.requestFocus();
                                        } else {
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
                          ),
                          isValidCode == false
                              ? Row(
                                  children: [
                                    DefaultText(
                                        text: AppLocalizations.of(context)!
                                            .translate('invalidCode'),
                                        isTextTheme: true,
                                        themeStyle: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                              fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 12, mobileFontSize: 10.sp),
                                              color: Colors.red,
                                              height: 1.5,
                                              fontFamily:
                                                  AppFontStyle.appFontFamily.readex,
                                              fontWeight: FontWeight.w400,
                                            ))
                                  ],
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 30,
                          ),
                          ResponsiveWidget(
                            localWidthRatio: 1,
                            fixedHeight: 48,
                            child: CustomRoundedButton(
                                title: AppLocalizations.of(context)!
                                    .translate('verify'),
                                isLoading:
                                    state is VerifyLoadingState ? true : false,
                                onPressed: state is VerifyLoadingState
                                    ? () {}
                                    : () {
                                        if (formKey.currentState!.validate()) {
                                          isValidCode = true;
                                          print(args.mobileID);
                                          if (args.isFromGoogle == true) {
                                            verifyCodeSocialCubit!
                                                .verifyCodeSmsSocial(
                                                    mobileId: args.mobileID!,
                                                    code:
                                                        "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                                    isFromGoogle: true,
                                                    isFromApple: false);
                                          } else if (args.isApple == true) {
                                            verifyCodeSocialCubit!
                                                .verifyCodeSmsSocial(
                                                    mobileId: args.mobileID!,
                                                    code:
                                                        "${codeControllerOne.text + codeControllerTwo.text + codeControllerThree.text + codeControllerFour.text + codeControllerFive.text}",
                                                    isFromGoogle: false,
                                                    isFromApple: true);
                                          }
                                        } else {
                                          setState(() {
                                            isValidCode = false;
                                          });
                                        }
                                      }),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          DefaultText(
                              text: state is VerifyCodeGoogleFaceError
                                  ? (state
                                      .verifyCodeEntity.errors?.first.message)
                                  : state is SignInWithGoogleError
                                      ? (state.googleSignInEntity.errors?.first
                                          .message)
                                      : '',
                              isTextTheme: true,
                              themeStyle: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: Colors.red,
                                  )),
                          SizedBox(
                            height: 10,
                          ),
                          DefaultText(
                            text: AppLocalizations.of(context)!
                                .translate('takeTIme'),
                            isTextTheme: true,
                            themeStyle: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  height: 1.5,
                                  fontFamily: AppFontStyle.appFontFamily.readex,
                                  fontWeight: FontWeight.w400,
                                ),
                            align: TextAlign.start,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              InkWell(
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
                                      verifyCodeSocialCubit!.resendCodeSms(
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
                                                      text: AppLocalizations.of(
                                                              context)!
                                                          .translate(
                                                              'resendCode'),
                                                      align: TextAlign.start,
                                                      isTextTheme: true,
                                                      themeStyle: Theme.of(
                                                              context)
                                                          .textTheme
                                                          .labelSmall!
                                                          .copyWith(
                                                              color: primary,
                                                              height: 1.5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontFamily:
                                                                  AppFontStyle
                                                                      .appFontFamily.readex)),
                                                  DefaultText(
                                                      text:
                                                          " ${enforceLTRForNumbers("${(time.toInt() ~/ 60).toString().padLeft(2, '0')}:${(time % 60).toString().padLeft(2, '0')}")}",
                                                      align: TextAlign.start,
                                                      isTextTheme: true,
                                                      themeStyle: Theme.of(
                                                              context)
                                                          .textTheme
                                                          .labelSmall!
                                                          .copyWith(
                                                              color: primary,
                                                              height: 1.5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontFamily:
                                                                  AppFontStyle
                                                                      .appFontFamily.readex)),
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
                                                    height: 1.5,
                                                    fontFamily: AppFontStyle
                                                        .appFontFamily.readex,
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                ),
                              ),
                            ],
                          ),
                          userBlockCounter == 3
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 90,
                                    ),
                                    isCountDown
                                        ? Row(
                                            children: [
                                              // Text(
                                              //   "You have been blocked",
                                              //   textAlign: TextAlign.start,
                                              //   style: TextStyle(
                                              //     fontSize: 16,
                                              //     height: 1.5,
                                              //     color: Colors.red,
                                              //     fontFamily: "DXRound",
                                              //   ),
                                              // ),
                                              Countdown(
                                                seconds: 3600,
                                                build: (BuildContext context,
                                                        double time) =>
                                                    Row(
                                                  children: [
                                                    DefaultText(
                                                        text:
                                                            "${AppLocalizations.of(context)!.translate('blockedFor')}  ${(time.toInt() ~/ 60).toString().padLeft(2, '0')}:${(time % 60).toString().padLeft(2, '0')}",
                                                        align: TextAlign.start,
                                                        isTextTheme: true,
                                                        themeStyle: Theme.of(
                                                                context)
                                                            .textTheme
                                                            .labelSmall!
                                                            .copyWith(
                                                              color: Colors.red,
                                                              height: 1.5,
                                                              fontFamily:
                                                                  AppFontStyle
                                                                      .appFontFamily.readex,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            )),
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
                                            ],
                                          )
                                        : SizedBox()
                                  ],
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      );

////////////////////////////////////////////////////////////////////////////////
  Widget _buildStack(var size, VerifyCodeSocialStates state,
          ArgumentsResetPasswordVerifyCode args) =>
      Stack(
        children: [
          AnimatedSlide(
            offset: getLocation(visibleContainer),
            duration: const Duration(milliseconds: 300),
            child: AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(milliseconds: 300),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: AppScreenSize.appWidgetSize.getLoginRightPanelWidth(context),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
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
                                    height: 1.5,
                                    fontFamily: AppFontStyle.appFontFamily.readex,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ResponsiveWidget(
                              localWidthRatio: ratioWidthComponentLogin,
                              child: InkWell(
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
                                            fontFamily:
                                                AppFontStyle.appFontFamily.readex,
                                            fontWeight: FontWeight.w400),
                                        children: [
                                          TextSpan(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .translate('wrongNumber'),
                                              style: TextStyle(
                                                  fontSize:
                                                      AppFontStyle.appFontSize.setFontSize(context, webFontSize: 14, mobileFontSize: 12.sp),
                                                  height: 1.5,
                                                  color: primary,
                                                  fontFamily:
                                                      AppFontStyle.appFontFamily.readex,
                                                  fontWeight: FontWeight.w400))
                                        ])),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Directionality(
                              textDirection: ui.TextDirection.ltr,
                              child: ResponsiveWidget(
                                localWidthRatio: 263 / 640,
                                fixedHeight: 68,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: brushBorder)),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextFormField(
                                      style: TextStyle(
                                        fontSize: AppFontStyle.appFontSize.setFontSize(
                                            context, webFontSize: 22, mobileFontSize: 20.sp),
                                      ),
                                      maxLength: 1,
                                      controller: codeControllerOne,
                                      textAlign: TextAlign.center,
                                      focusNode: firstNode,
                                      onChanged: (_) =>
                                          secondNode.requestFocus(),
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
                                      style: TextStyle(
                                        fontSize: AppFontStyle.appFontSize.setFontSize(
                                            context, webFontSize: 22, mobileFontSize: 20.sp),
                                      ),
                                      controller: codeControllerTwo,
                                      maxLength: 1,
                                      textAlign: TextAlign.center,
                                      focusNode: secondNode,
                                      onChanged: (_) =>
                                          thirdNode.requestFocus(),
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
                                      style: TextStyle(
                                        fontSize: AppFontStyle.appFontSize.setFontSize(
                                            context, webFontSize: 22, mobileFontSize: 20.sp),
                                      ),
                                      maxLength: 1,
                                      controller: codeControllerThree,
                                      textAlign: TextAlign.center,
                                      focusNode: thirdNode,
                                      onChanged: (_) =>
                                          fourthNode.requestFocus(),
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
                                      textAlign: TextAlign.center,
                                      controller: codeControllerFour,
                                      style: TextStyle(
                                        fontSize: AppFontStyle.appFontSize.setFontSize(
                                            context, webFontSize: 22, mobileFontSize: 20.sp),
                                      ),
                                      focusNode: fourthNode,
                                      onChanged: (_) => fiveNode.requestFocus(),
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
                                      style: TextStyle(
                                        fontSize: AppFontStyle.appFontSize.setFontSize(
                                            context, webFontSize: 22, mobileFontSize: 20.sp),
                                      ),
                                      maxLength: 1,
                                      textAlign: TextAlign.center,
                                      controller: codeControllerFive,
                                      focusNode: fiveNode,
                                      onChanged: (_) => fiveNode.unfocus(),
                                      decoration: InputDecoration(
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
                                                fontFamily:
                                                    AppFontStyle.appFontFamily.readex,
                                                fontWeight: FontWeight.w400,
                                              ),
                                        )
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            const SizedBox(
                              height: 30,
                            ),
                            ResponsiveWidget(
                                localWidthRatio: ratioWidthComponentLogin,
                                fixedHeight: 48,
                                child: CustomRoundedButton(
                                  title: AppLocalizations.of(context)!
                                      .translate('verify'),
                                  isLoading: state is VerifyLoadingState
                                      ? true
                                      : false,
                                  onPressed: () {},
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            ResponsiveWidget(
                              localWidthRatio: ratioWidthComponentLogin,
                              child: DefaultText(
                                text: AppLocalizations.of(context)!
                                    .translate('takeTIme'),
                                fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 14, mobileFontSize: 12.sp),
                                isTextTheme: true,
                                themeStyle: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: brush,
                                      height: 1.5,
                                      fontFamily: AppFontStyle.appFontFamily.readex,
                                      fontWeight: FontWeight.w400,
                                    ),
                                align: TextAlign.start,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            ResponsiveWidget(
                              localWidthRatio: ratioWidthComponentLogin,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {},
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
                                                        text: AppLocalizations
                                                                .of(context)!
                                                            .translate(
                                                                'resendCode'),
                                                        align: TextAlign.start,
                                                        isTextTheme: true,
                                                        themeStyle: Theme.of(
                                                                context)
                                                            .textTheme
                                                            .labelSmall!
                                                            .copyWith(
                                                                color: primary,
                                                                height: 1.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    AppFontStyle
                                                                        .appFontFamily.readex),
                                                      ),
                                                      DefaultText(
                                                        text:
                                                            " ${enforceLTRForNumbers("${(time.toInt() ~/ 60).toString().padLeft(2, '0')}:${(time % 60).toString().padLeft(2, '0')}")}",
                                                        align: TextAlign.start,
                                                        isTextTheme: true,
                                                        themeStyle: Theme.of(
                                                                context)
                                                            .textTheme
                                                            .labelSmall!
                                                            .copyWith(
                                                                color: primary,
                                                                height: 1.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    AppFontStyle
                                                                        .appFontFamily.readex),
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
                                              : DefaultText(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .translate('resendCode'),
                                                  align: TextAlign.start,
                                                  isTextTheme: true,
                                                  themeStyle: Theme.of(context)
                                                      .textTheme
                                                      .labelSmall!
                                                      .copyWith(
                                                        color: primary,
                                                        height: 1.5,
                                                        fontFamily:
                                                            AppFontStyle
                                                                .appFontFamily.readex,
                                                        fontWeight:
                                                            FontWeight.w400,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 90,
                                        ),
                                        isCountDown
                                            ? Row(
                                                children: [
                                                  Countdown(
                                                    seconds: 3600,
                                                    build:
                                                        (BuildContext context,
                                                                double time) =>
                                                            Row(
                                                      children: [
                                                        DefaultText(
                                                          text:
                                                              "${AppLocalizations.of(context)!.translate('')}  ${(time.toInt() ~/ 60).toString().padLeft(2, '0')}:${(time % 60).toString().padLeft(2, '0')}",
                                                          align:
                                                              TextAlign.start,
                                                          isTextTheme: true,
                                                          themeStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .labelSmall!
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .red,
                                                                    height: 1.5,
                                                                    fontFamily:
                                                                        AppFontStyle
                                                                            .appFontFamily.readex,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
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
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: false,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 50, left: 50, right: 50),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: SvgPicture.asset(ImagesPath.backIcon),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      ResponsiveWidget(
                        localWidthRatio: 388 / 640,
                        child: SvgPicture.asset(
                          ImagesPath.verificationCodeImage,
                          height:
                              MediaQuery.of(context).size.height * (238 / 800),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      DefaultText(
                        text: AppLocalizations.of(context)!
                            .translate('verifyDescriptionMainScreen'),
                        isTextTheme: true,
                        themeStyle:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: brush,
                                  height: 1.5,
                                  wordSpacing: 1.5,
                                  fontFamily: AppFontStyle.appFontFamily.readex,
                                  fontWeight: FontWeight.w500,
                                ),
                        align: TextAlign.center,
                        isMultiLine: true,
                      ),
                    ],
                  ),
                  ResponsiveWidget(
                    localWidthRatio: ratioLogoMiniWidth,
                    fixedHeight: MediaQuery.of(context).size.height *
                        ratioLogoMiniHeight,
                    bottomPadding: MediaQuery.of(context).size.height *
                        ratioHeightUnderLogo,
                    child: SvgPicture.asset(ImagesPath.dexefLogoBody),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
////////////////////////////////////////////////////////////////////////////////
