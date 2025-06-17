import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../../../core/size_widgets/app_font_style.dart';
import '../../../features/register/presentation/cubit/register_cubit.dart';
import '../../../features/register/presentation/cubit/register_states.dart';
import '../../rest/app_localizations.dart';
import '../../theme/colors.dart';
import '../public/default_text.dart';

class PhoneWidget extends StatelessWidget {
  final PhoneNumber? initialNumber;
  final FocusNode phoneFocusNode;
  final TextEditingController choosePhoneCode;
  final int maxLength;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final RegisterCubit cubit;
  final RegisterStates? states;
  final void Function(PhoneNumber)? onInputChanged;

  const PhoneWidget({
    super.key,
    required this.initialNumber,
    required this.phoneFocusNode,
    required this.choosePhoneCode,
    this.maxLength = 10,
    this.onFieldSubmitted,
    this.validator,
    required this.cubit,
    this.states,
    this.onInputChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: const TextTheme(
          titleMedium: TextStyle(color: brush,fontFamily: 'Readex'),
          bodyMedium: TextStyle(color: cannot,fontFamily: 'Readex'),
        ),
      ),
      child: InternationalPhoneNumberInput(
        initialValue: initialNumber,
        searchBoxDecoration: phoneDecoration(context, cubit, states!),
        focusNode: phoneFocusNode,
        spaceBetweenSelectorAndTextField: 0,
        textFieldController: choosePhoneCode,
        maxLength: maxLength,
        autofillHints: const [AutofillHints.telephoneNumberNational],
        onFieldSubmitted: onFieldSubmitted,
        onInputValidated: (value) {},
        formatInput: false,
        validator: validator,
        textStyle: TextStyle(
          color: Colors.black,
          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 14, mobileFontSize: 12.sp),
        ),
        selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.DIALOG,
          setSelectorButtonAsPrefixIcon: true,
          showFlags: false,
          leadingPadding: 10,
          trailingSpace: false,
        ),
        inputDecoration: phoneDecoration(context, cubit, states!),
        onInputChanged: onInputChanged,
        inputBorder: InputBorder.none,
      ),
    );
  }
////////////////////////////////////////////////////////////////////////////////
  InputDecoration phoneDecoration(BuildContext context, RegisterCubit registerCubit, RegisterStates state){
    return  InputDecoration(
      prefixStyle: const TextStyle(color: Colors.blue),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      errorStyle: const TextStyle(height:1,fontSize: 16,color: Colors.red,),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide( color: state is RegisterNormalError && registerCubit.hasPhoneError(state.message) ? redColor : brushBorder ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide( color: state is RegisterNormalError && registerCubit.hasPhoneError(state.message) ? redColor : brushBorder ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide( color: state is RegisterNormalError && registerCubit.hasPhoneError(state.message) ? redColor : selectedBorder ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.red),
      ),
      label: DefaultText(
        text: '   ${AppLocalizations.of(context)!.translate('phoneNumber')}   ',
        fontColor: brushLines,
        fontFamily: 'Dexef',
        fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 14, mobileFontSize: 12.sp),
      ),
      hintStyle: TextStyle(
        color: Colors.black,
        fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 12, mobileFontSize: 10.sp),
      ),
    );
  }
}
