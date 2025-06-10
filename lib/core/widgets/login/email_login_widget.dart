import 'package:auth_dexef/core/widgets/login/password_login_Widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/size_widgets/app_screen_size.dart';
import '../../../../../../core/size_widgets/responsive_widget.dart';
import '../../../../../../core/size_widgets/app_font_style.dart';
import '../../../dexef_auth/login/presentation/cubit/login_cubit.dart';
import '../../../dexef_auth/login/presentation/cubit/login_states.dart';
import '../../rest/app_localizations.dart';
import '../../rest/cash_helper.dart';
import '../../rest/constants.dart';
import '../../rest/regex.dart';
import '../public/custom_round_button.dart';
import '../public/custom_text_field.dart';
import '../public/default_text.dart';
import 'drop_down_countries_widget.dart';

class EmailLoginWidget extends StatefulWidget {
  final TextEditingController phoneOrEmail;
  final LoginCubit loginCubit;
  final LoginState state;
  final GlobalKey<FormState> formKey;
  final FocusNode emailFocusNode;

  const EmailLoginWidget({
    super.key,
    required this.phoneOrEmail,
    required this.loginCubit,
    required this.state,
    required this.formKey,
    required this.emailFocusNode,
  });
  @override
  State<EmailLoginWidget> createState() => _EmailLoginWidgetState();
}

class _EmailLoginWidgetState extends State<EmailLoginWidget> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
            controller: widget.phoneOrEmail,
            focusNode: widget.emailFocusNode,
            autofillHints: const [
              AutofillHints.email,
              AutofillHints.telephoneNumberNational
            ],
            prefix: DropDownCountries(loginCubit: widget.loginCubit),
            fillColor: Colors.white,
            autoFocus: kIsWeb && AppScreenSize.appDesignSize.isWebPlatform(context) ? true : kIsWeb && !AppScreenSize.appDesignSize.isWebPlatform(context) && keyboardOpen ? true : false,
            maxLines: 1,
            hintFontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 14, mobileFontSize: 12.sp),
            errorState: widget.loginCubit.errorMessage != null,
            onFieldSubmitted: isLoadingLogin ? null : (_) async {
              if (widget.formKey.currentState!.validate()) {
                widget.formKey.currentState!.save();
                isLoadingLogin = true;
                await widget.loginCubit.validateEmailNormal(widget.phoneOrEmail.text,);
              }
            },
            label: AppLocalizations.of(context)!.translate('emailPhone'),
            onChange: (_) {
              if(widget.loginCubit.errorMessage != null){
                widget.loginCubit.errorMessage = null;
                widget.loginCubit.changeErrorMessageState();
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                return AppLocalizations.of(context)!.translate('required');
              } else if (RegExp(r'^[A-Za-z_.]+$').hasMatch(value)) {
                if (!emailRegex.hasMatch(value)) {
                  return AppLocalizations.of(context)!.translate('invalidEmail');
                }
              } else if (numbersRegex.hasMatch(value)) {
                if (!phoneNumberRegex.hasMatch(value)) {
                  return AppLocalizations.of(context)!.translate('invalidPhoneNumber');
                }
              }
              return null;
            }),
        const SizedBox(height: 10),
        DefaultText(
            text: widget.loginCubit.errorMessage ?? '',
            isTextTheme: true,
            themeStyle: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.red)
        ),
        const SizedBox(height: 30),
        ResponsiveWidget(
          localWidthRatio: 1,
          fixedHeight: 48,
          child: CustomRoundedButton(
            title: AppLocalizations.of(context)!.translate('continue'),
            isLoading: widget.state is LoginLoading,
            onPressed: () async {
              if (widget.formKey.currentState!.validate()) {
                widget.formKey.currentState!.save();
                widget.loginCubit.errorMessage = null;
                await widget.loginCubit.validateEmailNormal(widget.phoneOrEmail.text);
                widget.loginCubit.socialLogin = '';
                widget.loginCubit.modifyDataFromPassword = false;
                debugPrint("selectedCountryCode ${CacheHelper.getData(key: Constants.selectedCountryCode.toString())}");
              }
            },
          ),
        ),
      ],
    );
  }
}