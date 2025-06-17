import 'package:flutter/material.dart';
import '../../../../core/size_widgets/app_screen_size.dart';
import '../../../../core/size_widgets/responsive_widget.dart';
import '../../theme/colors.dart';
import '../public/default_text.dart';

class VerifyRadio extends StatelessWidget {
  VerifyRadio({
    super.key,
    required this.radioText,
    required this.groupValue,
    required this.value,
    this.onChanged,
  });

  final String radioText;
  final bool groupValue;
  final bool value;
  final void Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      localWidthRatio: ratioWidthComponentLogin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Radio<bool>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            fillColor: MaterialStateProperty.resolveWith((states) {
              return calculatorCash;
            }),
          ),
          const SizedBox(
            width: 10,
          ),
          DefaultText(
            text: radioText,
            isTextTheme: true,
            themeStyle: Theme.of(context).textTheme.labelSmall!,
            isMultiLine: true,
          ),
        ],
      ),
    );
  }
}
