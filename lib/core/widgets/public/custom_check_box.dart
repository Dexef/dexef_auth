import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../rest/app_localizations.dart';
import '../../rest/cash_helper.dart';
import '../../rest/constants.dart';
import '../../size_widgets/app_font_style.dart';
import '../../theme/colors.dart';
import 'default_text.dart';

class CustomCheckBox extends StatefulWidget {
  CustomCheckBox({super.key, required this.isChecked,this.shape});
  late bool isChecked;
  OutlinedBorder? shape;
  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool isChecked = false;

  @override
  void initState() {
    isChecked = widget.isChecked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: .8,
          child: Checkbox(
            shape: widget.shape,
            value: isChecked,
            onChanged: (value) {
              setState(() {
                isChecked = value!;
                CacheHelper.saveData(key: Constants.rememberMeChecker.toString(), value: isChecked);
              });
            },
            // fillColor: MaterialStateProperty.all(textGreen),
            fillColor: MaterialStateProperty.resolveWith((states) {
              if (isChecked) {
                return calculatorCash ;
              } else {
                return Colors.white;
              }
            }),
            checkColor: Colors.white,
            // focusColor: Colors.green,
            //hoverColor: greyTextColor,
            // activeColor: Colors.green,
            //overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(.2)),
          ),
        ),
        InkWell(
                  hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,  // Removes the background highlight color
        splashColor: Colors.transparent,     // Removes the splash color
          onTap: () {
            setState(() {
              if(isChecked){
                isChecked = !isChecked;
                CacheHelper.saveData(
                    key: Constants.rememberMeChecker.toString(),
                    value: isChecked);
              }else{
                // used to remove stored data from the cache.
                CacheHelper.removeData(
                    key: Constants.rememberMeChecker.toString(),
                    );
              }

            });
          },
          child: DefaultText(
            text: AppLocalizations.of(context)!.translate('rememberMe'),
            isTextTheme: true,
            themeStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: brushIcon,
              fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 14, mobileFontSize: 12.sp),
              fontWeight: FontWeight.w400,
            )
          ),
        )
      ],
    );
  }
}
