import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/countries.dart';
import '../../../../../../core/size_widgets/app_font_style.dart';
import '../../rest/cash_helper.dart';
import '../../rest/constants.dart';
import '../public/default_text.dart';

class PopUpCountryCode extends StatefulWidget{
  final Country selectedUnite;
  final void Function(Country)? onSelected;
  // final List <Country> countriesList;
  const PopUpCountryCode({
    super.key,
    required this.selectedUnite,
    // required this.countriesList,
    this.onSelected
  });
  @override
  State<PopUpCountryCode> createState() => _PopUpCountryCodeState();
}

class _PopUpCountryCodeState extends State<PopUpCountryCode> {
  bool? isArabic;
  @override
  Widget build(BuildContext context) {
    isArabic = CacheHelper.getData(key: Constants.isArabic.toString()) ?? true ;
    return Theme(
      data: ThemeData(hoverColor: Colors.transparent),
      child: PopupMenuButton <Country>(
        position: PopupMenuPosition.over,
        onSelected: widget.onSelected,
        tooltip: "",
        offset: isArabic == true ? const Offset(-20,48) : const Offset(360,48),
        constraints: const BoxConstraints(maxHeight: 300),
        itemBuilder:(BuildContext context) => countries.map((e) => PopupMenuItem<Country>(
          value: e,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DefaultText(
                text: isArabic == true ? "${e.nameTranslations["ar"]}": e.name,
                fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 12, mobileFontSize: 10.sp),
              ),
              DefaultText(
                text: "+ ${e.dialCode}",
                fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 12, mobileFontSize: 10.sp),
              ),
            ],
          ),
        )).toList(),
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 6.w,),
            const Icon(Icons.arrow_drop_down, size: 14,),
            DefaultText(
              text: widget.selectedUnite.dialCode,
              fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 12, mobileFontSize: 10.sp),
            ),
            SizedBox(width: 6.w,),
            Container(height: 8, color: Colors.black54, width: 1,),
            SizedBox(width: 6.w,),
          ],
        ),
      ),
    );
  }
}
////////////////////////////////////////////////////////////////////////////////



