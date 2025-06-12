import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../../../core/size_widgets/app_screen_size.dart';
import '../../../../core/size_widgets/responsive_widget.dart';
import '../../domain/entity/verify_code_entity.dart';
import 'package:auth_dexef/locator.dart' as di;
import 'dart:ui' as ui;

class ChangePhoneNumber extends StatefulWidget {
  const ChangePhoneNumber({Key? key,}) : super(key: key);
  @override
  State<ChangePhoneNumber> createState() => _ChangePhoneNumberState();
}

class _ChangePhoneNumberState extends State<ChangePhoneNumber> {
  TextEditingController phoneController = TextEditingController();
  VerifyCodeCubit? verifyCodeCubit;
  final formKey = GlobalKey<FormState>();
  VerifyCodeEntity? verifyCodeEntity;
  bool visibleContainer = false;
  dynamic location;
  bool isTap = false;
  double opacity = 0.0;
  String initialCountry = 'EG';
  PhoneNumber number = PhoneNumber(isoCode: 'EG');
  String? countryCode, phoneNumber;
  Orientation? orientation;
  String currentLang = "EN";
  int maxLength = 10;

///////////////////////////////////////////////////////////////////////////////// location
  getLocation() {
    if (visibleContainer) {
      location = const Offset(1, 0);
    } else {
      location = const Offset(0, 0);
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
    //final args = ModalRoute.of(context)!.settings.arguments as ArgumentsChangePhoneNumber;
    //final args =  ArgumentsChangePhoneNumber(mobileID: 641,email: "",password: "");
    ArgumentsChangePhoneNumber? args = CacheHelper.getObjectFromPrefs(key: Constants.changePhoneNumberArguments.toString(), model: ArgumentsChangePhoneNumber);
    orientation = MediaQuery.of(context).orientation;
    String? errorMessage;
    return BlocProvider(
      create: (context) => di.locator<VerifyCodeCubit>(),
      child: BlocConsumer<VerifyCodeCubit, VerifyCodeStates>(
        listener: (context, state) {
          if(state is ChangePhoneNumberSuccess && args!.isFacebook == false && args.isGoogle == false){
            // context.go(Routes.verifyCodeChoose);
            CacheHelper.saveObjectToPrefs(key: Constants.verifyCodeScreenArguments.toString(), object: ArgumentsVerifyCodeScreen(
                mobileId: state.mobileID,
                email: args.email,
                password: args.password,
                fromPage: 'changePhoneNumber',
                countryCode: countryCode ?? '20',

            ));
          }else if(state is ChangePhoneNumberFailed){
            errorMessage = state.message;
            // showAlertDialog(
            //     context: context,
            //     isSuccess: false,
            //     title: AppLocalizations.of(context)!.translate('changePhoneFailed'),
            //     subTitle: state.message,
            //     textColor: Colors.black
            // );
          }else if(state is ResendCodeFailed){
            Fluttertoast.showToast(msg: state.message);
          }else if(state is ChangePhoneNumberSuccess && (args!.isFacebook == true || args.isGoogle == true)){
            Router.neglect(context, () {context.go(Routes.verifyCodeSocial);});
            CacheHelper.saveObjectToPrefs(key: Constants.verifyCodeSocialArguments.toString(),object: ArgumentsResetPasswordVerifyCode(
                mobileID: state.mobileID,
                isFromGoogle: args.isGoogle,
                isFromFacebook: args.isFacebook,
            ));
          }
        },
        builder: (context, state) {
          verifyCodeCubit = VerifyCodeCubit.get(context);
          return DefaultLoginScreen(
            isLoading: state is ChangePhoneLoadingState,
            body: args != null
                // ? (isTap == true || (kIsWeb &&  MediaQuery.of(context).size.shortestSide < 600)) || (orientation == Orientation.portrait)
                ? _buildRow(context, state, args)
                // : _buildStack(context, state)
                : Center(child: NetworkFailed()),
          );
        },
      ),
    );
  }

  Widget _buildRow(BuildContext context, VerifyCodeStates state, ArgumentsChangePhoneNumber args) => Row(
    children: [
      AbsorbPointer(
        absorbing:state is ChangePhoneLoadingState ,
        child: Container(
          width: MediaQuery.of(context).size.width -AppScreenSize.appWidgetSize.getLoginRightPanelWidth(context),
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
              // Visibility(
              //   visible: false,
              //   child: Row(
              //     children: [
              //       InkWell(
              //         onTap: () {
              //           Navigator.pop(context);
              //         },
              //         child: Padding(
              //           padding: EdgeInsets.only(top: 50, left: 50, right: 50),
              //           child: SvgPicture.asset("assets/images/back.svg"),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ResponsiveWidget(
                      localWidthRatio: ratioImageWidth,
                      child: getImage(path:'images/reset_password.svg' ,isSvg: true ,),
                    ),
                    const SizedBox(height: 30),
                    DefaultText(
                      text: 'Dexef Cloud',
                      isTextTheme: true,
                      maxLines: 1,
                      themeStyle: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          height: 1.5,
                          fontWeight:  FontWeight.w400,
                          wordSpacing: 1.5,
                          fontFamily: AppFontStyle.appFontFamily.readex
                      ),
                      align: TextAlign.center,
                    ),
                  ],
                ),
              ),
              ResponsiveWidget(
                localWidthRatio: ratioLogoMiniWidth,
                fixedHeight: MediaQuery.of(context).size.height * ratioLogoMiniHeight,
                child:  getImage(path:  'images/app_logo.svg' ,isSvg: true),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * ratioHeightUnderLogo,
              ),
            ],
          ),
        ),
      ),
      Container(
        height: MediaQuery.of(context).size.height,
        width: AppScreenSize.appWidgetSize.getLoginRightPanelWidth(context),
        child: Directionality(
          textDirection: context.locale.languageCode == 'en' ? ui.TextDirection.ltr : ui.TextDirection.rtl,
          child: Column(
            children: [
              ResponsiveWidget(
                endPadding: 50.w,
                topPadding: 22.h,
                bottomPadding: MediaQuery.of(context).size.height * (85/800),
                localWidthRatio: 1,
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: ResponsiveWidget(
                      localWidthRatio: (MediaQuery.of(context).size.width > AppConstants.minimumScreenSize) ? ratioWidthComponentLogin : 1 ,
                      startPadding: (MediaQuery.of(context).size.width > AppConstants.minimumScreenSize) ? 0 : 24,
                      endPadding: (MediaQuery.of(context).size.width > AppConstants.minimumScreenSize) ? 0 : 24 ,
                      child: Directionality(
                        textDirection: context.locale.languageCode == 'en' ? ui.TextDirection.ltr : ui.TextDirection.rtl,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            DefaultText(
                              text: AppLocalizations.of(context)!.translate('enterPhone'),
                              isTextTheme: true,
                              themeStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontFamily: AppFontStyle.appFontFamily.readex,
                                fontWeight: FontWeight.w800,
                                color: success,
                              )
                            ),
                            const SizedBox(height: 10),
                            DefaultText(
                              text: AppLocalizations.of(context)!.translate('verifyNumber'),
                              isTextTheme: true,
                              themeStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                                fontFamily: AppFontStyle.appFontFamily.readex,
                                fontWeight: FontWeight.w400,
                                color: brushLines,
                                height: 1.5,
                              )
                            ),
                            const SizedBox(height: 40),
                            InternationalPhoneNumberInput(
                              autoFocus: true,
                              initialValue: number,spaceBetweenSelectorAndTextField: 0,
                              textFieldController: phoneController,
                              onInputValidated: (value) {},
                              formatInput: false,
                              maxLength: maxLength,
                              validator: (value){
                                if(value!.isEmpty){
                                  return  AppLocalizations.of(context)!.translate('required');
                                }
                                else if (!phoneNumberRegex1.hasMatch(value)) {
                                  return AppLocalizations.of(context)!.translate('invalidPhoneNumber');
                                }
                              },
                              textStyle: TextStyle(fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 16, mobileFontSize: 14.sp),),
                              selectorConfig: SelectorConfig(
                                  selectorType: PhoneInputSelectorType.DIALOG,
                                  setSelectorButtonAsPrefixIcon: true,showFlags: false,leadingPadding: 10,trailingSpace: false
                              ),
                              inputDecoration: InputDecoration(
                                  contentPadding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  errorStyle: TextStyle(height: .5),

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(color: state is ChangePhoneNumberFailed ? redColor : brushBorder),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(color:state is ChangePhoneNumberFailed ? redColor : brushBorder,
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(color: state is ChangePhoneNumberFailed ? redColor : brushBorder)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(color: Colors.red)),
                                  hintText:AppLocalizations.of(context)!.translate('phoneNumber'),
                                  hintStyle: TextStyle(color:Colors.grey,fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 16, mobileFontSize: 14.sp), )
                              ),
                              onInputChanged: (phone) {
                                phoneNumber = phone.phoneNumber;
                                countryCode = phone.dialCode.toString();
                                setState(() {
                                if(state is ChangePhoneNumberFailed) state.message ='';
                                  if (phoneController.text.startsWith('0')) {
                                    phoneController.value = TextEditingValue(
                                      text: phoneController.text.substring(1),
                                      selection: TextSelection.fromPosition(
                                        TextPosition(offset: phoneController.text.length - 1),
                                      ),
                                    );
                                  }
                                  maxLength = countries
                                      .firstWhere((element) =>
                                  element.dialCode.toString() ==
                                      phone.dialCode
                                          ?.substring(1)
                                          .toString())
                                      .maxLength;
                                });

                                print(countryCode);
                                print(phoneNumber);
                                print(phone.isoCode);
                                print(phoneController.text);

                              },
                              inputBorder: InputBorder.none,
                            ),
                            DefaultText(
                              text:state is ChangePhoneNumberFailed ? state.message : '',
                            ),
                            const SizedBox(height: 50),
                            ResponsiveWidget(
                                localWidthRatio: 1,
                                fixedHeight: 48,
                                child: CustomRoundedButton(
                                    isLoading: state is ChangePhoneLoadingState,
                                    title: AppLocalizations.of(context)!.translate('next'),
                                    onPressed: () async {
                                      // navigateTo(context, ResetPasswordVerifyCode());
                                      if(formKey.currentState!.validate()){
                                        print(countryCode! + phoneController.text);

                                        String? phone = phoneController.text.startsWith('0') ? phoneController.text.replaceFirst('0', '') : phoneController.text;

                                        CacheHelper.saveData(key: Constants.phone.toString(), value: phone);
                                        CacheHelper.saveData(key: Constants.countryCode.toString(), value: countryCode);

                                        context.go(Routes.verifyCodeChangeNumber);
                                        CacheHelper.saveData(key: Constants.emailOrPhoneReset.toString(), value: phoneController.text);

                                        CacheHelper.saveObjectToPrefs(key: Constants.verifyCodeScreenArguments.toString(), object: ArgumentsVerifyCodeScreen(
                                            // mobileId: state.moni,
                                            email: args.email,
                                            password: args.password,
                                            fromPage: 'changePhoneNumber',mobilePhone: phoneController.text
                                        ));

                                        // verifyCodeCubit!.changePhoneNumber(mobileId: args.mobileID!,
                                        //     phoneNumber: countryCode! + phone, countryCode: countryCode!.substring(1).trim());
                                      }
                                    })
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
      ),
    ],
  );

  Widget _buildStack(BuildContext context, VerifyCodeStates state) => Stack(
    alignment: Alignment.centerLeft,
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
            child: Column(
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: ResponsiveWidget(
                        localWidthRatio: ratioWidthComponentLogin,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            DefaultText(
                              text: AppLocalizations.of(context)!.translate('enterPhone'),
                              fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 22, mobileFontSize: 20.sp),
                              fontFamily: AppFontStyle.appFontFamily.readex,
                              fontWeight: FontWeight.w800,
                              fontColor: success,
                            ),
                            const SizedBox(height: 10),
                            DefaultText(
                              text: AppLocalizations.of(context)!.translate('verifyNumber'),
                              fontSize:  AppFontStyle.appFontSize.setFontSize(context, webFontSize: 16, mobileFontSize: 14.sp),
                              fontFamily: AppFontStyle.appFontFamily.readex,
                              fontWeight: FontWeight.w400,
                              fontColor: brushLines,
                              height: 1.5,
                            ),
                            const SizedBox(height: 40),
                            InternationalPhoneNumberInput(
                              autoFocus: true,
                              initialValue: number,spaceBetweenSelectorAndTextField: 0,
                              textFieldController: phoneController,
                              onInputValidated: (value) {},
                              formatInput: false,
                              validator: (value){
                                if(value!.isEmpty){
                                  return  AppLocalizations.of(context)!.translate('required');
                                }
                                else if (!phoneNumberRegex1.hasMatch(value)) {
                                  return AppLocalizations.of(context)!.translate('invalidPhoneNumber');
                                }
                                return null;
                              },
                              textStyle: TextStyle(fontSize:  AppFontStyle.appFontSize.setFontSize(context, webFontSize: 16, mobileFontSize: 14.sp),),
                              selectorConfig: SelectorConfig(
                                  selectorType: PhoneInputSelectorType.DIALOG,
                                  setSelectorButtonAsPrefixIcon: true,showFlags: false,leadingPadding: 10,trailingSpace: false
                              ),
                              inputDecoration: InputDecoration(
                                  contentPadding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  errorStyle: TextStyle(height: .5),

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(color: brushBorder),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(color: brushBorder,
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(color: brushBorder)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(color: Colors.red)),
                                  hintText: 'Phone Number',
                                  hintStyle: TextStyle(color:Colors.grey,fontSize:  AppFontStyle.appFontSize.setFontSize(context, webFontSize: 16, mobileFontSize: 14.sp), )
                              ),
                              onInputChanged: (phone) {
                                phoneNumber = phone.phoneNumber;
                                countryCode = phone.dialCode.toString();
                                setState(() {
                                  if (phoneController.text.startsWith('0')) {
                                    phoneController.value = TextEditingValue(
                                      text: phoneController.text.substring(1),
                                      selection: TextSelection.fromPosition(
                                        TextPosition(offset: phoneController.text.length - 1),
                                      ),
                                    );
                                  }
                                  maxLength = countries
                                      .firstWhere((element) =>
                                  element.dialCode.toString() ==
                                      phone.dialCode
                                          ?.substring(1)
                                          .toString())
                                      .maxLength;
                                });
                              },
                              inputBorder: InputBorder.none,
                            ),
                            const SizedBox(height: 50),
                            ResponsiveWidget(
                                localWidthRatio: 1,
                                fixedHeight: 48,
                                child: CustomRoundedButton(
                                    isLoading: state is ChangePhoneLoadingState,
                                    title:  AppLocalizations.of(context)!.translate('next'),
                                    onPressed: ()  {})
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Visibility(
        visible: (MediaQuery.of(context).size.width < AppConstants.minimumScreenSize) ? false : true,
        child: Container(
          width: MediaQuery.of(context).size.width -AppScreenSize.appWidgetSize.getLoginRightPanelWidth(context),
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
              // Visibility(
              //   visible: false,
              //   child: Row(
              //     children: [
              //       InkWell(
              //         onTap: () {
              //           Navigator.pop(context);
              //         },
              //         child: Padding(
              //           padding: EdgeInsets.only(top: 50, left: 50, right: 50),
              //           child: SvgPicture.asset("assets/images/back.svg"),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ResponsiveWidget(
                      localWidthRatio: ratioMyDexefWidth,
                      child:
                      getImage(path:  'images/app_logo.svg' ,isSvg: true  , height: MediaQuery.of(context).size.height * ratioMyDexefHeight,),
                    ),
                    const SizedBox(height: 30),
                    DefaultText(
                      text: 'Smart Resturant POS',
                      fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 42, mobileFontSize: 40.sp),
                      align: TextAlign.center,
                      fontFamily: AppFontStyle.appFontFamily.readex,
                      fontColor: brush,
                      wordSpacing: 1.5,
                      height: 1.5,
                    ),
                  ],
                ),
              ),
              ResponsiveWidget(
                localWidthRatio: ratioLogoMiniWidth,
                fixedHeight: MediaQuery.of(context).size.height * ratioLogoMiniHeight,
                child:  getImage(path:  'images/dexef_logo_body.svg',isSvg: true),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * ratioHeightUnderLogo,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}