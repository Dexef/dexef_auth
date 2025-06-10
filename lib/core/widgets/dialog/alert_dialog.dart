import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../size_widgets/app_font_style.dart';
import '../../theme/colors.dart';
import '../public/default_text.dart';

showAlertDialog({
  required BuildContext context,
  required String title,
  String? subTitle,
  required Color textColor,
  required bool isSuccess,
}) {
  AlertDialog alert = AlertDialog(
    elevation: 0.6,
    shadowColor: Colors.black,
    alignment: AlignmentDirectional.topEnd,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    content: SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    isSuccess
                        ? 'assets/images/icons_ok.svg'
                        : 'assets/images/icons_info.svg',
                    height: 36,
                    width: 36,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DefaultText(
                          text: title,
                          fontColor: textColor,
                          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 16, mobileFontSize: 14.sp),
                        ),
                        SizedBox(height: 6.h),
                        if (subTitle != null)
                          DefaultText(
                            text: subTitle,
                            isMultiLine: true,
                            fontColor: currencyColor,
                            fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 12, mobileFontSize: 10.sp),
                            maxLines: null,
                            overFlow: TextOverflow.visible,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
                      hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,  // Removes the background highlight color
        splashColor: Colors.transparent,     // Removes the splash color
              onTap: () => Navigator.of(context).pop(true),
              child: SvgPicture.asset(
                'assets/images/icons_cancel.svg',
                height: 16.h,
                width: 16.w,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  // Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(const Duration(seconds: 4), () => Navigator.of(context).pop(true));
      return alert;
    },
  );
}


// showAlertDialog({
//   required BuildContext context,
//   required String title,
//   String? subTitle,
//   required Color textColor,
//   required bool isSuccess,
// }) {
//   AlertDialog alert = AlertDialog(
//     elevation: 0.6,
//     shadowColor: Colors.black,
//     alignment: AlignmentDirectional.topEnd,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//     content: SizedBox(
//       width: 400,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SvgPicture.asset(isSuccess
//                     ? 'assets/images/icons_ok.svg'
//                     : 'assets/images/icons_info.svg',height: 36,width: 36,
//                 ),
//                 SizedBox(width: 10.w,),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       DefaultText(
//                         text: title,
//                         fontColor: textColor,
//                         fontSize: 16,
//                       ),
//                       SizedBox(height: 6.h,),
//                       if (subTitle != null)
//                         DefaultText(
//                           text: subTitle,
//                           isMultiLine: true,
//                           fontColor: uploadLogoTextColor,
//                           fontSize: 12,
//                           maxLines: 4,
//                           overFlow: TextOverflow.ellipsis,
//                         )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           InkWell(
//               onTap: () => Navigator.of(context).pop(true),
//               child: SvgPicture.asset('assets/images/icons_cancel.svg', height: 16.h, width: 16.w,)),
//         ],
//       ),
//     ),
//   );
//
//   // show the dialog
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       Future.delayed(const Duration(seconds: 4),() => Navigator.of(context).pop(true));
//       return alert;
//     },
//   );
// }
