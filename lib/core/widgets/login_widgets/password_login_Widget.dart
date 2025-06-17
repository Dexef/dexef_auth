import 'package:auth_dexef/core/rest/regex.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/size_widgets/app_screen_size.dart';
import '../../../../../../core/size_widgets/responsive_widget.dart';
import '../../../../../../core/size_widgets/app_font_style.dart';
import '../../../features/login/presentation/cubit/login_cubit.dart';
import '../../../features/login/presentation/cubit/login_state.dart';
import '../../rest/app_localizations.dart';
import '../../rest/routes.dart';
import '../../theme/colors.dart';
import '../public/custom_check_box.dart';
import '../public/custom_round_button.dart';
import '../public/default_text.dart';
import '../public/password_text_field.dart';

bool isLoadingLogin = false;
class PasswordLoginWidget extends StatefulWidget {
  final TextEditingController passwordController;
  final LoginCubit loginCubit;
  final LoginState state;
  final String phoneOrEmail;
  final GlobalKey<FormState> formKey;
  final FocusNode passwordFocusNode;
  final bool rememberMeChecker;
  const PasswordLoginWidget({
    super.key,
    required this.passwordController,
    required this.loginCubit,
    required this.state,
    required this.phoneOrEmail,
    required this.formKey,
    required this.passwordFocusNode,
    required this.rememberMeChecker,
  });
  @override
  State<PasswordLoginWidget> createState() => _PasswordLoginWidgetState();
}

class _PasswordLoginWidgetState extends State<PasswordLoginWidget> {
  @override
  Widget build(BuildContext context) {
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20,),
        PasswordTextFormField(
          controller: widget.passwordController,
          focusNode: widget.passwordFocusNode,
          errorState: widget.loginCubit.errorMessage != null,
          autoFocus: kIsWeb && AppScreenSize.appDesignSize.isWebPlatform(context) ? true : kIsWeb && !AppScreenSize.appDesignSize.isWebPlatform(context) && keyboardOpen ? true : false,
          onFieldSubmitted: (_) async {
            if (widget.formKey.currentState!.validate()) {
              widget.formKey.currentState!.save();
              isLoadingLogin = true;
              widget.loginCubit.errorMessage = null;
              await widget.loginCubit.loginNormal(context, emailOrPhone: widget.phoneOrEmail, passwordText: widget.passwordController.text);
            }
          },
          onChange: (String value) {
            if(widget.loginCubit.errorMessage != null){
              widget.loginCubit.errorMessage = null;
              widget.loginCubit.changeErrorMessageState();
            }
          },
          label: AppLocalizations.of(context)!.translate('profilePassword'),
          validator: (value) {
            if (value!.isEmpty) {
              return AppLocalizations.of(context)!.translate('required');
            }
            return null;
          },
        ),
        // const Gap(10),
        if(widget.loginCubit.errorMessage != null && widget.loginCubit.errorMessage != '')...[
          DefaultText(
            text: widget.loginCubit.errorMessage ?? '',
            isTextTheme: true,
            themeStyle: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.red)
          ),
        ],
        // const Gap(10),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: InkWell(
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,  // Removes the background highlight color
            splashColor: Colors.transparent,     // Removes the splash color
            onTap: () {
              widget.loginCubit.modifyData();
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: DefaultText(
                  text: AppLocalizations.of(context)!.translate('modifyData'),
                  isTextTheme: true,
                  themeStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontFamily: AppFontStyle.appFontFamily.readex,
                    fontWeight: FontWeight.w400,
                    color: primary,
                    fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 11, mobileFontSize: 9.sp),
                  )
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 8),
              child: CustomCheckBox(
                isChecked: widget.rememberMeChecker,
              ),
            ),
            InkWell(
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,  // Removes the background highlight color
              splashColor: Colors.transparent,     // Removes the splash color

              onTap: () {
                context.go(Routes.resetPassword);
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: DefaultText(
                    text: AppLocalizations.of(context)!
                        .translate('forgetPassword'),
                    isTextTheme: true,
                    themeStyle: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(
                        color: brushIcon,
                        fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 11, mobileFontSize: 9.sp),
                        fontWeight: FontWeight.w400,
                    )),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        ResponsiveWidget(
          localWidthRatio: 1,
          fixedHeight: 48,
          child: CustomRoundedButton(
            title: AppLocalizations.of(context)!.translate('signIn'),
            isLoading: widget.state is LoginLoading,
            onPressed: () async {
              if (widget.formKey.currentState!.validate()) {
                widget.formKey.currentState!.save();
                isLoadingLogin = true;
                widget.loginCubit.errorMessage = null;
                await widget.loginCubit.loginNormal(context, emailOrPhone: widget.phoneOrEmail, passwordText: widget.passwordController.text);
              }
            },
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
