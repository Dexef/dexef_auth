import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import 'default_text.dart';

class CustomRoundedButton extends StatelessWidget {
  CustomRoundedButton({
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.height = 48,
    this.width = 394,
    this.borderRadius,
    super.key
  });
  final String title;
  final Function()? onPressed;
  bool? isLoading;
  double? height;
  double? width;
  double? borderRadius;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      height: height,
      color: isLoading == true ? primary.withOpacity(.50) : primary,
      minWidth: double.infinity,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(borderRadius ?? 25)),
      child: DefaultText(
        text: title,
        isTextTheme: true,
        themeStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
