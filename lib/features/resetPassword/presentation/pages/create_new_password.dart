import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/size_widgets/app_screen_size.dart';
import '../../../../../core/size_widgets/app_font_style.dart';
import 'dart:ui' as ui;

import '../../../../core/rest/app_constants.dart';
import '../../../../core/rest/app_localizations.dart';
import '../../../../core/rest/arguments.dart';
import '../../../../core/rest/cash_helper.dart';
import '../../../../core/rest/constants.dart';
import '../../../../core/rest/methods.dart';
import '../../../../core/rest/regex.dart';
import '../../../../core/rest/routes.dart';
import '../../../../core/size_widgets/responsive_widget.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/public/custom_round_button.dart';
import '../../../../core/widgets/public/default_login_screen.dart';
import '../../../../core/widgets/public/default_text.dart';
import '../../../../core/widgets/public/network_failed.dart';
import '../../../../core/widgets/public/password_text_field.dart';
import '../cubit/reset_password_cubit.dart';
import '../cubit/reset_password_state.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({Key? key}) : super(key: key);

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  TextEditingController codeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  late ResetPasswordCubit resetPasswordCubit;
  final formKey = GlobalKey<FormState>();
  bool visibleContainer = false;
  dynamic location;
  double opacity = 0.0;
  bool isTap = false;
  Orientation? orientation;
////////////////////////////////////////////////////////////////////////////////
  getLocation(){
    if(visibleContainer){
      location = Offset(1, 0);
    }else{
      location = Offset(0, 0);
    }
    return location;
  }
////////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 5), (){
      setState(() {
        visibleContainer = true;
        opacity = 1.0;
      });
    });
    Future.delayed(Duration(milliseconds: 350), (){
      setState(() {
        isTap = true;
      });
    });
    super.initState();
  }
////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    ArgumentsCreateNewPassword? args = CacheHelper.getObjectFromPrefs(key: Constants.createNewPasswordArguments.toString(), model: ArgumentsCreateNewPassword);
    final size = MediaQuery.of(context).size;
    orientation = MediaQuery.of(context).orientation;
    return BlocConsumer<ResetPasswordCubit,ResetPasswordStates>(
      listener: (context,state){
        if(state is CreateNewPasswordSuccess){
          Router.neglect(context, () {
            context.go(Routes.passwordChangedSuccessful);
          });
        }
      },
      builder: (context,state){
        resetPasswordCubit = ResetPasswordCubit.instance;
        return DefaultLoginScreen(
          isLoading: state is CreateNewPasswordLoading,
          body: args != null ? _buildRow(size, state, resetPasswordCubit, args) : const Center(child: NetworkFailed()),
        );
      },
    );
  }
///////////////////////////////////////////////////////////////////////////////////
  Widget _buildRow (
    var size,
    ResetPasswordStates state,
    ResetPasswordCubit resetPasswordCubit,
    ArgumentsCreateNewPassword args
  )=>Row(
    children: [
      AbsorbPointer(
        absorbing: state is CreateNewPasswordLoading,
        child: Container(
          width: size.width - AppScreenSize.appWidgetSize.getLoginRightPanelWidth(context),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: cloudBackground, boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.16),
              offset: const Offset(0, 0),
              blurRadius: 12.0,
            )
          ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  InkWell(
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,  // Removes the background highlight color
                    splashColor: Colors.transparent,     // Removes the splash color
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding:  EdgeInsets.only(top: 50.h,left: 50.w,right: 50.w),
                      child: const SizedBox(),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ResponsiveWidget(
                      localWidthRatio: 372/640,
                      child: getImage(path:  'images/change_password.svg',isSvg: true,  height: MediaQuery.of(context).size.height * (233/800),),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (50/800),),
                    DefaultText(
                      text: AppLocalizations.of(context)!.translate('followSteps'),
                      align: TextAlign.center,
                      isMultiLine: true,
                      isTextTheme: true,
                      themeStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontFamily: AppFontStyle.appFontFamily.readex,
                        wordSpacing: 1.5,
                        height: 1.6,
                      )
                    ),
                  ],
                ),
              ),
              ResponsiveWidget(
                localWidthRatio: ratioLogoMiniWidth,
                fixedHeight: MediaQuery.of(context).size.height * ratioLogoMiniHeight,
                child:getImage(path:  'images/dexef_logo_body.svg',isSvg: true),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * ratioHeightUnderLogo,
              )
            ],
          ),
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
                textDirection: context.locale.languageCode == 'en' ? ui.TextDirection.ltr : ui.TextDirection.rtl,
                child: ResponsiveWidget(
                  localWidthRatio: AppScreenSize.appDesignSize.isWebPlatform(context) ? ratioWidthComponentLogin : 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DefaultText(
                        text: AppLocalizations.of(context)!.translate('changePassword'),
                        isTextTheme: true,
                        themeStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontFamily: AppFontStyle.appFontFamily.readex,
                          fontWeight: FontWeight.w800,
                        ),
                        align: TextAlign.start,
                      ),
                      const SizedBox(height: 6,),
                      DefaultText(
                        text: AppLocalizations.of(context)!.translate('changeReasons'),
                        isTextTheme: true,
                        themeStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontFamily: AppFontStyle.appFontFamily.readex,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                        align: TextAlign.start,
                      ),
                      const SizedBox(height: 36),
                      PasswordTextFormField(
                        controller: passwordController,
                        label:  AppLocalizations.of(context)!.translate('password'),
                        onFieldSubmitted: (_){
                          if(formKey.currentState!.validate()){
                            resetPasswordCubit.createNewPassword(
                                code: args.code!,
                                mobileID: args.mobileID!,
                                password: passwordController.text
                            );
                          }

                        },
                        onChange: (string){
                          setState(() {
                            resetPasswordCubit.errorMessage = null;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.translate('required');
                          } else if (!passwordRegex
                              .hasMatch(value)) {
                            return AppLocalizations.of(context)!.translate('passwordDescription');
                          }
                          return null;
                        },
                        // isPasswordVisible: true,
                      ),
                      const SizedBox(height: 10),
                      PasswordTextFormField(
                        controller: confirmPasswordController,
                        label: AppLocalizations.of(context)!.translate('confirmPassword'),
                        onChange: (string){
                          setState(() {
                            resetPasswordCubit.errorMessage = null;
                          });
                        },
                        onFieldSubmitted: (_){
                          if(formKey.currentState!.validate()){
                            resetPasswordCubit.createNewPassword(
                                code: args.code!,
                                mobileID: args.mobileID!,
                                password: passwordController.text
                            );
                          }

                        },
                        validator: (value) {
                          print(value);
                          print(confirmPasswordController.text);
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.translate('required');
                          }else if(value != passwordController.text){
                            return AppLocalizations.of(context)!.translate('passwordNotSimilar');
                          }
                          return null;
                        },
                        // isPasswordVisible: true,
                      ),
                      DefaultText(
                        text: resetPasswordCubit.errorMessage ?? '',
                        isTextTheme: true,
                        themeStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: redColor,
                        fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 11, mobileFontSize: 9.sp),
                        )
                      ),
                      const SizedBox(height: 40),
                      ResponsiveWidget(
                        // localWidthRatio:AppScreenSize.appDesignSize.isWebDesktop(context) ? ratioWidthComponentLogin : 1,
                        localWidthRatio: 1,
                        fixedHeight: 48,
                        child: CustomRoundedButton(
                            isLoading: state is CreateNewPasswordLoading,
                            title: AppLocalizations.of(context)!.translate('save'),
                            onPressed: (){
                              print('mobile id =====${args.mobileID}');
                              if(formKey.currentState!.validate()){
                                resetPasswordCubit.createNewPassword(
                                    code: args.code!,
                                    mobileID: args.mobileID!,
                                    password: passwordController.text
                                );
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
//////////////////////////////////////////////////////////////////////////////////
  Widget _buildStack (var size, ResetPasswordStates state,
      ResetPasswordCubit resetPasswordCubit , ArgumentsCreateNewPassword args) => Stack(children: [
    AnimatedSlide(
      duration: Duration(milliseconds: 300),
      offset: getLocation(),
      child: AnimatedOpacity(
        opacity: opacity,
        duration: Duration(milliseconds: 300),
        child: Container(
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
                    ResponsiveWidget(
                      localWidthRatio: ratioWidthComponentLogin,
                      child: DefaultText(
                        text:  AppLocalizations.of(context)!.translate('changePassword'),
                        fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 32, mobileFontSize: 30.sp),
                        fontFamily: AppFontStyle.appFontFamily.readex,
                        align: TextAlign.start,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    ResponsiveWidget(
                      localWidthRatio: ratioWidthComponentLogin,
                      child: DefaultText(
                        text: AppLocalizations.of(context)!.translate('changeReasons'),
                        fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 16, mobileFontSize: 14.sp),
                        fontColor: brush,
                        fontFamily: AppFontStyle.appFontFamily.readex,
                        fontWeight: FontWeight.w400,
                        align: TextAlign.start,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 45),
                    ResponsiveWidget(
                      localWidthRatio: ratioWidthComponentLogin,
                      fixedHeight: 68,
                      child: PasswordTextFormField(
                        controller: passwordController,
                        label: AppLocalizations.of(context)!.translate('password'),
                        onChange: (string){
                          setState(() {
                            resetPasswordCubit.errorMessage = null;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.translate('required');
                          } else if (!passwordRegex
                              .hasMatch(value)) {
                            return AppLocalizations.of(context)!.translate('passwordDescription');
                          }
                          return null;
                        },
                        // isPasswordVisible: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ResponsiveWidget(
                      localWidthRatio: ratioWidthComponentLogin,
                      fixedHeight: 68,
                      child: PasswordTextFormField(
                        controller: confirmPasswordController,
                        label: AppLocalizations.of(context)!.translate('confirmPassword'),
                        onChange: (string){
                          setState(() {
                            resetPasswordCubit.errorMessage = null;
                          });
                        },
                        validator: (value) {
                          print(value);
                          print(confirmPasswordController.text);
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.translate('required');
                          }else if(value != passwordController.text){
                            return AppLocalizations.of(context)!.translate('passwordNotSimilar');
                          }
                          return null;
                        },
                        // isPasswordVisible: true,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ResponsiveWidget(
                      localWidthRatio: ratioWidthComponentLogin,
                      fixedHeight: 48,
                      child: CustomRoundedButton(
                          isLoading: state is CreateNewPasswordLoading,
                          title:  AppLocalizations.of(context)!.translate('save'), onPressed: (){
                        if(formKey.currentState!.validate()){
                          resetPasswordCubit.createNewPassword(
                              code: args.code!,
                              mobileID: args.mobileID!,
                              password: passwordController.text
                          );
                        }
                      }),
                    ),
                    // ConditionalBuilder(
                    //   condition: state is !LoadingState,
                    //   builder: (context) => CustomRoundedButton(title: "Save", onPressed: (){
                    //     if(formKey.currentState!.validate()){
                    //       resetPasswordCubit.createNewPassword(
                    //           code: args.code!,
                    //           mobileID: args.mobileID!,
                    //           password: passwordController.text
                    //       );
                    //     }
                    //   }),
                    //   fallback: (context) => CustomLoadingButton(),
                    // ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    Visibility(
      visible: (MediaQuery.of(context).size.width < 1280) ? false : true,
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
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                InkWell(
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,  // Removes the background highlight color
                  splashColor: Colors.transparent,     // Removes the splash color
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding:  EdgeInsets.only(top: 50.h,left: 50.w,right: 50.w),
                    child: SizedBox(),
                  ),
                ),
              ],
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ResponsiveWidget(
                    localWidthRatio: 372/1280,
                    child: getImage(path:  'images/change_password.svg',isSvg: true,  height: MediaQuery.of(context).size.height * (233/800),),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * (50/800),),
                  DefaultText(
                    text:AppLocalizations.of(context)!.translate('followSteps'),
                    isTextTheme: true,
                    themeStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color:primary,
                        height: 1.5,
                        fontWeight:  FontWeight.w400,
                        fontFamily: AppFontStyle.appFontFamily.readex
                    ),
                    align: TextAlign.center,
                    isMultiLine: true,
                  ),
                ],
              ),
            ),
            ResponsiveWidget(
              localWidthRatio: ratioLogoMiniWidth,
              fixedHeight: MediaQuery.of(context).size.height * ratioLogoMiniHeight,
              child: getImage(path:  'images/dexef_logo_body.svg',isSvg: true,),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * ratioHeightUnderLogo,
            )
          ],
        ),
      ),
    ),
  ],
  );
////////////////////////////////////////////////////////////////////////////////
}
