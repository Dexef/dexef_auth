import 'package:auth_dexef/features/register/presentation/cubit/register_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
import '../../../../core/widgets/register_widget/verify_radio_box.dart';
import '../cubit/register_states.dart';

class ChoosingVerificationCode extends StatefulWidget {
  const ChoosingVerificationCode({
    Key? key,
  }) : super(key: key);
  @override
  State<ChoosingVerificationCode> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<ChoosingVerificationCode> {
  final formKey = GlobalKey<FormState>();
  late RegisterCubit registerCubit;
  @override
  void initState() {
    CacheHelper.removeData(key: Constants.isWhatsApp.toString());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ArgumentsVerifyCodeScreen? args = CacheHelper.getObjectFromPrefs(
      key: Constants.verifyCodeScreenArguments.toString(),
      model: ArgumentsVerifyCodeScreen
    );
    String emailOrPhone = CacheHelper.getData(key: Constants.emailOrPhoneReset.toString()) ?? '';
    String phone = CacheHelper.getData(key: Constants.phone.toString()) ?? '' ;
    String countryCode = CacheHelper.getData(key: Constants.countryCode.toString()) ?? '' ;
    int mobileId = CacheHelper.getData(key: Constants.mobileId.toString()) ?? 0 ;
    registerCubit.errorMessage = '' ;
    return BlocConsumer<RegisterCubit, RegisterStates>(
      listener: (context, state) {
        if(state is SendCodeSuccess){
          if(args?.fromPage == 'signUp'){
            Router.neglect(context, () {
              context.go(Routes.verifyCodeScreen);
            });
            CacheHelper.saveObjectToPrefs(
              key: Constants.verifyCodeScreenArguments.toString(),
              object: ArgumentsVerifyCodeScreen(
                mobileId:  args?.mobileId ?? mobileId ,
                email: args?.email,
                password: args?.password,
                fromPage: args?.fromPage,
                mobilePhone: args?.mobilePhone,
                countryCode: countryCode,
              ),
            );
          }
          else if(args?.fromPage == 'verifySocial'){
            Router.neglect(context, () {
              context.go(Routes.verifyCodeSocial);
            });
          }
          else if(args?.fromPage == 'resetPassword'){
            Router.neglect(context, () {
              context.go(Routes.resetPasswordVerifyCode);
            });
          }else if(args?.fromPage == 'changePhoneNumber'){
            Router.neglect(context, () {
              context.go(Routes.verifyCodeChooseProfile);
            });
          }
        }else if (state is ChangeMobileSuccess){
          ArgumentsChangePhoneNumber? changeArgs = CacheHelper.getObjectFromPrefs(key: Constants.changePhoneNumberArguments.toString(), model: ArgumentsChangePhoneNumber);
          context.go(Routes.verifyCodeScreen);
          CacheHelper.saveObjectToPrefs(key: Constants.verifyCodeScreenArguments.toString(), object: ArgumentsVerifyCodeScreen(
            mobileId: state.changeMobileEntity.data?.mobileId,
            email: changeArgs?.email,
            password: changeArgs?.password,
            fromPage: 'changePhoneNumber',
          ));
        }
      },
      builder: (context, state) {
        registerCubit = RegisterCubit.instance;
        return DefaultLoginScreen(
          isLoading: state is SendCodeLoading || state is VerifyMobileLoading,
          body: AbsorbPointer(
            absorbing: state is VerifyMobileLoading || state is ResendCodeLoading || state is SendCodeLoading,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ResponsiveWidget(
                          localWidthRatio: 388 / 640,
                          localHeightRatio: 346/1024,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              getImage(
                                path: 'images/prepare_code.svg',
                                isSvg: true,
                                height: MediaQuery.of(context).size.height * (238 / 800),
                                fit: BoxFit.contain
                              ),
                              const SizedBox(height: 30,),
                              DefaultText(
                                text: AppLocalizations.of(context)!
                                    .translate('prepareCode'),
                                isTextTheme: true,
                                themeStyle: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                    height: 2,
                                    wordSpacing: 1.5,
                                    fontWeight: FontWeight.w500,
                                    fontFamily:
                                    AppFontStyle.appFontFamily.readex
                                ),
                                align: TextAlign.center,
                                isMultiLine: true,
                              ),
                            ],
                          ),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    fontFamily:
                                    AppFontStyle.appFontFamily.readex),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ResponsiveWidget(
                                localWidthRatio: ratioWidthComponentLogin,
                                child: DefaultText(
                                  text: AppLocalizations.of(context)!
                                      .translate('selectAway'),
                                  isTextTheme: true,
                                  themeStyle: Theme.of(context)
                                      .textTheme
                                      .labelMedium !
                                      .copyWith(
                                      height: 1.5,
                                      fontWeight:
                                      AppFontStyle.fontWeightCustoms.regular,
                                      fontFamily: AppFontStyle.appFontFamily.readex),
                                ),
                              ),
                              const SizedBox(height: 24,),
                              DefaultText(
                                  text: AppLocalizations.of(context)!.translate('howContact'),
                                  isTextTheme: true,
                                  themeStyle: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                      color: brushIcon,
                                      height: 1.5,
                                      fontWeight: AppFontStyle.fontWeightCustoms.regular,
                                      fontFamily: AppFontStyle.appFontFamily.readex)
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              ResponsiveWidget(
                                localWidthRatio: 0.85,
                                child: VerifyRadio(
                                  radioText: AppLocalizations.of(context)!.translate('whatsCode'),
                                  groupValue: registerCubit.isWhatsAppSelected,
                                  value: true,
                                  onChanged: (value) =>
                                      verifyCodeCubit?.handleWhatsAppChanged(value),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              ResponsiveWidget(
                                localWidthRatio: 0.85,
                                child: VerifyRadio(
                                  radioText: AppLocalizations.of(context)!
                                      .translate('smsCode'),
                                  groupValue: verifyCodeCubit!.isWhatsAppSelected ,
                                  value: false,
                                  onChanged: (value) =>
                                      verifyCodeCubit?.handleSmsChanged(value),
                                ),
                              ),
                              SizedBox(height: 10,),
                              ResponsiveWidget(
                                localWidthRatio: 0.7,
                                child: DefaultText(
                                    text: verifyCodeCubit?.errorMessage?.contains("is not a valid phone number") == true
                                        ? AppLocalizations.of(context)?.translate('phoneNotRegistered')
                                        : verifyCodeCubit?.errorMessage,
                                    isTextTheme: true,
                                    maxLines: null,
                                    themeStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                                      color: redColor,
                                      height: 1.5,)
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ResponsiveWidget(
                                localWidthRatio: ratioWidthComponentLogin,
                                fixedHeight: 48,
                                child: CustomRoundedButton(
                                  ////
                                    isLoading: false,
                                    title: AppLocalizations.of(context)!.translate('continue'),
                                    onPressed: state is UpdateMobileLoading || state is SendSmsLoading ? (){}
                                        : (){
                                      if (formKey.currentState!.validate()) {
                                        if(args?.fromPage == 'signUp' || args?.fromPage == 'verifySocial'){
                                          verifyCodeCubit?.sendSmsVerification(
                                            mobileId: args!.mobileId!,
                                            isWhatsApp:CacheHelper.getData(key: Constants.isWhatsApp.toString()) ?? true,
                                          );
                                        }else if(args?.fromPage == 'resetPassword'){
                                          verifyCodeCubit?.resetPasswordEmailOrPhone(args?.mobilePhone ?? emailOrPhone,CacheHelper.getData(key: Constants.isWhatsApp.toString()) ?? true,);
                                        }else if(args?.fromPage == 'changePhoneNumber'){
                                          verifyCodeCubit?.changePhoneNumber(
                                            mobileId: mobileId,
                                            phoneNumber: countryCode + phone,
                                            countryCode: countryCode.substring(1).trim(),
                                            isWhatsapp:CacheHelper.getData(key: Constants.isWhatsApp.toString()) ?? true,
                                          );
                                        }else if(args?.fromPage == 'changePasswordProfile'){
                                          verifyCodeCubit?.updateMobile(
                                            mobileID: mobileId,
                                            phoneNumber: args!.mobilePhone!,
                                            countryCode: args.countryCode!,
                                            isWhatsApp:CacheHelper.getData(key: Constants.isWhatsApp.toString()) ?? true,
                                          );
                                        }
                                      }
                                    }),
                              ),
                              const SizedBox(
                                height: 10,
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
          ),
        );
      },
    );
  }
}
