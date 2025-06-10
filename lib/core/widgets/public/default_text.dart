import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../size_widgets/app_font_style.dart';

class DefaultText extends StatelessWidget {
  double? fontSize;
  double? wordSpacing;
  double? height;
  FontWeight? fontWeight;
  Color? fontColor;
  Color? fontColor2;
  String? fontFamily;
  String? text;
  String? text2;
  TextAlign align;
  bool? isMultiLine;
  bool? isInSearch;
  InlineSpan? textSpan;
  TextDecoration? textDecoration;
  Color? decorationColor;
  TextOverflow overFlow;
  int? maxLines;
  bool isTextTheme;
  bool isTextTheme2;
  TextStyle? themeStyle;
  TextStyle? themeStyle2;

  DefaultText(
      {super.key, this.text,
        this.text2,
        this.fontSize,
        this.fontColor,
        this.fontColor2,
        this.fontWeight,
        this.fontFamily,
        this.align = TextAlign.start,
        this.wordSpacing,
        this.height,
        this.isMultiLine = false,
        this.isInSearch = false,
        this.textSpan,
        this.textDecoration,
        this.decorationColor,
        this.overFlow = TextOverflow.clip,
        this.maxLines,
        this.isTextTheme = false,
        this.isTextTheme2 = false,
        this.themeStyle,
        this.themeStyle2,
        });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: align,
      maxLines: maxLines,
      overflow: overFlow,
      softWrap: true,
      text:TextSpan(
        children: [
          TextSpan(
            text: text,
            style: isTextTheme ? themeStyle : TextStyle(
              fontSize: fontSize != null ? AppFontStyle.appFontSize.setFontSize(context, webFontSize: fontSize!, mobileFontSize: (fontSize! - 2).sp) : AppFontStyle.appFontSize.setFontSize(context, webFontSize: 16, mobileFontSize: 14.sp),
              fontWeight: fontWeight ??AppFontStyle.fontWeightCustoms.normal,
              color: fontColor,
              fontFamily: fontFamily ?? AppFontStyle.appFontFamily.readex,
              wordSpacing: wordSpacing,
              height: height,
              decoration : textDecoration,
              decorationColor: decorationColor,
            )
          ),
          TextSpan(
            text: text2,
            style: isTextTheme2 ? themeStyle2 : TextStyle(
              fontSize: fontSize != null ? AppFontStyle.appFontSize.setFontSize(context, webFontSize: fontSize!, mobileFontSize: (fontSize! - 2).sp) : AppFontStyle.appFontSize.setFontSize(context, webFontSize: 16, mobileFontSize: 14.sp),
              fontWeight: fontWeight ?? AppFontStyle.fontWeightCustoms.normal,
              color: fontColor2,
              fontFamily: fontFamily ?? AppFontStyle.appFontFamily.readex,
              wordSpacing: wordSpacing,
              height: height,
              decoration : textDecoration,
              decorationColor: decorationColor,
            )
          ),
        ],
      )
    );
  }
}
