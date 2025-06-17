import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/size_widgets/app_screen_size.dart';
import 'dart:ui' as ui;

import '../../../../core/rest/app_constants.dart';
import '../../../../core/rest/app_localizations.dart';
import '../../../../core/rest/arguments.dart';
import '../../../../core/rest/cash_helper.dart';
import '../../../../core/rest/constants.dart';
import '../../../../core/rest/methods.dart';
import '../../../../core/rest/regex.dart';
import '../../../../core/rest/routes.dart';
import '../../../../core/size_widgets/app_font_style.dart';
import '../../../../core/size_widgets/responsive_widget.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/public/custom_round_button.dart';
import '../../../../core/widgets/public/custom_text_field.dart';
import '../../../../core/widgets/public/default_login_screen.dart';
import '../../../../core/widgets/public/default_text.dart';
import '../cubit/reset_password_cubit.dart';
import '../cubit/reset_password_state.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);
  @override
  State<ResetPassword> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPassword> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late ResetPasswordCubit resetPasswordCubit;
  bool visibleContainer = false;
  dynamic location;
  bool isTap = false;
  double opacity = 0.0;
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
    super.initState();
  }

////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    return BlocConsumer<ResetPasswordCubit, ResetPasswordStates>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          CacheHelper.saveData(key: Constants.mobileId.toString(), value: (state.resetPasswordEntity.data?.mobileId));
        }
      },
      builder: (context, state) {
        resetPasswordCubit = ResetPasswordCubit.get(context);
        final size = MediaQuery.of(context).size;
        return Directionality(
          textDirection: ui.TextDirection.ltr,
          child: DefaultLoginScreen(
            isLoading: state is ResetPasswordLoading,
            body: _buildRow(size, state)
          ),
        );
      },
    );
  }

////////////////////////////////////////////////////////////////////////////////////////////
  Widget _buildRow(var size, ResetPasswordStates state) => Row(
    children: [
      AbsorbPointer(
        absorbing: state is ResetPasswordLoading,
        child: Container(
          width: size.width - AppScreenSize.appWidgetSize.getLoginRightPanelWidth(context),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: cloudBackground, boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.16),
              offset: Offset(0, 0),
              blurRadius: 12.0,
            )
          ]),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
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
              //             cursor: SystemMouseCursors.click,
              //             child: SvgPicture.asset(
              //                 "assets/images/back.svg")),
              //       ),
              //     ),
              //   ],
              // ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ResponsiveWidget(
                      localWidthRatio: 296 / 640,
                      child:  getImage(path:'images/reset_password.svg',isSvg: true , height: MediaQuery.of(context).size.height * (301 / 800),),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    DefaultText(
                      isMultiLine: true,
                      text: AppLocalizations.of(context)!.translate('canChangePassword'),
                      isTextTheme: true,
                      themeStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontFamily: AppFontStyle.appFontFamily.readex,
                        fontWeight: FontWeight.w500,
                        color:userLoginText,
                        wordSpacing: 1.5,
                        height: 1.5,
                      )
                    ),
                  ],
                ),
              ),
              ResponsiveWidget(
                localWidthRatio: ratioLogoMiniWidth,
                fixedHeight: MediaQuery.of(context).size.height *
                    ratioLogoMiniHeight,
                child: getImage(path:'images/dexef_logo_body.svg',isSvg: true ,),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    ratioHeightUnderLogo,
              )
            ],
          ),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height,
        width: AppScreenSize.appWidgetSize.getLoginRightPanelWidth(context),
        child: Center(
          child: ResponsiveWidget(
            localWidthRatio: MediaQuery.of(context).size.width > 1280 ? ratioWidthComponentLogin : 1,
            startPadding: 24,
            endPadding: 24,
            child: Form(
              key: formKey,
              child: Directionality(
                textDirection: context.locale.languageCode == 'en' ? ui.TextDirection.ltr : ui.TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DefaultText(
                      text: AppLocalizations.of(context)!.translate('resetPassword'),
                      isTextTheme: true,
                      themeStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontFamily: AppFontStyle.appFontFamily.readex,
                        color: userLoginText,
                        fontWeight: FontWeight.w800,
                      )
                    ),
                    const SizedBox(height: 16,),
                    DefaultText(
                      text:AppLocalizations.of(context)!.translate('enterEmail'),
                      isTextTheme: true,
                      themeStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                        height: 1.5,
                        color: brush.withOpacity(opacity),
                        fontWeight: FontWeight.w400,
                        fontFamily: AppFontStyle.appFontFamily.readex,
                      )
                    ),
                    const SizedBox(height: 30,),
                    ResponsiveWidget(
                      localWidthRatio: 1,
                      fixedHeight: 68,
                      child: CustomTextFormField(
                          maxLines: 1,
                          label: AppLocalizations.of(context)!.translate('emailPhone'),
                          controller: emailController,
                          fillColor: Colors.white,
                          onFieldSubmitted:(_) async {
                            if(formKey.currentState!.validate()){
                              CacheHelper.saveObjectToPrefs(key: Constants.verifyCodeSocialArguments.toString(),
                                  object: ArgumentsResetPasswordVerifyCode(
                                    // mobileID: state.mobileID,
                                  ));
                              CacheHelper.saveObjectToPrefs(key: Constants.verifyCodeScreenArguments.toString(), object: ArgumentsVerifyCodeScreen(
                                // mobileId: state.mobileID,
                                  fromPage: "resetPassword"
                              ));

                              CacheHelper.saveData(key: Constants.emailOrPhoneReset.toString(), value: emailController.text);

                              context.go(Routes.verifyCodeResetPassword);
                            }

                          },
                          // onFieldSubmitted: (value) {
                          //   if (formKey.currentState!.validate()) {
                          //     resetPasswordCubit
                          //         .resetPasswordEmailOrPhone(
                          //         emailController.text);
                          //   }
                          // },
                          errorState:  state is ResetPasswordError,
                          autoFocus: true,
                          onChange: (string){
                            setState(() {
                              if(state is ResetPasswordError) state.message = '';
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return  AppLocalizations.of(context)!.translate('required');
                            } else if (numbersRegex.hasMatch(value) ||
                                value.contains("+")) {
                              if (!phoneNumberRegex.hasMatch(value)) {
                                return AppLocalizations.of(context)!.translate('invalidPhoneNumber');
                              }
                            } else if (!emailRegexNew.hasMatch(value)) {
                              return  AppLocalizations.of(context)!.translate('invalidEmail');
                            }

                            return null;
                          }),
                    ),
                    ResponsiveWidget(
                      localWidthRatio: ratioWidthComponentLogin,
                      // fixedHeight: 68,
                      child:DefaultText(
                        text:state is ResetPasswordError ? state.message : '',
                        isTextTheme: true,
                        themeStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Colors.red,
                        )
                      ),
                    ),
                    const SizedBox(height: 50,),
                    ResponsiveWidget(
                      localWidthRatio: 1,
                      fixedHeight: 48,
                      child: CustomRoundedButton(
                          title: AppLocalizations.of(context)!.translate('next'),
                          isLoading: state is ResetPasswordLoading,
                          onPressed: () {
                            if(formKey.currentState!.validate()){
                              CacheHelper.saveObjectToPrefs(key: Constants.verifyCodeSocialArguments.toString(),
                                  object: ArgumentsResetPasswordVerifyCode(
                                    // mobileID: state.mobileID,
                                  ));
                              CacheHelper.saveObjectToPrefs(key: Constants.verifyCodeScreenArguments.toString(), object: ArgumentsVerifyCodeScreen(
                                // mobileId: state.mobileID,
                                  fromPage: "resetPassword"
                              ));

                              CacheHelper.saveData(key: Constants.emailOrPhoneReset.toString(), value: emailController.text);

                              context.go(Routes.verifyCodeResetPassword);
                            }

                            // navigateTo(context, ResetPasswordVerifyCode());
                            // if (formKey.currentState!.validate()) {
                            //   resetPasswordCubit.resetPasswordEmailOrPhone(emailController.text);
                            // }
                            // context.goNamed('resetPasswordVerifyCode',pathParameters: {
                            //   "mobileId" : "270"
                            // });
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 17,
                        ),
                        DefaultText(
                          text:  AppLocalizations.of(context)!.translate('backTo'),
                          align: TextAlign.center,
                          isTextTheme: true,
                          themeStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                            height: 1.5,
                            fontFamily: AppFontStyle.appFontFamily.readex,
                            fontWeight: FontWeight.w400,
                          )
                        ),
                        InkWell(
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,  // Removes the background highlight color
                          splashColor: Colors.transparent,     // Removes the splash color
                          onTap: () => context.go(Routes.loginScreen),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: DefaultText(
                              text:AppLocalizations.of(context)!.translate('signIn'),
                              align: TextAlign.center,
                              isTextTheme: true,
                              themeStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                                height: 1.5,
                                fontFamily: AppFontStyle.appFontFamily.readex,
                                color: primary,
                                fontWeight: FontWeight.w400,
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );

/////////////////////////////////////////////////////////////////////////////////////////////
  Widget _buildStack(var size, ResetPasswordStates state) => Stack(
    children: [
      AnimatedSlide(
        offset: getLocation(),
        duration: Duration(milliseconds: 300),
        child: AnimatedOpacity(
          opacity: opacity,
          duration: Duration(milliseconds: 300),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: AppScreenSize.appWidgetSize.getLoginRightPanelWidth(context),
            child: Center(
              child: ResponsiveWidget(
                localWidthRatio: ratioWidthComponentLogin,
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DefaultText(
                        text: AppLocalizations.of(context)!.translate('resetPassword'),
                        fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 32, mobileFontSize: 30.sp),
                        fontFamily: AppFontStyle.appFontFamily.readex,
                        fontColor: userLoginText,
                        fontWeight: FontWeight.w800,
                      ),
                      const SizedBox(height: 16,),
                      DefaultText(
                        text:AppLocalizations.of(context)!.translate('enterEmail'),
                        fontColor: brush.withOpacity(opacity),
                        fontWeight: FontWeight.w400,
                        fontFamily: AppFontStyle.appFontFamily.readex,
                        fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 16, mobileFontSize: 14.sp),
                        height: 1.5,
                      ),
                      const SizedBox(height: 30,),
                      ResponsiveWidget(
                        localWidthRatio: 1,
                        fixedHeight: 68,
                        child: CustomTextFormField(
                            label:  AppLocalizations.of(context)!.translate('emailPhone'),
                            controller: emailController,
                            onFieldSubmitted: (value) {
                              // if (formKey.currentState!.validate()) {
                              //   resetPasswordCubit.resetPasswordEmailOrPhone(emailController.text);
                              // }
                            },
                            autoFocus: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return  AppLocalizations.of(context)!.translate('required');
                              } else if (numbersRegex.hasMatch(value) ||
                                  value.contains("+")) {
                                if (!phoneNumberRegex.hasMatch(value)) {
                                  return AppLocalizations.of(context)!.translate('invalidPhoneNumber');
                                }
                              } else if (!emailRegexNew.hasMatch(value)) {
                                return  AppLocalizations.of(context)!.translate('invalidEmail');
                              }

                              return null;
                            }),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      ResponsiveWidget(
                        localWidthRatio: 1,
                        fixedHeight: 48,
                        child: CustomRoundedButton(
                            title:  AppLocalizations.of(context)!.translate('next'),
                            isLoading: state is ResetPasswordLoading,
                            onPressed: () {
                              context.go(Routes.verifyCodeResetPassword);
                              // navigateTo(context, ResetPasswordVerifyCode());
                              // if (formKey.currentState!.validate()) {
                              //   resetPasswordCubit.resetPasswordEmailOrPhone(emailController.text);
                              // }
                              // context.goNamed('resetPasswordVerifyCode',pathParameters: {
                              //   "mobileId" : "270"
                              // });
                            }),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 17,
                          ),
                          DefaultText(
                            text: AppLocalizations.of(context)!.translate('backTo'),
                            align: TextAlign.center,
                            fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 14, mobileFontSize: 12.sp),
                            height: 1.5,
                            fontColor: brush,
                            fontFamily: AppFontStyle.appFontFamily.readex,
                            fontWeight: FontWeight.w400,
                          ),
                          InkWell(
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,  // Removes the background highlight color
                            splashColor: Colors.transparent,     // Removes the splash color

                            onTap: () {
                              //Navigator.of(context).pushNamed(Login.route);
                              context.go(Routes.loginScreen);
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: DefaultText(
                                text: AppLocalizations.of(context)!.translate('signIn'),
                                align: TextAlign.center,
                                fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 14, mobileFontSize: 12.sp),
                                height: 1.5,
                                fontColor: primary,
                                fontFamily: AppFontStyle.appFontFamily.readex,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      Visibility(
        visible: (MediaQuery.of(context).size.width < AppConstants.minimumScreenSize) ? false : true,
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
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
              //             cursor: SystemMouseCursors.click,
              //             child:
              //                 SvgPicture.asset("assets/images/back.svg")),
              //       ),
              //     ),
              //   ],
              // ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ResponsiveWidget(
                      localWidthRatio: 296 / 640,
                      child:  getImage(path:'images/reset_password.svg',isSvg: true , height: MediaQuery.of(context).size.height * (301 / 800),),

                    ),
                    SizedBox(
                      height: 30,
                    ),
                    DefaultText(
                      isMultiLine: true,
                      text:AppLocalizations.of(context)!.translate('canChangePassword'),
                      fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 16, mobileFontSize: 14.sp),
                      align: TextAlign.center,
                      fontFamily: AppFontStyle.appFontFamily.readex,
                      fontWeight: FontWeight.w500,
                      fontColor: userLoginText,
                      wordSpacing: 1.5,
                      height: 1.5,
                    )
                  ],
                ),
              ),
              ResponsiveWidget(
                localWidthRatio: ratioLogoMiniWidth,
                fixedHeight: MediaQuery.of(context).size.height *
                    ratioLogoMiniHeight,
                child: getImage(path:'images/dexef_logo_body.svg',isSvg: true ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    ratioHeightUnderLogo,
              )
            ],
          ),
        ),
      ),
    ],
  );
}
